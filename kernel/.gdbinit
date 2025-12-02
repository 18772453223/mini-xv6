set confirmation off
set architecture riscv:rv64
target remote localhost:1234
symbol-file kernel
# 设置断点在入口
b _entry
# 设置断点在 main
b main
# 设置断点在 usertrap
b usertrap
continue
