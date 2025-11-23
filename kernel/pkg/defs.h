#ifndef _DEFS_H
#define _DEFS_H

#include "types.h"
#include "riscv.h"
#include "params.h"
// console.c
void consputc(int c);

// print.c
int printf(char *fmt, ...);
void clear_screen(void);
void panic(char *s);

// uart.c
void uart_init(void);
void uart_putc(char c);
void uart_puts(char *s);


// kalloc.c
void pmm_init();
void * alloc_page(void);
void free_page(void *pa);

// string.c
void * memset(void *dst, int c, uint n);
void memmove(void *dst, const void *src, uint n);

// vm.c
void kvminit(void);
void kvminithart(void);
void kernel_map(pagetable_t pagetable, uint64 va, uint64 pa, uint64 sz, int perm);
pte_t * walk(pagetable_t pagetable, uint64 va, int alloc);
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm);
pagetable_t create_user_pagetable();
void remove_user_mappings(pagetable_t pagetable, uint64 va, uint64 npages, int free);
void free_walk(pagetable_t pagetable);
int copy_user_memory(pagetable_t src, pagetable_t dst, uint64 sz);
pagetable_t proc_pagetable(struct proc *p);
void free_proc_pagetable(struct proc *p);
void free_user_pagetable(pagetable_t pagetable, uint64 sz);

void test_physical_memory(void);
void test_pagetable(void); 
void test_virtual_memory(void);

// trap.c
void test_timer_interrupt(void);
void test_exception(void);
void handle_exception(void);
void trap_init(void);
int plic_claim(void);
void plic_complete(int irq);
void prepare_return(void);
// syscall dispatch
struct proc; // forward
int syscall_dispatch(struct proc *p);

// plic.c
void plicinit(void);

// swtch.S
void swtch(struct context *old, struct context *new);
void sched(void);

// proc.c
struct proc* get_current_process();
struct cpu* get_current_cpu();
void yield(void);
void scheduler(void);
void sleep(void *chan);
void wakeup(void *chan);
int fork(void);
void exit(int status);
int wait(int *status);
int kill(int pid);
int getpid(void);
void userinit(void);

// string.c
char * safestrcpy(char *dst, const char *src, int n);

#endif