# Fact-Check Report -- Complexite (S6 INSA Rennes)

**Date:** 2026-04-17
**Scope:** 18 generated files across `guide/`, `exercises/`, `exam-prep/`
**Source materials:** `data/moodle/guide/` (6 chapters + cheat sheet), `data/moodle/fiches/`, `data/annales/`

---

## Summary

Total issues found: **11**
- FIXED directly: **5**
- Verified correct (no change needed): **6 major claims audited**
- Informational notes (not errors): **4**

Overall quality: **HIGH**. The generated guide is accurate on all core algorithm complexities, recurrence solutions, DP formulations, and greedy arguments. The few issues found were missing precision in formal definitions, a misleading application of the simplified Master Theorem, and a broken counter-example for greedy matrix traversal.

---

## 1. Asymptotic Notation Definitions

### 1.1 O-notation missing non-negativity constraint
**File:** `guide/01_asymptotic_notation.md`, line 12
**Issue:** The formal definition of O(g(n)) omitted the requirement that f(n) >= 0.
**Standard definition:** "there exist c > 0, n0 >= 0 such that for all n >= n0: **0 <=** f(n) <= c * g(n)"
**Status:** FIXED. Added `0 <=` to the O definition.

### 1.2 Omega-notation missing non-negativity constraint
**File:** `guide/01_asymptotic_notation.md`, line 22
**Issue:** Similar omission for Omega.
**Status:** FIXED. Added `>= 0` constraint.

### 1.3 Theta, petit-o definitions
**Verified correct.** Theta defined as O AND Omega. petit-o defined via limit. Both match the source guide and standard definitions.

### 1.4 Hierarchy of complexities
**Verified correct.** O(1) < O(log n) < O(sqrt(n)) < O(n) < O(n log n) < O(n^2) < O(n^3) < O(2^n) < O(n!). Matches source `01_notations_asymptotiques.md` and standard references. The numeric table values (n=10, n=100, n=1000) are all accurate.

---

## 2. Master Theorem

### 2.1 Simplified version scope mismatch
**Files:** `guide/01_asymptotic_notation.md` (line 196), `guide/04_divide_and_conquer.md` (line 36)
**Issue:** The simplified Master Theorem is stated for `T(n) = a*T(n/b) + c*n` (f(n) linear). However, the examples table includes:
- Binary search: T(n) = T(n/2) + O(1), where f(n) = O(1), NOT O(n).
- Strassen: T(n) = 7T(n/2) + O(n^2), where f(n) = O(n^2), NOT O(n).

These require the **general** Master Theorem (Case 1: f(n) = O(n^{log_b(a) - epsilon})). The simplified version `a < b => O(n)` gives the wrong result for binary search if interpreted literally (it would predict O(n), not O(log n)).

**Status:** FIXED. Added clarifying notes in both files explaining that binary search and Strassen use the general Master Theorem, not the simplified f(n)=cn form. Also updated the cheat sheet in guide/04 to separate simplified and general cases.

### 2.2 Core three cases
**Verified correct.** The three cases (a < b, a = b, a > b) are correctly stated for the simplified form. The general Master Theorem results cited (O(log n) for binary search, O(n^{log_2(7)}) for Strassen) are all correct.

### 2.3 Recursion tree demonstration
**File:** `guide/04_divide_and_conquer.md`, lines 46-59
**Verified correct.** The geometric series argument for the three cases is sound.

---

## 3. Recurrence Solutions

### 3.1 Characteristic equation method (5 steps)
**Files:** `guide/02_recurrences.md`, `data/moodle/guide/02_recurrences.md`
**Verified correct.** The procedure matches the source guide exactly. The particular solution table (g(n) forms vs. trial solutions) is accurate, including the crucial rule about multiplying by n^m when alpha is a root of multiplicity m.

### 3.2 Detailed example: u_n = u_{n-1} + 6u_{n-2} + 5*3^n
**Files:** `guide/02_recurrences.md` (lines 71-111), `exercises/01_recurrences.md` (Exercice 1)
**Verified by hand computation:**
- Char eq: r^2 - r - 6 = 0, Delta = 25, r1 = 3, r2 = -2. CORRECT.
- 3 is a root, so try C*n*3^n. Substitution yields C = 3. CORRECT.
- u_n^{(p)} = n*3^{n+1}. CORRECT.
- Initial conditions: A = -1, B = 3. CORRECT.
- Verification: u_0 = -1 + 3 = 2, u_1 = -3 - 6 + 9 = 0. CORRECT.

