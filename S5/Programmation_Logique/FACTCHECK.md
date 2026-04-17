# Fact-Check Report: Programmation Logique (Prolog)

**Date**: 2026-04-17
**Files reviewed**: 19 generated files (8 guide, 6 exercises, 4 exam-prep, 1 README)
**Source files cross-referenced**: 8 .pl/.ecl source files + 3 correction files

---

## Summary

**Overall assessment**: HIGH QUALITY -- The generated material is accurate, well-structured, and closely matches the source .pl files. Two substantive errors were found and fixed. No errors were found in Prolog syntax, unification examples, resolution trees, cut behavior, or negation-as-failure descriptions.

**Errors found**: 2 (both fixed)
**Warnings**: 3 (minor, documented below)

---

## Errors Found and Fixed

### ERROR 1: add_bit comment inconsistent with actual call signature

**Files affected**:
- `guide/05-arithmetic.md`
- `exercises/tp5-solution.md`

**Description**: The comment for `add_bit` said `add_bit(Cin, B1, B2, Sum, Cout)` but the `addc` clause calls it as `add_bit(B1, B2, Cin, Sum, Cout)` (with B1 and B2 before Cin). The same inconsistency exists in the source file `arithmetic.ecl`, where the comment says `(Cin, B1, B2, ...)` but the `addc` call sends `(E1, E2, Cin, ...)`. Since the full-adder truth table is symmetric in its three input bits, the actual computed results are correct regardless of argument order, but the misleading comment could confuse students trying to understand how `addc` works.

**Fix applied**: Changed comment to `add_bit(B1, B2, Cin, Sum, Cout)` to match the actual calling convention in `addc`. Updated the variable names in the `addc` clause from `E1`/`E2` to `B1`/`B2` for consistency with the comment.

**Severity**: MEDIUM -- Misleading documentation, though computation results were never wrong.

### ERROR 2: Binary addition trace had incorrect sub-call

**Files affected**:
- `guide/05-arithmetic.md`
- `exercises/tp5-solution.md`

**Description**: The trace for `add2([1,1], [1], R)` showed a step `addc([], [], 0, []) -> R2 = [1]` which implied a recursive sub-call that does not occur. The actual resolution is: `addc([1], [], 0, R2)` directly matches the clause `addc(X, [], 0, X)` with X=[1], so R2=[1] without any further recursion. The final answer R=[0,0,1] was correct, but the intermediate trace steps were misleading.

**Fix applied**: Rewrote the trace to show the correct clause matching at each step, with explicit annotations showing which clause is being used.

**Severity**: MEDIUM -- Incorrect trace could mislead students during exam preparation.

---

## Warnings (not fixed, documented only)

### WARNING 1: Source code inconsistency inherited

The source file `arithmetic.ecl` has the same add_bit comment inconsistency that was fixed in the guide. The source was not modified since it is reference material.

### WARNING 2: merge2 allows duplicate solutions on equal elements

In `exam-prep/annale-2023.md`, the `merge2/3` predicate uses `X1 =< X2` and `X1 >= X2` which overlap when X1 == X2. This means for equal elements, both clauses 3 and 4 apply, allowing duplicate solutions on backtracking. This matches the source correction exactly and is not a bug per se, but students should be aware of this behavior.

### WARNING 3: contamine/3 asymmetric transitive propagation

In `exam-prep/annale-2023.md`, the `contamine/3` predicate only propagates through `collegues(X,Z)` in the recursive clause, not `collegues(Z,X)`. This means transitive contamination is direction-dependent. This matches the source correction exactly.

---

## Verification Results by Category

### 1. Prolog Syntax

All 19 files checked. Every Prolog code block contains syntactically valid Prolog:
- Facts end with `.`
- Rules use `:-` correctly
- Operators are valid (`=<` not `<=`, `\==`, `\+`, `is`)
- Variables start with uppercase, atoms with lowercase
- Lists use proper `[H|T]` notation

**Result**: PASS (0 errors)

### 2. Unification Steps

