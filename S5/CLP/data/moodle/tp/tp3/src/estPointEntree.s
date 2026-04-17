/*******************************************************************************
 * estPointEntree.s - Entry Point Detection Function
 *
 * Determines if a given vertex is an entry point in the graph.
 * A vertex is an entry point if it has no incoming edges (no other vertex
 * has it as a successor).
 ******************************************************************************/

/*******************************************************************************
 * Graph Structure Offsets
 ******************************************************************************/
.equ offsetGrapheNbSommets, 0
.equ offsetGrapheNom, 4
.equ offsetGrapheNbSucc, 8
.equ offsetGrapheLesSuccs, 12

/*******************************************************************************
 * Stack Frame Offsets
 ******************************************************************************/
.equ offsetReturnValue, 8       /* Return value (0 or 1) */
.equ offsetG, 12                /* Graph structure pointer */
.equ offsetSommet, 16           /* Vertex character to check */
.equ offsetI, -4                /* Local: outer loop counter */
.equ offsetJ, -8                /* Local: inner loop counter */

/*******************************************************************************
 * Text Section
 ******************************************************************************/
.text
.global estPointEntree

/*******************************************************************************
 * estPointEntree - Check if Vertex is Entry Point
 *
 * Parameters (on stack):
 *   [fp, #16] - sommet: Vertex character to check
 *   [fp, #12] - g: Pointer to graph structure
 *
 * Returns (on stack):
 *   [fp, #8]  - Result: 1 if entry point, 0 otherwise
 *
 * Local variables:
 *   [fp, #-4] - i: Outer loop counter (vertices)
 *   [fp, #-8] - j: Inner loop counter (successors)
 *
 * Algorithm:
 *   for i = 0 to g.nbSommets - 1:
 *       for j = 0 to g.nbSucc[i] - 1:
 *           if g.lesSuccs[i][j] == sommet:
 *               return 0  // Found incoming edge
 *   return 1  // No incoming edges found
 ******************************************************************************/
estPointEntree:
  /* === Function Prologue === */
  stmfd sp!, {fp, lr}           /* Save FP and LR */
  mov fp, sp                    /* Set new frame pointer */
  sub sp, #8                    /* Allocate local variables (i, j) */
  stmfd sp!, {r0, r1, r2, r3, r4, r5, r6, r7} /* Save registers */

  /* === Initialize Outer Loop === */
  mov r0, #0                    /* i = 0 */
  str r0, [fp, #offsetI]

loopI:
  /* === Check Outer Loop Condition: i < g.nbSommets === */
  ldr r0, [fp, #offsetI]        /* r0 = i */
  ldr r1, [fp, #offsetG]        /* r1 = g */
  ldr r2, [r1, #offsetGrapheNbSommets] /* r2 = g.nbSommets */
  cmp r0, r2                    /* Compare i with nbSommets */
  bge endLoopI                  /* Exit if i >= nbSommets */

  /* === Initialize Inner Loop === */
  mov r3, #0                    /* j = 0 */
  str r3, [fp, #offsetJ]

loopJ:
  /* === Check Inner Loop Condition: j < g.nbSucc[i] === */
  ldr r3, [fp, #offsetJ]        /* r3 = j */
  ldr r4, [r1, #offsetGrapheNbSucc] /* r4 = g.nbSucc (pointer) */
  ldr r4, [r4, r0, lsl #2]      /* r4 = g.nbSucc[i] */
  cmp r3, r4                    /* Compare j with nbSucc[i] */
  bge endLoopJ                  /* Exit if j >= nbSucc[i] */

  /* === Check if g.lesSuccs[i][j] == sommet === */
  ldr r5, [r1, #offsetGrapheLesSuccs] /* r5 = g.lesSuccs (pointer) */
  ldr r5, [r5, r0, lsl #2]      /* r5 = g.lesSuccs[i] (pointer to string) */
  ldrb r5, [r5, r3]             /* r5 = g.lesSuccs[i][j] (character) */
  ldr r6, [fp, #offsetSommet]   /* r6 = sommet (target character) */
  cmp r5, r6                    /* Compare successor with target */
  bne else                      /* If not equal, continue */

  /* === Found Incoming Edge: Return 0 === */
  mov r7, #0                    /* r7 = 0 (not an entry point) */
  b return                      /* Jump to return */

else:
  /* === Increment Inner Loop Counter === */
  add r3, #1                    /* j++ */
  str r3, [fp, #offsetJ]        /* Store j */
  b loopJ                       /* Continue inner loop */

endLoopJ:
  /* === Increment Outer Loop Counter === */
  add r0, #1                    /* i++ */
  str r0, [fp, #offsetI]        /* Store i */
  b loopI                       /* Continue outer loop */

endLoopI:
  /* === No Incoming Edges Found: Return 1 === */
  mov r7, #1                    /* r7 = 1 (is an entry point) */

return:
  /* === Store Return Value === */
  str r7, [fp, #offsetReturnValue]

  /* === Function Epilogue === */
  ldmfd sp!, {r0, r1, r2, r3, r4, r5, r6, r7} /* Restore registers */
  add sp, #8                    /* Free local variables */
  ldmfd sp!, {fp, lr}           /* Restore FP and LR */
  bx lr                         /* Return */

/*******************************************************************************
 * Complexity:
 *   Time: O(V × E) - Nested loops over vertices and edges
 *   Space: O(1) - Constant space
 *
 * Example:
 *   In graph: a→b, b→c,d, c→d, d→e, e→b,c
 *   
 *   estPointEntree('a', g) → 1 (no incoming edges)
 *   estPointEntree('b', g) → 0 (incoming from a and e)
 *   estPointEntree('c', g) → 0 (incoming from b and e)
 *   estPointEntree('d', g) → 0 (incoming from b and c)
 *   estPointEntree('e', g) → 0 (incoming from d)
 ******************************************************************************/
