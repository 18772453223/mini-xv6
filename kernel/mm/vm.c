#include "riscv.h"
#include "defs.h"
#include "memlayout.h"

pagetable_t kernel_pagetable;

extern char etext[];  // kernel.ld sets this to end of kernel code.
extern char trampoline[]; // trampoline.S

pagetable_t create_pagetable(void) {
    pagetable_t kpgtbl;
    kpgtbl = (pagetable_t)alloc_page();
  
    memset(kpgtbl, 0, PGSIZE);

    // uart registers
    kernel_map(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    printf("Mapped UART0\n");
    // virtio mmio disk interface
    kernel_map(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    printf("Mapped VIRTIO0\n");
    // PLIC
    kernel_map(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    printf("Mapped PLIC\n");
    // map kernel text executable and read-only.
    kernel_map(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    printf("Mapped kernel text\n");
    // map kernel data and the physical RAM we'll make use of.
    kernel_map(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    printf("Mapped kernel data and physical RAM\n");

    // map the trampoline for trap entry/exit to
    // the highest virtual address in the kernel.
    kernel_map(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    printf("Mapped trampoline, trampoline addr: %lx\n", (uint64)trampoline);

    return kpgtbl;

}

void kvminit(void) {
  kernel_pagetable = create_pagetable();
}

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void kvminithart() {
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));

  // flush stale entries from the TLB.
  sfence_vma();
}

void kernel_map(pagetable_t pagetable, uint64 va, uint64 pa, uint64 sz, int perm) {
    if (mappages(pagetable, va, sz, pa, perm) != 0) {
        panic("kernel_map::mappages failed");
    }
}

// Get the PTE for a virtual address.
pte_t * walk(pagetable_t pagetable, uint64 va, int alloc) {

    if (va >= MAXVA) {
        panic("walk::va is larger than MAXVA!!!");
    }
    
    for (int level = 2; level > 0; level--) {
        // Get the pte that points to the next level page table
        pte_t *pte = &pagetable[PX(level, va)];
        if (*pte & PTE_V) {
            pagetable = (pagetable_t)PTE2PA(*pte);
        } else {
            if (!alloc || (pagetable = (pagetable_t)alloc_page()) == 0)
                return 0;
            memset(pagetable, 0, PGSIZE);
            *pte = PA2PTE(pagetable) | PTE_V;
        }
    }
    return &pagetable[PX(0, va)];
} 


int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm) {
    if (size % PGSIZE != 0) {
        panic("size aligned to PAGESIZE");
    }

    if (va % PGSIZE != 0) {
        panic("va aligned to PAGESIZE");
    }

    if (pa % PGSIZE != 0) {
        panic("pa aligned to PAGESIZE");
    }

    if (size == 0) {
        panic("size cannot be zero");
    }

    uint64 start = va, end = va + size;
    for (uint64 a = start; a < end; a += PGSIZE, pa += PGSIZE) {
        // printf("va is %x\n", a);
        pte_t *pte = walk(pagetable, a, 1);
        if (pte == 0) {
            return -1;
        }
        if (*pte & PTE_V) {
            panic("mappages::remap");
        }
        *pte = PA2PTE(pa) | perm | PTE_V;
    }

    return 0;
}

// create a user page table, with no user memory.
pagetable_t create_user_pagetable() {
    pagetable_t pagetable;

    // Allocate new page table
    pagetable = (pagetable_t)alloc_page();
    if (pagetable == 0) {
        return 0;
    }
    memset(pagetable, 0, PGSIZE);

    return pagetable;
}

// remove mappings from a user page table, free the physical memory of leaf page if 'free' is set.
void remove_user_mappings(pagetable_t pagetable, uint64 va, uint64 npages, int free) {
    if (va % PGSIZE != 0) {
        panic("remove_user_mappings::va not aligned to PGSIZE");
    }

    for (uint64 a = va; a < va + npages * PGSIZE; a += PGSIZE) {
        pte_t *pte = walk(pagetable, a, 0);
        if (pte == 0) {
            continue;
        }
        if ((*pte & PTE_V) == 0) {
            continue;
        }
        if (free) {
            uint64 pa = PTE2PA(*pte);
            free_page((void*)pa);
        }
        *pte = 0;
    }
}

// free a pagetable of middle levels.
void free_walk(pagetable_t pagetable) {
    for (uint64 i = 0; i < 512; i++) {
        pte_t *pte = &pagetable[i];
        if ((*pte & PTE_V) && ((*pte & (PTE_R | PTE_W | PTE_X)) == 0)) {
            // This PTE points to a lower-level page table.
            uint64 child = PTE2PA(*pte);
            free_walk((pagetable_t)child);
            *pte = 0;
        } else if (*pte & PTE_V) {
            panic("free_walk::leaf pte is still valid");
        }
    }
    
    free_page((void*)pagetable);
}

void free_user_pagetable(pagetable_t pagetable, uint64 sz) {
    if (sz > 0) {
        remove_user_mappings(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    }
    
    free_walk(pagetable);
}

// copy memory from a source pagetable to a destination pagetable.
int copy_user_memory(pagetable_t src, pagetable_t dst, uint64 sz) {
    uint64 flags;

    for (uint64 i = 0; i < sz; i += PGSIZE) {
        pte_t *src_pte = walk(src, i, 0);
        if (src_pte == 0) {
            continue;
        }
        if ((*src_pte & PTE_V) == 0) {
            continue;
        }
        flags = PTE_FLAGS(*src_pte);
        uint64 pa = PTE2PA(*src_pte);

        // allocate a new page for son process
        char *mem = (char*)alloc_page();
        if (mem == 0) {
            remove_user_mappings(dst, 0, i / PGSIZE, 1);
            free_walk(dst);
            return -1;
        }
        // copy data from parent process to son process
        memmove(mem, (char*)pa, PGSIZE);

        if (mappages(dst, i, PGSIZE, (uint64)mem, flags) != 0) {
            remove_user_mappings(dst, 0, i / PGSIZE, 1);
            free_walk(dst);
            return -1;
        }
    }
    return 0;
}