### 3.3 Exercise 3: Double root u_n = 4u_{n-1} - 4u_{n-2} + 3
**File:** `exercises/01_recurrences.md`, lines 67-89
**Verified:**
- Char eq: (r-2)^2 = 0, double root r=2. CORRECT.
- Sol homogene: (A + Bn)*2^n. CORRECT.
- Particular: try C (constant). C = 4C - 4C + 3 => C = 3. CORRECT.
- u_0 = 1: A*1 + 3 = 1 => A = -2. CORRECT.
- u_1 = 2: (-2 + B)*2 + 3 = 2 => -4 + 2B + 3 = 2 => 2B = 3 => B = 3/2. CORRECT.

### 3.4 Exercise 6: alpha-is-root trap u_n = 3u_{n-1} - 2u_{n-2} + 2^n
**File:** `exercises/01_recurrences.md`, lines 146-181
**Verified by hand computation:**
- Roots: r=1, r=2. CORRECT.
- g(n)=2^n, alpha=2 is root. Try C*n*2^n. CORRECT.
- Substitution: dividing by 2^{n-2} gives 4Cn = 4Cn - 2C + 4, so C = 2. CORRECT.
- Initial conditions: A = 3, B = -3. CORRECT.
- Final: u_n = 3 + 2^n(2n - 3). Verified: u_0 = 0, u_1 = 1, u_2 = 7, and 3*1 - 2*0 + 4 = 7. CORRECT.

### 3.5 Generating functions example
**File:** `guide/02_recurrences.md`, lines 142-164
**Verified:** The manipulation of sum_{n>=2} n*3^{n-2}*x^n into x^2 * [3x/(1-3x)^2 + 2/(1-3x)] is correct. The decomposition (m+2)*(3x)^m = m*(3x)^m + 2*(3x)^m leading to 3x/(1-3x)^2 + 2/(1-3x) is sound.

### 3.6 Generating function formulas
**Verified correct.** All four core formulas match standard references:
- 1/(1-x) = sum x^n
- 1/(1-ax) = sum a^n x^n
- 1/(1-x)^2 = sum (n+1) x^n
- x/(1-x)^2 = sum n x^n

---

## 4. Sorting Algorithms

### 4.1 Complexity table
**File:** `guide/03_sorting_algorithms.md`
**Verified correct.** All complexities match standard references and the source guide:
- Insertion: O(n) best, O(n^2) worst, stable, in-place. CORRECT.
- Selection: O(n^2) all cases, unstable, in-place. CORRECT.
- Merge sort: O(n log n) all cases, stable, NOT in-place. CORRECT.
- Quicksort: O(n log n) average, O(n^2) worst, unstable, in-place. CORRECT.
- Heap sort: O(n log n) all cases, unstable, in-place. CORRECT.
- Counting sort: O(n+k), stable. CORRECT.
- Radix sort: O(d*(n+k)), stable. CORRECT.

### 4.2 Sorting lower bound proof
**File:** `guide/03_sorting_algorithms.md`, lines 100-108
**Verified correct.** The argument via decision trees is standard:
- Decision tree with n! leaves requires height h >= log_2(n!).
- By Stirling: log_2(n!) = n*log_2(n) - n*log_2(e) + O(log n) = Omega(n log n).
- Therefore h = Omega(n log n). CORRECT.

---

## 5. Dynamic Programming

### 5.1 Edit distance recurrence
**File:** `guide/05_dynamic_programming.md`, lines 116-128
**Verified correct.** The recurrence c(i,j) = min(c(i-1,j)+D, c(i,j-1)+I, c(i-1,j-1)+S) matches the source guide and standard Levenshtein formulation. The BRUIT-to-BRUIT visualization table is correct.

### 5.2 Matrix chain multiplication recurrence
**File:** `guide/05_dynamic_programming.md`, lines 145-149
**Verified correct.** m(i,j) = min_{k=i..j-1} {m(i,k) + m(k+1,j) + p_{i-1}*p_k*p_j}. Standard formulation.

