#include "types.h"
#include "defs.h"
#include "memlayout.h"
#include "riscv.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel loaded from ELF file
                    // defined by the linker script in kernel.ld

struct run {
    struct run *next;
};

struct {
    struct run *freelist;
} fmem;

void pmm_init() {
    freerange(end, (void *)PHYSTOP);
}

void freerange(void *pa_start, void *pa_end) {
    char *p;
    // round up to be page-aligned
    p = (char *)PGROUNDUP((uint64)pa_start);
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE) {
        free_page(p);
    }
}

void free_page(void *pa) {
    struct run *r;
    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);

    r = (struct run *)pa;
    r->next = fmem.freelist;
    fmem.freelist = r;
}

void * alloc_page(void) {
    struct run *r;
    r = fmem.freelist;
    if (r) {
        fmem.freelist = r->next;
    }

    if (r) {
        memset((char*)r, 5, PGSIZE); 
    }
    
    return (void *)r;
}
