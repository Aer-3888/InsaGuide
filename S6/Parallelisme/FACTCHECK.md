# Fact-Check Report -- S6/Parallelisme

Date: 2026-04-17

## Scope

Verified all 19 generated files across `guide/` (8 chapters + README), `exercises/` (5 TP guides + README), and `exam-prep/` (3 files + README) against:
- Source C files: `data/moodle/tp/tp{1..6}/src/*.c`
- Source Makefiles: `data/moodle/tp/tp{1,4,5,6}/src/Makefile`
- Source course guides: `data/moodle/guide/{01..05,cheat_sheet}.md`
- Source course PDFs (cross-referenced via the extracted guides)

---

## 1. Amdahl's Law

### Formula: CORRECT

```
S_max(p) = 1 / ((1-f) + f/p)
```

- `f` = fraction parallelisable (0 to 1): CORRECT throughout all files
- `1-f` = fraction sequentielle: CORRECT throughout all files
- The guide consistently uses `f` for the parallel fraction, matching the source guide `data/moodle/guide/01_intro_parallelisme.md`
- Limit formula `S_max(inf) = 1/(1-f)`: CORRECT

### Numerical Examples: ALL CORRECT

Verified every row of the f=0.9 table in `guide/01_fondamentaux.md`:

| p | Formula | Expected | Guide | Status |
|---|---------|----------|-------|--------|
| 1 | 1/(0.1+0.9) | 1.00 | 1.00 | CORRECT |
| 2 | 1/(0.1+0.45) | 1.818 | 1.82 | CORRECT |
| 4 | 1/(0.1+0.225) | 3.077 | 3.08 | CORRECT |
| 8 | 1/(0.1+0.1125) | 4.706 | 4.71 | CORRECT |
| 16 | 1/(0.1+0.05625) | 6.400 | 6.40 | CORRECT |
| inf | 1/0.1 | 10.00 | 10.00 | CORRECT |

### Inverse Problem (find f from S): CORRECT

In `guide/01_fondamentaux.md` and `exam-prep/exercices_type.md`:
- S=5 with p=8: f=0.914 -- verified algebraically: 5=1/((1-f)+f/8), solving gives f=6.4/7=0.9143. CORRECT.

### Limit Table: CORRECT

| f | S_max | Calculation |
|---|-------|-------------|
| 50% | 2x | 1/0.5=2 CORRECT |
| 75% | 4x | 1/0.25=4 CORRECT |
| 90% | 10x | 1/0.1=10 CORRECT |
| 95% | 20x | 1/0.05=20 CORRECT |
| 99% | 100x | 1/0.01=100 CORRECT |

### Amdahl Warning in `exam-prep/pieges_frequents.md`: CORRECT

The "FAUX" version `S(p) = 1 / (f + (1-f)/p)` is correctly identified as wrong, and the "VRAI" version `S(p) = 1 / ((1-f) + f/p)` is correctly identified as right. The verification method (test f=1 gives S=p, f=0 gives S=1) is correct.

---

## 2. Gustafson's Law

### Formula: CORRECT

```
S_scaled(p) = p - alpha * (p - 1)
```

- `alpha` = fraction sequentielle: CORRECT (matches source guide)
- Example: alpha=0.1, p=100 -> S=100-0.1*99=90.1: CORRECT

### Amdahl vs Gustafson Comparison: CORRECT

The table in `guide/01_fondamentaux.md` correctly distinguishes:
- Amdahl: fixed problem size, pessimistic
- Gustafson: growing problem size, optimistic

---

## 3. Speedup and Efficiency Formulas

### Throughout all files: CORRECT

- `S(p) = T(1) / T(p)`: CORRECT
- `E(p) = S(p) / p`: CORRECT
- All worked examples in `exam-prep/exercices_type.md` verified:
  - S(8)=20/4=5.0: CORRECT
  - E(8)=5/8=0.625: CORRECT
  - f from S(8)=5: f=0.914: CORRECT
  - S(64) with f=0.914: 1/(0.086+0.914/64)=1/(0.086+0.01428)=1/0.10028=9.97: CORRECT
  - S(inf) with f=0.914: 1/0.086=11.63: CORRECT

---

## 4. OpenMP

### Pragma Syntax: ALL CORRECT

