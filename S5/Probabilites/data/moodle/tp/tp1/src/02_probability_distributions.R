# TP1 - Part 2: Probability Distributions in R
# Working with distribution functions: d*, p*, q*, r*

# =============================================================================
# PROBABILITY DISTRIBUTION FUNCTIONS IN R
# =============================================================================
# Four function families for each distribution:
# - d* : Density/mass function (PDF/PMF)
# - p* : Cumulative distribution function (CDF) - P(X ≤ x)
# - q* : Quantile function (inverse CDF)
# - r* : Random number generation

# =============================================================================
# 1. NORMAL DISTRIBUTION EXAMPLES
# =============================================================================

# Density function: dnorm(x, mean, sd)
# Calculate density at specific points
densities <- dnorm(c(0.8, 1, 1.2), mean=1, sd=0.2)
print(densities)

# Visualize normal distribution N(1, 0.4)
curve(dnorm(x, mean=1, sd=0.4),
      from=-3, to=7,
      xlab="x", ylab="Density",
      main="Normal Distribution N(1, 0.4)",
      col="blue", lwd=2)

# Add another normal distribution N(4, 3.4) to same plot
curve(dnorm(x, mean=4, sd=3.4),
      add=TRUE,  # Overlay on existing plot
      col="red", lwd=2)

# Add legend
legend("topright",
       legend=c("N(1, 0.4)", "N(4, 3.4)"),
       col=c("blue", "red"),
       lwd=2)

# =============================================================================
# 2. BINOMIAL DISTRIBUTION EXAMPLE
# =============================================================================

# Binomial: Number of successes in n trials with probability p
# B(n=10, p=0.2)

x <- 0:10  # Possible values (0 to 10 successes)
y <- dbinom(x, size=10, prob=0.2)  # Probability mass function

# Plot as histogram-style bars
plot(x, y,
     type='h',      # Histogram-style vertical lines
     lwd=30,        # Line width
     lend="square", # Square line ends
     ylab="P(X=x)",
     xlab="Number of successes",
     main="Binomial Distribution B(10, 0.2)",
     col="darkgreen")

# Add points at tips
points(x, y, pch=19, col="darkgreen", cex=1.5)

# =============================================================================
# 3. CDF AND QUANTILE EXAMPLES
# =============================================================================

# CDF: Probability that X ≤ x
# P(X ≤ 5) for X ~ B(10, 0.2)
prob_at_most_5 <- pbinom(5, size=10, prob=0.2)
print(paste("P(X ≤ 5) =", round(prob_at_most_5, 4)))

# P(X ≥ 6) = 1 - P(X ≤ 5)
prob_at_least_6 <- 1 - pbinom(5, size=10, prob=0.2)
print(paste("P(X ≥ 6) =", round(prob_at_least_6, 4)))

# Quantile: Find x such that P(X ≤ x) = p
# Find median (50th percentile) of N(0, 1)
median_std_normal <- qnorm(0.5, mean=0, sd=1)
print(paste("Median of N(0,1):", median_std_normal))  # Should be 0

# Find 95th percentile of N(0, 1)
q95_std_normal <- qnorm(0.95, mean=0, sd=1)
print(paste("95th percentile of N(0,1):", round(q95_std_normal, 3)))  # ~1.645

# =============================================================================
# 4. RANDOM NUMBER GENERATION
# =============================================================================

# Generate random samples
set.seed(42)  # For reproducibility

# Generate 1000 samples from N(100, 15)
normal_samples <- rnorm(1000, mean=100, sd=15)

# Visualize histogram vs theoretical density
hist(normal_samples,
     freq=FALSE,  # Show density not counts
     breaks=30,
     col="lightblue",
     border="white",
     main="Normal Samples vs Theoretical Density",
     xlab="Value",
     ylab="Density")

# Overlay theoretical density
curve(dnorm(x, mean=100, sd=15),
      add=TRUE,
      col="red",
      lwd=2)

legend("topright",
       legend=c("Empirical", "Theoretical"),
       fill=c("lightblue", NA),
       border=c("black", NA),
       col=c(NA, "red"),
       lwd=c(NA, 2))

# =============================================================================
# 5. COMMON DISTRIBUTIONS REFERENCE
# =============================================================================

# Uniform distribution: runif(n, min, max)
uniform_samples <- runif(100, min=0, max=1)

# Exponential distribution: rexp(n, rate=lambda)
exponential_samples <- rexp(100, rate=2)

# Poisson distribution: rpois(n, lambda)
poisson_samples <- rpois(100, lambda=5)

# Student's t-distribution: rt(n, df)
t_samples <- rt(100, df=10)

# Chi-squared distribution: rchisq(n, df)
chisq_samples <- rchisq(100, df=5)

# Print summary statistics
cat("\nSummary of distributions:\n")
cat("Uniform [0,1]:", mean(uniform_samples), "\n")
cat("Exponential (λ=2):", mean(exponential_samples), "Expected:", 1/2, "\n")
cat("Poisson (λ=5):", mean(poisson_samples), "Expected:", 5, "\n")
