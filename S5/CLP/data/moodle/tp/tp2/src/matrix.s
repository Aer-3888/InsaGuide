/*******************************************************************************
 * matrix.s - Matrix Multiplication in ARM Assembly
 *
 * Computes the product of two 3×3 matrices: RES = M1 × M2
 *
 * Algorithm:
 *   for i = 0 to N-1:
 *       for j = 0 to N-1:
 *           RES[i][j] = 0
 *           for k = 0 to N-1:
 *               RES[i][j] += M1[i][k] * M2[k][j]
 *
 * Memory Layout (row-major):
 *   Matrix M[i][j] stored as: M[0][0], M[0][1], M[0][2], M[1][0], ...
 *   Address of M[i][j] = base + (i*N + j) * sizeof(word)
 ******************************************************************************/

/*******************************************************************************
 * Constants
 ******************************************************************************/
.set    N, 3                    /* Matrix dimension (3×3) */

/*******************************************************************************
 * BSS Section - Uninitialized Data
 ******************************************************************************/
.bss
res:    .space  (4*N*N)         /* Result matrix: 3×3 = 9 words × 4 bytes = 36 bytes */

/*******************************************************************************
 * Data Section - Initialized Data
 ******************************************************************************/
.data
/* Matrix M1 (3×3) - stored row by row */
m1:     .word   1
        .word   2
        .word   3
        .word   4
        .word   5
        .word   6
        .word   7
        .word   8
        .word   9

/* Matrix M2 (3×3) - stored row by row */
m2:     .word   1
        .word   1
        .word   1
        .word   2
        .word   2
        .word   2
        .word   3
        .word   3
        .word   3

.global _start

/*******************************************************************************
 * Stack Frame Offsets
 ******************************************************************************/
/* Local variables (negative offsets from FP) */
.equ    i_offset, -4            /* Loop counter i */
.equ    j_offset, -8            /* Loop counter j */
.equ    k_offset, -12           /* Loop counter k */

/* Parameters (positive offsets from FP) */
.equ    m1_offset, 8            /* Address of matrix m1 */
.equ    m2_offset, 12           /* Address of matrix m2 */

/*******************************************************************************
 * produit - Matrix Multiplication Function
 *
 * Parameters (on stack):
 *   [fp, #8]  - Address of first matrix (m1)
 *   [fp, #12] - Address of second matrix (m2)
 *
 * Result:
 *   Writes product to global 'res' matrix
 *
 * Local Variables:
 *   [fp, #-4]  - i (outer loop counter)
 *   [fp, #-8]  - j (middle loop counter)
 *   [fp, #-12] - k (inner loop counter)
 *
 * Registers Used:
 *   r0 - Loop counter i
 *   r1 - Loop counter j
 *   r2 - Loop counter k
 *   r5 - Temporary: m1[i][k]
 *   r6 - Temporary: m2[k][j]
 *   r7 - Accumulator: res[i][j]
 *   r8 - Address: &res[i][j]
 *   r9 - Temporary address calculations
 ******************************************************************************/