Every pragma in the guide matches the OpenMP specification:
- `#pragma omp parallel`: CORRECT
- `#pragma omp parallel for`: CORRECT
- `#pragma omp parallel for reduction(+:var)`: CORRECT
- `#pragma omp critical`: CORRECT
- `#pragma omp critical(name)`: CORRECT
- `#pragma omp atomic`: CORRECT
- `#pragma omp barrier`: CORRECT
- `#pragma omp single`: CORRECT
- `#pragma omp master`: CORRECT
- `#pragma omp parallel sections` / `#pragma omp section`: CORRECT
- `#pragma omp for nowait`: CORRECT
- `#pragma omp parallel for collapse(2)`: CORRECT
- `#pragma omp parallel for schedule(TYPE, CHUNK)`: CORRECT
- `#pragma omp simd`: CORRECT

### Clause Names: ALL CORRECT

- `shared(x)`, `private(x)`, `firstprivate(x)`, `lastprivate(x)`: CORRECT descriptions
- `reduction(op:x)`: CORRECT syntax and semantics
- `schedule(static/dynamic/guided/auto)`: CORRECT descriptions
- `num_threads(n)`, `nowait`, `collapse(n)`: CORRECT

### Reduction Operators: CORRECT

| Operator | Initial Value | Guide | Status |
|----------|---------------|-------|--------|
| `+` | 0 | 0 | CORRECT |
| `*` | 1 | 1 | CORRECT |
| `min` | largest value | "Plus grande valeur" | CORRECT |
| `max` | smallest value | "Plus petite valeur" | CORRECT |
| `&` | ~0 | ~0 | CORRECT |
| `\|` | 0 | 0 | CORRECT |

### Scheduling Types: CORRECT

All four types (`static`, `dynamic`, `guided`, `auto`) correctly described with appropriate use cases.

### Default Variable Scoping: CORRECT

- Variables before block: `shared` (correct)
- Variables inside block: `private` (correct)
- Loop variable: `private` automatically (correct)

### Function Names: ALL CORRECT

- `omp_get_thread_num()`: CORRECT
- `omp_get_num_threads()`: CORRECT
- `omp_get_wtime()`: CORRECT
- `omp_set_num_threads(n)`: CORRECT

### Compilation Flag: CORRECT

`gcc -fopenmp` consistently used. Warning about silent ignore without `-fopenmp`: CORRECT.

### Implicit Barriers: CORRECT

Listed for `parallel`, `for`, `sections`, `single`. Noted absence for `master`. All correct per OpenMP spec.

---

## 5. MPI

### Function Signatures: ALL CORRECT

#### MPI_Send:
```c
MPI_Send(const void *buf, int count, MPI_Datatype type, int dest, int tag, MPI_Comm comm);
```
CORRECT.

#### MPI_Recv:
```c
MPI_Recv(void *buf, int count, MPI_Datatype type, int source, int tag, MPI_Comm comm, MPI_Status *status);
```
CORRECT. `MPI_ANY_SOURCE` and `MPI_ANY_TAG` wildcards mentioned: CORRECT.

#### MPI_Bcast:
```c
MPI_Bcast(&buf, count, type, root, comm);
```
CORRECT.

#### MPI_Scatter:
```c
MPI_Scatter(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm);
```
CORRECT.

#### MPI_Gather:
```c
MPI_Gather(sendbuf, sendcount, sendtype, recvbuf, recvcount, recvtype, root, comm);
```
CORRECT.

#### MPI_Reduce:
```c
MPI_Reduce(&sendbuf, &recvbuf, count, type, op, root, comm);
```
CORRECT.

#### MPI_Allreduce:
```c
MPI_Allreduce(&sendbuf, &recvbuf, count, type, op, comm);
```
CORRECT (no root parameter).

#### MPI_Sendrecv:
```c
MPI_Sendrecv(&sendbuf, sendcount, sendtype, dest, sendtag,
             &recvbuf, recvcount, recvtype, source, recvtag, comm, &status);
```
CORRECT.

#### MPI_Isend / MPI_Irecv:
```c
MPI_Isend(&buf, count, type, dest, tag, comm, &request);
MPI_Irecv(&buf, count, type, source, tag, comm, &request);
MPI_Wait(&request, &status);
```
CORRECT.

