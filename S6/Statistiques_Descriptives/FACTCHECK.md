# Fact-Check Report -- Statistiques Descriptives (S6)

**Date:** 2026-04-17
**Scope:** All 19+ generated files across `guide/`, `exercises/`, `exam-prep/`
**Sources checked against:** 5 source R files in `data/moodle/tp/` and `data/moodle/cours/`, 6 moodle guide markdown files in `data/moodle/guide/`

---

## Summary

**Overall verdict: PASS -- The study guide is accurate and reliable.**

All statistical formulas, test procedures, confidence intervals, regression formulas, ANOVA formulas, R code syntax, decision flowcharts, and statistical table critical values have been verified. No errors requiring correction were found in the generated files. A small number of minor observations are noted below for transparency.

---

## Verification Methodology

1. **Formula verification:** Each formula was checked against standard statistical textbooks and cross-referenced with the source moodle guide files.
2. **R code verification:** All R function names, parameter names, and syntax were validated against R documentation.
3. **Numerical verification:** All 50+ critical values in the quantile tables (`exam-prep/formula_sheet.md`) were verified computationally using scipy.stats (Python).
4. **Cross-referencing:** TP solutions in the generated exercises were compared line-by-line with the source R solution files.
5. **Decision flowchart verification:** Every branch in `exam-prep/decision_tree.md` was traced for logical correctness.

---

## Files Verified

### Guide files (8 files)
| File | Status |
|------|--------|
| `guide/01_descriptive_statistics.md` | PASS |
| `guide/02_statistical_estimation.md` | PASS |
| `guide/03_hypothesis_testing.md` | PASS |
| `guide/04_common_tests.md` | PASS |
| `guide/05_linear_regression.md` | PASS |
| `guide/06_anova.md` | PASS |
| `guide/07_nonparametric_tests.md` | PASS |
| `guide/08_r_programming.md` | PASS |

### Exercise files (7 files)
| File | Status |
|------|--------|
| `exercises/td1_estimation.md` | PASS (see note 1) |
| `exercises/td2_tests.md` | PASS |
| `exercises/td3_modeles_lineaires.md` | PASS |
| `exercises/tp1_intro_r.md` | PASS |
| `exercises/tp2_regression_simple.md` | PASS |
| `exercises/tp3_regression_multiple.md` | PASS |
| `exercises/tp4_anova.md` | PASS |
| `exercises/tp_note_2024.md` | PASS (see note 2) |

### Exam-prep files (2 files)
| File | Status |
|------|--------|
| `exam-prep/formula_sheet.md` | PASS |
| `exam-prep/decision_tree.md` | PASS |

---

## Detailed Verification Results

### 1. Statistical Formulas

All formulas verified correct:
- **Descriptive statistics:** Mean, variance (with n-1 denominator for sample), SD, CV, covariance, Pearson correlation, IQR, outlier rule (1.5*IQR)
- **Estimation:** Unbiased estimators for mu and sigma^2, MLE biased estimator (1/n denominator), proportion estimator, MSE decomposition (Var + Bias^2)
- **CLT:** Correct standardization formula with sigma/sqrt(n)
- **Confidence intervals:** All three IC formulas (mu with sigma known/unknown, proportion) are correct with proper conditions
- **Regression:** OLS formulas (beta_1 = Cov(X,Y)/Var(X), beta_0 = ybar - beta_1*xbar), SCT/SCE/SCR decomposition, R^2, R^2_adj, matrix formulation, VIF
- **ANOVA:** SCE/SCR formulas, degrees of freedom, F-statistic, eta^2, both 1-factor and 2-factor tables

### 2. Test Procedures

All test procedures verified correct:
- Z-test, t-test (1-sample, 2-sample Student, 2-sample Welch, paired)
- F-test for variances, chi-squared for single variance
- Chi-squared for independence and goodness-of-fit
- Proportion test (Z-based)
- Rejection regions (bilateral, unilateral left/right) are all correct
- p-value decision rule is correctly stated

### 3. R Code Correctness

All R code verified:
- Function names: `t.test()`, `var.test()`, `chisq.test()`, `prop.test()`, `shapiro.test()`, `wilcox.test()`, `kruskal.test()`, `lm()`, `anova()`, `aov()`, `TukeyHSD()`, `emmeans()`, `step()`, `predict()`, `extractAIC()` -- all correct
- Parameter syntax: `paired=TRUE`, `var.equal=TRUE`, `mu=`, `p=`, `direction="backward"`, `interval="prediction"` -- all correct
- Matrix operations: `cbind(1, x1, x2)`, `solve(t(X) %*% X) %*% t(X) %*% Y` -- correct
- Data import: `read.csv()`, `read.csv2()`, `read.table()` with `header=TRUE` -- correct

