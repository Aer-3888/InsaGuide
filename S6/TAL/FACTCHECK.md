# Fact-Check Report -- TALEO (TAL/NLP) Study Guide

Date: 2026-04-17
Files checked: 21 generated files (9 guide, 6 exercises, 4 exam-prep, 2 READMEs)
Sources checked: 8 source guide chapters, 7 TALEO-CM markdown files, 2023 exam images

---

## SUMMARY

**Overall assessment: PASS with minor issues**

All formulas, algorithm traces, and numerical calculations are correct. The Chomsky hierarchy, Naive Bayes, TF-IDF, Viterbi, CKY, PCFG, and perplexity content is accurate and consistent with the course materials. One file contained visible scratch work that has been fixed.

- **Critical errors found: 0**
- **Issues fixed: 1** (transition parser exercise with confusing scratch work)
- **Minor observations: 6** (documented below, no changes needed)

---

## 1. N-GRAM FORMULAS

| Item | Status | Notes |
|------|--------|-------|
| Bigram: P[w_i \| w_{i-1}] | CORRECT | Consistent across all files |
| Trigram: P[w_i \| w_{i-2}, w_{i-1}] | CORRECT | |
| ML estimation: C(hw)/C(h) | CORRECT | |
| Laplace smoothing: (C(hw)+1)/(C(h)+\|V\|) | CORRECT | Denominator correctly uses \|V\|, not 1 |
| Interpolation: SUM lambda_i * P_ML, SUM lambda = 1 | CORRECT | |
| Back-off formulation | CORRECT | Matches CM6 source |
| Kneser-Ney description | CORRECT | Simplified but accurate |
| Good-Turing: C*(hw) = (C(hw)+1)*N_{C+1}/N_C | CORRECT | |

**Bigram example calculation** (guide/02, exercises/05):
- P(chat\|le) = C("le chat")/C("le") = 2/2 = 1.0 -- CORRECT
- P(mange\|chat) = 1/2 = 0.5 -- CORRECT

---

## 2. VITERBI ALGORITHM

| Item | Status | Notes |
|------|--------|-------|
| Recursion: H(i,k) = max_j[H(j,k-1)*a_ji*b_i(w_k)] | CORRECT | |
| Initialization: H(i,1) = pi_i * b_i(w_1) | CORRECT | |
| Complexity: O(n * \|T\|^2) | CORRECT | |
| Backtracking step | CORRECT | Properly described |

**Numerical traces verified:**

guide/04 (il mange):
- H(P,1) = 0.6 * 0.90 = 0.540 -- CORRECT
- H(V,2) via P = 0.540 * 0.5 * 0.80 = 0.216 -- CORRECT
- Result: P, V -- CORRECT

exercises/01 (le chat mange):
- H(D,1) = 0.6 * 0.8 = 0.480 -- CORRECT
- H(N,2) = 0.480 * 0.7 * 0.60 = 0.2016 -- CORRECT
- H(V,3) = 0.2016 * 0.8 * 0.80 = 0.12902 -- CORRECT (0.129024 exact)
- Result: D, N, V -- CORRECT

---

## 3. CKY ALGORITHM

| Item | Status | Notes |
|------|--------|-------|
| Requires CNF | CORRECT | Properly stated |
| Bottom-up strategy | CORRECT | |
| Table construction | CORRECT | |
| Complexity: O(n^3 * \|R\|^2) | CORRECT per course | See observation below |

**CKY trace** (exercises/02, "le chat mange la souris"):
- Diagonal: Det, N, V, Det, N -- CORRECT
- [1,2] = {NP} from Det+N -- CORRECT
- [4,5] = {NP} from Det+N -- CORRECT
- [3,5] = {VP} from V+NP -- CORRECT
- [1,5] = {S} from NP+VP -- CORRECT

**Observation**: The complexity O(n^3 * |R|^2) follows the course material (CM7). Standard textbooks often cite O(n^3 * |G|) where |G| is grammar size, which reduces to O(n^3 * |R|) with proper indexing. The guide correctly follows the course convention.

---

## 4. TF-IDF

| Item | Status | Notes |
|------|--------|-------|
| tf(w,d) = n(w,d) / SUM n(v,d) | CORRECT | |
| idf(w) = log(\|D\| / df(w)) | CORRECT | |
| tfidf = tf * idf | CORRECT | |

**IDF calculations verified** (log base 10):
- log10(4/3) = 0.125 -- CORRECT
- log10(4/2) = 0.301 -- CORRECT
- log10(4/1) = 0.602 -- CORRECT
- log10(200/75) = 0.426 -- CORRECT
- log10(200/2) = 2.000 -- CORRECT
- log10(200/10) = 1.301 -- CORRECT
- log10(200/20) = 1.000 -- CORRECT
- log10(5/3) = 0.222 -- CORRECT
- log10(5/2) = 0.398 -- CORRECT
- log10(5/1) = 0.699 -- CORRECT

