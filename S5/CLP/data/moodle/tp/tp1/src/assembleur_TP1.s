/*******************************************************************************
 * assembleur_TP1.s - Introduction to ARM Assembly
 *
 * Exercise 2: GCD (Greatest Common Divisor) Implementation
 * Demonstrates: Recursion, stack management, function calling conventions
 *
 * Algorithm: Euclid's subtraction-based GCD
 *   gcd(a, b) = 0 if a==0 or b==0
 *   gcd(a, b) = a if a==b
 *   gcd(a, b) = gcd(a-b, b) if a>b
 *   gcd(a, b) = gcd(a, b-a) if a<b
 ******************************************************************************/

/* Stack frame offsets for pgcd function parameters and return value */
.equ a, 12                      /* Offset to parameter a from FP */
.equ b, 16                      /* Offset to parameter b from FP */
.equ res, 8                     /* Offset to return value from FP */

/*******************************************************************************
 * Data Section - Initialized Variables
 ******************************************************************************/
.section .data
    x : .word 666               /* First input value */
    y : .word 666               /* Second input value */

/*******************************************************************************
 * BSS Section - Uninitialized Variables
 ******************************************************************************/
.section .bss

/*******************************************************************************
 * Text Section - Code
 ******************************************************************************/
.section .text
.global _start

/*******************************************************************************
 * _start - Program Entry Point
 *
 * Loads x and y from memory, calls pgcd function, retrieves result
 ******************************************************************************/
_start:
    /* Load first parameter (x) */
    ldr r0, =x                  /* r0 = address of x */
    ldr r0, [r0]                /* r0 = value at address (dereference) */

    /* Load second parameter (y) */
    ldr r1, =y                  /* r1 = address of y */
    ldr r1, [r1]                /* r1 = value at address */

    /* Prepare function call: pgcd(x, y) */
    stmfd sp!, {r0, r1}         /* Push parameters (b=r1, a=r0) onto stack */
    sub sp, sp, #4              /* Reserve 4 bytes for return value */

    /* Call pgcd function */
    bl pgcd                     /* Branch with Link (saves return address in LR) */

    /* Retrieve result */
    ldmfd sp!, {r2}             /* Pop return value into r2 */
    add sp, sp, #8              /* Free space used by parameters (2 × 4 bytes) */

/* Infinite loop - program end */
end:
    b end                       /* Branch to self (halt execution) */

/*******************************************************************************
 * pgcd - Recursive GCD Function
 *
 * Parameters (on stack):
 *   [fp, #12] - a (first number)
 *   [fp, #16] - b (second number)
 *
 * Return value:
 *   [fp, #8]  - result (GCD of a and b)
 *
 * Algorithm:
 *   1. If a==0 or b==0, return 0
 *   2. If a==b, return a
 *   3. If a>b, return pgcd(a-b, b)
 *   4. If a<b, return pgcd(a, b-a)
 ******************************************************************************/
pgcd:
    /* === Function Prologue === */
    /* Save caller's context */
    stmfd sp!, {lr}             /* Save return address (Link Register) */
    stmfd sp!, {fp}             /* Save caller's frame pointer */

    /* Set up new stack frame */
    mov fp, sp                  /* FP now points to base of our frame */

    /* Save registers we'll modify */
    stmfd sp!, {r0, r1, r2}     /* Save r0, r1, r2 (caller's registers) */

    /* === Function Body === */
    /* Load parameters from stack */
    ldr r0, [fp, #a]            /* r0 = a (first parameter) */
    ldr r1, [fp, #b]            /* r1 = b (second parameter) */

    /* Check if a == 0 */
    cmp r0, #0                  /* Compare a with 0 */
    beq retZ                    /* If a==0, branch to return 0 */

    /* Check if b == 0 */
    cmp r1, #0                  /* Compare b with 0 */
    beq retZ                    /* If b==0, branch to return 0 */

    /* Check if a == b */
    cmp r0, r1                  /* Compare a with b */
    beq retA                    /* If a==b, branch to return a */

    /* Check if a > b */
    bgt retP1                   /* If a>b, branch to recursive case 1 */

    /* === Case: a < b → return pgcd(a, b-a) === */
    sub r1, r1, r0              /* r1 = b - a */
    stmfd sp!, {r0, r1}         /* Push new arguments: (a, b-a) */
    sub sp, sp, #4              /* Reserve space for result */
    bl pgcd                     /* Recursive call */
    ldmfd sp!, {r0}             /* Get result into r0 */
    add sp, sp, #8              /* Clean up arguments */
    str r0, [fp, #res]          /* Store result in return value slot */
    b fin                       /* Jump to function epilogue */

retA:
    /* === Case: a == b → return a === */
    mov r2, r0                  /* r2 = a */
    str r2, [fp, #res]          /* Store result */
    b fin                       /* Jump to epilogue */

retZ:
    /* === Case: a==0 or b==0 → return 0 === */
    mov r2, #0                  /* r2 = 0 */
    str r2, [fp, #res]          /* Store 0 as result */
    b fin                       /* Jump to epilogue */

retP1:
    /* === Case: a > b → return pgcd(a-b, b) === */
    sub r0, r0, r1              /* r0 = a - b */
    stmfd sp!, {r0, r1}         /* Push new arguments: (a-b, b) */
    sub sp, sp, #4              /* Reserve space for result */
    bl pgcd                     /* Recursive call */
    ldmfd sp!, {r0}             /* Get result into r0 */
    add sp, sp, #8              /* Clean up arguments */
    str r0, [fp, #res]          /* Store result in return value slot */
    b fin                       /* Jump to epilogue */

    /* === Function Epilogue === */
fin:
    /* Restore saved registers */
    ldmfd sp!, {r0, r1, r2}     /* Restore caller's r0, r1, r2 */
                                /* No local variables to clean up */

    /* Restore frame pointer and return address */
    ldmfd sp!, {fp}             /* Restore caller's frame pointer */
    ldmfd sp!, {lr}             /* Restore return address */

    /* Return to caller */
    bx lr                       /* Branch to address in Link Register */