produit:
    /* === Function Prologue === */
    stmfd   sp!, {lr}           /* Save return address */
    stmfd   sp!, {fp}           /* Save frame pointer */
    mov     fp, sp              /* Set new frame pointer */

    /* Allocate local variables: i, j, k (3 words = 12 bytes) */
    sub     sp, sp, #12

    /* Save registers we'll modify */
    stmfd   sp!, {r0, r1, r2, r5, r6, r7, r8, r9}

    /* === Initialize Outer Loop (i) === */
    mov     r0, #0              /* i = 0 */
    str     r0, [fp, #i_offset] /* Store i on stack */

loop_i:
    /* Load i and check loop condition */
    ldr     r0, [fp, #i_offset]
    cmp     r0, #N              /* Compare i with N */
    bhs     loop_i_out          /* Exit if i >= N (unsigned) */

    /* === Initialize Middle Loop (j) === */
    mov     r1, #0              /* j = 0 */
    str     r1, [fp, #j_offset]

loop_j:
    /* Load j and check loop condition */
    ldr     r1, [fp, #j_offset]
    cmp     r1, #N              /* Compare j with N */
    bhs     loop_j_out          /* Exit if j >= N */

    /* === Initialize res[i][j] = 0 === */
    /* Calculate address of res[i][j] */
    mov     r7, #N
    mla     r8, r7, r0, r1      /* r8 = N*i + j (linear index) */
    mov     r8, r8, LSL #2      /* r8 = (N*i + j) * 4 (byte offset) */
    ldr     r7, =res            /* r7 = base address of res */
    add     r8, r7              /* r8 = &res[i][j] */

    /* Set res[i][j] = 0 */
    mov     r7, #0
    str     r7, [r8]            /* res[i][j] = 0 */

    /* === Initialize Inner Loop (k) === */
    mov     r2, #0              /* k = 0 */
    str     r2, [fp, #k_offset]

loop_k:
    /* Load k and check loop condition */
    ldr     r2, [fp, #k_offset]
    cmp     r2, #N              /* Compare k with N */
    bhs     loop_k_out          /* Exit if k >= N */

    /* === Compute res[i][j] += m1[i][k] * m2[k][j] === */

    /* Get m1[i][k] */
    mov     r9, #N
    mla     r9, r9, r0, r2      /* r9 = N*i + k */
    mov     r9, r9, LSL #2      /* r9 = (N*i + k) * 4 */
    ldr     r6, [fp, #m1_offset] /* r6 = base address of m1 */
    add     r9, r6              /* r9 = &m1[i][k] */
    ldr     r5, [r9]            /* r5 = m1[i][k] */

    /* Get m2[k][j] */
    mov     r9, #N
    mla     r9, r9, r2, r1      /* r9 = N*k + j */
    mov     r9, r9, LSL #2      /* r9 = (N*k + j) * 4 */
    ldr     r6, [fp, #m2_offset] /* r6 = base address of m2 */
    add     r6, r9              /* r6 = &m2[k][j] */
    ldr     r6, [r6]            /* r6 = m2[k][j] */

    /* Multiply and accumulate: r7 = m1[i][k] * m2[k][j] + r7 */
    mla     r7, r6, r5, r7      /* r7 = r6*r5 + r7 (multiply-accumulate) */

    /* Save result back to res[i][j] */
    str     r7, [r8]

    /* === Increment Inner Loop Counter === */
    add     r2, r2, #1          /* k++ */
    str     r2, [fp, #k_offset]
    b       loop_k              /* Continue inner loop */

loop_k_out:

    /* === Increment Middle Loop Counter === */
    add     r1, r1, #1          /* j++ */
    str     r1, [fp, #j_offset]
    b       loop_j              /* Continue middle loop */

loop_j_out:

    /* === Increment Outer Loop Counter === */
    ldr     r0, [fp, #i_offset]
    add     r0, r0, #1          /* i++ */
    str     r0, [fp, #i_offset]
    b       loop_i              /* Continue outer loop */

loop_i_out:

    /* === Function Epilogue === */
    /* Restore saved registers */
    ldmfd   sp!, {r0, r1, r2, r5, r6, r7, r8, r9}

    /* Free local variables (i, j, k) */
    add     sp, sp, #12

    /* Restore frame pointer and return address */
    ldmfd   sp!, {fp}
    ldmfd   sp!, {lr}

    /* Return to caller */
    bx      lr

/*******************************************************************************
 * _start - Program Entry Point
 *
 * Sets up parameters and calls produit function
 ******************************************************************************/
_start:
    /* === Function Call Setup === */
    /* Load addresses of matrices */
    ldr     r0, =m1             /* r0 = address of m1 */
    ldr     r1, =m2             /* r1 = address of m2 */

    /* Push parameters onto stack */
    stmfd   sp!, {r0, r1}       /* Push m1 and m2 addresses */

    /* === Call Matrix Multiplication === */
    bl      produit             /* Call produit function */

    /* No result to retrieve (written to global 'res') */
    /* Clean up stack (remove parameters) */
    /* (Could add 'add sp, sp, #8' here, but program ends anyway) */

loop_end:
    b       loop_end            /* Infinite loop - halt execution */

.end

/*******************************************************************************
 * Expected Result:
 *
 * M1:          M2:          RES:
 * 1  2  3      1  1  1      14  14  14
 * 4  5  6   ×  2  2  2   =  32  32  32
 * 7  8  9      3  3  3      50  50  50
 *
 * Calculation for RES[0][0]:
 *   = M1[0][0]*M2[0][0] + M1[0][1]*M2[1][0] + M1[0][2]*M2[2][0]
 *   = 1*1 + 2*2 + 3*3
 *   = 1 + 4 + 9
 *   = 14
 *
 * To verify in GDB:
 *   (gdb) x/9dw &res
 *   Should show: 14, 14, 14, 32, 32, 32, 50, 50, 50
 ******************************************************************************/
