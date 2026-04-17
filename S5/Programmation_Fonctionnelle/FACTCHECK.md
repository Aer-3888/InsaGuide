# Fact-Check Report: Programmation Fonctionnelle (OCaml)

Date: 2026-04-17

## Scope

Verified all 22 generated files (8 guide chapters, 9 TP solutions, 4 exam-prep files including README) against 9 source .ml files (tp1-tp9), 3 exam solution .ml files (2019, 2020, 2023), and the original course logique.ml.

## Issues Found and Fixed

### 1. FIXED -- TP2 sigma3 trace result (exercises/tp2-solution.md)

**Error**: The trace for `sigma3 ((fun x -> x * x), fun x acc -> x :: acc) 2 [] (0, 10)` had an incorrect final result and contradictory explanation.

The trace initially showed the construction steps correctly (0 :: 4 :: 16 :: ... :: []) but then claimed "sigma3 construit la liste dans l'ordre inverse du parcours" with final result `[100; 64; 36; 16; 4; 0]`.

**Correct**: Since `fc = fun x acc -> x :: acc` (cons), and sigma3 applies `fc(f(a), recursive_result)`, this is a right-fold pattern. The first element processed (a=0) ends up first in the list. The correct result is `[0; 4; 16; 36; 64; 100]`.

**Note**: The source file tp2.ml contains a comment `(* [100; 64; 36; 16; 4; 0] *)` which is itself incorrect. Python simulation confirms the true result is `[0; 4; 16; 36; 64; 100]`.

### 2. FIXED -- TP2 sigma3 type annotation (exercises/tp2-solution.md)

**Error**: Type was `(('a -> 'b) * ('b -> 'c -> 'c)) -> int -> 'c -> int * int -> 'c`

**Correct**: Since `a` is used in both `f a` and `a > b` (int comparison) and `a + i` (int addition), the first component of the tuple is constrained to `int -> 'a`, not `'a -> 'b`. Corrected to: `((int -> 'a) * ('a -> 'b -> 'b)) -> int -> 'b -> int * int -> 'b`

### 3. FIXED -- TP7 exercise heading (exercises/tp7-solution.md)

**Error**: "Exercice 2 : Compter les noeuds"

**Correct**: Changed to "Exercice 2 : Compter les feuilles". The `compter` function for n-ary trees only counts `Feuille` nodes (adding 1 for each Feuille), not internal `Noeud` nodes. This is confirmed by the source test: `compter a2 (* 2 *)` where a2 = `noeud 3 [feuille 4; feuille 4]` has 2 leaves and 1 internal node.

### 4. FIXED -- fold_right trace pseudo-syntax (guide/04-higher-order-functions.md)

**Error**: `(* = (fun 1 acc -> 1 + acc) (f 2 (f 3 0))  *)` -- `fun 1 acc -> ...` is not valid OCaml syntax (you cannot pattern match a constant in a `fun` parameter).

**Correct**: Replaced with `(* = f 1 (f 2 (f 3 0))    ou f = fun x acc -> x + acc *)` which uses valid notation.

### 5. FIXED -- exam-2023 missing `rec` on `brz` (exam-prep/exam-2023.md)

**Error**: `let brz s reg = match reg with ...` -- The `Concat` and `Union` cases call `brz s x` and `brz s y` recursively, so `rec` is required.

**Correct**: Changed to `let rec brz s reg = match reg with ...`

### 6. FIXED -- TP2 maxi trace formula (exercises/tp2-solution.md)

**Error**: `m1 = (0+2)/3 = 0.667, m2 = (0+4)/3 = 1.333` was a misleading simplification of the actual formula `m1 = (2*.a +. b) /. 3.`

**Correct**: Changed to `m1 = (2*0+2)/3 = 0.667, m2 = (0+2*2)/3 = 1.333` which shows the actual formula application.

## Verified Correct (No Issues)

### OCaml Syntax
- All `let`/`let rec` bindings are syntactically valid
- All `match...with` expressions use correct pattern syntax
- All type declarations (`type`, `type...of`, records) are well-formed
- All function definitions use correct arrow syntax
- Operator usage (`.` for record access, `::` for cons, `@` for concat) is correct throughout

### Type Signatures
- `List.map : ('a -> 'b) -> 'a list -> 'b list` -- correct
- `List.filter : ('a -> bool) -> 'a list -> 'a list` -- correct
- `List.fold_right : ('a -> 'b -> 'b) -> 'a list -> 'b -> 'b` -- correct
- `List.fold_left : ('b -> 'a -> 'b) -> 'b -> 'a list -> 'b` -- correct (note param order differs from fold_right)
- `compose : ('b -> 'c) -> ('a -> 'b) -> 'a -> 'c` -- correct
- `appliquepaire : ('a -> 'b) -> 'a * 'a -> 'b * 'b` -- correct
- `rapport : ('a -> float) * ('a -> float) -> 'a -> float` -- correct
- `jqastable : 'a -> ('a -> 'a) -> 'a` -- correct
- All TP function signatures match the source implementations
- All exam function signatures are consistent with their implementations

