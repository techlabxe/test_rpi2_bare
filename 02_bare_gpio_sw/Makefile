.PHONY: kernel.elf

SOURCES_ASM := \
	boot.S

SOURCES_C := \
	hello_arm.c


OBJCPY := arm-none-eabi-objcopy
OBJDMP := arm-none-eabi-objdump
GCC := arm-none-eabi-gcc
LD := arm-none-eabi-ld
MAP := kernel.map

OBJS := $(patsubst %.S,%.o,$(SOURCES_ASM))
OBJS += $(patsubst %.c,%.o,$(SOURCES_C)) 

ASFLAGS := -D__ASSEMBLY__
CFLAGS := -O0 -fpic -nostdlib -g
CFLAGS += -nostartfiles -nodefaultlibs
CFLAGS += -mfloat-abi=hard -march=armv7-a -mtune=cortex-a7 -mfpu=neon-vfpv4

kernel.img : kernel.elf
	$(OBJCPY) kernel.elf -O binary $@
	$(OBJDMP) -D kernel.elf > kernel.asm

%.o : %.S Makefile
	$(GCC) $(ASFLAGS) -c $< -o $@

%.o : %.c Makefile
	$(GCC) $(CFLAGS) -c $< -o $@

kernel.elf: $(OBJS) link-rpi2.ld
	$(LD) -o $@ $(OBJS) -Tlink-rpi2.ld -Map $(MAP)

clean:
	rm -f kernel.elf kernel.img $(OBJS) $(MAP)

