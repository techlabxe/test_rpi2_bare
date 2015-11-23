.section ".text.boot"

.global init_uart 
.global put_uart

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

GPIO_REG_GPPUD = 0x94   @ GPIO Pin Pull-up/down Enable
GPIO_REG_GPPUDCLK0 = 0x98 @GPIO Pin Pull-up/down Enable Clock 0 
GPIO_REG_GPPUDCLK1 = 0x9C @GPIO Pin Pull-up/down Enable Clock 1
GPIO_ALT0 = 0x4  @ GPIO-Pin takes alternate function0

init_uart:
  stmfd sp!, {r1-r8,lr}
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
  ldmfd sp!, {r1-r8,pc}
  @ mov pc, lr

@ r1 にアドレス.
@ r2 に送信バイトサイズ.
put_uart:
  stmfd sp!, {r0-r8,lr}
  ldr r3, =#PERIPHERAL_BASE
  ldr r4, =#UART_BASE_OFFSET
  add r4, r3, r4 @ r4 に UART の基本アドレスを入れたままにしておく.
  cmp r2, #0
  beq 2f
1:ldr r3, [r4, #UART_REG_FR]
  mov r3, r3, lsr #5
  ands r3, r3, #1
  bne 1b
  ldrb r0, [r1]
  str r0, [r4, #UART_REG_DR]
  add r1, r1, #1
  subs r2, r2, #1
  bne 1b
2:ldmfd sp!, {r0-r8,pc}
  @ mov pc, lr
    