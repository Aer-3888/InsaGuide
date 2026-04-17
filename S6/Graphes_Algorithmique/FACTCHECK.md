# Fact-Check Report: Graphes et Algorithmique (S6)

Date: 2026-04-17
Files checked: 21 generated files (9 guide, 6 exercises, 4 exam-prep, 2 READMEs)
Source materials: 10 moodle guide files, TD 1-7 folders, fiches, annales

---

## Summary

**Total issues found: 5**
- CRITICAL (factual error affecting correctness): 2 -- FIXED
- MAJOR (severely confusing content): 1 -- FIXED
- MINOR (cosmetic or clarity): 2 -- noted but not blocking

---

## CRITICAL Issues (Fixed)

### 1. Petersen graph incorrectly stated as Hamiltonian

**File:** `guide/06_euler_hamilton.md`, line 264-267 (original)
**Error:** The text stated "Ce graphe est hamiltonien malgre d(v)=3 < n/2=5 pour tout v." This is **false**. The Petersen graph is a well-known example of a non-Hamiltonian graph. It has a Hamiltonian path but no Hamiltonian cycle.
**Impact:** Students relying on this would give wrong answers in DS problems involving the Petersen graph, which is a frequently tested example.
**Fix applied:** Replaced with correct statement: "Ce graphe n'est PAS hamiltonien (resultat classique)." Added C_5 as a correct example of a graph that is Hamiltonian despite not satisfying Dirac's condition.
**Cross-check:** The exercises file `exercises/04_euler_hamilton_cycles.md` (exercise 3c) already correctly stated that the Petersen graph has no Hamiltonian cycle. The error was only in the guide.

### 2. Dijkstra negative-weight counterexample was incorrect

**File:** `guide/03_shortest_paths.md`, lines 109-123 (original)
**Error:** The "why Dijkstra fails with negative weights" example showed a graph with arcs A->B(1), A->C(5), B->C(-4). In this specific graph, Dijkstra would actually produce the correct result (it visits B before C, and would update C from 5 to -3 correctly). The counterexample did not actually demonstrate Dijkstra's failure.
**Impact:** Students would memorize a flawed counterexample and might not understand the actual mechanism of Dijkstra's failure with negative weights.
**Fix applied:** Replaced with a correct counterexample where Dijkstra genuinely fails: A->B(1), A->D(10), B->C(2), D->C(-8). Dijkstra visits C(dist=3) before D(dist=10), so when D later provides a cheaper path to C (cost 2), C is already marked visited and cannot be updated.

---

## MAJOR Issue (Fixed)

### 3. Hierholzer algorithm example was incoherent

**File:** `guide/06_euler_hamilton.md`, lines 92-223 (original)
**Error:** The Hierholzer example spanned ~130 lines of failed attempts. The author initially tried to demonstrate the algorithm on K_4 (which has all odd degrees and therefore no Eulerian cycle), then spent dozens of lines discovering this, then tried several more graphs that also failed to have all even degrees, before finally finding a trivially simple 4-cycle as the example. The entire section was a stream of consciousness with no clean result, making it useless as a study reference.
**Impact:** Students would be confused by the chaotic presentation and unable to extract a clear example of how Hierholzer works.
**Fix applied:** Replaced the entire section with a clean "bowtie" graph example (two triangles sharing a vertex C, with d(C)=4 and all other vertices degree 2). The example clearly demonstrates both phases of Hierholzer: finding an initial cycle (A-B-C-A), finding a sub-cycle at a vertex with remaining edges (C-D-E-C), and inserting the sub-cycle to get A-B-C-D-E-C-A.

---

## MINOR Issues (Not Fixed -- Non-blocking)

### 4. Oriented graph ASCII diagrams occasionally ambiguous

**Files:** `guide/01_graph_fundamentals.md` (line 41-47), `exercises/01_definitions_representations.md` (lines 82-100)
**Issue:** Some ASCII diagrams for oriented graphs try to show arc directions with `|`, `v`, and `+` characters, but the result can be hard to parse. For example, the arc (D,A) in the first guide is shown with a `+------+` at the bottom which is not immediately clear.
**Impact:** Low -- the formal definitions and arc lists always accompany the diagrams.

### 5. Ford-Fulkerson example in guide has minor graph description redundancy

**File:** `guide/05_network_flow.md` (lines 87-98)
**Issue:** The graph description at the top of the Ford-Fulkerson example uses a semi-graphical format that is harder to follow than the clean arc list that follows it. The visual representation mixes arrows and ASCII formatting in a way that could be misread.
**Impact:** Low -- the arc list on line 98 unambiguously specifies the graph.

---

## Verified Correct (No Issues Found)

### Algorithm Traces

