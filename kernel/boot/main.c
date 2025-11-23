#include "defs.h"

void main () {
    uart_init();          // initialize UART before any prints
    clear_screen();       // optional: clear terminal
    printf("\n[riscv-os] booting...\n");
    trap_init();          // init trap vectors
    pmm_init();           // init physical memory allocator
    kvminit();            // build kernel page table
    kvminithart();        // enable paging
    init_process_table(); // init process table entries
    printf("process table initialized\n");
    userinit();           // create first user process
    printf("user init process created\n");
    // intr_on();           
    printf("entering scheduler\n");
    scheduler();          // enter scheduler (never returns)
}