.PHONY: kernel.elf

kernel: kernel.elf
	arm-none-eabi-objcopy $< -O binary kernel.img

kernel.elf: hello_arm.c
	arm-none-eabi-gcc -O0 -mfpu=neon-vfpv4 -mfloat-abi=hard -march=armv7-a -mtune=cortex-a7 -nostartfiles -g $< -o $@

clean:
	rm -f kernel.elf kernel.img

