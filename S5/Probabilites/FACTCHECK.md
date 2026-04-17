# Fact-Check Report: S5/Probabilites Study Guide

**Date**: 2026-04-17
**Files checked**: 17 generated files (8 guide chapters, 3 exam-prep, 5 TP solutions, 1 README)
**Source materials**: 5 TP source .R files, 1 annale .R file, 1 annale .Rmd file, course skeleton .R

---

## Summary

| Category | Items Checked | Errors Found | Errors Fixed |
|----------|--------------|--------------|--------------|
| Distribution formulas (PMF/PDF/CDF) | 12 distributions | 0 | 0 |
| E[X] and Var(X) | 12 distributions | 0 | 0 |
| Limit theorem statements | 3 (Chebyshev, LLN, CLT) | 0 | 0 |
| Confidence interval formulas | 4 (mean known/unknown, variance, proportion) | 0 | 0 |
| Hypothesis testing formulas | 5 test types | 0 | 0 |
| R code syntax | ~50 code blocks | 0 | 0 |
| Worked example calculations | 15+ examples | 5 errors | 5 fixed |
| Distribution comparison tables | 4 tables | 0 | 0 |
| TP solutions vs source .R files | 5 TPs | 2 errors (propagated) | 2 fixed |

**Overall**: 5 numerical errors found and fixed. All formulas, distribution properties, and R syntax are correct.

---

## Errors Found and Fixed

### ERROR 1 (CRITICAL): Integration by parts notation -- Chapter 3

**File**: `guide/03-continuous-random-variables.md`, line 92
**Issue**: Incorrect variable assignment in integration by parts for E[X] of the exponential distribution.
**Was**: "Let u = lambda*x, v' = e^{-lambda*x}, so u' = lambda, v = ..."
**Should be**: "Let u = x, v' = lambda*e^{-lambda*x}, so u' = 1, v = -e^{-lambda*x}"
**Impact**: The final result (E[X] = 1/lambda) was correct, but the intermediate derivation steps were wrong. A student following the stated substitution would not arrive at the correct intermediate expressions.
**Status**: FIXED

### ERROR 2 (CRITICAL): Octopus weight statistics -- TP4 Solution

**File**: `exercises/tp4-solution.md`
**Issue**: The standard deviation, standard error, confidence interval, test statistic, and p-value for the octopus weights exercise were all numerically incorrect.
**Root cause**: The source TP4 .R file's comments (not code) contain incorrect approximate values. The guide propagated these incorrect comment values instead of computing from the actual data.

| Statistic | Was (incorrect) | Correct |
|-----------|----------------|---------|
| S' (sd) | ~1107.7 | ~1158.4 |
| SE | 286.0 | 299.1 |
| 90% CI | [2196.2, 3203.8] | [2173.3, 3226.7] |
| t-statistic | -1.049 | -1.003 |
| p-value | 0.312 | 0.333 |

**Impact**: All derived values were wrong. However, the final decision (fail to reject H0) remains the same because |t| < 1.761 in both cases.
**Status**: FIXED

### ERROR 3 (MODERATE): Two-sample t-test pooled statistics -- TP4 Solution

**File**: `exercises/tp4-solution.md`
**Issue**: The pooled standard deviation, standard error, and test statistic for the two-sample t-test were numerically incorrect.
**Root cause**: Same as Error 2 -- source TP4 .R comments contain approximate values that do not match the formula output.

| Statistic | Was (incorrect) | Correct |
|-----------|----------------|---------|
| Pooled SD (sp) | ~1.130 | ~1.123 |
| SE of difference | ~0.528 | ~0.512 |
| t-statistic | -1.610 | -1.659 |
| Large-sample t | ~-5.3 | ~-5.2 |

**Impact**: The final decisions (fail to reject for small n, reject for large n) remain correct in both cases.
**Status**: FIXED

### ERROR 4 (CRITICAL): Power analysis table -- TP4 Solution and Chapter 6

**Files**: `exercises/tp4-solution.md`, `guide/06-hypothesis-testing.md`
**Issue**: The power summary table and the required sample size for 90% power contained incorrect values for n >= 200.

The guide's power formula uses z_crit = u_{1-alpha/2} = 1.96 (correct for two-sided test at alpha=0.05), and the values for n=40 (24.4%) and n=100 (51.6%) are correct under this formula. However, the values for n=200, n=214, and n=300 were computed using z_crit = 1.645 (one-sided), creating an internal inconsistency.

| n | Was (incorrect) | Correct (z=1.96) |
|---|----------------|-------------------|
| 200 | 85.8% | 80.7% |
| 214 | 90.0% | 83.3% |
| 300 | 97.2% | 93.4% |

The required n for 90% power was stated as ~214 but is actually ~263 (for a two-sided test with z_crit=1.96).

**Impact**: Students would underestimate the sample size needed for 90% power by approximately 23%.
**Status**: FIXED (table corrected, n=214 replaced with n=263)

