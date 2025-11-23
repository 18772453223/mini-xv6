#include "pkg/syscall.h"
#include "pkg/defs.h"
#include "proc/proc.h"

// simple syscall wrappers; user arguments taken from trapframe
static int sys_fork(struct proc *p) { return fork(); }
static int sys_exit(struct proc *p) { exit((int)p->trapframe->a0); return 0; }
static int sys_wait(struct proc *p) { return wait((int*)p->trapframe->a0); }
static int sys_kill(struct proc *p) { return kill((int)p->trapframe->a0); }
static int sys_getpid(struct proc *p) { 
    struct proc *cp = get_current_process();
    printf("sys_getpid: pid=%d\n", cp ? cp->pid : -1);
    return cp ? cp->pid : -1;
 }

typedef int (*syscall_fn)(struct proc *);

static syscall_fn sys_table[SYS_getpid + 1] = {
    [SYS_fork] = sys_fork,
    [SYS_exit] = sys_exit,
    [SYS_wait] = sys_wait,
    [SYS_kill] = sys_kill,
    [SYS_getpid] = sys_getpid,
};

// dispatch syscall by a7, write return value to a0
int syscall_dispatch(struct proc *p) {
    int num = (int)p->trapframe->a7;
    
    if(num < 1 || num > SYS_getpid) {
        p->trapframe->a0 = -1;
        return -1;
    }

    syscall_fn f = sys_table[num];

    if(f == 0) {
        p->trapframe->a0 = -1;
        return -1;
    }

    int rv = f(p);
    p->trapframe->a0 = rv;
    return rv;
}