### Data Types: CORRECT

| MPI Type | C Type | Status |
|----------|--------|--------|
| `MPI_INT` | `int` | CORRECT |
| `MPI_LONG` | `long` | CORRECT |
| `MPI_FLOAT` | `float` | CORRECT |
| `MPI_DOUBLE` | `double` | CORRECT |
| `MPI_CHAR` | `char` | CORRECT |

### Communicators: CORRECT

`MPI_COMM_WORLD` consistently used and correctly described as the default communicator containing all processes.

### Reduction Operations: CORRECT

`MPI_SUM`, `MPI_PROD`, `MPI_MAX`, `MPI_MIN`, `MPI_MAXLOC`, `MPI_MINLOC` all listed correctly.

### Collective Semantics: CORRECT

The critical rule "all processes must call collective operations" is emphasized repeatedly across all files. CORRECT.

### count vs sizeof: CORRECT

The pitfall about `count` being the number of elements (not bytes) is correctly and repeatedly flagged.

---

## 6. Race Conditions

### Examples: ALL CORRECT

1. **Counter increment** (`guide/02_pthreads.md`, `guide/06_synchronisation.md`): `compteur++` correctly identified as non-atomic (read-modify-write), race condition correctly explained. CORRECT.

2. **OpenMP sum without reduction** (`exam-prep/pieges_frequents.md`): Correctly identified as race condition, correct fix with `reduction(+:somme)`. CORRECT.

3. **Histogram race** (`exam-prep/exercices_type.md`): Correctly identified concurrent `histogram[image[i]]++` as race condition. Both atomic and local-histogram solutions are correct. CORRECT.

4. **Loop dependency** (`exam-prep/pieges_frequents.md`): `tab[i] = tab[i-1] + 1` correctly identified as non-parallelizable due to loop-carried dependency. CORRECT.

---

## 7. CUDA

### Kernel Syntax: CORRECT

- `__global__` qualifier for kernels: CORRECT
- `__device__` for GPU-only functions: CORRECT
- `__host__` for CPU functions: CORRECT
- Launch syntax `kernel<<<nb_blocs, taille_bloc>>>(args)`: CORRECT

### Index Formula: CORRECT

```c
int i = blockIdx.x * blockDim.x + threadIdx.x;
```
CORRECT. Example with 3 blocks of 4 threads verified:
- Bloc 0: i=0,1,2,3 CORRECT
- Bloc 1: i=4,5,6,7 CORRECT
- Bloc 2: i=8,9,10,11 CORRECT

### Block Count Formula: CORRECT

```c
int nb_blocs = (N + taille_bloc - 1) / taille_bloc;
```
CORRECT (ceiling division).

### Memory Hierarchy: CORRECT

| Memory | Scope | Speed | Size | Status |
|--------|-------|-------|------|--------|
| Registers | Per thread | Ultra-fast | Few KB | CORRECT |
| Shared (`__shared__`) | Per block | ~5 cycles | 48-96 KB/SM | CORRECT |
| Global | All threads | 400-600 cycles | 4-24 GB | CORRECT |
| CPU RAM | CPU only | Very slow (PCIe) | 8-64 GB | CORRECT |

### Memory API: CORRECT

- `cudaMalloc((void **)&ptr, size)`: CORRECT
- `cudaMemcpy(dst, src, size, direction)`: CORRECT
- `cudaMemcpyHostToDevice` / `cudaMemcpyDeviceToHost`: CORRECT
- `cudaFree(ptr)`: CORRECT
- `cudaDeviceSynchronize()`: CORRECT
- `__syncthreads()` for intra-block barrier: CORRECT

### 2D Dimensions: CORRECT

```c
dim3 taille_bloc(16, 16);
dim3 nb_blocs((largeur+15)/16, (hauteur+15)/16);
```
CORRECT.

### Reduction Kernel: CORRECT

The tree-reduction pattern in `guide/08_gpu_cuda.md` is algorithmically correct: stride halving with `__syncthreads()` at each level, thread 0 writes the block result.

### Warp Size: CORRECT

32 threads per warp. CORRECT per NVIDIA specification.

---

## 8. TP Solutions vs Source C Files

### TP1 (OpenMP Basics)

#### exo1.c

