# Probabilités - TP Solutions (R)

**Course**: Probabilités - 3rd Year Computer Science
**Institution**: INSA Rennes
**Language**: R

## Overview

This directory contains complete solutions and documentation for all Probabilités lab sessions. Each TP includes cleaned, commented R code and comprehensive README explaining concepts, formulas, and R functions.

## Repository Structure

```
tp/
├── README.md              # This file
├── tp1/                   # Introduction to R and distributions
│   ├── README.md
│   └── src/
│       ├── 01_basic_r_operations.R
│       ├── 02_probability_distributions.R
│       ├── 03_exponential_distribution.R
│       ├── 04_urn_problem.R
│       └── 05_dice_frequency.R
├── tp2/                   # Law of Large Numbers & CLT
│   ├── README.md
│   └── src/
│       ├── 01_michelson_law_of_large_numbers.R
│       ├── 02_michelson_central_limit_theorem.R
│       ├── 03_mcq_simulation.R
│       └── 04_mcq_normal_approximation.R
├── tp3/                   # Confidence Intervals
│   ├── README.md
│   └── src/
│       └── confidence_intervals.R
├── tp4/                   # Hypothesis Testing
│   ├── README.md
│   └── src/
├── tp5/                   # Random Vectors
│   ├── README.md
│   └── src/
└── _originals/            # Original TP files (archived)
```

## Topics Covered

### TP1: Introduction to R and Probability Distributions
- R basics: types, vectors, data frames
- Probability distribution functions (d*, p*, q*, r*)
- Exponential distribution simulation
- Law of Large Numbers demonstration
- Random sampling and visualization

**Key Functions**: `c()`, `seq()`, `rep()`, `data.frame()`, `rnorm()`, `rbinom()`, `rexp()`, `curve()`, `hist()`

### TP2: Law of Large Numbers and Central Limit Theorem
- Michelson's speed of light data analysis
- Empirical mean convergence (LLN)
- Distribution of sample means (CLT)
- Binomial simulation (MCQ problem)
- Normal approximation to binomial
- Continuity correction

**Key Functions**: `library(MASS)`, `tapply()`, `cumsum()`, `rbinom()`, `pbinom()`, `pnorm()`

### TP3: Confidence Intervals
- Quantile calculations for decision-making
- Mean CI with known variance (normal distribution)
- Mean CI with unknown variance (t-distribution)
- Variance CI (chi-squared distribution)
- Coverage rate validation
- Visualization of interval estimates

**Key Functions**: `qnorm()`, `qt()`, `qchisq()`, `qbinom()`, `read.csv2()`, `tapply()`

**Formulas**:
- Mean CI (σ known): `X̄ ± z_(α/2) × (σ/√n)`
- Mean CI (σ unknown): `X̄ ± t_(n-1, α/2) × (S'/√n)`
- Variance CI: `[(n-1)S'²/χ²_upper, (n-1)S'²/χ²_lower]`

### TP4: Hypothesis Testing
- One-sample t-tests (conformity tests)
- Two-sample t-tests (homogeneity tests)
- Test power and sample size calculations
- Type I and Type II errors
- p-value interpretation
- Manual vs `t.test()` implementation

**Key Functions**: `t.test()`, `qt()`, `pt()`, `pnorm()`

**Decision Rules**:
- Reject H₀ if p-value < α
- Reject H₀ if |test statistic| > critical value

### TP5: Random Vectors and Multivariate Distributions
- Joint probability distributions
- Marginal and conditional distributions
- Multinomial distribution
- Multivariate normal distribution
- 3D visualization

**Key Functions**: `apply()`, `margin.table()`, `dmultinom()`, `rmvnorm()`, `scatterplot3d()`

## R Statistical Functions Quick Reference

### Distribution Function Naming

| Prefix | Purpose | Example |
|--------|---------|---------|
| `d*` | Density/mass (PDF/PMF) | `dnorm(x, mean, sd)` |
| `p*` | Cumulative (CDF) | `pnorm(q, mean, sd)` |
| `q*` | Quantile (inverse CDF) | `qnorm(p, mean, sd)` |
| `r*` | Random generation | `rnorm(n, mean, sd)` |

### Common Distributions

