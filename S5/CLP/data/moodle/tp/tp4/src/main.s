/*******************************************************************************
 * main.s - Raspberry Pi LED Control (Bare Metal)
 *
 * Objective: Blink the ACT (Activity) LED in SOS Morse code pattern
 *
 * Pattern: ... --- ... (3 short, 3 long, 3 short)
 *
 * Hardware: Raspberry Pi (any model with ACT LED on GPIO 47)
 * LED: ACT LED (green activity LED on board)
 * GPIO: Pin 47
 ******************************************************************************/

/*******************************************************************************
 * GPIO Register Addresses (Raspberry Pi 2/3)
 * Base: 0x3F200000
 ******************************************************************************/
/* GPIO Function Select Registers */
.set GPSEL4, 0x3f200010         /* GPFSEL4: Function select for GPIO 40-49 */

/* GPIO Pin Output Set/Clear Registers */
.set GPSET1, 0x3f200020         /* GPSET1: Set pins 32-53 high */
.set GPCLR1, 0x3f20002c         /* GPCLR1: Clear pins 32-53 low */

/*******************************************************************************
 * Timing Constants
 * These are iteration counts for busy-wait loops
 * Actual timing depends on CPU frequency
 ******************************************************************************/
.set speed_short, 1800000       /* Short pulse duration (dit) */
.set speed_long, 9000000        /* Long pulse duration (dah) */

/*******************************************************************************
 * Stack Frame Offsets
 ******************************************************************************/
.set offsetTime, 8              /* (Unused in current implementation) */

/*******************************************************************************
 * Text Section - Program Code
 ******************************************************************************/
.section .text
.global _start

/*******************************************************************************
 * _start - Program Entry Point
 *
 * Initializes GPIO pin 47 as output and enters infinite SOS blink loop
 ******************************************************************************/
_start:
    /* === GPIO Initialization === */
    /* Configure GPIO 47 as output */

    /* Load GPFSEL4 register address */
    ldr r0, =GPSEL4             /* r0 = 0x3F200010 */

    /* Configure pin 47 (bits 21-19 in GPFSEL4) */
    /* Pin 47 = (47 % 10) = pin 7 in this register */
    /* Bit offset = 7 * 3 = 21 */
    /* Set bits [21:19] = 001 (output mode) */
    mov r1, #0b00000000001000000000000000000000

    /* Write configuration to register */
    str r1, [r0]                /* GPFSEL4 = configuration */

begin:
    /* === SOS Pattern Loop === */

    /* --- Letter S: 3 short blinks --- */
    ldr r2, =speed_short        /* Load short duration into r2 */
    bl allumer                  /* Short blink 1 */
    bl allumer                  /* Short blink 2 */
    bl allumer                  /* Short blink 3 */

    /* --- Letter O: 3 long blinks --- */
    ldr r2, =speed_long         /* Load long duration into r2 */
    bl allumer                  /* Long blink 1 */
    bl allumer                  /* Long blink 2 */
    bl allumer                  /* Long blink 3 */

    /* --- Letter S: 3 short blinks --- */
    ldr r2, =speed_short        /* Load short duration into r2 */
    bl allumer                  /* Short blink 1 */
    bl allumer                  /* Short blink 2 */
    bl allumer                  /* Short blink 3 */

    /* --- Pause between SOS repetitions --- */
    ldr r2, =speed_long         /* Load long pause duration */
    bl sleep                    /* Wait (LED off) */

    /* Repeat forever */
    b begin                     /* Jump back to start */

/*******************************************************************************
 * allumer - Blink LED Once
 *
 * Turns LED on, waits, turns LED off, waits
 * Blink duration controlled by r2 register
 *
 * Input:
 *   r2 - Duration for on and off periods (iteration count)
 *
 * Modifies:
 *   r0, r1 (register addresses and bit patterns)
 *   Calls sleep (modifies r0)
 *
 * Note: Uses r3 to preserve LR instead of stack
 *       (bare metal - no stack initialization)
 ******************************************************************************/
allumer:
    mov r3, lr                  /* Save return address in r3 */

    /* === Turn LED ON === */
    ldr r0, =GPSET1             /* r0 = GPSET1 register address */

    /* GPIO 47 in bank 1 (pins 32-53) */
    /* Bit position = 47 - 32 = 15 */
    mov r1, #0b00000000000000001000000000000000

    str r1, [r0]                /* Set bit 15 → LED on */

    /* Wait with LED on */
    bl sleep                    /* Duration in r2 */

    /* === Turn LED OFF === */
    ldr r0, =GPCLR1             /* r0 = GPCLR1 register address */

    /* Same bit position (15) */
    mov r1, #0b00000000000000001000000000000000

    str r1, [r0]                /* Clear bit 15 → LED off */

    /* Wait with LED off (gap between pulses) */
    bl sleep                    /* Duration in r2 */

    /* Return to caller */
    bx r3                       /* Return using saved address */

/*******************************************************************************
 * sleep - Software Delay (Busy-Wait Loop)
 *
 * Implements a delay by counting from 0 to target value
 *
 * Input:
 *   r2 - Target iteration count (determines delay duration)
 *
 * Modifies:
 *   r0 (loop counter)
 *
 * Timing:
 *   Approximate, depends on CPU frequency
 *   Each iteration executes: CMP, BGE, ADD, B (4 instructions)
 *
 * Note: Not precise timing - for accurate delays, use hardware timer
 ******************************************************************************/
sleep:
    mov r0, #0                  /* Initialize counter to 0 */

sleep_loop:
    cmp r0, r2                  /* Compare counter with target */
    bge end_sleep_loop          /* Exit if counter >= target */
    add r0, #4                  /* Increment counter by 4 */
    b sleep_loop                /* Continue loop */

end_sleep_loop:
    bx lr                       /* Return to caller */

.end

/*******************************************************************************
 * Hardware Details:
 *
 * GPIO 47 (ACT LED on Raspberry Pi 2/3):
 *   - Function Select: GPFSEL4, bits [21:19]
 *   - Set High: GPSET1, bit 15
 *   - Set Low: GPCLR1, bit 15
 *
 * Register Layout:
 *   GPFSEL4 [31:0]:
 *     Bits [2:0]   = GPIO 40
 *     Bits [5:3]   = GPIO 41
 *     ...
 *     Bits [21:19] = GPIO 47  <-- We use this
 *     ...
 *     Bits [29:27] = GPIO 49
 *
 *   GPSET1 [21:0] (bits 31-22 reserved):
 *     Bit 0  = GPIO 32
 *     ...
 *     Bit 15 = GPIO 47  <-- We use this
 *     ...
 *     Bit 21 = GPIO 53
 *
 * Morse Code Timing:
 *   Dit (short): 1 unit
 *   Dah (long):  3 units
 *   Gap:         1 unit between pulses
 *   Letter gap:  3 units
 *   Word gap:    7 units
 *
 * SOS Pattern:
 *   S = • • •        (3 short)
 *   O = ▬ ▬ ▬        (3 long)
 *   S = • • •        (3 short)
 *
 * Compilation:
 *   arm-none-eabi-as -o main.o main.s
 *   arm-none-eabi-ld -Ttext=0x8000 -o kernel.elf main.o
 *   arm-none-eabi-objcopy kernel.elf -O binary kernel.img
 *
 * Deployment:
 *   Copy kernel.img to Raspberry Pi SD card boot partition
 *   (along with bootcode.bin and start.elf)
 ******************************************************************************/
