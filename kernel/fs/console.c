#include "defs.h"

#define BACKSPACE 0x100

void consputc(int c) {
    if (c == BACKSPACE) {
        uart_putc('\b'); uart_putc(' '); uart_putc('\b');
    } else {
        uart_putc(c);
    }
}