#include "defs.h"
#include "memlayout.h"
#include "proc.h"
#include "syscall.h" // local kernel syscall numbers (from pkg/ included by -Ipkg)

#define MAX_INTERRUPTS 32

typedef void (*interrupt_handler_t)(void);

// define interrupt handler table
interrupt_handler_t interrupt_table[MAX_INTERRUPTS];

void kernelvec();

extern int devintr();

extern char uservec[], userret[], trampoline[];

volatile int interrupt_count = 0;

void trap_init(void) {
    for (int i = 0; i < MAX_INTERRUPTS; i++) {
        interrupt_table[i] = 0; 
    }
    // register_interrupt(UART0_IRQ, uartintr);
    // register_interrupt(VIRTIO0_IRQ, virtiointr);

    // set the kernel trap vector address
    w_stvec((uint64)kernelvec);
}

void register_interrupt(int irq, interrupt_handler_t h) {
    if (irq > 0 && irq < MAX_INTERRUPTS) {
        interrupt_table[irq] = h;
    }
}

void enable_interrupt(int irq);


void disable_interrupt(int irq);


// handle traps from user space (syscall, interrupt, exception)
uint64 usertrap() {
    uint64 scause = r_scause();
    uint64 sepc = r_sepc();
    struct proc *p = get_current_process();
    printf("usertrap ENTER: scause=%lx sepc=%lx pid=%d\n",
           scause, sepc, p ? p->pid : -1);
    

    // set stvec to kernel handler while in kernel
    w_stvec((uint64)kernelvec);

    if((r_sstatus() & SSTATUS_SPP) != 0) {
        panic("usertrap: not from user mode");
    }

    // save user pc
    p->trapframe->epc = r_sepc();

    if(scause == 8) { // syscall
        p->trapframe->epc += 4; // advance user pc before executing
        // debug: trace syscall number
        printf("[debug] syscall a7=%ld pid=%d\n", p->trapframe->a7, p->pid);
        syscall_dispatch(p);
    } else if(scause >> 63) { // interrupt
        int which = devintr();

        if(which == 2) { // timer
            // only yield if a process is actually running
            printf("usertrap: timer interrupt pid=%d\n", p->pid);
            if(get_current_process()) {
                yield();
            }
        }
    } else {
        // exception: set killed and return
        p->killed = 1;
    }

    // return to user space
    prepare_return();
    uint64 satp = MAKE_SATP(p->pagetable);
    
    return satp;
}

void kerneltrap() {
    printf("kerneltrap invoked\n");

    uint64 sepc = r_sepc();
    uint64 sstatus = r_sstatus();
    uint64 scause = r_scause();
    uint64 stval = r_stval();

    if((sstatus & SSTATUS_SPP) == 0)
        panic("kerneltrap: not from supervisor mode");

    if(intr_get() != 0)
        panic("kerneltrap: interrupts enabled");

    int is_interrupt = (scause >> 63);
    printf("kerneltrap: scause=0x%lx stval=0x%lx sepc=0x%lx interrupt=%d\n", scause, stval, sepc, is_interrupt);


    // handle interrupt
    if (is_interrupt) {
        int which_dev = devintr();

        if(which_dev == 0){
            printf("kerneltrap: unknown interrupt scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
            panic("kerneltrap");
        } else if (which_dev == 2 && get_current_process() != 0) {
            // timer interrupt
            // yield to scheduler
            printf("kerneltrap: timer interrupt yield pid=%d\n", get_current_process()->pid);
            yield();
        }
    } else {
        // handle exception
        handle_exception();
    }
    

    w_sepc(sepc);
    w_sstatus(sstatus);
}

int devintr() {
    uint64 scause = r_scause();

    printf("devintr: scause=0x%lx\n", scause);
    // device interrupt
    if (scause == 0x8000000000000009L) {
        // get irq from plic
        int irq = plic_claim();

        // invoke corrsponding interrupt handler
        if (irq > 0 && irq < MAX_INTERRUPTS) {
            if (interrupt_table[irq]) {
                interrupt_table[irq]();
            } else {
                printf("unexpected interrupt irq=%d\n", irq);
            }
        }

        if (irq) {
            plic_complete(irq);
        }
        return 1;
    } else if (scause == 0x8000000000000005L) {
        // ntf("timer interrupt\n");
        // timer interrupt
        timer_interrupt();     
        return 2;
    } else {
        return 0;
    }
}

void timer_interrupt() {
    interrupt_count++;
    w_stimecmp(r_time() + 1000000);
}


void handle_exception() {
    uint64 scause = r_scause();
    uint64 sepc = r_sepc();
    uint64 stval = r_stval();
    printf("handle_exception: scause=%lu sepc=%lx stval=%lx\n",
           scause, sepc, stval);
           
    switch (scause) {
        case 2:
            panic("handle_exception: Illegal instruction");
            break;
        case 12:
            panic("handle_exception: Instruction page fault");
            break;
        case 13:
            panic("handle_exception: Load page fault");
            break;
        case 15:
            panic("handle_exception: Store/AMO page fault");
            break;
        default:
            panic("Unknown exception");
    }
}

// prepare to return to user: fill trapframe kernel metadata and set stvec to uservec
void prepare_return(void) {
    struct proc *p = get_current_process();

    if(p == 0) {
        panic("prepare_return: no current proc");
    }

    intr_off();
    p->trapframe->kernel_satp = r_satp();
    p->trapframe->kernel_sp = p->kstack + PGSIZE;
    p->trapframe->kernel_trap = (uint64)usertrap;
    p->trapframe->kernel_hartid = r_tp();

    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP;   // set previous mode to user
    x |= SSTATUS_SPIE;   // enable user interrupts when back to user
    w_sstatus(x);

    uint64 uservec_pos = TRAMPOLINE + (uservec - trampoline);
    printf("prepare_return: stvec=%lx sepc=%lx sstatus=%lx\n", uservec_pos, p->trapframe->epc, x);
    printf("prepare_return: trapframe=%lx TRAPFRAME=%lx\n", (uint64)p->trapframe, TRAPFRAME);
    printf("usertrap: %lx\n", uservec_pos);
    w_stvec(uservec_pos);
    w_sepc(p->trapframe->epc);
}
