# CLP Fact-Check Report

**Date**: 2026-04-17
**Scope**: All generated guide, exercise, and exam-prep files for S5/CLP
**Source materials**: Assembly source files (.s), Logisim circuits (.circ), microcode ROMs (.mem), course PDFs

---

## Summary

| Metric | Count |
|--------|-------|
| Files checked | 13 generated files |
| Source files cross-referenced | 12 .s files, 2 .mem files, 30+ .circ file references |
| Critical issues found | 1 |
| Minor issues found | 2 |
| Fixes applied | 3 |
| Mathematical claims verified | 40+ |

---

## Issues Found and Fixed

### CRITICAL-1: Incorrect string in 2017 exam code samples (FIXED)

**Files affected**: `guide/assembly-arm.md`, `exam-prep/exam-assembly-walkthrough.md`

**Problem**: The code samples used `"Ouvroir de litterature potentielle"` (without accent on the first 'e' in "litterature"), but the actual source file (`Exercice1 Theo.s`) uses `"Ouvroir de litterature potentielle"` with the accented character. This matters because:
- With the accented spelling: ARM `LDRB` + `CMP #'e'` gives count = **5** (the accented character's bytes do not match ASCII 0x65)
- Without accent: the count would be **6**
- The guide claimed 5 (correct for the source) but displayed the wrong string (which would give 6)

**Fix**: Updated both files to use the accented string from the source, and added notes explaining why the accent affects the count.

### MINOR-1: Wrong source file attribution for 2017 exam (FIXED)

**File affected**: `exam-prep/exam-assembly-walkthrough.md`

**Problem**: The walkthrough attributed the character-counting code to `assembleur_2017.s`, but that file actually contains a scalar product / orthogonality program (ProduitScalaire with vectors A, B, C). The character counter is from `Exercice1 Theo.s`.

**Fix**: Updated the attribution to reference the correct file.

### MINOR-2: Cleaned-up Colinearite code without noting source differences (FIXED)

**File affected**: `exam-prep/exam-assembly-walkthrough.md`

**Problem**: The 2018 exam walkthrough showed a corrected version of the Colinearite function using conditional stores (`STREQ`/`STRNE`), while the actual student solution (`assembleur_2018.s` lines 158-161) has unconditional `STR` instructions (a bug where the result is always overwritten). The guide presented the fixed version without noting the discrepancy.

**Fix**: Added a note explaining that the walkthrough shows a corrected version and describing the bug in the original source.

---

## Verified Correct

### Boolean Algebra and Logic (combinational-logic.md, td-combinational.md)

- All 7 logic gate truth tables: **CORRECT**
- All Boolean algebra laws (identity, null, idempotent, complement, commutative, associative, distributive, absorption): **CORRECT**
- De Morgan's laws and generalized form: **CORRECT**
- XOR/XNOR identity proof (Exercise 1a): **CORRECT** -- step-by-step algebraic manipulation verified
- Absorption proof (Exercise 1b: A.B + A.C.D + /B.D = A.B + /B.D): **CORRECT** -- Karnaugh map entries verified cell by cell
- Gray code transcoder (a=A, b=A XOR B, c=B XOR C, d=C XOR D): **CORRECT**
- Transistor classification formulas (C1, C2, C3): **CORRECT**
- Karnaugh map column ordering (Gray code: 00, 01, 11, 10): **CORRECT**

### Number Systems (combinational-logic.md, td-combinational.md)

- All 5 binary-decimal-hex-octal conversions: **CORRECT** (verified programmatically)
- Two's complement: +63 = 00111111, -63 = 11000001: **CORRECT**
- Two's complement addition: 30 + (-8) = 22: **CORRECT**
- Encoding precision: ceil(log2(360)) = 9 bits, ceil(log2(3600)) = 12 bits: **CORRECT**
- ASCII case conversion (bit 5 manipulation): **CORRECT**

### MUX and Decoder (td-combinational.md)

- 2-to-1 MUX equation: out = /S.I0 + S.I1: **CORRECT**
- Truth table for S(C,B,A) when N in {0,3,5,7}: **CORRECT**
- Simplified expression S = /A./B./C + A.(B + C): **CORRECT** -- verified against all 8 input combinations
- VU-meter segment equations (s1 through s7): **CORRECT** -- verified for all input values 0-7

### Sequential Logic (sequential-logic.md, td-sequential.md)

- D flip-flop equation Q(t+1) = D: **CORRECT**
- T flip-flop equation Q(t+1) = T XOR Q(t): **CORRECT**
- JK flip-flop equation Q(t+1) = J./Q(t) + /K.Q(t): **CORRECT**
- RS flip-flop equation Q(t+1) = S + /R.Q(t): **CORRECT**
- All flip-flop conversion formulas (D from JK, T from JK, JK from D, D from T, RS from D): **CORRECT**
- Edge detector (Mealy machine) state table and implementation: **CORRECT**
- LED toggle state machine transitions and equations: **CORRECT** -- verified all 8 transition combinations
- Sequence detector equations: **CORRECT** -- key transitions verified
- Divisibility by 5 transition table: **CORRECT** -- all 10 transitions match modular arithmetic

### Adder equations

- Half adder: Sum = A XOR B, Carry = A.B: **CORRECT**
- Full adder: Sum = A XOR B XOR Cin, Cout = A.B + (A XOR B).Cin: **CORRECT**

### Processor Architecture (processor-architecture.md, td-processor.md, pgcd-arithmetic.md)

- UC/UT decomposition description: **CORRECT** -- commands flow UC->UT, conditions flow UT->UC
- GCD algorithm (Euclid's subtraction): **CORRECT** -- gcd(24,18) = 6 trace verified
- GCD state machine (S0-S4): **CORRECT**
- Fibonacci machine states (A-E) and commands: **CORRECT**
- Fibonacci microcode binary encoding (all 5 words): **CORRECT** -- exact match with ex_5.mem hex values
  - State A: 001 000 0001001 = 0x409
  - State B: 010 011 0000000 = 0x980
  - State C: 111 001 1110000 = 0x1CF0
  - State D: 001 011 0000110 = 0x586
  - State E: 111 000 0001000 = 0x1C08
- Fibonacci verification trace F(6) = 8: **CORRECT** -- 6 iterations traced step by step
- PGCD ROM contents match source file 11-pgcd-uc2.mem: **CORRECT**
- Sequencer MUX configuration (codes 0, 1, 2, 7): **CORRECT**

### ARM Assembly (assembly-arm.md, td-assembly.md)

- Register conventions (r0-r3 arguments, r4-r10 callee-saved, r11=fp, r13=sp, r14=lr, r15=pc): **CORRECT**
- CPSR flags (N, Z, C, V): **CORRECT**
- Data directives (.word, .byte, .ascii, .asciz, .skip, .align): **CORRECT**
- All instruction descriptions (MOV, LDR, STR, ADD, SUB, MUL, MLA, AND, ORR, EOR, BIC, CMP, B/BL/BX): **CORRECT**
- Addressing modes (offset, post-indexed, pre-indexed with writeback): **CORRECT**
- Condition codes (EQ, NE, GT, LT, GE, LE, HI, HS, LO, LS): **CORRECT**
- Stack convention (Full Descending, STMFD/LDMFD): **CORRECT**
- Function calling convention and stack frame layout: **CORRECT** -- offsets verified against pgcd.s
- Factorial: 12! = 479,001,600 fits in 32 bits, 13! does not: **CORRECT**
- Collatz sequence code: **CORRECT** -- matches collatz.s source exactly
- Character structure (carastruct.s) code and trace: **CORRECT** -- matches source
- Array analysis (CodeTest.s): **CORRECT** -- matches source, includes note about loop termination bug
- GPIO addresses and bit positions: **CORRECT** -- matches main.s (TP4) source

### Exam Walkthroughs (exam-assembly-walkthrough.md)

- 2017 character counting logic: **CORRECT** (after string fix)
- 2018 direction vector computation (-b, a): **CORRECT**
- 2018 collinearity cross product formula: **CORRECT** -- (-2)*6 - 3*(-4) = 0
- 2018 stack offsets (tabD=8, tabV=12, nbDroites=16): **CORRECT** -- verified against prologue push sequence
- 2019 ingredient structure layout (grammage=0, nom=4, total=16): **CORRECT** -- matches source .set definitions
- 2019 TrouverNb trace (150 for BEURRE): **CORRECT**

### Logisim Circuit References (logisim-circuits.md)

- All 18 course circuit files referenced: **17 found, 1 has Unicode filename encoding artifact** (12-pgcd-integration.circ exists on disk but with garbled encoding in the accent)
- All 15 TD circuit files referenced: **ALL FOUND**
- Circuit descriptions match their names and pedagogical context: **CORRECT**

---

## Remaining Concerns (not errors, but worth noting)

1. **2019 CompterIngredients sentinel detection**: The student solution code detects end-of-list by checking if the first byte of an ingredient is 0. However, ingredients like SUCRE (grammage bytes: 0, 8, 0) also start with 0, which would cause premature termination. This is a bug in the student's code, not the guide. The guide faithfully represents the code but does not call out this latent bug.

2. **2017 assembleur_2017.s not covered**: The file `assembleur_2017.s` contains a scalar product / orthogonality exercise (vectors with letters, x/y coordinates, ProduitScalaire function). This exam exercise is not covered in the walkthroughs. Only Exercise 1 (character counting) is walked through.

3. **Logisim circuit 12**: The filename `12-pgcd-integration.circ` has a Unicode encoding artifact in the filesystem (shows as `12-pgcd-inteÌgration.circ`). This is a filesystem/encoding issue, not a guide error.

4. **Source code quality notes**: Several student solutions contain suboptimal patterns (e.g., the 2018 Colinearite function with non-conditional STR, the 2018 GenerationVectDir.s alternative using BL instead of B for the loop). The guide generally shows cleaned-up versions, which is appropriate for pedagogical purposes.

---

## Overall Accuracy Assessment

**HIGH ACCURACY**. The study guide is well-constructed with strong fidelity to source materials. All Boolean algebra identities, flip-flop equations, truth tables, Karnaugh maps, microcode encodings, ARM instruction descriptions, and state machine designs are mathematically correct. The three issues found (1 critical, 2 minor) have been fixed. The guide demonstrates thorough understanding of both the digital logic and assembly portions of the CLP course.
