#include "proc.h"
#include "defs.h"
#include "memlayout.h"
#include "interrupt_ops.c"

struct proc procs[NPROC];
struct cpu cur_cpu;
extern pagetable_t kernel_pagetable;

extern char trampoline[];
extern char userret[];
extern void forkret();

int nextpid = 1;

static struct proc *allocate_process();
static void free_process(struct proc *p);
// external user test binary symbols (forktest)
extern char forktest_start[];
extern char forktest_end[];

// Init process table
void init_process_table()
{
    for (int i = 0; i < NPROC; i++)
    {
        struct proc *p = &procs[i];
        p->state = UNUSED;
        p->kstack = KSTACK((uint64)(p - procs));
    }
}

// allocate a new process structure and kernel state
struct proc *allocate_process()
{
    push_off();

    for (int i = 0; i < NPROC; i++)
    {
        struct proc *p = &procs[i];
        if (p->state == UNUSED)
        {
            p->pid = nextpid++;

            p->trapframe = (struct trapframe *)alloc_page();
            if (p->trapframe == 0)
            {
                pop_off();
                return 0;
            }

            p->pagetable = proc_pagetable(p);
            if (p->pagetable == 0)
            {
                free_page((void *)p->trapframe);
                p->trapframe = 0;
                pop_off();
                return 0;
            }

            // Allocate kernel stack
            char *kstack_pa = (char *)alloc_page();
            if (kstack_pa == 0)
            {
                free_proc_pagetable(p);
                free_page((void *)p->trapframe);
                p->trapframe = 0;
                pop_off();
                return 0;
            }
            uint64 kstack_va = p->kstack;
            // Map in kernel page table
            kernel_map(kernel_pagetable, kstack_va, (uint64)kstack_pa, PGSIZE, PTE_R | PTE_W);

            p->state = USED;

            memset(&p->context, 0, sizeof(struct context));
            p->context.ra = (uint64)forkret;
            p->context.sp = p->kstack + PGSIZE;

            pop_off();
            return p;
        }
    }
    pop_off();
    return 0;
}

// free process resources and mark UNUSED
static void free_process(struct proc *p)
{
    if (p->trapframe)
        free_page((void *)p->trapframe);
    p->trapframe = 0;
    if (p->pagetable)
        free_proc_pagetable(p);
    p->pagetable = 0;

    pte_t *pte = walk(kernel_pagetable, p->kstack, 0);
    if (pte && (*pte & PTE_V))
    {
        uint64 pa = PTE2PA(*pte);
        free_page((void *)pa);
        *pte = 0; // Unmap
    }

    p->sz = 0;
    p->pid = 0;
    p->parent = 0;
    p->name[0] = 0;
    p->chan = 0;
    p->killed = 0;
    p->xstate = 0;
    p->state = UNUSED;
}

// internal fork implementation: duplicate current process
int kfork()
{
    struct proc *new_proc = allocate_process();
    if (new_proc == 0)
    {
        printf("kfork: allocate_process failed\n");
        return -1;
    }

    struct proc *cur_proc = get_current_process();

    printf("kfork: parent pid=%d sz=%lu\n", cur_proc->pid, cur_proc->sz);

    if (copy_user_memory(cur_proc->pagetable, new_proc->pagetable, cur_proc->sz) < 0)
    {
        printf("kfork: copy_user_memory failed\n");
        free_process(new_proc);
        return -1;
    }

    *(new_proc->trapframe) = *(cur_proc->trapframe);
    new_proc->sz = cur_proc->sz;
    // fork return 0 in child process
    new_proc->trapframe->a0 = 0;

    push_off();
    new_proc->parent = cur_proc;
    new_proc->state = RUNNABLE;
    pop_off();

    printf("fork: parent=%d child=%d\n", cur_proc->pid, new_proc->pid);
    return new_proc->pid;
}

// return to user after first schedule of a new child
void forkret()
{
    struct proc *p = get_current_process();

    pop_off();
    printf("forkret: pid=%d entering user mode\n", p->pid);
    printf("forkret: trapframe epc=%lx sp=%lx ra=%lx\n", p->trapframe->epc, p->trapframe->sp, p->trapframe->ra);

    prepare_return();

    uint64 satp = MAKE_SATP(p->pagetable);
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);

    printf("forkret: calling userret at %lx with satp_hi=%x satp_lo=%x\n", trampoline_userret, (uint)((satp >> 32) & 0xffffffff), (uint)(satp & 0xffffffff));
    printf("forkret: about to jump, current pc will be lost\n");

    ((void (*)(uint64))trampoline_userret)(satp);
}

struct cpu *get_current_cpu()
{
    return &cur_cpu;
}

struct proc *get_current_process()
{
    return get_current_cpu()->proc;
}

// allocate a pagetable which maps trampoline and trapframe for process.
pagetable_t proc_pagetable(struct proc *p)
{
    pagetable_t pagetable = create_user_pagetable();
    if (pagetable == 0)
    {
        return 0;
    }

    // map trampoline code (for system call return)
    if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline, PTE_R | PTE_X) < 0)
    {
        free_user_pagetable(pagetable, 0);
        return 0;
    }
    // map trapframe page
    if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)p->trapframe, PTE_R | PTE_W) < 0)
    {
        remove_user_mappings(pagetable, TRAMPOLINE, 1, 0);
        free_user_pagetable(pagetable, 0);
        return 0;
    }
    return pagetable;
}

