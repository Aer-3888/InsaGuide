/*******************************************************************************
 * main.s - Graph Definition and Program Entry Point
 *
 * Defines a directed graph with 5 vertices (a-e) and demonstrates DFS traversal.
 *
 * Graph structure:
 *   a → b
 *   b → c, d
 *   c → d
 *   d → e
 *   e → b, c
 ******************************************************************************/

/*******************************************************************************
 * Graph Structure Offsets
 ******************************************************************************/
.equ offsetGrapheNbSommets, 0   /* Number of vertices */
.equ offsetGrapheNom, 4         /* Pointer to vertex names */
.equ offsetGrapheNbSucc, 8      /* Pointer to successor counts */
.equ offsetGrapheLesSuccs, 12   /* Pointer to successor arrays */

/*******************************************************************************
 * Data Section - Graph Definition
 ******************************************************************************/
.data

/* Vertex names (5 vertices: a, b, c, d, e) */
nom: .ascii "abcde"
.align

/* Number of successors for each vertex */
nbSucc: .word 1, 2, 1, 1, 2

/* Successor arrays for each vertex */
b: .ascii "b"                   /* Successors of 'a' */
.align
cd: .ascii "cd"                 /* Successors of 'b' */
.align
d: .ascii "d"                   /* Successors of 'c' */
.align
e: .ascii "e"                   /* Successors of 'd' */
.align
bc: .ascii "bc"                 /* Successors of 'e' */
.align

/* Array of pointers to successor arrays */
lesSucc: .word b, cd, d, e, bc

/* Graph structure (4 words) */
g:
  .word 5                       /* nbSommets = 5 */
  .word nom                     /* Pointer to vertex names */
  .word nbSucc                  /* Pointer to successor counts */
  .word lesSucc                 /* Pointer to successor arrays */

/* Marking array for DFS (0 = unvisited, 1 = visited) */
marquer:
  .byte 0, 0, 0, 0, 0
  .align

/*******************************************************************************
 * Text Section - Program Entry Point
 ******************************************************************************/
.text
.global _start

/*******************************************************************************
 * _start - Program Entry Point
 *
 * Performs DFS traversal starting from vertex 'a'
 ******************************************************************************/
_start:
  /* === Prepare DFS Parameters === */
  mov r0, #'a'                  /* r0 = starting vertex ('a') */
  ldr r1, =g                    /* r1 = address of graph structure */
  ldr r2, =marquer              /* r2 = address of marking array */

  /* Push parameters onto stack (v, g, marquer) */
  stmfd sp!, {r2, r1, r0}       /* Stack: [marquer, g, v] from top */

  /* === Call DFS === */
  bl dfs                        /* Call depth-first search */

  /* Note: Result is in 'marquer' array (modified in place) */
  /* After DFS from 'a', all reachable vertices are marked as 1 */

end:
  b end                         /* Infinite loop - halt execution */

/*******************************************************************************
 * Expected Result:
 *
 * After DFS starting from 'a':
 *   marquer[] = {1, 1, 1, 1, 1}  (all vertices visited)
 *
 * Traversal order: a → b → c → d → e
 * (exact order depends on successor list order)
 *
 * To verify in GDB:
 *   (gdb) x/5xb &marquer
 *   Should show: 0x01 0x01 0x01 0x01 0x01
 ******************************************************************************/