### Evaluation Traces
- `fact 4 = 24` -- correct (4*3*2*1*1)
- `sigma(-2, 2) = 0` -- correct (-2+-1+0+1+2)
- `sigma(-2, 4) = 7` -- correct (sum of -2 to 4)
- `sigma2 (fun x -> 2*x) (-2, 2) = 0` -- correct
- `sigma2 (fun x -> 2*x) (-2, 4) = 14` -- correct (matches source test)
- `sigma3 ((fun x -> 2*x), (+)) 2 0 (2, 6) = 24` -- correct (4+8+12)
- `sigma4 ((fun x -> 2*x), (+)) ((fun v -> v > 6), (fun v -> v+2)) 0 2 = 24` -- correct
- `int_of_bint [B1; B0; B1] = 5` -- correct (1 + 0 + 4)
- `rang_opt 2 [3; 2; 1] = Some 2` -- correct
- `Collatz from 13: 13->40->20->10->5->16->8->4->2->1` -- correct
- `unebulle [3; 1; 4; 2] = [1; 3; 2; 4]` -- correct
- `n_premier 4 = 7` (4th prime) -- correct
- `bissext 2016 = true` -- correct (divisible by 4, not by 100)
- `eval_lin (fun v -> ...) {cst=2; coeffs=[(7,"x");(9,"y")]} = 27` -- correct
- `normalise [B0; B1; B1; B0; B0] = [B0; B1; B1]` -- correct (both = 6)
- Knights puzzle 1: c1=false, c2=true -- verified by truth table
- Knights puzzle 2: k=true, g=true -- verified by truth table
- Knights puzzle 3: c1=true, g=true -- verified by truth table
- `to_list arbre_test = [5; 12; 6; 7; 8]` (infixe) -- correct
- `compter arbre_test = 3` (3 leaves) -- correct
- `placer` trace for simplified tree -- all coordinates verified

### Pattern Matching
- All exhaustiveness claims are accurate (warnings identified where patterns are incomplete)
- Wildcard `_` behavior is correctly described throughout
- Guards (`when`) are correctly explained
- Or-patterns (e.g., `Or (f, g) | And (f, g) | ...`) are correctly used in TP9

### Tail Recursion
- `fact` (non-tail recursive version) correctly identified as non-tail (multiplication after recursive call)
- `fact` (accumulator version) correctly identified as tail-recursive
- `longueur` (accumulator version) correctly identified as tail-recursive
- `fold_left` correctly described as tail-recursive

### Module Syntax
- `module M = struct ... end` -- correct
- `module type S = sig ... end` -- correct
- `module F (X : S) = struct ... end` (functor) -- correct
- `include M` -- correct
- Type abstraction in signatures correctly explained

### TP Solutions vs Source
- TP1 through TP9: all functions match their source implementations
- Type definitions (coul, haut, carte, arbin, narbr, formula) all match source
- Test values and expected results are consistent with source tests
- The TP8 variant-based card type (`Carte of haut * coul`) correctly distinguished from TP3 record-based type (`{h: haut; c: coul}`)

### Exam Walkthroughs vs Source
- Exam 2019: `linexpr`, `eval_lin`, `check1-3`, `constant`, `variable`, `mul`, `normalise`, `anneau`, `eval_expr`, `simpl_expr`, `linexpr_of_expr` -- all match source
- Exam 2020: `bit/bint`, `int_of_bit`, `int_of_bint`, `count_zeros`, `count_and_remove`, `normalise`, `comparison`, `is_sorted`, `add_elt`, `union`, `intset`, `cardinal`, `mem`, `singleton`, `add_elt`, `remove_elt`, `union`, `div2`, `elements` -- all match source
- Exam 2023: `qname`, `expr`, `program`, `state`, `get`, `set`, `eexpr`, `eprog`, `opt`, `compile` -- all match source
- Guide's cleaned-up versions (e.g., `b1 || b2` vs source's `if boo2 then boo2 else boo1`) are semantically equivalent

## Observations (Not Errors)

1. **Source tp2.ml comment is wrong**: The source file's own comment says `sigma3 ... 2 [] (0, 10)` returns `[100; 64; 36; 16; 4; 0]` but the actual result is `[0; 4; 16; 36; 64; 100]`. The guide was corrected but the source file retains the original error.

2. **TP7 source docstring is misleading**: The source says `compter a` "counts the total number of nodes" but it actually counts only leaf nodes. The guide was corrected.

3. **Guide uses cleaned-up code**: Several exam solutions in the guide are refactored to use pattern destructuring `(a, b)` instead of `fst`/`snd`, and use `| _ -> false` instead of explicitly listing cross-type cases. These are semantically equivalent improvements.

4. **TP9 source file**: The original `logique.ml` contains a full Opal parser combinator library and only `failwith "TODO"` stubs for the core functions. The guide provides completed implementations that match the expected behavior defined by the source test cases.

5. **Exam 2020 `add_elt` for intset**: The guide's version omits the redundant `if mem s i = true then s else` guard from the source. The guide version is cleaner and functionally equivalent for all valid inputs.