Verified all unification examples in:
- `guide/02-unification-resolution.md` (6 examples)
- `guide/03-lists.md` (7 list unification examples)
- `exercises/tp1-solution.md` (enfant, grand_pere unification)
- `exercises/tp2-solution.md` (carte, main unification)

All substitutions are correct. The `f(X,X) = f(a,b)` failure case is correctly explained.

**Result**: PASS (0 errors)

### 3. Execution Traces

Verified all execution traces against source code:
- `guide/02-unification-resolution.md`: plat(X) trace -- correct 4-port model
- `guide/03-lists.md`: membre, append, renverser traces -- all correct
- `guide/04-recursion.md`: longueur, renverser, infixe traces -- all correct
- `guide/05-arithmetic.md`: factorial, Peano add1, binary add2 -- fixed (see ERROR 2)
- `exercises/tp1-solution.md`: plat, val_cal, ancetre traces -- all correct
- `exercises/tp2-solution.md`: inf_carte, une_paire traces -- all correct
- `exercises/tp3-solution.md`: compte, conc3, tri traces -- all correct
- `exercises/tp4-solution.md`: dans_arbre_binaire, remplacer, insertion traces -- all correct
- `exercises/tp5-solution.md`: Peano add/sub/prod, binary add2, factorial3 -- fixed (see ERROR 2)
- `exercises/tp6-solution.md`: difference, division, nb_pieces_tot, est_compose_de -- all correct
- `exam-prep/annale-2023.md`: is_sorted, merge2, contagion -- all correct
- `exam-prep/annale-2024.md`: mystere, interpreter -- all correct

**Result**: PASS after fixes (2 errors fixed)

### 4. Resolution Trees

Verified resolution trees in:
- `guide/02-unification-resolution.md`: grand_parent(tom, W) tree -- correct solutions W=pat
- `guide/02-unification-resolution.md`: ancetre(X, louis_d_Orleans) tree -- correct structure
- `guide/08-resolution-trees.md`: ancetre(X, c) tree -- correct solutions X=b, X=a
- `guide/08-resolution-trees.md`: p(X,Y) with and without cut -- correct pruning behavior
- `guide/08-resolution-trees.md`: gentil(X) with negation -- correct solutions X=jean, X=marie
- `guide/08-resolution-trees.md`: membre(X, [a,b]) tree -- correct structure

All trees follow correct SLD resolution order (depth-first, left-to-right), with proper clause numbering and substitution annotations.

**Result**: PASS (0 errors)

### 5. Cut Behavior

Verified cut examples in:
- `guide/06-cut-negation.md`: p(X) without vs with cut -- correctly shows (X=2,X=3,X=4) vs (no solutions)
- `guide/06-cut-negation.md`: green cut (max) vs red cut (max_rouge) -- correctly distinguished
- `guide/06-cut-negation.md`: cut-fail pattern for negation -- correct mechanism
- `guide/08-resolution-trees.md`: p(X,Y) with cut -- correctly shows only (1,a) and (1,b)
- `exercises/tp4-solution.md`: remplacer/4 cut -- correctly prevents duplicate replacement

**Result**: PASS (0 errors)

### 6. Negation as Failure

Verified all `\+` examples:
- `guide/06-cut-negation.md`: `\+` definition via cut-fail -- correct
- `guide/06-cut-negation.md`: variable-free requirement -- correctly warned
- `guide/06-cut-negation.md`: correct vs incorrect ordering with `\+` -- correct
- `exercises/tp6-solution.md`: division via double negation -- correct
- `exam-prep/annale-2023.md`: travail/1 with `\+(grippe(X)), \+(covid(X))` -- correct
- `exam-prep/annale-2024.md`: sans_eastwood with `\+(vedette(...))` -- correct

**Result**: PASS (0 errors)

### 7. Built-in Predicates (findall/bagof/setof)

Verified descriptions in `guide/07-advanced-topics.md`:
- findall returns [] on no solutions -- correct
- bagof fails on no solutions -- correct
- setof sorts and eliminates duplicates -- correct
- `^` operator for existential quantification in bagof/setof -- correct
- Usage in TP examples (count, total_pieces_livrees_fournisseur) -- matches source

