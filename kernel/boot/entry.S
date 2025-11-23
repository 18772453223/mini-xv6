.section .text
.global _entry
.extern __bss_start
.extern __bss_end
.extern stack0

_entry:
    // allocate stack space 
    la sp, stack0
    li a0, 1024*4
    add sp, sp, a0

    // set .bss 0
    la   t0, __bss_start     
    la   t1, __bss_end      

1:
    beq  t0, t1, 2f
    sb   zero, 0(t0)        
    addi t0, t0, 1           
    j    1b


2:
    call start

spin:
    j spin