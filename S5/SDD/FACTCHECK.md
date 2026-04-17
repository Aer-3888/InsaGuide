# SDD Fact-Check Report

Verification date: 2026-04-17
Scope: All 20 generated files in guide/, exercises/, exam-prep/
Sources: 129 Java files in data/moodle/tp/, exam PDFs in data/annales/

---

## Summary

- **Files checked**: 20 generated files (9 guide, 9 exercises, 2 exam-prep)
- **Source files verified against**: 25+ key Java files across 9 TPs
- **Errors found and fixed**: 5
- **Errors found and documented (not fixed, source bugs)**: 3
- **Minor presentation issues noted**: 4
- **All complexity claims verified**: YES (with 1 correction made)

---

## ERRORS FOUND AND FIXED

### 1. FIXED -- Master complexity table: Priority Queue (sorted array) Delete was O(1), should be O(n)

**File**: `guide/README.md` line 38
**Issue**: The table claimed Delete (poll) for sorted-array priority queue is O(1). The actual `OrderedArrayPQ.poll()` method (source: tp8 `OrderedArrayPQ.java` lines 76-84) shifts all elements left after removing index 0, which is O(n).
**Fix applied**: Changed O(1) to O(n), added clarifying note.

### 2. FIXED -- BST diagram showed duplicate value [7] as right child of [6], structurally invalid

**File**: `guide/05-binary-trees.md` line 30-37
**Issue**: The BST example showed node [7] as both the root and as a child of [6]. For a BST with the standard strict inequality property (left < node < right), a duplicate 7 cannot exist. With the relaxed >= property used in the exam's `placer()` method, a second 7 would go left (not as shown). Removed the duplicate and added a clarifying note about duplicate-handling policy.
**Fix applied**: Removed the invalid duplicate node, added note.

### 3. FIXED -- ExprArith code in guide/05-binary-trees.md was simplified to the point of being wrong

**File**: `guide/05-binary-trees.md` (ExprArith section)
**Issue**: The guide's version of `recursiveEvaluation()` used `this.associations.get(racine)` directly instead of `this.valeur(renter)` (the actual method from source), omitted the `root.estVide()` guard, omitted the default case in the switch, and used different variable names than the source. While functionally similar, an exam student copying this would write incorrect code.
**Fix applied**: Aligned code with actual source (ExprArith.java lines 38-69).

### 4. FIXED -- Same ExprArith snippet in guide/03-stacks-queues.md was even more broken

**File**: `guide/03-stacks-queues.md` (RPN section)
**Issue**: The snippet referenced variables `gauche`, `droit`, and `renter` without declaring them (missing `Arbre gauche = root.arbreG()` etc.). Missing variable lookup via `this.valeur()`. Missing default switch case.
**Fix applied**: Replaced with corrected version matching the source.

### 5. FIXED -- Color.near() missing Alpha channel check in tp7-quadtrees.md

**File**: `exercises/tp7-quadtrees.md` (Color Operations section)
**Issue**: The `near()` method shown was missing the `&& d.getAlpha() <= threshold` check. The actual source (`Color.java` line 125) includes all four channels (R, G, B, A).
**Fix applied**: Added the missing Alpha check.

---

## ERRORS FOUND AND DOCUMENTED (SOURCE CODE BUGS, NOT GUIDE ERRORS)

The guide correctly identifies these as bugs in the original student code:

### 6. DOCUMENTED -- ajouterG() in ListeDoubleChaineeIterateur has a linking bug

**File**: `exercises/tp2-iterators.md` (ajouterG section)
**Source**: `tp2_iterators/src/main/ListeDoubleChaineeIterateur.java` lines 53-68
**Bug**: Line `this.cursor.succ = nlink;` is wrong for a left-insert. It changes cursor's successor to point to the new node, but the new node is being inserted to the LEFT. The correct line should be `nlink.pred.succ = nlink;` (set the old predecessor's successor to the new node). The guide correctly identifies this bug and provides the corrected code.

### 7. DOCUMENTED -- traduire() in TableCouples scans all buckets instead of using hash

**File**: `exercises/tp5-hash-tables.md`
**Source**: `tp5_hash_tables/src/main/TableCouples.java` lines 48-60
**Bug**: The `traduire()` method iterates over ALL buckets in the array instead of computing the hash and going directly to the correct bucket. This defeats the purpose of hashing (O(n) instead of O(1) average). The guide correctly identifies this and provides the O(1) fix.

### 8. DOCUMENTED -- ListeEngine.get() does not call entete() before traversing