Guide: Matches source exactly. `#pragma omp parallel` with `omp_get_thread_num()`. CORRECT.

#### exo2.c

Guide correctly reproduces the manual distribution `(ITERNUM/tot)*num` to `(ITERNUM/tot)*(num+1)` and correctly identifies the divisibility pitfall. The `parallel for` alternative is also correct. CORRECT.

#### exo3.c (PI calculation)

**Source loop:** `for (long i=1; i<=1+nb_pas; i++)` with `x = (i-0.5)*pas`
**Guide loop:** `for (long i = 1; i <= 1+nb_pas; i++)` with `x = (i - 0.5) * pas`
CORRECT match.

The `reduction(+:som) private(x)` clauses match the source. CORRECT.

Note: The guide chapter `guide/03_openmp.md` section 10 shows a *different* PI algorithm (midpoint rule with `i=0` to `i<N`, `x=(i+0.5)*pas`) which is also mathematically valid. This is presented as a standalone example, not as the TP1 solution, so there is no contradiction.

### TP2 (Heat Equation - OpenMP)

#### exo1.c

Guide in `exercises/tp2_3_openmp_avance.md` faithfully reproduces:
- `#define INDEX(A,B) A*(N+2)+B`: matches source
- `#define N 100`, `#define M 100`, `#define MAX 1000`, `#define SEUIL 1`: matches source
- `#pragma omp parallel for reduction(+:delta)` on outer loop: matches source
- `int machin = k*(N+2)` offset pre-computation: matches source
- 5-point stencil `/5`: matches source (uses `/5` not `/5.0`, but in context of double arithmetic, equivalent)
- Pointer swap: matches source

CORRECT.

#### exo2.c (Sieve of Eratosthenes)

Guide correctly reproduces the algorithm and correctly analyzes why the parallelization works despite apparent data dependencies (idempotent writes of zero). CORRECT.

### TP4 (MPI PI)

#### parallel.c

Guide in `exercises/tp4_mpi_pi.md` faithfully reproduces:
- `MPI_Bcast(&N, 1, MPI_LONG, 0, MPI_COMM_WORLD)`: matches source
- Block-contiguous distribution `borneInf = (double)rank / nbProc`: matches source
- Trapezoidal integration: matches source
- `MPI_Reduce(&resultPartiel, &estimationPi, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD)`: matches source
- Division by 2.0 after reduce: matches source

CORRECT.

#### sequentiel.c

Guide correctly describes the sequential trapezoidal method. The `f(0)` starting value and the `rez/2.0/N` normalization match the source. CORRECT.

### TP5 (MPI Matrix-Vector)

#### main.c

Guide in `exercises/tp5_mpi_matvec.md` faithfully reproduces:
- `assert(n%nbproc==0)`: matches source
- `MPI_Bcast(vectAMult, n, MPI_DOUBLE, 0, MPI_COMM_WORLD)`: matches source
- `MPI_Scatter(matriceAMult, n*(n/nbproc), MPI_DOUBLE, matFragment, n*(n/nbproc), MPI_DOUBLE, 0, MPI_COMM_WORLD)`: matches source
- Inner product loop `rezFragment[k] += matFragment[k*n+l] * vectAMult[l]`: matches source
- `MPI_Gather(rezFragment, n/nbproc, MPI_DOUBLE, rez, n/nbproc, MPI_DOUBLE, 0, MPI_COMM_WORLD)`: matches source

CORRECT.

### TP6 (MPI Heat)

#### parallel.c

Guide in `exercises/tp6_mpi_chaleur.md` faithfully reproduces:
- Fragment size calculation: `nbLignesUtiles = N/nbP`, `nbLines = nbLignesUtiles+2`, `debutFragment = nbLignesUtiles*(M+2)`, `tailleFragment = nbLines*(M+2)`: matches source
- Initial distribution via Send/Recv (not Scatter): matches source
- `eqChaleurIter(fragment+M+3, fragment1+M+3, M, nbLignesUtiles, M+2)`: matches source
- Halo exchange pattern: `MPI_Isend` for sends, `MPI_Recv` for receives: matches source
- `MPI_Allreduce(&delta, &deltaTotal, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD)`: matches source
- K iterations between Allreduce checks: matches source