void free_proc_pagetable(struct proc *p)
{
    remove_user_mappings(p->pagetable, TRAMPOLINE, 1, 0);
    remove_user_mappings(p->pagetable, TRAPFRAME, 1, 0);
    free_user_pagetable(p->pagetable, p->sz);
}

// simple round-robin scheduler
void scheduler()
{
    printf("scheduler started\n");

    struct proc *p = get_current_process();
    struct cpu *c = get_current_cpu();
    c->proc = 0;

    for (;;)
    {
        intr_on();

        for (int i = 0; i < NPROC; i++)
        {
            p = &procs[i];

            push_off(); // disable interrupts while we scan & pick a RUNNABLE proc

            if (p->state == RUNNABLE)
            {

                printf("scheduler: switching to %d, ra=%lx\n", p->pid, p->context.ra);
                p->state = RUNNING;
                c->proc = p;

                swtch(&c->context, &p->context); // switch into process; returns when process calls sched()

                c->proc = 0;
            }
            pop_off();
        }
    }
}

// switch from process to scheduler context
void sched()
{
    struct proc *p = get_current_process();
    struct cpu *c = get_current_cpu();

    swtch(&p->context, &c->context);
}

// yield CPU
void yield()
{
    struct proc *p = get_current_process();
    if (p == 0)
    {
        return;
    }
    printf("yield: pid=%d\n", p->pid);
    push_off();

    if (p->state == RUNNING)
    {
        p->state = RUNNABLE;
    }

    pop_off();
    sched();
}
// sleep on a channel (simple, busy scheduling around SLEEPING state)
void sleep(void *chan)
{
    struct proc *p = get_current_process();

    push_off();
    p->chan = chan;
    p->state = SLEEPING;
    pop_off();

    sched();
    // when woken
    p->chan = 0;
}

// wake up all processes sleeping on chan
void wakeup(void *chan)
{
    push_off();
    for (int i = 0; i < NPROC; i++)
    {
        struct proc *p = &procs[i];
        if (p->state == SLEEPING && p->chan == chan)
        {
            p->state = RUNNABLE;
        }
    }
    pop_off();
}

// userinit: load embedded forktest binary and make runnable
void userinit()
{
    struct proc *p = allocate_process();

    if (p == 0)
    {
        panic("userinit alloc failed");
    }

    char *mem = (char *)alloc_page();

    if (mem == 0)
    {
        panic("userinit page alloc");
    }

    if (mappages(p->pagetable, 0, PGSIZE, (uint64)mem, PTE_R | PTE_W | PTE_X | PTE_U) < 0)
        panic("userinit mappages");

    uint64 sz = (uint64)forktest_end - (uint64)forktest_start;

    printf("userinit: loading forktest_start=%lx end=%lx sz=%lu\n", (uint64)forktest_start, (uint64)forktest_end, sz);

    if (sz > PGSIZE)
        panic("forktest too big");

    memmove(mem, forktest_start, sz);

    // Debug: verify the copied code
    printf("userinit: first 4 instructions at mem:\n");
    unsigned int *code = (unsigned int *)mem;
    for (int i = 0; i < 4; i++)
    {
        printf("  [%d] = 0x%x\n", i, code[i]);
    }

    p->sz = PGSIZE; // simple fixed size

    // Initialize trapframe - clear all registers
    memset(p->trapframe, 0, sizeof(struct trapframe));
    p->trapframe->epc = 0;
    p->trapframe->sp = PGSIZE; // stack at top of first page

    safestrcpy(p->name, "forktest", sizeof(p->name));

    push_off();
    p->state = RUNNABLE;
    pop_off();

    printf("userinit: pid=%d set RUNNABLE epc=%lu sz=%lu\n", p->pid, p->trapframe->epc, p->sz);
}

// public kernel fork wrapper
int fork(void)
{
    return kfork();
}

// terminate current process
void exit(int status)
{
    struct proc *p = get_current_process();
    push_off();
    p->xstate = status;
    p->state = ZOMBIE;
    printf("exit: pid=%d status=%d\n", p->pid, status);
    // wake parent (if any) on its wait channel (use parent pointer as chan)
    wakeup(p->parent);
    pop_off();
    sched(); // never returns
}

// wait for a child to exit; simplistic busy loop
int wait(int *status)
{
    printf("wait: pid=%d waiting for child\n", get_current_process()->pid);
    struct proc *p = get_current_process();

    for (;;)
    {
        int have_child = 0;

        for (int i = 0; i < NPROC; i++)
        {
            struct proc *ch = &procs[i];

            if (ch->parent == p)
            {
                have_child = 1;

                if (ch->state == ZOMBIE)
                {
                    int pid = ch->pid;
                    if (status)
                        *status = ch->xstate; // user VA ignored simplistically
                    free_process(ch);
                    return pid;
                }
            }
        }

        if (!have_child)
            return -1; // no children

        yield();
    }
}

// set killed flag of pid
int kill(int pid)
{
    for (int i = 0; i < NPROC; i++)
    {
        struct proc *p = &procs[i];
        if (p->pid == pid)
        {
            push_off();
            p->killed = 1;
            if (p->state == SLEEPING)
                p->state = RUNNABLE;
            pop_off();
            return 0;
        }
    }
    return -1;
}

// return current pid
int getpid(void)
{
    struct proc *p = get_current_process();
    return p ? p->pid : -1;
}

// (removed embedded initcode; now using external forktest binary)