### 5.3 Matrix chain multiplication exercise
**File:** `exercises/03_dynamic_programming.md`, Exercice 3
**Verified by hand computation:**
- p = [10, 30, 5, 60, 10]
- m[1][2] = 10*30*5 = 1500. CORRECT.
- m[2][3] = 30*5*60 = 9000. CORRECT.
- m[3][4] = 5*60*10 = 3000. CORRECT.
- m[1][3]: min(0+9000+18000, 1500+0+3000) = min(27000, 4500) = 4500. CORRECT.
- m[2][4]: min(0+3000+1500, 9000+0+18000) = min(4500, 27000) = 4500. CORRECT.
- m[1][4]: min(0+4500+3000, 1500+3000+500, 4500+0+6000) = min(7500, 5000, 10500) = 5000. CORRECT.

### 5.4 Minimal path in matrix exercise
**File:** `exercises/03_dynamic_programming.md`, Exercice 1
**Issue (cosmetic):** The file contained a wrong intermediate table followed by "NON, recalculons:" and then the correct recalculation. This was confusing.
**Status:** FIXED. Removed the incorrect table, kept only the correct step-by-step calculation showing the final answer of 11.

### 5.5 Edit distance exercise (BRUIT -> BUT)
**File:** `exercises/03_dynamic_programming.md`, Exercice 4
**Verified correct.** The table is filled correctly and the distance is 2 (delete R, delete I).

### 5.6 Triangulation of polygon recurrence
**File:** `guide/05_dynamic_programming.md`, lines 159-163
**Verified correct.** Matches the source guide and standard formulation. The structure is identical to matrix chain multiplication, which is noted correctly.

---

## 6. Greedy Algorithms

### 6.1 Exchange argument proof for interval scheduling
**Files:** `guide/06_greedy_algorithms.md`, `exercises/04_greedy_and_bnb.md` (Exercice 3)
**Verified correct.** The proof structure is sound:
1. Lemma: fin(g_i) <= fin(o_i) for all i. Proved by induction.
2. Contradiction: if m > k, then o_{k+1} is compatible with G, so the greedy would have selected it.

### 6.2 Counter-example for greedy coin change
**File:** `exercises/04_greedy_and_bnb.md`, Exercice 1
**Verified correct.** Pieces {6, 4, 1}, render 8: greedy gives 6+1+1=3 pieces, optimal is 4+4=2. Valid counter-example.

### 6.3 Counter-example for greedy matrix traversal
**File:** `exercises/04_greedy_and_bnb.md`, Exercice 6
**Issue:** The original counter-example was BROKEN. Every attempted matrix either failed to demonstrate the greedy's suboptimality or the analysis was incorrect. The exercise degenerated into trying and failing multiple matrices, concluding "the greedy is hard to defeat on regular matrices."
**Status:** FIXED. Replaced with a working counter-example:
```
1   1  100
1  100    1
1    1    1
```
Greedy (choosing min adjacent at each step): 1+1+100+1+1 = 104. Optimal (going down first): 1+1+1+1+1 = 5.

### 6.4 Counter-example in exercises/03 (DP section)
**File:** `exercises/03_dynamic_programming.md`, Exercice 2
**Issue:** Same problem -- the counter-examples did not successfully demonstrate greedy suboptimality.
**Status:** FIXED. Replaced with the same working counter-example from 6.3.

---

## 7. NP-Completeness

### 7.1 Class definitions
**File:** `guide/08_np_completeness.md`
**Verified correct.**
- P: polynomial-time decidable by deterministic TM. CORRECT.
- NP: polynomial-time verifiable / non-deterministic polynomial. CORRECT.
- NP-hard: all NP problems reduce to it. CORRECT.
- NP-complete: NP AND NP-hard. CORRECT.

### 7.2 Cook-Levin theorem
**Verified correct.** SAT stated as first NP-complete problem. 3-SAT reduction mentioned.

### 7.3 Reduction chain
**File:** `guide/08_np_completeness.md`, lines 87-99
**Verified:** The reduction chain SAT -> 3-SAT -> CLIQUE -> VERTEX COVER -> HAM CYCLE -> TSP is a standard pedagogical chain. SUBSET SUM -> KNAPSACK -> PARTITION is also correctly stated (SUBSET SUM <=_p PARTITION is the standard direction for proving PARTITION NP-complete).

### 7.4 Reduction direction
**Verified correct.** The guide correctly emphasizes that to show B is NP-hard, reduce a known NP-complete problem A **to** B (A <=_p B), not the other way around.