The `eqChaleurIter` function signature and implementation match the source exactly. CORRECT.

---

## 9. Deadlock Examples

### MPI Send/Send Deadlock: CORRECT

The example where both processes call `MPI_Send` before `MPI_Recv` is a textbook correct deadlock scenario. The explanation about internal buffer limits is accurate. All three solutions (alternating, Sendrecv, Isend) are correct.

### Pthreads Deadlock: CORRECT

The example of thread 1 locking A then B while thread 2 locks B then A is a correct deadlock scenario. The four Coffman conditions are correctly stated as all being necessary. The ordered-locking and trylock solutions are both correct.

---

## 10. Performance Calculations

### All Worked Examples: CORRECT

Every speedup, efficiency, and Amdahl calculation in `exam-prep/exercices_type.md` and `exam-prep/questions_cours.md` was verified independently and found to be arithmetically correct.

### Timing Advice: CORRECT

- OpenMP: `omp_get_wtime()` recommended, `clock()` warned against: CORRECT
- MPI: `MPI_Wtime()` recommended: CORRECT
- CUDA: `cudaEvent` API described correctly: CORRECT

---

## 11. C Code Syntactic Correctness

All C code examples across all 19 files were reviewed for syntactic correctness:
- All `#include` directives present and correct
- All function signatures match the POSIX/MPI/CUDA APIs
- All `#pragma omp` directives have correct syntax
- No missing semicolons, brackets, or parentheses
- Correct use of pointer casts (e.g., `(void *)`, `(int *)`)
- Correct memory management patterns (malloc/calloc/free for host, cudaMalloc/cudaFree for device)

---

## Issues Found and Fixed

### Issue 1: Pthreads Compilation Flag in README (FIXED)

**File:** `guide/README.md`
**Before:** `gcc programme.c -o programme -lpthread`
**After:** `gcc -pthread programme.c -o programme`
**Reason:** The `-pthread` flag (used consistently in chapter 02 and the cheat sheet) is the correct modern flag that sets both compiler and linker options. `-lpthread` only sets the linker flag and may miss compile-time definitions. The guide chapter 02 already used `-pthread` correctly; the README was inconsistent.

---

## No Issues Found (Verified Clean)

The following areas were all verified and found to be completely correct:

1. All Amdahl's law formulas and numerical examples
2. All Gustafson's law formulas and examples
3. All speedup/efficiency formulas and worked problems
4. All OpenMP pragmas, clauses, scheduling types, and reduction operators
5. All MPI function signatures, data types, communicators, and reduction operations
6. All race condition examples and their corrections
7. All deadlock examples and their solutions
8. All CUDA kernel syntax, memory hierarchy, indexation formulas, and API calls
9. All TP solution code against actual source files (TP1 through TP6)
10. All C code syntactic correctness
11. All compilation commands and flags
12. Flynn's taxonomy (SISD, SIMD, MISD, MIMD) with correct examples
13. Memory model descriptions (shared vs distributed vs GPU)
14. Scalability definitions (strong vs weak scaling)
15. False sharing explanation and solutions

---

## Summary

| Category | Items Checked | Issues Found | Issues Fixed |
|----------|---------------|--------------|--------------|
| Amdahl's Law | 12 formulas/examples | 0 | 0 |
| Gustafson's Law | 3 formulas/examples | 0 | 0 |
| Speedup/Efficiency | 8 worked problems | 0 | 0 |
| OpenMP | 18 pragmas, 6 clauses, 4 schedules, 6 operators | 0 | 0 |
| MPI | 12 function signatures, 5 data types, 6 operations | 0 | 0 |
| Race Conditions | 4 examples | 0 | 0 |
| CUDA | 8 API functions, 4 built-in variables, memory hierarchy | 0 | 0 |
| TP Solutions | 6 TPs, 10 source files cross-checked | 0 | 0 |
| C Code Syntax | All code blocks in 19 files | 0 | 0 |
| Compilation Flags | 4 technologies | 1 (README inconsistency) | 1 |
| **TOTAL** | ~100 individual verifications | **1** | **1** |

**Overall Assessment:** The generated study guide is of exceptionally high quality. All formulas, API descriptions, code examples, and performance calculations are correct. The single issue found was a minor inconsistency in the README compilation flag for Pthreads, which has been fixed.
