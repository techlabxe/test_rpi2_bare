.section ".text.boot"

.global _start 

// .global _get_stack_pointer

_start:
  ldr sp, =0x8000
  b kernel_main
  
//_infloop:
//  b _infloop
  
//_get_stack_pointer:
//  str sp, [sp]
//  ldr r0, [sp]
//  mov pc, lr
  