---

## 8. Amortized Analysis

### 8.1 Aggregate method -- binary counter
**File:** `guide/09_amortized_analysis.md`, lines 29-43
**Verified correct.** Total bit flips over n increments: sum_{i=0}^{k-1} n/2^i < 2n. Amortized cost O(1) per increment.

### 8.2 Potential method -- binary counter
**File:** `guide/09_amortized_analysis.md`, lines 107-116
**Verified correct.** Potential = number of 1-bits. For an increment that resets t bits and sets 1: cost_real = t+1, delta_Phi = 1-t, amortized = 2. CORRECT.

### 8.3 Potential method -- dynamic array
**File:** `guide/09_amortized_analysis.md`, lines 119-129
**Verified correct.** Potential = 2*size - capacity. When doubling: cost_real = n+1, Phi_before = 2n - n = n, Phi_after = 2(n+1) - 2n = 2, amortized = (n+1) + (2-n) = 3. CORRECT.

### 8.4 Accounting method -- dynamic array
**File:** `guide/09_amortized_analysis.md`, lines 83-87
**Verified correct.** Amortized cost 3 per insertion: 1 for the insert, 1 saved for its own future copy, 1 saved for copying an already-present element. Standard argument.

---

## 9. Performance Evaluation

### 9.1 Amdahl's Law formula
**File:** `guide/10_performance_evaluation.md`, line 128
**Verified correct.** Speedup = 1/((1-p) + p/S). Maximum when S -> inf: 1/(1-p). CORRECT.

### 9.2 DS 2024 Amdahl example
**File:** `guide/10_performance_evaluation.md`, lines 144-156
**Verified by computation:**
- Opt A: 1/(0.83 + 0.017) = 1/0.847 = 1.1806 ~ 1.18. CORRECT.
- Opt B: 1/(0.30 + 0.56) = 1/0.86 = 1.1628 ~ 1.16. CORRECT.
- Choice A > B. CORRECT.

---

## 10. Informational Notes (not errors)

### 10.1 Fibonacci complexity
The guide states O(2^n) for naive Fibonacci. The exact growth rate is Theta(phi^n) where phi = (1+sqrt(5))/2 ~ 1.618. O(2^n) is a valid (though loose) upper bound. This matches the source course materials, so no change is warranted.

### 10.2 Master Theorem condition a >= 1
The source guide (`02_recurrences.md`) states "a > 1, b > 1" for the simplified version. The generated guide (`02_recurrences.md`) correctly has "a >= 1, b > 1", which is more inclusive (allows a=1 for binary search). Both are acceptable depending on convention.

### 10.3 Heap sort best case
The guide states O(n log n) for heap sort's best case. Some sources give O(n) for building the heap when all elements are equal, but the standard classification is O(n log n) for the full heap sort algorithm. The guide is consistent with standard treatment.

### 10.4 Graph algorithms and NP-completeness chapters
Chapters 07 (Graph Algorithms) and 08 (NP-Completeness) go beyond what is directly in the source materials (the INSA course focuses more on exploration/B&B than formal NP-completeness). These chapters are supplementary and contain no factual errors, but they should be understood as extensions beyond the core exam material.

---

## Files Modified

| File | Changes |
|------|---------|
| `guide/01_asymptotic_notation.md` | Added non-negativity constraint to O and Omega definitions; added note about Master Theorem scope |
| `guide/04_divide_and_conquer.md` | Added Master Theorem scope clarification; separated simplified and general cases in cheat sheet |
| `exercises/03_dynamic_programming.md` | Fixed matrix path exercise (removed broken intermediate table); fixed greedy counter-example |
| `exercises/04_greedy_and_bnb.md` | Replaced broken greedy matrix traversal counter-example with a working one |

---

## Conclusion

The generated study guide is **factually sound** on all major claims:
- All recurrence solutions verified by hand computation
- All algorithm complexities match standard references and source materials
- All DP formulations are correct
- The exchange argument for interval scheduling is valid
- Amortized analysis calculations are correct
- Amdahl's Law applications are numerically accurate

The fixes applied were:
1. Precision improvements to formal definitions (non-negativity in O/Omega)
2. Scope clarification for the simplified Master Theorem
3. Replacement of a broken counter-example for greedy matrix traversal
4. Removal of a confusing incorrect-then-corrected table in a DP exercise
