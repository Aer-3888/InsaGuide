/*******************************************************************************
 * rechercheSommet.s - Vertex Search Function
 *
 * Finds the index of a vertex in the graph given its character name.
 * Uses linear search through the vertex name array.
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
.equ offsetReturnValue, 8       /* Return value location */
.equ offsetG, 12                /* Graph structure pointer */
.equ offsetSommet, 16           /* Vertex character to search */
.equ offsetI, -4                /* Local loop counter */

/*******************************************************************************
 * Text Section
 ******************************************************************************/
.text
.global rechercheSommet

/*******************************************************************************
 * rechercheSommet - Find Vertex Index
 *
 * Searches for a vertex in the graph and returns its index.
 *
 * Parameters (on stack):
 *   [fp, #16] - sommet: Vertex character to find
 *   [fp, #12] - g: Pointer to graph structure
 *
 * Returns (on stack):
 *   [fp, #8]  - Index of vertex (0 to nbSommets-1)
 *
 * Local variables:
 *   [fp, #-4] - i: Loop counter
 *
 * Algorithm:
 *   i = 0
 *   while g.nom[i] != sommet:
 *       i++
 *   return i
 ******************************************************************************/
rechercheSommet:
  /* === Function Prologue === */
  stmfd sp!, {fp, lr}           /* Save FP and LR */
  mov fp, sp                    /* Set new frame pointer */
  sub sp, #4                    /* Allocate local variable (i) */
  stmfd sp!, {r0, r1, r2}       /* Save registers */

  /* === Initialize Loop Counter === */
  mov r0, #0                    /* i = 0 */
  str r0, [fp, #offsetI]

loop:
  /* === Load g.nom[i] === */
  ldr r0, [fp, #offsetI]        /* r0 = i */
  ldr r1, [fp, #offsetG]        /* r1 = g (graph pointer) */
  add r1, #offsetGrapheNom      /* r1 = &g.nom (offset to nom field) */
  ldr r1, [r1]                  /* r1 = g.nom (pointer to name array) */
  ldrb r1, [r1, r0]             /* r1 = g.nom[i] (character at index i) */

  /* === Compare with Target === */
  ldr r2, [fp, #offsetSommet]   /* r2 = sommet (target character) */
  cmp r1, r2                    /* Compare g.nom[i] with sommet */
  beq endloop                   /* If equal, found it */

  /* === Increment and Continue === */
  add r0, #1                    /* i++ */
  str r0, [fp, #offsetI]        /* Store i */
  b loop                        /* Continue searching */

endloop:
  /* === Return Index === */
  ldr r0, [fp, #offsetI]        /* r0 = i (found index) */
  str r0, [fp, #offsetReturnValue] /* Store return value */

  /* === Function Epilogue === */
  ldmfd sp!, {r0, r1, r2}       /* Restore registers */
  add sp, #4                    /* Free local variable */
  ldmfd sp!, {fp, lr}           /* Restore FP and LR */
  bx lr                         /* Return */

/*******************************************************************************
 * Complexity:
 *   Time: O(V) - Linear search through vertex names
 *   Space: O(1) - Constant space
 *
 * Assumptions:
 *   - Vertex 'sommet' exists in graph (no error handling)
 *   - Vertex names are unique
 ******************************************************************************/
