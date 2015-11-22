.section ".text.boot"

.global _start 

// .global _get_stack_pointer

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

ledloop:
  bl _waitloop
  bl _led_off
  bl _waitloop
  bl _led_on
  b ledloop
//  b kernel_main
  
_infloop:
  b _infloop
  
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
  
//_get_stack_pointer:
//  str sp, [sp]
//  ldr r0, [sp]
//  mov pc, lr
  
