# 交叉编译工具链前缀
CROSS   ?= riscv64-unknown-elf
CC      := $(CROSS)-gcc

# 目录定义
BOOTDIR := boot
FSDIR   := fs
MMDIR   := mm
PKGDIR  := pkg
TRAPDIR  := trap
PROCDIR  := proc
USERDIR  := ../user

# 编译和链接参数
CFLAGS  := -march=rv64gc -mabi=lp64 -mcmodel=medany \
		   -ffreestanding -nostdlib -O2 -Wall -Wextra \
		   -I$(PKGDIR) -I$(PROCDIR)

LDFLAGS := -T $(BOOTDIR)/kernel.ld -nostdlib

# user program (forktest) build into binary object
USER_ASM = forktest.S

SRCS = entry.S main.c uart.c console.c print.c test.c kalloc.c vm.c string.c start.c trap.c plic.c kernelvec.S \
	proc.c swtch.S trampoline.S syscall.c forktest.S

OBJS = $(SRCS:.c=.o)
OBJS := $(OBJS:.S=.o)

# 设置源文件搜索路径
vpath %.S $(BOOTDIR):$(TRAPDIR):$(PROCDIR):$(USERDIR)
vpath %.c $(BOOTDIR):$(FSDIR):$(MMDIR):$(PKGDIR):$(TRAPDIR):$(PROCDIR)

# 最终生成的内核文件
KERNEL = kernel

all: $(KERNEL)

# 编译规则
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.S
	$(CC) $(CFLAGS) -c $< -o $@

# 链接生成内核
$(KERNEL): $(OBJS) $(BOOTDIR)/kernel.ld
	$(CC) $(CFLAGS) $(LDFLAGS) $(OBJS) -o $@

# user program builds like normal object; symbols forktest_start/forktest_end used

run: $(KERNEL)
	qemu-system-riscv64 -machine virt \
	-cpu rv64,sstc=on \
	-nographic -bios none -kernel $(KERNEL)

debug: $(KERNEL)
	qemu-system-riscv64 -machine virt \
	-cpu rv64,sstc=on \
	-bios none \
	-nographic -bios none -kernel $(KERNEL) -s -S

clean:
	rm -f $(OBJS) $(KERNEL)

.PHONY: all run clean
