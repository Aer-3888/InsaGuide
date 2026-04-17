/*******************************************************************************
 * dfs.s - Depth-First Search Implementation
 *
 * Recursively traverses a graph using depth-first search, marking visited vertices.
 *
 * Algorithm:
 *   1. Find index of current vertex
 *   2. Mark vertex as visited
 *   3. For each successor:
 *      - Find successor index
 *      - If not visited, recursively call DFS on successor
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
/* Parameters */
.equ offsetMarquer, 8           /* Marking array pointer */
.equ offsetG, 12                /* Graph structure pointer */
.equ offsetV, 16                /* Current vertex (character) */

/* Local variables */
.equ offsetI_v, -4              /* Index of current vertex */
.equ offsetI_w, -8              /* Index of successor vertex */
.equ offsetI, -16               /* (unused in this implementation) */
.equ offsetJ, -20               /* Loop counter for successors */
.equ offsetW, -24               /* Current successor character */

/*******************************************************************************
 * Text Section
 ******************************************************************************/
.text
.global dfs

/*******************************************************************************
 * dfs - Depth-First Search Function
 *
 * Parameters (on stack):
 *   [fp, #16] - v: Current vertex (character)
 *   [fp, #12] - g: Pointer to graph structure
 *   [fp, #8]  - marquer: Pointer to marking array
 *
 * Local variables:
 *   [fp, #-4]  - i_v: Index of vertex v
 *   [fp, #-8]  - i_w: Index of successor w
 *   [fp, #-20] - j: Loop counter (0 to nbSucc[i_v]-1)
 *   [fp, #-24] - w: Current successor character
 *
 * Modifies:
 *   marquer[i_v] = 1 (marks vertex as visited)
 ******************************************************************************/
dfs:
  /* === Function Prologue === */
  stmfd sp!, {fp, lr}           /* Save FP and LR */
  mov fp, sp                    /* Set new frame pointer */
  sub sp, #20                   /* Allocate local variables (5 words = 20 bytes) */
  stmfd sp!, {r0, r1, r2, r3, r4} /* Save registers */

  /* === Find Index of Current Vertex === */
  /* Call: rechercheSommet(v, g) */
  ldr r0, [fp, #offsetV]        /* r0 = v (vertex character) */
  ldr r1, [fp, #offsetG]        /* r1 = g (graph pointer) */
  stmfd sp!, {r1, r0}           /* Push parameters (g, v) */
  sub sp, #4                    /* Reserve space for return value */
  bl rechercheSommet            /* Call function */
  ldmfd sp!, {r0}               /* r0 = returned index */
  str r0, [fp, #offsetI_v]      /* Store i_v */
  add sp, #8                    /* Clean up parameters */

  /* === Mark Current Vertex as Visited === */
  ldr r0, [fp, #offsetMarquer]  /* r0 = marquer array pointer */
  ldr r1, [fp, #offsetI_v]      /* r1 = i_v (index) */
  mov r2, #1                    /* r2 = 1 (visited flag) */
  strb r2, [r0, r1]             /* marquer[i_v] = 1 */

  /* === Initialize Loop Counter === */
  mov r0, #0                    /* j = 0 */
  str r0, [fp, #offsetJ]

loop:
  /* === Check Loop Condition: j < g.nbSucc[i_v] === */
  ldr r0, [fp, #offsetJ]        /* r0 = j */
  ldr r1, [fp, #offsetG]        /* r1 = g */
  ldr r2, [r1, #offsetGrapheNbSucc] /* r2 = g.nbSucc (pointer) */
  ldr r3, [fp, #offsetI_v]      /* r3 = i_v */
  ldr r2, [r2, r3, lsl #2]      /* r2 = g.nbSucc[i_v] (word access) */
  cmp r0, r2                    /* Compare j with nbSucc[i_v] */
  bge endLoop                   /* Exit if j >= nbSucc[i_v] */

  /* === Get Successor: w = g.lesSuccs[i_v][j] === */
  ldr r2, [r1, #offsetGrapheLesSuccs] /* r2 = g.lesSuccs (pointer) */
  ldr r2, [r2, r3, lsl #2]      /* r2 = g.lesSuccs[i_v] (pointer to string) */
  ldrb r2, [r2, r0]             /* r2 = g.lesSuccs[i_v][j] (character) */
  str r2, [fp, #offsetW]        /* Store w */

  /* === Find Index of Successor === */
  /* Call: rechercheSommet(w, g) */
  stmfd sp!, {r1, r2}           /* Push parameters (g, w) */
  sub sp, #4                    /* Reserve space for return value */
  bl rechercheSommet            /* Call function */
  ldmfd sp!, {r4}               /* r4 = i_w (successor index) */
  add sp, #8                    /* Clean up parameters */
  str r4, [fp, #offsetI_w]      /* Store i_w */

  /* === Check if Successor is Visited === */
  ldr r3, [fp, #offsetMarquer]  /* r3 = marquer array */
  ldrb r3, [r3, r4]             /* r3 = marquer[i_w] */
  cmp r3, #0                    /* Is successor unvisited? */
  bne else                      /* If visited, skip recursive call */

  /* === Recursive DFS Call === */
  /* Call: dfs(w, g, marquer) */
  ldr r3, [fp, #offsetMarquer]  /* r3 = marquer */
  stmfd sp!, {r3, r1, r2}       /* Push parameters (marquer, g, w) */
  bl dfs                        /* Recursive call */
  add sp, #12                   /* Clean up parameters (3 words) */

else:
  /* (No action needed if already visited) */

  /* === Increment Loop Counter === */
  ldr r0, [fp, #offsetJ]        /* Load j */
  add r0, r0, #1                /* j++ */
  str r0, [fp, #offsetJ]        /* Store j */
  b loop                        /* Continue loop */

endLoop:

  /* === Function Epilogue === */
  ldmfd sp!, {r0, r1, r2, r3, r4} /* Restore registers */
  add sp, #20                   /* Free local variables */
  ldmfd sp!, {fp, lr}           /* Restore FP and LR */
  bx lr                         /* Return */

/*******************************************************************************
 * Complexity:
 *   Time: O(V + E) - Each vertex visited once, each edge traversed once
 *   Space: O(V) - Recursion depth bounded by number of vertices
 ******************************************************************************/