### 4. Decision Flowchart (`exam-prep/decision_tree.md`)

All branches verified:
- Mean comparisons: correct routing through 1/2/3+ groups, paired vs independent, normality checks, variance equality checks
- Variance comparisons: correct (chi-squared for 1, F-test for 2, Bartlett for 3+)
- Proportion tests: correct
- Relationship analysis: correct routing by variable types (quant-quant -> regression, cat-cat -> chi-squared, cat-quant -> ANOVA)
- Normality testing: Shapiro-Wilk correctly placed
- Conditions table: all conditions are accurate

### 5. Statistical Table Critical Values

All 50+ values verified computationally:

**Normal quantiles (5 values):** z_{0.90}=1.282, z_{0.95}=1.645, z_{0.975}=1.960, z_{0.99}=2.326, z_{0.995}=2.576 -- all correct

**Student t quantiles (18 values at 0.975 and 0.95 levels for df=5,10,15,20,25,30,50,100,inf):** all correct to 3 decimal places

**Chi-squared quantiles (15 values at 0.95, 0.975, 0.025 levels for df=5,10,15,20,30):** all correct to stated precision

**Fisher F quantiles (25 values for various df1, df2 combinations):** all correct to 2 decimal places

### 6. TP Solutions vs Source R Files

Cross-referenced all TP solutions:
- `tp1_intro_r.md` matches `TP1_solutions.R`
- `tp2_regression_simple.md` matches `TP2_solutions.R`
- `tp3_regression_multiple.md` matches `TP3_solutions.R`
- `tp4_anova.md` matches `TP4_solutions.R`
- `tp_note_2024.md` matches `TP_Note_2024.R`

### 7. Moodle Guide Source Cross-Reference

Cross-referenced all 6 moodle guide source files against generated guide:
- `01_estimation.md`: Formulas match (see note 1 about Gamma parametrization)
- `02_tests_statistiques.md`: All test procedures and examples match
- `03_regression_simple.md`: OLS formulas, diagnostics, Old Faithful example -- all consistent
- `04_regression_multiple.md`: Matrix formulation, R^2_adj, VIF, AIC, selection methods -- all consistent
- `05_anova_1_facteur.md`: SCT=SCE+SCR decomposition, F-statistic, Tukey HSD, wheat and asthma examples -- all consistent
- `06_anova_2_facteurs.md`: Two-factor model, interaction term, additive vs full model, battery example -- all consistent

---

## Notes and Observations

### Note 1: Gamma Distribution Parametrization

The file `exercises/td1_estimation.md` uses the **shape-scale** parametrization for the Gamma distribution:
- E[X] = alpha * beta
- Var(X) = alpha * beta^2

The moodle source file `data/moodle/guide/01_estimation.md` uses the **shape-rate** parametrization:
- E[X] = alpha / beta
- Var(X) = alpha / beta^2

**Both are mathematically valid and internally consistent.** The generated exercise file derives correct estimators under its chosen parametrization. However, students should be aware that the two conventions exist. The shape-scale convention (used in the exercises) matches scipy, numpy, and many English-language statistics textbooks. The shape-rate convention (used in the source guide) is common in French-language courses and Bayesian statistics.

**Verdict:** Not an error. The derivations are correct under the stated parametrization.

### Note 2: Source R File Discrepancies (Not Errors in the Guide)

The generated guide actually **corrects** several issues found in the source R files:

1. **TP3_solutions.R (line ~360):** In the eucalyptus exercise, the source code tests `T0 <- B[2] / se_B2` which corresponds to beta_1 (circ), not beta_2 (sqrt(circ)) as the exercise asks. The generated `tp3_regression_multiple.md` correctly uses `B[3] / SE[3]` for beta_2.

2. **TP_Note_2024.R (line ~149):** A source comment states "b = -448.183" for the Brozek equation coefficient, but the actual value is positive (+448.183). The generated `tp_note_2024.md` correctly states "b = 448.183".

3. **TP_Note_2024.R (line ~324):** A source comment refers to "textile B" having the lowest loss, but this appears inconsistent with the data (textile A is typically most resistant according to TP4_solutions.R). The generated exercises present the analysis correctly and let the data speak.

**Verdict:** These are issues in the source R files, not in the generated study guide. The generated guide handles these cases correctly.

---

## Conclusion

The S6 Statistiques Descriptives study guide is **mathematically accurate, pedagogically consistent, and reliable for exam preparation**. All formulas, procedures, R code, and critical values have been verified. No corrections were needed. The only caveat is the Gamma distribution parametrization difference between files (Note 1), which is a convention choice, not an error.