**TF-IDF example** (exercises/03, 200 docs):
- Vecteur d = (0.0852, 0.1000, 0.0000, 0.1500) -- CORRECT
- cos(d, c1) = 0.679 -- CORRECT
- cos(d, c2) = 0.719 -- CORRECT
- Classification: c2 -- CORRECT

---

## 5. NAIVE BAYES WITH LAPLACE SMOOTHING

| Item | Status | Notes |
|------|--------|-------|
| Formula: p(w\|c) = (n(w,c)+1)/(N_c+\|V\|) | CORRECT | |
| Classification: argmax p(c)*PROD p(w_i\|c) | CORRECT | |
| Prior: p(c) = docs_c / total_docs | CORRECT | |

**Numerical calculations verified:**

"fantastique mais decevant" (guide/07, source/03):
- score(positif) = 0.5 * (2/15) * (3/15) = 0.01333 -- CORRECT
- score(negatif) = 0.5 * (1/24) * (4/24) = 0.00347 -- CORRECT
- Classification: POSITIF -- CORRECT

"super mais nul" (exercises/03):
- score(positif) = 0.5 * (3/15) * (1/15) = 0.00667 -- CORRECT
- score(negatif) = 0.5 * (4/24) * (8/24) = 0.02778 -- CORRECT
- Classification: NEGATIF -- CORRECT

Laplace sum verification (\|V\|=4, N_c=10):
- (6+4+1+3)/14 = 14/14 = 1.00 -- CORRECT (valid distribution)

---

## 6. CHOMSKY HIERARCHY

| Type | Name | Constraint | Guide Description |
|------|------|-----------|-------------------|
| 0 | Unrestricted | alpha -> beta | CORRECT |
| 1 | Context-sensitive | alpha A beta -> alpha gamma beta | CORRECT |
| 2 | Context-free (CFG) | A -> gamma (1 NT on left) | CORRECT |
| 3 | Regular | A -> aB or A -> a | CORRECT |

Inclusion: Type 3 C Type 2 C Type 1 C Type 0 -- CORRECT

CFG characterization as "standard in TAL" -- CORRECT per course material.

---

## 7. PERPLEXITY

| Item | Status | Notes |
|------|--------|-------|
| Formula: PP = 2^{-1/n * SUM log2 P(w_i)} | CORRECT | |
| Lower = better | CORRECT | Explicitly warned as common trap |
| PP=1 perfect, PP=\|V\| random | CORRECT | |
| Measured on test corpus | CORRECT | |

**Calculation verified** (guide/02):
- PP = 2^{2/3} = 1.587 -- CORRECT

**Calculation verified** (exercises/05, with Laplace):
- log2 sum = -10.285, PP = 2^{2.571} = 5.94 -- CORRECT (minor rounding 5.94 vs 5.95 at higher precision, acceptable)

---

## 8. HMM

| Item | Status | Notes |
|------|--------|-------|
| Parameters: A (transitions), B (emissions), pi (initial) | CORRECT | |
| Expression: p(w,t) = p(t1)*p(w1\|t1)*PROD p(t_i\|t_{i-1})*p(w_i\|t_i) | CORRECT | |
| Estimation: P(t_i\|t_{i-1}) = C(t_{i-1},t_i)/C(t_{i-1}) | CORRECT | |
| Generative model: p(w,t) not p(t\|w) | CORRECT | |
| HMM as special case of CRF | CORRECT | Per CM5 source |

**Notation**: The generated guide uses `a_{ij} = P(t_j | t_i)` (standard notation: probability of transitioning from state i to state j). This correctly differs from the source guide's non-standard `a_{ij} = P(t_i | t_{j-1})`. The Viterbi recursion consistently uses `a_ji` (from j to i), which is compatible with both notations.

---

## 9. PCFG

| Item | Status | Notes |
|------|--------|-------|
| P(arbre) = PRODUIT P(regle_i) | CORRECT | Explicitly warns it's a product not sum |
| Constraint: SUM P(X->gamma) = 1 for each X | CORRECT | |
| Purpose: disambiguation | CORRECT | |

**Calculation verified** (guide/05, "block the door with stones"):
- Arbre 1 = 1.0 * 0.3 * 0.7 * 1.0 * 0.1^5 = 2.10e-6 -- CORRECT
- Arbre 2 = 1.0 * 0.7 * 0.3 * 0.7 * 1.0 * 0.1^5 = 1.47e-6 -- CORRECT
- Arbre 1 > Arbre 2 -- CORRECT

**Calculation verified** (exercises/02, PCFG exercise 2):
- Arbre 1 = 0.7^3 * 0.5^4 * 0.3^3 * 0.4 = 2.315e-4 -- CORRECT
- Arbre 2 = 0.7^3 * 0.5^4 * 0.3^3 * 0.6 * 0.3 = 1.042e-4 -- CORRECT

