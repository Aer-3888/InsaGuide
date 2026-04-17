/*******************************************************************************
 * pgcd.s - GCD (Greatest Common Divisor) Implementation
 *
 * Alternative implementation with English comments and cleaner structure
 * Demonstrates: Recursion, stack frames, parameter passing
 *
 * Algorithm: Euclid's subtraction-based GCD
 ******************************************************************************/

/*******************************************************************************
 * Data Section - Initialized Variables
 ******************************************************************************/
.data
a:      .word   24              /* First input value */
b:      .word   18              /* Second input value */

/*******************************************************************************
 * Constants - Stack Frame Offsets
 ******************************************************************************/
.equ    b_off, 16               /* Offset to parameter b from FP */
.equ    a_off, 12               /* Offset to parameter a from FP */
.equ    res_off, 8              /* Offset to return value from FP */

/*******************************************************************************
 * BSS Section - Uninitialized Variables
 ******************************************************************************/
.bss
.align

/*******************************************************************************
 * Text Section - Code
 ******************************************************************************/
.text
.global _start

/*******************************************************************************
 * pgcd - Recursive GCD Function
 *
 * Computes the greatest common divisor of two integers using Euclid's
 * subtraction algorithm.
 *
 * Parameters (on stack):
 *   [fp, #12] - a (first integer)
 *   [fp, #16] - b (second integer)
 *
 * Returns (on stack):
 *   [fp, #8]  - GCD(a, b)
 *
 * Stack Frame Layout:
 *   [fp, #16]  b (parameter)
 *   [fp, #12]  a (parameter)
 *   [fp, #8]   result
 *   [fp, #4]   saved LR
 *   [fp, #0]   saved FP  <-- FP points here
 *   [fp, #-4]  (locals or saved registers below)
 ******************************************************************************/
pgcd:
    /* === Function Prologue === */
    stmfd   sp!, {lr}           /* Save return address */
    stmfd   sp!, {fp}           /* Save frame pointer */
    mov     fp, sp              /* Set new frame pointer */
    /* Note: No local variables needed, no register saves needed */

    /* === Load Parameters === */
    ldr     r0, [fp, #a_off]    /* r0 = a */
    ldr     r1, [fp, #b_off]    /* r1 = b */

    /* === Base Cases === */
    /* Check if a == 0 */
    cmp     r0, #0
    beq     pgcd_null           /* If a==0, return 0 */

    /* Check if b == 0 */
    cmp     r1, #0
    beq     pgcd_null           /* If b==0, return 0 */

    /* Neither is null, continue */
    b       pgcd_not_null

pgcd_null:
    /* === Return 0 (one parameter is zero) === */
    sub     r0, r0              /* r0 = r0 - r0 = 0 (clever way to set 0) */
    str     r0, [fp, #res_off]  /* Store 0 as result */
    b       pgcd_return         /* Jump to epilogue */

pgcd_not_null:
    /* === Check if a == b === */
    cmp     r0, r1
    bne     pgcd_not_eq         /* If a != b, continue checking */

    /* a == b, so GCD(a,b) = a */
    str     r0, [fp, #res_off]  /* Store a as result */
    b       pgcd_return         /* Jump to epilogue */

pgcd_not_eq:
    /* === Check if a > b === */
    cmp     r0, r1
    bls     pgcd_a_lq_b         /* Branch if a <= b (unsigned) */

    /* a > b: Call pgcd(a-b, b) */
    sub     r0, r0, r1          /* r0 = a - b */
    b       pgcd_func_call      /* Jump to recursive call setup */

pgcd_a_lq_b:
    /* a <= b (actually a < b since a==b handled above) */
    /* Call pgcd(a, b-a) */
    sub     r1, r1, r0          /* r1 = b - a */
    /* r0 already contains a, fall through to function call */

pgcd_func_call:
    /* === Recursive Function Call Setup === */
    /* At this point:
     *   r0 = first argument (modified a or original a)
     *   r1 = second argument (original b or modified b)
     */

    /* Push parameters onto stack */
    stmfd   sp!, {r0, r1}       /* Push (new_a, new_b) */

    /* Reserve space for return value */
    sub     sp, sp, #4          /* Allocate 4 bytes for result */

    /* Make recursive call */
    bl      pgcd                /* Call pgcd recursively */

    /* Retrieve result */
    ldmfd   sp!, {r0}           /* Pop result into r0 */

    /* Clean up arguments */
    add     sp, sp, #8          /* Remove two 4-byte arguments */

    /* Store result in our return value location */
    str     r0, [fp, #res_off]  /* Store result for our caller */
    b       pgcd_return         /* Jump to epilogue */

pgcd_return:
    /* === Function Epilogue === */
    /* No registers to restore (we didn't save any) */
    /* No local variables to clean up */

    /* Restore frame pointer and return address */
    ldmfd   sp!, {fp}           /* Restore caller's frame pointer */
    ldmfd   sp!, {lr}           /* Restore return address */

    /* Return to caller */
    bx      lr                  /* Branch exchange (supports ARM/Thumb) */

/*******************************************************************************
 * _start - Program Entry Point
 *
 * Initializes parameters and calls pgcd function
 ******************************************************************************/
_start:
    /* === Load Input Values === */
    /* Load first parameter (a) */
    ldr     r0, =a              /* r0 = address of variable a */
    ldr     r0, [r0]            /* r0 = value at that address (24) */

    /* Load second parameter (b) */
    ldr     r1, =b              /* r1 = address of variable b */
    ldr     r1, [r1]            /* r1 = value at that address (18) */

    /* === Function Call Setup === */
    /* Push parameters onto stack (right to left: b, a) */
    stmfd   sp!, {r0, r1}       /* Stack now has: [b, a] from top */

    /* Reserve space for return value */
    sub     sp, sp, #4          /* Allocate 4 bytes */

    /* === Call pgcd Function === */
    bl      pgcd                /* Branch with Link (saves PC in LR) */

    /* === Retrieve Result === */
    ldm     sp!, {r0}           /* Pop result into r0 (note: LDM not LDMFD) */

    /* === Clean Up Stack === */
    add     sp, sp, #8          /* Remove two arguments (2 × 4 bytes) */

    /* Result is now in r0 - could be returned as exit code */

/* === Program End === */
_loopdone:
    b       _loopdone           /* Infinite loop (halt execution) */

/*******************************************************************************
 * Expected Results:
 *
 * Input:  a = 24, b = 18
 * Output: r0 = 6 (GCD of 24 and 18)
 *
 * Trace:
 *   pgcd(24, 18) → pgcd(6, 18) → pgcd(6, 12) → pgcd(6, 6) → 6
 *
 * Verification:
 *   24 = 6 × 4
 *   18 = 6 × 3
 *   GCD(4, 3) = 1, so 6 is the greatest common divisor
 ******************************************************************************/