### ERROR 5 (MINOR): Large-sample t-test approximate value

**File**: `exercises/tp4-solution.md`
**Issue**: The comment said t~-5.3 for the large-sample case, but the correct value with the proper pooled variance formula is ~-5.2.
**Impact**: Minor rounding difference; conclusion unchanged.
**Status**: FIXED

---

## Items Verified as Correct

### Probability Foundations (Chapter 1)
- [x] Kolmogorov axioms: all 3 stated correctly
- [x] Conditional probability formula: P(A|B) = P(A cap B)/P(B) -- correct
- [x] Bayes' theorem: both simple and generalized forms -- correct
- [x] Bayes worked example: P(M1|D) = 0.018/0.038 = 0.474 -- verified
- [x] Independence definition: P(A cap B) = P(A)P(B) -- correct
- [x] Combinatorics table: permutations, arrangements, combinations, with replacement -- all correct

### Discrete Random Variables (Chapter 2)
- [x] Bernoulli: PMF p^k(1-p)^{1-k}, E=p, Var=p(1-p) -- correct
- [x] Binomial: PMF C(n,k)p^k(1-p)^{n-k}, E=np, Var=np(1-p) -- correct
- [x] Poisson: PMF e^{-lambda}lambda^k/k!, E=lambda, Var=lambda -- correct
- [x] Geometric: PMF p(1-p)^{k-1}, E=1/p, Var=(1-p)/p^2 -- correct (k starts at 1)
- [x] Hypergeometric: PMF, E[X]=kK/N -- correct
- [x] R function `dgeom(k-1, p)` note for geometric -- correct (R counts failures from 0)
- [x] R function `dhyper(x, m=K, n=N-K, k)` -- correct parameter mapping
- [x] MCQ example: 1 - pbinom(5, 10, 0.25) = 0.0197 -- verified correct
- [x] Urn example: E[X] = 6 * 8/13 = 3.69 -- verified correct
- [x] Binomial-to-Poisson approximation conditions -- correct
- [x] Binomial-to-Normal approximation conditions (np>=5, n(1-p)>=5) -- correct

### Continuous Random Variables (Chapter 3)
- [x] Uniform: PDF=1/(b-a), CDF, E=(a+b)/2, Var=(b-a)^2/12 -- correct
- [x] Exponential: PDF=lambda*e^{-lambda*x}, CDF=1-e^{-lambda*x}, E=1/lambda, Var=1/lambda^2 -- correct
- [x] Normal: PDF formula, E=mu, Var=sigma^2 -- correct
- [x] Standardization Z=(X-mu)/sigma -- correct
- [x] Key quantiles: 1.645 (90%), 1.960 (95%), 2.576 (99%) -- correct
- [x] Normal sum property: N(mu1+mu2, sqrt(sigma1^2+sigma2^2)) -- correct
- [x] Gamma: E=p/theta, Var=p/theta^2 -- correct
- [x] Cauchy: no finite mean or variance -- correct
- [x] Memoryless property derivation for exponential -- correct
- [x] Quarter-disk example: P = pi/4 = 0.785 -- correct
- [x] WARNING about N(mu, sigma) vs N(mu, sigma^2) convention -- appropriate and correct
- [x] R functions: dexp(x, rate=lambda), dnorm(x, mean, sd) -- correct parameter names

### Limit Theorems (Chapter 4)
- [x] E[Xbar_n] = mu, Var(Xbar_n) = sigma^2/n -- correct
- [x] Chebyshev inequality: P(|X-mu| >= a) <= Var(X)/a^2 -- correct
- [x] Chebyshev table (k=2: >=75%, k=3: >=89%, k=4: >=93.75%) -- correct
- [x] LLN statement (weak law, convergence in probability) -- correct
- [x] LLN proof sketch via Chebyshev -- correct
- [x] CLT statement and standardized form -- correct
- [x] Chebyshev exact values for Exp(1): k=1 (86%), k=2 (95%), k=3 (98%) -- verified
- [x] Gamma(2,1) example: sigma/sqrt(500) = 0.0632 -- verified
- [x] Rounding errors: Y ~ N(0, sqrt(100/12)), P(|Y|>10) = 0.00053 -- verified
- [x] Normal approximation to binomial: conditions and continuity correction table -- correct
- [x] LLN vs CLT comparison table -- correct