**Result**: PASS (0 errors)

### 8. TP Solutions vs Source .pl Files

Cross-referenced every predicate in exercises/ against data/moodle/tp/src/:

| TP | File | Match |
|----|------|-------|
| TP1 | basemenu.pl | EXACT match on all predicates (plat, repas, plat200_400, plat_bar, val_cal, repas_eq) |
| TP1 | basevalois.pl | EXACT match on all predicates (enfant, parent, grand_pere, frere, oncle, cousin, le_roi_est_mort_vive_le_roi, ancetre) |
| TP2 | cartes.pl | EXACT match (est_carte, est_main, inf_hauteur, inf_couleur, inf_carte, est_main_triee, une_paire, deux_paires, brelan, suite, full) |
| TP3 | listes.pl | EXACT match (membre, compte, renverser, palind, enieme, hors_de, tous_diff, conc3, debute_par, sous_liste, elim, tri, inserer, enieme2, eniemefinal, conc3final, comptefinal, inclus, non_inclus, union_ens, inclus2) |
| TP4 | arbres.pl | EXACT match (arbre_binaire, dans_arbre_binaire, sous_arbre_binaire, remplacer, isomorphes, infixe, prefixe, postfixe, insertion_arbre_ordonne, insertion_arbre_ordonne1) |
| TP5 | arithmetic.ecl | EXACT match on logic (add1, sub1, prod1, factorial1, add_bit, addc, add2, sub2, prod2, factorial2, factorial3). Comment fix applied (see ERROR 1) |
| TP6 | tp_BDD.pl | EXACT match (all section 2 and section 3 predicates, including division, nb_pieces_tot, nb_voiture) |

**Result**: PASS (0 logic errors; all predicates match source)

### 9. Exam Corrections vs Source Corrections

- **2024**: Guide matches `correction_2024_Prolog.txt` on Q1-Q4, Q6-Q7, Q8-Q16. Note: source Q11 has a syntax error (missing `]`), guide version is correct.
- **2023**: Guide matches `prolog_correction_2023.txt` on Q1-Q6, Q10-Q14. Insert/3 implementation differs in style (guide uses direct cons, source uses append) but both are correct and produce identical results.
- **2019**: Exercise 4 predicates (meme_taille, liste_somme, multiples) match `prolog_sujet_2019_ex_4.txt`.
- **2020**: Predicates (oter_n_prem, pas_dans, maxi) match `2019_2020.pl`.

**Result**: PASS (0 errors)

---

## Files Reviewed

### Guide (8 files)
1. `guide/README.md` -- Overview, correct structure
2. `guide/01-prolog-basics.md` -- Facts, rules, queries, operators
3. `guide/02-unification-resolution.md` -- Unification, SLD, backtracking, 4-port model
4. `guide/03-lists.md` -- List operations, ensemble operations
5. `guide/04-recursion.md` -- Recursive patterns, accumulators, trees, termination
6. `guide/05-arithmetic.md` -- is/2, Peano, binary arithmetic **(2 fixes applied)**
7. `guide/06-cut-negation.md` -- Cut, green/red cut, negation as failure
8. `guide/07-advanced-topics.md` -- findall/bagof/setof, assert/retract, BDD deductives
9. `guide/08-resolution-trees.md` -- SLD tree construction, cut impact, exam techniques

### Exercises (6 files)
1. `exercises/tp1-solution.md` -- Restaurant + Valois
2. `exercises/tp2-solution.md` -- Poker cards
3. `exercises/tp3-solution.md` -- Lists and sets
4. `exercises/tp4-solution.md` -- Binary trees
5. `exercises/tp5-solution.md` -- Peano, binary, classic arithmetic **(2 fixes applied)**
6. `exercises/tp6-solution.md` -- Deductive databases

### Exam-Prep (4 files)
1. `exam-prep/README.md` -- Exam format, strategy, priorities
2. `exam-prep/annale-2023.md` -- Lists + COVID base
3. `exam-prep/annale-2024.md` -- Films + mystere + stack interpreter
4. `exam-prep/annale-recurrent-patterns.md` -- Patterns across 2015-2026