| Distribution | Parameters | R Name |
|--------------|------------|--------|
| Normal | μ, σ | `*norm(mean, sd)` |
| Student's t | df | `*t(df)` |
| Chi-squared | df | `*chisq(df)` |
| Binomial | n, p | `*binom(size, prob)` |
| Exponential | λ | `*exp(rate)` |
| Poisson | λ | `*pois(lambda)` |
| Uniform | a, b | `*unif(min, max)` |

## Essential R Techniques

### Data Manipulation
```r
data$column              # Access column
subset(data, condition)  # Filter rows
tapply(X, INDEX, FUN)   # Group and apply
```

### Statistical Summaries
```r
mean(x)                 # Mean
sd(x)                   # Standard deviation
var(x)                  # Variance (unbiased)
summary(x)              # Five-number summary
```

### Plotting
```r
plot(x, y)              # Scatter plot
hist(x, freq=FALSE)     # Histogram (density)
curve(expr, from, to)   # Function plot
abline(h=y, v=x)        # Add reference lines
legend()                # Add legend
```

## Common Pitfalls and Tips

1. **Loop bounds**: R loops are inclusive on both ends
2. **Degrees of freedom**: Use n-1 for sample statistics
3. **Histogram density**: Set `freq=FALSE` to overlay density curves
4. **Chi-squared CI**: Bounds are inverted (upper uses lower quantile)
5. **Standard error**: SE = σ/√n, not just σ
6. **p-value interpretation**: p < α → reject H₀, not "accept H₁"
7. **Coverage rate**: ~95% empirical for 95% theoretical CI

## Required Packages

```r
install.packages("MASS")          # Datasets (michelson, etc.)
install.packages("mvtnorm")       # Multivariate normal
install.packages("scatterplot3d") # 3D visualization
install.packages("rje")           # marginTable, conditionTable
```

## Running the Code

1. **Set working directory**:
   ```r
   setwd("/path/to/tp/tpN/src")
   ```

2. **Load data files** (for TP3):
   ```r
   data <- read.csv2("../vitesse.csv")
   ```

3. **Run scripts**:
   ```r
   source("script_name.R")
   ```

## Learning Path

### Recommended Order
1. **TP1**: Learn R basics and distribution functions
2. **TP2**: Understand fundamental theorems (LLN, CLT)
3. **TP3**: Apply inference (confidence intervals)
4. **TP4**: Make decisions (hypothesis testing)
5. **TP5**: Extend to multiple dimensions

### Key Concepts by Priority
1. **Core**: Mean, variance, standard deviation
2. **Distributions**: Normal, t, chi-squared, binomial
3. **Theorems**: LLN, CLT
4. **Inference**: Confidence intervals, hypothesis tests
5. **Advanced**: Power analysis, multivariate distributions

## Statistical Formulas Cheat Sheet

### Confidence Intervals

| Parameter | Condition | Formula |
|-----------|-----------|---------|
| Mean μ | σ known | X̄ ± z_(α/2) × σ/√n |
| Mean μ | σ unknown | X̄ ± t_(n-1,α/2) × S'/√n |
| Variance σ² | Normal data | [(n-1)S'²/χ²_up, (n-1)S'²/χ²_low] |

### Hypothesis Testing

| Test | H₀ | Test Statistic | Distribution |
|------|----|----|--------------|
| One-sample (σ known) | μ = μ₀ | (X̄ - μ₀)/(σ/√n) | N(0,1) |
| One-sample (σ unknown) | μ = μ₀ | (X̄ - μ₀)/(S'/√n) | t(n-1) |
| Two-sample (equal var) | μ₁ = μ₂ | (X̄₁ - X̄₂)/SE_pooled | t(n₁+n₂-2) |

### Standard Errors

- SE(mean) = σ/√n
- SE(proportion) = √(p(1-p)/n)
- SE(difference) = √(σ₁²/n₁ + σ₂²/n₂)

## Additional Resources

- **R Documentation**: `help(function_name)` or `?function_name`
- **Probability Theory**: Course slides and textbook
- **R Graphics**: `demo(graphics)` for examples
- **Statistical Tests**: `?t.test`, `?chisq.test`, etc.

## Notes

- All R code is fully commented and self-contained
- Original TP files archived in `_originals/` directory
- Each README includes theory, formulas, and practical insights
- Code follows best practices: clear variable names, modular structure
- Visualizations included for all major concepts

## Author

Solutions compiled from course materials (2024-2025) with comprehensive documentation and code cleanup for INSA Rennes 3rd year CS students.