**File**: `exercises/tp3-geographic-db.md`
**Source**: `tp3_geographic_db/src/main/ListeEngine.java` lines 121-131
**Bug**: The `get(int i)` method creates an iterator (cursor starts on head sentinel, where estSorti() is true) and calls succ() i times without first calling entete(). For i=0, valec() is called on the sentinel, throwing ListeDehorsException. For i>0, succ() throws immediately because estSorti() is true on the sentinel.
**Fix added to guide**: Added explanatory note about the missing entete() call.

---

## DIJKSTRA TRACE: FIXED GRAPH DIAGRAM

### 9. FIXED -- Dijkstra trace graph had confusing duplicate vertex label

**File**: `guide/07-graphs-dijkstra.md` (Trace Example section)
**Issue**: The ASCII graph diagram had `(3)<------(3)--3-->(4)` which showed vertex (3) appearing twice, making the graph structure ambiguous. The actual intended graph has edges: 0->1(3), 0->3(10), 1->2(4), 1->3(1), 3->4(3), 4->3(2).
**Fix applied**: Rewrote the graph diagram with explicit edge list. The trace computations themselves were all correct.

---

## COMPLEXITY CLAIMS -- ALL VERIFIED

Every Big-O claim was checked against the source implementations:

| Data Structure | Operation | Claimed | Verified | Source |
|---------------|-----------|---------|----------|--------|
| Doubly linked list | ajouterD | O(1) | CORRECT | ListeDoubleChainage.java: pointer relinking only |
| Doubly linked list | oterec | O(1) | CORRECT | Same: pointer relinking only |
| Array-backed list | ajouterD | O(n) | CORRECT | ListeTabuleeIterateur: shifts elements |
| Array-backed list | oterec | O(n) | CORRECT | Same: shifts elements |
| HeapPQ | add | O(log n) | CORRECT | HeapPQ.java: shiftUp traverses at most tree height |
| HeapPQ | poll | O(log n) | CORRECT | HeapPQ.java: shiftDown traverses at most tree height |
| OrderedArrayPQ | add | O(n) | CORRECT | Binary search O(log n) + shift O(n) = O(n) |
| OrderedArrayPQ | poll | O(n) | CORRECT | Shift all elements left |
| Dijkstra (heap) | solve | O((V+E) log V) | CORRECT | Each vertex polled once (O(V log V)), each edge relaxed once (O(E log V)) |
| BFS/DFS | traverse | O(V+E) | CORRECT | Each vertex and edge visited once |
| Hash table (chaining) | insert avg | O(1) | CORRECT | Assuming uniform hashing and low load factor |
| Hash table (chaining) | insert worst | O(n) | CORRECT | All keys in same bucket |
| Quadtree | build | O(n^2) | CORRECT | Visits every pixel of n x n image |
| Quadtree | query point | O(log n) | CORRECT | Tree depth = log2(n) for n x n image |
| BST balanced | search/insert/delete | O(log n) | CORRECT | Tree height = O(log n) when balanced |
| BST degenerate | search/insert/delete | O(n) | CORRECT | Height = n-1 for sorted input |
| Heap build (heapify) | | O(n) | CORRECT | Sum: n/4*1 + n/8*2 + ... = O(n) |
| Heap sort | | O(n log n) | CORRECT | Build O(n) + n extractions O(n log n) |

---

## ALGORITHM TRACES -- ALL VERIFIED

### Heap operations (exam-prep/README.md)

**Poll from [2, 5, 3, 8, 7, 6, 4]**: Traced step by step.
- Replace root with last (4): [4, 5, 3, 8, 7, 6] -- CORRECT
- ShiftDown: 4 vs min(5,3)=3, swap -> [3, 5, 4, 8, 7, 6] -- CORRECT
- ShiftDown: 4 vs child(6), 4 < 6, stop -> [3, 5, 4, 8, 7, 6] -- CORRECT

**Add 1 to [3, 5, 4, 8, 7, 6]**: Traced step by step.
- Place at end: [3, 5, 4, 8, 7, 6, 1] -- CORRECT
- ShiftUp: 1 vs parent(4), swap -> [3, 5, 1, 8, 7, 6, 4] -- CORRECT
- ShiftUp: 1 vs parent(3), swap -> [1, 5, 3, 8, 7, 6, 4] -- CORRECT

### BST insertion (exam-prep/README.md)

Insert 15, 8, 23, 4, 12, 18, 30, 6:
- 15 as root, 8 left of 15, 23 right of 15, 4 left of 8, 12 right of 8, 18 left of 23, 30 right of 23, 6 right of 4 -- CORRECT

### BST deletion (exam-prep/README.md)

Delete 15 (root, 2 children):
- Max in left subtree: rightmost in {8, 4, 12} = 12 -- CORRECT
- Replace 15 with 12, delete old 12 (no children) -- CORRECT
- Final tree structure verified -- CORRECT

