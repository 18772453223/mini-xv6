.section .text

.globl forktest_start
.globl forktest_end

/*
 * initcode 风格的最小用户程序：测试 fork / exit / getpid
 * 内核已在 sys_getpid 里打印 pid，不需要用户态输出。
 * 流程：
 *   fork -> 根据返回值分支：
 *     子进程: getpid -> exit(42)
 *     父进程: exit(0) (不等待)
 */
forktest_start:
    # 调用 fork
    li      a7, 1          # SYS_fork
    ecall                  # a0 = pid (child=0 parent>0 err<0)
    sext.w  a0, a0
    bltz    a0, fork_fail  # 错误直接退出
    beqz    a0, child      # 子进程分支

parent:
    # 父进程直接退出，无需等待
    li      a7, 2          # SYS_exit
    li      a0, 0
    ecall
parent_spin:
    j       parent_spin    # 不应该继续执行

child:
    # 触发一次 getpid 观察调度
    li      a7, 5          # SYS_getpid
    ecall
    li      a7, 2          # SYS_exit
    li      a0, 42
    ecall
child_spin:
    j       child_spin     # 不应该继续执行

fork_fail:
    li      a7, 2          # SYS_exit
    li      a0, -1
    ecall
fail_spin:
    j       fail_spin

forktest_end:
