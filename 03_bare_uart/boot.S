.section ".text.boot"

.global _start 

PERIPHERAL_BASE = 0x3f000000  @RPI2 ではここからペリフェラルのマップ開始.
GPIO_BASE_OFFSET= 0x00200000  @GPIO 関連レジスタへのオフセット
UART_BASE_OFFSET= 0x00201000  @UART 関連レジスタへのオフセット.

GPIO_REG_GPPUD = 0x94   @ GPIO Pin Pull-up/down Enable
GPIO_REG_GPPUDCLK0 = 0x98 @GPIO Pin Pull-up/down Enable Clock 0 
GPIO_REG_GPPUDCLK1 = 0x9C @GPIO Pin Pull-up/down Enable Clock 1

UART_REG_DR     = 0     @ Data register [32]
UART_REG_RSRECR = 4     @ 
UART_REG_FR     = 0x18  @ Flag register [32]
UART_REG_ILPR   = 0x20
UART_REG_IBRD   = 0x24 @ Integer Baud rate divisor [32]
UART_REG_FBRD   = 0x28 @ Fractional Baud rate divisor [32]
UART_REG_LCRH   = 0x2c @ Line Control register [32]
UART_REG_CR     = 0x30 @ Control Register [32]
UART_REG_IFLS   = 0x34 @ Interupt FIFO Level Seclet register [32]
UART_REG_IMSC   = 0x38 @ Interupt Mask Set Clear register
UART_REG_RIS    = 0x3c @ Raw Input Status register
UART_REG_MIS    = 0x40 @ Masked Interupt Status register
UART_REG_ICR    = 0x44 @ Interupt Clear Register
UART_REG_DMACR  = 0x48 @ DMA Control Register
UART_REG_ITCR   = 0x80 @ Test Control register
UART_REG_ITIP   = 0x84 @ Integration test input reg
UART_REG_ITOP   = 0x88 @ Integration test output reg
UART_REG_TDR    = 0x8c @ test data reg

GPIO_ALT0 = 0x4  @ GPIO-Pin takes alternate function0

_start:
  ldr sp, =0x8000
  ldr r0, =0x3f200010
  ldr r2, =1
  mov r1, r2, lsl #21
  str r1,[r0]   // 0x3F200010 = 1<<21
  ldr r2, =1
  mov r1, r2, lsl #15
  ldr r0, =0x3f200020
  str r1,[r0]
  bl _init_uart
  //bl  testuart
  bl  testuart2
  b ledloop

_infloop:
  b _infloop

.align 4
_core1entry:
  ldr sp,=0x8100
ledloop:
  bl _waitloop
  bl _led_off
  bl _waitloop
  bl _led_on
  b ledloop
  
_waitloop:
   mov r6, lr
   mov r4, #1
   mov r4, r4, lsl #20 @512k times loop
1: subs r4, r4, #1
   bne 1b              @ if(r4) goto 1
2: @loopend
  mov pc, r6
  
_led_on:
  mov r6, lr
  ldr r0, =0x3f200000
  ldr r1, =8 @GPSET1
  add r0, r0, r1, lsl #2
  mov r1, #1
  mov r1, r1, lsl #15
  str r1, [r0]
  mov pc, r6
  
_led_off:
  mov r6, lr
  ldr r0, =0x3f200000
  ldr r1, =11 @ GPCLR
  add r0, r0, r1, lsl #2
  mov r1, #1
  mov r1, r1, lsl #15
  str r1, [r0]
  mov pc, r6

_init_uart:
  ldr r0, =#PERIPHERAL_BASE
  ldr r1, =#UART_BASE_OFFSET
  add r4, r0, r1 @ r4 に UART の基本アドレスを入れたままにしておく.
  mov r0, #0
  str r0, [r4, #UART_REG_CR]
  // GPIO14, 15 に ALT0 の役割で初期化.
  ldr r0, =#PERIPHERAL_BASE
  ldr r1, =#GPIO_BASE_OFFSET
  add r5, r0, r1 @ r5 に GPIO の基本アドレスを入れたままにしておく.
  add r0, r5, #4 @GPFSEL1
  ldr r1, [r0]
  mvn r2, #0x3f000 
  and r1, r1, r2
  mov r3, #GPIO_ALT0
  orr r1, r1, r3,lsl #12
  orr r1, r1, r3,lsl #15
  str r1, [r5, #4] @ GPFSEL1
  // GPIO Pull-up/down を無効にして 150 サイクルを待つ.
  mov r0, #0
  str r0, [r4, #GPIO_REG_GPPUD]
  mov r3, #1
  mov r3, r3, lsl #8
delay_loop1:
  subs r3, r3, #1
  bne delay_loop1
  ldr r0, =#0xC000 @ (1<<14|1<<15)
  str r0, [r4, #GPIO_REG_GPPUDCLK0]
  mov r3, #1
  mov r3, r3, lsl #8
delay_loop2:
  subs r3, r3, #1
  bne delay_loop2
  @ GPPUDCLK0 を再び 0 にセット.
  mov r0, #0
  str r0, [r4, #GPIO_REG_GPPUDCLK0]
  @ Interrupt Clear Register 割り込みを無効にする
  ldr r0, =#0x7ff
  str r0, [r4, #UART_REG_ICR]
  mov r0, #1
  str r0, [r4, #UART_REG_IBRD]
  mov r0, #40
  str r0, [r4, #UART_REG_FBRD]
  mov r0, #0x70 @ 1<<4:FIFO, 0b11 (5,6bit) : 8bit/frame
  str r0, [r4, #UART_REG_LCRH]
  ldr r0, =#0x3F1
  str r0, [r4, #UART_REG_IMSC]
  ldr r0, =#0x301
  str r0, [r4, #UART_REG_CR]
  mov pc, lr

@ テストのためのコード.
testuart:
  ldr r0, =#PERIPHERAL_BASE
  ldr r1, =#UART_BASE_OFFSET
  add r4, r0, r1 @ r4 に UART の基本アドレスを入れたままにしておく.
  mov r3, #10
checkfr:
  ldr r0, [r4, #UART_REG_FR]
  mov r1, r0, lsr #5
  ands r1, r1, #1
  bne checkfr
  mov r0, #0x41
  str r0, [r4, #UART_REG_DR]
  subs r3, r3, #1
  bne checkfr
  mov r0, #0x43
  str r0, [r4, #UART_REG_DR]
  mov r0, #0
  str r0, [r4, #UART_REG_DR]
  mov pc, lr
  
@ Hello,world 出力用.
testuart2:
  ldr r0, =#PERIPHERAL_BASE
  ldr r1, =#UART_BASE_OFFSET
  add r4, r0, r1 @ r4 に UART の基本アドレスを入れたままにしておく.
  ldr r2, msg_addr
  ldr r3, msg_length
checkfr2:
  ldr r0, [r4, #UART_REG_FR]
  mov r1, r0, lsr #5
  ands r1, r1, #1
  bne checkfr2
  ldrb r0, [r2]
  str r0, [r4, #UART_REG_DR]
  add r2, r2, #1
  subs r3, r3, #1
  bne checkfr2
  mov pc, lr

msg_addr: .long msg0
msg_length: .long msg0_size

.data
 .align 4
msg0: .asciz "Hello, world\r\n"
 .align 4
msg0_size = . - msg0