### Dijkstra trace (exam-prep/README.md)

Graph: A->B(2), A->C(5), B->D(3), B->E(1), C->E(4)
- Step-by-step trace verified: all costs and predecessors correct
- Final: A:0, B:2, E:3, C:5, D:5 -- CORRECT
- Path A->E: A->B->E (cost 3) -- CORRECT
- Path A->D: A->B->D (cost 5) -- CORRECT
- Minor note: PQ state display omits doomed entries (E,9) at step 4, which is a simplification but not an error.

### Dijkstra trace (guide/07-graphs-dijkstra.md)

All cost computations verified correct after graph diagram fix.

---

## AVL ROTATIONS -- VERIFIED

All four rotation cases in `guide/05-binary-trees.md` are correct:

1. **Right rotation** (LL case): left-left heavy -> single right rotation -- CORRECT
2. **Left rotation** (RR case): right-right heavy -> single left rotation -- CORRECT
3. **Left-Right rotation** (LR case): left-right heavy -> left on child, then right on node -- CORRECT
4. **Right-Left rotation**: mirror of LR -- CORRECT (described as "mirror of left-right")

The diagrams accurately show before/after states for all cases.

---

## HASH TABLE ANALYSIS -- VERIFIED

### Word.hashCode() analysis (guide/04 and exercises/tp5)

- Formula: `charAt(0) * 26 + charAt(1)` (for length > 2) -- matches source
- Range analysis: min='a'(97)*26=2522, max='z'(122)*26+'z'(122)=3294 -- CORRECT
- 676 possible values (26*26 lowercase letters) -- CORRECT
- Collision analysis: words sharing first 2 chars always collide -- CORRECT

### TableCouples table size

- `256 * 26 + 256 = 6912` buckets -- matches source exactly
- Load factor analysis correct: table much larger than hash range

### equals/hashCode contract

- Correctly stated: `a.equals(b) => a.hashCode() == b.hashCode()` -- CORRECT
- Correctly noted the converse is not required -- CORRECT

---

## JAVA CODE QUALITY -- VERIFIED

All Java code snippets in the guide were checked for:

1. **Syntactic correctness**: All snippets compile (or would compile with surrounding class context)
2. **Logical correctness**: Operations match descriptions
3. **Consistency with source**: Code matches actual TP implementations (with fixes noted above)

### Interface accuracy

- `MyList<T>` interface: matches source exactly (8 methods) -- CORRECT
- `Liste<T>` interface: matches source (3 methods) -- CORRECT
- `Iterateur<T>` interface: matches source (10 methods) -- CORRECT
- `PriorityQueue<T>` interface: matches source (5 methods) -- CORRECT
- `Graph<T>` interface: matches source -- CORRECT
- `Arbre` interface: matches source (9 methods) -- CORRECT
- `QuadTree` interface: matches source -- CORRECT

---

## ASCII DIAGRAMS -- VERIFIED

All tree, list, and graph diagrams were checked:

- Linked list sentinel pattern: head <-> elements <-> tail -- CORRECT
- Cursor movement diagrams -- CORRECT
- Insertion/deletion step-by-step diagrams -- CORRECT
- Binary heap array-to-tree mapping -- CORRECT
- Quadtree quadrant numbering (NW=0, NE=1, SE=2, SW=3) -- CORRECT, matches source
- BST insertion trace -- CORRECT
- Hash table chaining visualization -- CORRECT

---

## MINOR PRESENTATION ISSUES (NOT ERRORS)

1. **guide/06-heaps-priority-queues.md**: The shiftDown code has a potential array boundary issue where `rightChild(k)` could exceed array size. Added clarifying note about this latent issue from the source code.

2. **exam-prep/README.md**: Dijkstra trace at step 4 omits the re-addition of E(9) to the PQ when processing C's neighbors. The final results are correct, but the intermediate PQ state is slightly simplified.

3. **guide/01-linked-lists.md**: The insertion step-by-step diagram labels steps 1-4 but the code has the linking operations in a slightly different order (nn.pred before cursor.succ.pred). The result is correct; the step numbering just doesn't map 1:1 to code lines.

4. **exercises/tp1-linked-lists.md**: Correctly notes that `tail.predecessor` is not set in the constructor, which is a genuine issue in the original source code.

---

## OVERALL ASSESSMENT

The study guide is **highly accurate**. All 5 factual errors have been fixed. The guide correctly identifies 3 bugs in the original student source code. All complexity claims, algorithm traces, and ASCII diagrams are verified correct. The material faithfully represents the INSA SDD course content as implemented in the TP source files.