| Algorithm | File | Verdict |
|-----------|------|---------|
| Dijkstra (guide example) | `guide/03_shortest_paths.md` | CORRECT -- all 5 steps verified, distances match |
| Dijkstra (exam-prep) | `exam-prep/03_algorithm_traces.md` | CORRECT -- 6 steps verified, dist={A:0,B:2,C:3,D:7,E:5,F:5} |
| Dijkstra (typical problems) | `exam-prep/02_typical_problems.md` | CORRECT -- dist={A:0,B:3,C:2,D:4,E:9} |
| Bellman-Ford (guide) | `guide/03_shortest_paths.md` | CORRECT -- circuit B->D->B of weight -2 detected |
| Bellman-Ford (exam-prep) | `exam-prep/03_algorithm_traces.md` | CORRECT -- dist={A:0,B:2,C:3,D:0,E:1}, no negative circuit |
| Floyd-Warshall (guide) | `guide/03_shortest_paths.md` | CORRECT -- all 3 k-iterations verified step by step |
| Floyd-Warshall (exam-prep) | `exam-prep/03_algorithm_traces.md` | CORRECT -- final matrix matches manual calculation |
| Kruskal (guide) | `guide/04_minimum_spanning_trees.md` | CORRECT -- ACM={B-C,A-C,D-E,C-D}, weight=8, 4 edges for 5 vertices |
| Kruskal (exercises) | `exercises/05_trees_coloring.md` | CORRECT -- ACM={A-C,D-F,B-E,C-F,B-C}, weight=15, 5 edges for 6 vertices |
| Kruskal (exam-prep) | `exam-prep/03_algorithm_traces.md` | CORRECT -- weight=39, 6 edges for 7 vertices |
| Prim (guide) | `guide/04_minimum_spanning_trees.md` | CORRECT -- same weight=8 as Kruskal |
| Prim (exercises) | `exercises/05_trees_coloring.md` | CORRECT -- same weight=15 as Kruskal |
| Ford-Fulkerson (guide) | `guide/05_network_flow.md` | CORRECT -- flot max=16, conservation verified at all nodes |
| Ford-Fulkerson (exercises) | `exercises/06_network_flows.md` | CORRECT -- flot max=16, coupe min {s,A,B,C}/{t} = 4+12 = 16 |
| Ford-Fulkerson (exam-prep) | `exam-prep/02_typical_problems.md` | CORRECT -- flot max=12, coupe {s,B}/{A,C,t} = 8+4 = 12 |
| Tarjan CFC (exercises) | `exercises/03_connectivity_traversals.md` | CORRECT -- CFC {A,B,C}, {D,E,F}, {G} |
| BFS (exercises) | `exercises/03_connectivity_traversals.md` | CORRECT -- distances verified |
| DFS (exercises) | `exercises/03_connectivity_traversals.md` | CORRECT -- order A,B,D,G,E,C,F |
| Ordonnancement MPM (exercises) | `exercises/06_network_flows.md` | CORRECT -- ES, LS, MT all verified, critical path A->C->F->H, duration=11 |
| Ordonnancement MPM (exam-prep) | `exam-prep/03_algorithm_traces.md` | CORRECT -- critical path A->C->F->G, duration=16 |
| Ordonnancement MPM (typical) | `exam-prep/02_typical_problems.md` | CORRECT -- critical path A->D->F, duration=12 |

### Theorem Statements

| Theorem | File(s) | Verdict |
|---------|---------|---------|
| Handshaking lemma | `guide/01`, `exam-prep/04` | CORRECT -- Sum d(v) = 2m |
| Directed version | `guide/01` | CORRECT -- Sum d+(v) = Sum d-(v) = m |
| Euler's formula | `guide/08`, `exam-prep/04` | CORRECT -- n - m + f = 2 for connected planar graphs |
| Consequence m <= 3n-6 | `guide/08`, `exam-prep/04` | CORRECT -- proof via 3f <= 2m is sound |
| Consequence m <= 2n-4 | `guide/08` | CORRECT -- for bipartite planar graphs (4f <= 2m) |
| K_5 non-planarity | `guide/08`, `exam-prep/04` | CORRECT -- 10 > 9 = 3*5-6 |
| K_{3,3} non-planarity | `guide/08`, `exam-prep/04` | CORRECT -- 9 > 8 = 2*6-4 |
| Kuratowski's theorem | `guide/08` | CORRECT -- subdivision characterization |
| Wagner's theorem | `guide/08` | CORRECT -- minor characterization |
| Euler cycle conditions (undirected) | `guide/06`, `exercises/04` | CORRECT -- connected + all degrees even |
| Euler chain conditions | `guide/06`, `exercises/04` | CORRECT -- connected + 0 or 2 odd-degree vertices |
| Euler circuit (directed) | `guide/06`, `exercises/04` | CORRECT -- connected + d+(v)=d-(v) for all v |
| Dirac's theorem | `guide/06`, `exercises/04` | CORRECT -- d(v) >= n/2 => Hamiltonian cycle (n >= 3) |
| Ore's theorem | `guide/06`, `exercises/04` | CORRECT -- d(u)+d(v) >= n for non-adjacent pairs |
| Sufficiency caveat | `guide/06` | CORRECT -- clearly stated as sufficient, not necessary |
| Brooks' theorem | `guide/07` | CORRECT -- chi <= Delta except for K_n and odd cycles |
| Four color theorem | `guide/07`, `guide/08` | CORRECT -- every planar graph is 4-colorable |
| Vizing's theorem | `guide/07` | CORRECT -- Delta <= chi' <= Delta + 1 |
| Max-flow min-cut | `guide/05`, `exam-prep/04` | CORRECT -- theorem and proof sketch are sound |
| Konig's theorem | `guide/05` | CORRECT -- max matching = min vertex cover (bipartite) |
| Tree equivalences (6) | `guide/09` | CORRECT -- all 6 classical equivalences listed |
| Bipartite iff no odd cycle | `guide/01`, `exam-prep/04` | CORRECT -- both directions of proof are sound |

