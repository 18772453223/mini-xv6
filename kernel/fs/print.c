#include <stdarg.h>
#include "types.h"
#include "defs.h"

#define INT_MIN 0x80000000

static char digits[] = "0123456789abcdef";

volatile int panicking = 0; // printing a panic message
volatile int panicked = 0; // spinning forever at end of a panic
 
static void print_number(int num, int base, int sign) {
    char buf[20];
    int i = 0;

    unsigned int un;
    // signed negative will firstly be converted to the opposite and add "-"
    if (sign && (sign = (num < 0))) {
        if (num == INT_MIN) {
            un = (unsigned int)num; // avoid overflow
        } else {
            un = -num;
        }
    } else {
        un = num;
    }

    do {
        buf[i++] = digits[un % base];
    } while((un /= base) != 0);

    if (sign) {
        buf[i++] = '-';
    }
    while(--i >= 0) {
        uart_putc(buf[i]);
    }
}

static void printptr(uint64 x) {
  int i;
  consputc('0');
  consputc('x');
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
}


int printf(char *fmt, ...) {
    va_list ap;
    int i, cx, c0, c1, c2;
    char *s;

    va_start(ap, fmt);
    for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
        if(cx != '%'){
        consputc(cx);
        continue;
        }
        i++;
        c0 = fmt[i+0] & 0xff;
        c1 = c2 = 0;

        if(c0) c1 = fmt[i+1] & 0xff;
        if(c1) c2 = fmt[i+2] & 0xff;

        if(c0 == 'd'){
            print_number(va_arg(ap, int), 10, 1);
        } else if(c0 == 'l' && c1 == 'd'){
            print_number(va_arg(ap, uint64), 10, 1);
            i += 1;
        } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
            print_number(va_arg(ap, uint64), 10, 1);
            i += 2;
        } else if(c0 == 'u'){
            print_number(va_arg(ap, uint32), 10, 0);
        } else if(c0 == 'l' && c1 == 'u'){
            print_number(va_arg(ap, uint64), 10, 0);
            i += 1;
        } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
            print_number(va_arg(ap, uint64), 10, 0);
            i += 2;
        } else if(c0 == 'x'){
            print_number(va_arg(ap, uint32), 16, 0);
        } else if(c0 == 'l' && c1 == 'x'){
            print_number(va_arg(ap, uint64), 16, 0);
            i += 1;
        } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
            print_number(va_arg(ap, uint64), 16, 0);
            i += 2;
        } else if(c0 == 'p'){
            printptr(va_arg(ap, uint64));
        } else if(c0 == 'c'){
            consputc(va_arg(ap, uint));
        } else if(c0 == 's'){
            if((s = va_arg(ap, char*)) == 0)
                s = "(null)";
            for(; *s; s++)
                consputc(*s);
        } else if(c0 == '%'){
            consputc('%');
        } else if(c0 == 0){
            break;
        } else {
            // Print unknown % sequence to draw attention.
            consputc('%');
            consputc(c0);
        }

    }
    va_end(ap);

    return 0;
}

void panic(char *s) {
  printf("panic: ");
  printf("%s\n", s);
  for(;;)
    ;
}

void clear_screen() {
    printf("\033[2J");
    printf("\033[H");
}