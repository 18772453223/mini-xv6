#include "defs.h"
#include "memlayout.h"

extern pagetable_t kernel_pagetable;


void assert (int cond) {
    if (!cond) {
        printf("ASSERTION FAILED");
        printf("\n");
        return;
    }
    
    printf("ASSERTION PASSED");
    printf("\n");
}

void test_physical_memory(void) {

    // 测试基本分配和释放
    void *page1 = alloc_page();
    void *page2 = alloc_page();

    printf("Allocated pages: %p, %p\n", page1, page2);

    assert(page1 != page2);
    assert(((uint64)page1 & 0xFFF) == 0);

    // 测试数据写入
    *(int*)page1 = 0x12345678;
    assert(*(int*)page1 == 0x12345678);

    // 测试释放和重新分配
    free_page(page1);
    void *page3 = alloc_page();

    free_page(page2);
    free_page(page3);

}

void test_pagetable(void) {
    // 页对齐检查pagetable_t pt = create_pagetable();
    pagetable_t pt = create_pagetable();

    // 测试基本映射
    uint64 va = 0x1000000;
    uint64 pa = (uint64)alloc_page();

    printf("value = %d", PGSIZE % PGSIZE);
    assert(mappages(pt, va, PGSIZE, pa, PTE_R | PTE_W) == 0);

    // 测试地址转换
    pte_t *pte = walk(pt, va, 0);
    assert(pte != 0 && (*pte & PTE_V));
    assert(PTE2PA(*pte) == pa);

    // 测试权限位
    assert(*pte & PTE_R);
    assert(*pte & PTE_W);
    assert(!(*pte & PTE_X));
}

void test_virtual_memory(void) {
    printf("Before enabling paging...\n");


    // 启用分页
    kvminit();
    kvminithart();

    printf("After enabling paging...\n");


    // 测试内核代码仍然可执行
    uint64 va = uart_putc;

    pte_t * pte = walk(kernel_pagetable, va, 0);

    assert(pte != 0 && (*pte & PTE_V));
    assert(*pte & PTE_R);
    assert(*pte & PTE_X);
    assert(!(*pte & PTE_W));
        
    uart_puts("Kernel code can execute!\n");
    // 测试内核数据仍然可访问
    va = (uint64)&kernel_pagetable;
    pte_t * pte2 = walk(kernel_pagetable, va, 0);
    assert(pte2 != 0 && (*pte2 & PTE_V));
    assert(*pte2 & PTE_R);
    
    // 测试设备访问仍然正常

} 