### Complexity Claims

| Algorithm | Claimed Complexity | Verdict |
|-----------|-------------------|---------|
| BFS | O(n+m) | CORRECT |
| DFS | O(n+m) | CORRECT |
| Dijkstra (array) | O(n^2) | CORRECT |
| Dijkstra (binary heap) | O((n+m) log n) | CORRECT |
| Dijkstra (Fibonacci heap) | O(m + n log n) | CORRECT |
| Bellman-Ford | O(nm) | CORRECT |
| Floyd-Warshall | O(n^3) time, O(n^2) space | CORRECT |
| Kruskal | O(m log m) = O(m log n) | CORRECT |
| Prim (array) | O(n^2) | CORRECT |
| Prim (binary heap) | O(m log n) | CORRECT |
| Prim (Fibonacci heap) | O(m + n log n) | CORRECT |
| Edmonds-Karp | O(nm^2) | CORRECT |
| Hierholzer | O(m) | CORRECT |
| Tarjan (SCC) | O(n+m) | CORRECT |
| Topological sort | O(n+m) | CORRECT |

### Proof Sketches (exam-prep/04_common_proofs.md)

| Proof | Verdict |
|-------|---------|
| Handshaking lemma | CORRECT -- double counting argument |
| Tree has n-1 edges | CORRECT -- induction on n, leaf removal |
| Tree has >= 2 leaves | CORRECT -- longest path argument |
| Bipartite iff no odd cycle | CORRECT -- both directions |
| Euler's formula | CORRECT -- induction on m |
| m <= 3n-6 | CORRECT -- face/edge double counting |
| K_5 non-planar | CORRECT -- contradiction with m <= 3n-6 |
| K_{3,3} non-planar | CORRECT -- uses bipartite bound m <= 2n-4 |
| Dijkstra correctness | CORRECT -- loop invariant argument |
| Max-flow min-cut sketch | CORRECT -- key ideas properly stated |

### Graph Properties and Coloring

| Claim | Verdict |
|-------|---------|
| chi(K_n) = n | CORRECT |
| chi(tree) = 2 (n >= 2) | CORRECT |
| chi(bipartite) = 2 | CORRECT |
| chi(C_{2k}) = 2 | CORRECT |
| chi(C_{2k+1}) = 3 | CORRECT |
| chi(planar) <= 4 | CORRECT |
| omega(G) <= chi(G) <= Delta(G)+1 | CORRECT |
| P(K_n, k) = k(k-1)...(k-n+1) | CORRECT |
| P(tree, k) = k(k-1)^(n-1) | CORRECT |
| K_n edges = n(n-1)/2 | CORRECT |
| K_{p,q} edges = p*q | CORRECT |
| Forest: n vertices, p components => n-p edges | CORRECT |
| Euler formula with p components: n-m+f = 1+p | CORRECT |

### TD Solutions vs Generated Exercises

The exercises are original (not direct copies of TD problems) but cover the same topics:
- exercises/01 covers TD 1 topics (definitions, degrees, matrices)
- exercises/02 covers TD 2-3 topics (relations, operations, subgraphs)
- exercises/03 covers TD 4 topics (BFS, DFS, SCC)
- exercises/04 covers TD 5 topics (Euler/Hamilton)
- exercises/05 covers TD 6 topics (Kruskal, Prim, coloring)
- exercises/06 covers TD 7 topics (flows, scheduling)

All exercise solutions have been verified for correctness.

---

## Consistency with Source Materials

The generated guide is consistent with the moodle source guide files:
- Algorithm pseudo-codes match between generated and source
- Theorem statements are identical
- Complexity claims are consistent
- The cheat sheet accurately summarizes the guide content
- Exam strategy matches the structure observed in annales (2015-2024)

---

## Files Modified During Fact-Check

1. `guide/06_euler_hamilton.md` -- Fixed Petersen graph claim (critical), replaced Hierholzer example (major)
2. `guide/03_shortest_paths.md` -- Fixed Dijkstra negative-weight counterexample (critical)
