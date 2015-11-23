OUTPUT_FORMAT("elf32-littlearm", "elf32-bigarm", "elf32-littelearm" )
OUTPUT_ARCH(arm)

ENTRY(_start)
SEARCH_DIR("=/usr/local/lib"); SEARCH_DIR("=/lib"); SEARCH_DIR("=/usr/lib");
SECTIONS
{
  PROVIDE( __executable_start = SEGMENT_START("text-segment", 0x8000));
  . = SEGMENT_START("text-segment", 0x8000 );
  .text : 
  {
    *(.text.exit .text.exit.*)
    *(.text.startup .text.startup.*)
    *(text .stub .text.*)
    
  } = 0
  _text_end = .;
  .data :
  {
    __data_start = . ;
    *(.data .data.* .gnu.linkonce.d.*)
  }
  __bss_start = .;
  __bss_start__ = .;
  .bss :
  {
    *(.bss .bss.* .gnu.linkonce.b.*)
  }
  _bss_end__ = .; __bss_end__ = .;
  . = ALIGN(32 / 8);
  . = ALIGN(32 / 8);
  __end__ = .;
  _end = .; PROVIDE (end = .);
  
  .stack 0x80000 :
  {
    _stack = .;
    *(.stack)
  }
}

