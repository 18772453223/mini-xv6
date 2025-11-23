#include "defs.h"

#define UART0 0x10000000L

#define Reg(reg) ((volatile unsigned char *)(UART0 + (reg)))
#define RHR 0                 // receive holding register (for input bytes)
#define THR 0                 // transmit holding register (for output bytes)
#define IER 1                 // interrupt enable register
#define IER_RX_ENABLE (1<<0)
#define IER_TX_ENABLE (1<<1)
#define FCR 2                 // FIFO control register
#define FCR_FIFO_ENABLE (1<<0)
#define FCR_FIFO_CLEAR (3<<1) // clear the content of the two FIFOs
#define ISR 2                 // interrupt status register
#define LCR 3                 // line control register
#define LCR_EIGHT_BITS (3<<0)
#define LCR_BAUD_LATCH (1<<7) // special mode to set baud rate
#define LSR 5                 // line status register
#define LSR_RX_READY (1<<0)   // input is waiting to be read from RHR
#define LSR_TX_IDLE (1<<5) 

#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

// Initialize the UART (16550 compatible) for simple polling IO.
// We set 8N1 and a small divisor for a default baud (ignored by QEMU virt
// but keeps sequence correct). Interrupts are left disabled; we use polling.
void uart_init(void) {
  // Disable interrupts.
  WriteReg(IER, 0x00);
  // Enable FIFO & clear them.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
  // Set baud rate divisor latch.
  WriteReg(LCR, LCR_BAUD_LATCH);
  // Divisor low/high bytes (set to 0x03 -> 38400 if base clock 115200* divisor, not critical here).
  WriteReg(0, 0x03);
  WriteReg(1, 0x00);
  // 8 bits, no parity, one stop bit, clear baud latch.
  WriteReg(LCR, LCR_EIGHT_BITS);
}

void uart_putc(char c) {
  // Wait until transmitter idle then write the byte.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0);
  WriteReg(THR, c);
}

void uart_puts(char *s) {
    while (*s != '\0') {
        uart_putc(*s);
        s++;
    } 
}

int uartgetc(void) {
  if(ReadReg(LSR) & LSR_RX_READY){
    // input data is ready.
    return ReadReg(RHR);
  } else {
    return -1;
  }
}

/* void uartintr(void) {
  ReadReg(ISR); // acknowledge the interrupt

  acquire(&tx_lock);
  if(ReadReg(LSR) & LSR_TX_IDLE){
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
      break;
    consoleintr(c);
  }
} */