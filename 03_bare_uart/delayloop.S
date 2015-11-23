.section ".text"
.global delay_loop

@ DelayLoop
@   usage:
@     mov r1, #100 @ループカウント.
@     bl delay_loop 
delay_loop:
  cmp r1, #0
  beq loopend
  sub r1, r1, #1
  b delay_loop
loopend:
  mov pc, lr
