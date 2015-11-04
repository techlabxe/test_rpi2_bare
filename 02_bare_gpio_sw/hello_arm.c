/* 
 * Prerequire:
 *   sudo apt-get install gcc-arm-none-eabi
 *
 * Compile:
 *   arm-none-eabi-gcc -O2 -mfpu=vfp -mfloat-abi=hard -march=armv7-a -mtune=cortex-a7 -nostartfiles -g hello_arm.c -o kernel.elf

 */

// RPI2 only
#define GPIO_BASE       0x3F200000UL
#define LED_GPFSEL      GPIO_GPFSEL4
#define LED_GPFBIT      21
#define LED_GPSET       GPIO_GPSET1
#define LED_GPCLR       GPIO_GPCLR1
#define LED_GPIO_BIT    15

#define SW0_GPFSEL      GPIO_GPFSEL1
#define SW0_GPFBIT      8
#define SW0_GPIO_BIT    18
#define SW0_GPLEVEL     GPIO_GPLEV0

#define GPIO_GPFSEL0    0
#define GPIO_GPFSEL1    1
#define GPIO_GPFSEL2    2
#define GPIO_GPFSEL3    3
#define GPIO_GPFSEL4    4
#define GPIO_GPFSEL5    5

#define GPIO_GPSET0     7
#define GPIO_GPSET1     8

#define GPIO_GPCLR0     10
#define GPIO_GPCLR1     11

#define GPIO_GPLEV0     13
#define GPIO_GPLEV1     14

#define GPIO_GPEDS0     16
#define GPIO_GPEDS1     17

#define GPIO_GPREN0     19
#define GPIO_GPREN1     20

#define GPIO_GPFEN0     22
#define GPIO_GPFEN1     23

#define GPIO_GPHEN0     25
#define GPIO_GPHEN1     26

#define GPIO_GPLEN0     28
#define GPIO_GPLEN1     29

#define GPIO_GPAREN0    31
#define GPIO_GPAREN1    32

#define GPIO_GPAFEN0    34
#define GPIO_GPAFEN1    35

#define GPIO_GPPUD      37
#define GPIO_GPPUDCLK0  38
#define GPIO_GPPUDCLK1  39

/** GPIO Register set */
volatile unsigned int* gpio;

/** Simple loop variable */
volatile unsigned int tim;

void kernel_main(int r0, int r1, int tags )
{
  gpio = (unsigned int*)GPIO_BASE;
  gpio[LED_GPFSEL] |= (1 << LED_GPFBIT);
    
  gpio[GPIO_GPFSEL1] |= (0 << SW0_GPFBIT);
  
  while( 1 ) 
  {
    for(tim = 0; tim < 250000; tim++ )
    {
      ;
    }
    gpio[LED_GPCLR] = (1 << LED_GPIO_BIT);

    for(tim = 0; tim < 250000; tim++ ) 
    {
      ;
    }
    if( gpio[SW0_GPLEVEL] & (1<<SW0_GPIO_BIT) ) {
      gpio[LED_GPSET] = (1 << LED_GPIO_BIT);
    }
  }

  return;
}