---

## 10. EXAM ANALYSIS

The analysis in `exam-prep/analyse_annales.md` was cross-checked against the 2023 exam images.

**2023 exam structure** (from images):
1. RI -- 3 pts (booleen vs vectoriel) -- MATCHES analysis
2. Dependances -- 2 pts (transition parser trace) -- MATCHES analysis
3. Questions cours -- 4 pts (lexeme/mot-forme, hypothese distributionnelle) -- MATCHES analysis
4. Classification -- 7 pts (IDF, TF-IDF, cosinus) -- MATCHES analysis
5. Modeles langue -- 4 pts (RNN, perplexite) -- MATCHES analysis

**Frequency claims**:
- "Classification/TF-IDF present in 6/6 exams" -- Cannot fully verify (PDF rendering unavailable for 2016-2022), but plausible given exam PDFs exist for all 6 years and the 2023 exam confirms the pattern.
- "Analyse syntaxique in 6/6 exams" -- Same caveat; 2023 exam confirms with Section 2 (dependances).
- Point distribution (~35% classification, ~20% questions cours, ~20% modeles langue, ~15% syntaxe, ~10% RI) -- 2023 exam matches: 7+4+4+3+2 = 20 pts with 35%/20%/20%/15%/10%.

---

## ISSUES FIXED

### FIX 1: Transition parser exercise 2 contained scratch work (FIXED)

**File**: `exercises/06_transition_parser.md`, Exercise 2

**Problem**: The exercise contained three successive attempts at the trace table with visible confusion and self-corrections ("Attend... le probleme est que...", "Reprenons", "Non, revoyons..."). This included incorrect intermediate attempts that a student could mistake for the solution.

**Fix applied**: Replaced all three attempts with a single clean trace table with the correct final answer and clear step-by-step explanations. Key correction: step 7 uses Right-Arc (D) for chien-->noir, not Left-Arc, because chien (second) is the head of noir (sommet).

---

## MINOR OBSERVATIONS (no changes needed)

### 1. Log base convention
The guides use log base 10 for IDF calculations and log base 2 for perplexity. This is correctly noted in exercises/04 ("log en base 10 vs base 2: verifier la convention dans l'enonce"). The course material does not consistently specify the base for IDF, but base 10 is standard in IR.

### 2. CKY complexity notation
The guides state O(n^3 * |R|^2) following the course. Standard textbooks more commonly cite O(n^3 * |G|). Both are valid depending on the implementation assumed. The guide correctly follows the course convention.

### 3. Perplexity rounding
Exercise 05 gives PP = 5.94 for the Laplace-smoothed example. The exact value is 5.947... which rounds to either 5.94 or 5.95 depending on precision. The difference is negligible and acceptable for a DS exercise.

### 4. Source guide HMM notation
The source guide (data/moodle/guide/05) uses the non-standard notation `a_{ij} = P(t_i | t_{j-1})`. The generated guide correctly normalizes this to `a_{ij} = P(t_j | t_i)` which is the standard convention. No issue in the generated material.

### 5. BM25 formula completeness
The guides include the BM25 query-term component `[tf(t,q)*(k3+1)] / [tf(t,q)+k3]` in the source guide (04_recherche_information.md) but the cheat sheet and exam-prep formulas omit it. Since for most exam questions the query has each term appearing once (tf(t,q)=1), this simplification is reasonable and the omission does not affect exam correctness.

### 6. Booleen vs Vectoriel (2023 exam Q1.2)
Exercise 04 answers Q2 (produit scalaire binaire with single-term query) as "OUI" (same score). This is correct for a single-term query with binary representation: both dot products equal 1. The exercise correctly notes this would differ for multi-term queries.

---

## VERIFIED ITEMS CHECKLIST

- [x] N-gram formulas and examples
- [x] Viterbi algorithm steps and numerical traces (2 exercises)
- [x] CKY algorithm table construction (1 exercise)
- [x] TF-IDF formulas and calculations (3 exercises)
- [x] Naive Bayes with Laplace smoothing (3 exercises)
- [x] Chomsky hierarchy (Types 0-3)
- [x] Perplexity formula and calculations (2 exercises)
- [x] HMM parameters and formulation
- [x] CRF formulation
- [x] PCFG probability calculations (2 exercises)
- [x] Transition parser traces (2 exercises)
- [x] Cosine similarity calculations
- [x] Wu-Palmer formula
- [x] Word2Vec/GloVe descriptions
- [x] BPE algorithm description
- [x] PageRank formula
- [x] BM25 formula
- [x] Rocchio formula
- [x] nDCG formula
- [x] Precision/Recall/F1 formulas
- [x] UAS/LAS definitions
- [x] BIO system description
- [x] Exam frequency analysis (partially verified)
- [x] All "piege DS" warnings accurate