### Confidence Intervals (Chapter 5)
- [x] CI for mean (sigma known): Xbar +/- z * sigma/sqrt(n) -- correct
- [x] CI for mean (sigma unknown): Xbar +/- t * S'/sqrt(n) -- correct
- [x] CI for variance: [(n-1)S'^2/chi^2_upper, (n-1)S'^2/chi^2_lower] -- correct, with inverted quantiles noted
- [x] CI for proportion (conservative): phat +/- z * 1/(2*sqrt(n)) -- correct
- [x] Chi-squared: E=k, Var=2k -- correct
- [x] Student t: E=0 (k>1), Var=k/(k-2) (k>2) -- correct
- [x] Student t quantile table: t_1=12.71, t_3=3.182, t_5=2.571, t_10=2.228, t_30=2.042, t_100=1.984 -- correct
- [x] Biased vs unbiased variance: formulas and numerical example (2,4,6) -- verified correct
- [x] CI worked example (sigma known): [79.02, 80.98] -- verified
- [x] CI worked example (sigma unknown): S'=sqrt(2), CI=[77.7, 82.3] -- verified
- [x] Sample size formula: n = (z*sigma/delta)^2 -- correct, example n=16 verified
- [x] R note: var()/sd() compute unbiased (n-1) -- correct
- [x] Decision flowchart: correct routing for mean/variance/proportion -- correct

### Hypothesis Testing (Chapter 6)
- [x] Type I/II error table -- correct
- [x] Conformity test (sigma known): Z statistic and N(0,1) -- correct
- [x] Conformity test (sigma unknown): T statistic and t_{n-1} -- correct
- [x] Homogeneity pooled t-test: formula for pooled variance and df=n1+n2-2 -- correct
- [x] Welch test: Satterthwaite df formula -- correct
- [x] p-value formula for two-tailed: 2*P(S <= -|s|) -- correct
- [x] Insulating pieces example: z=-2.24, reject at alpha=0.05 -- verified
- [x] Unknown sigma variant: t=-2.157 at df=23, |t|>2.069 reject -- verified
- [x] Power formula structure -- correct (uses right-tail approximation)
- [x] R functions: t.test(), z.test() with TeachingDemos -- correct

### Joint Distributions (Chapter 7)
- [x] Joint PMF table sums to 1: 0.02+0.06+...+0.01 = 1.00 -- verified
- [x] Marginal of X: P(X=0)=0.20, P(X=5)=0.49, P(X=10)=0.31 -- verified
- [x] Marginal of Y: P(Y=0)=0.07, P(Y=5)=0.36, P(Y=10)=0.36, P(Y=15)=0.21 -- verified
- [x] Conditional P(X|Y=5): 1/6, 5/12, 5/12 -- verified
- [x] Covariance matrix properties (symmetric, PSD) -- correct
- [x] Linear transform: Var(AX+b) = A*Sigma*A^T -- correct
- [x] Var(Y) worked example: a^T*Sigma*a = 92 -- verified
- [x] Multinomial: PMF, E[Xi]=np_i, Var(Xi)=np_i(1-p_i), Cov=-np_ip_j -- correct
- [x] Multivariate normal density -- correct
- [x] Gaussian vector key properties: marginals normal, independence iff diagonal Sigma -- correct
- [x] Bivariate normal marginal derivation -- correct

### R Programming (Chapter 8)
- [x] d/p/q/r naming convention -- correct
- [x] Distribution parameter table (norm: mean/sd; binom: size/prob; etc.) -- correct
- [x] Plotting commands (plot, curve, hist, barplot, legend, abline) -- correct syntax
- [x] tapply usage for grouped operations -- correct
- [x] set.seed() for reproducibility -- correct
- [x] Key pitfalls table -- all correct

### TP Solutions vs Source .R Files
- [x] TP1: R operations, exponential, urn, dice -- all match source code
- [x] TP2: Michelson LLN, CLT, MCQ simulation, normal approximation -- all match
- [x] TP3: Overbooking, mean CI, variance CI, Student t -- all match source logic
- [x] TP5: Joint distribution, multinomial roulette, covariance computation -- all match

### Exam Prep Materials
- [x] Formula sheet: all formulas consistent with guide chapters -- verified
- [x] Distribution recognition table -- correct mappings
- [x] Numerical quantile values to memorize -- all correct
- [x] Decision flowcharts -- correct routing
- [x] Pattern 2 worked example (n=25): xbar=1200, s'=200 -- verified

---

## Notes

1. **Convention consistency**: The guide correctly and consistently uses N(mu, sigma) with sigma as standard deviation (not variance), matching both R's convention and the course's convention. This is explicitly noted multiple times.

2. **Source material discrepancies**: The GONZALEZ.r student exam file (2021) uses a simple average for pooled variance instead of the proper weighted formula. The guide correctly uses the proper pooled formula.

3. **Power analysis methodology**: The guide presents the one-tail right approximation for power, which is standard practice when the alternative is in a known direction. The left tail contribution is negligible (< 0.001) for the examples given. The corrected table now uses values consistent with the stated formula and z_crit=1.96.

4. **PDF sources not verifiable**: The course PDFs (poly_24_25.pdf, main.pdf, etc.) could not be read due to missing poppler-utils. Formulas were verified against mathematical knowledge and cross-checked with the R source files and student exam solutions.
