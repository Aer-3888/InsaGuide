# TP2 - Part 1: Michelson Speed of Light - Law of Large Numbers
# Analyze real experimental data to verify the Law of Large Numbers

# =============================================================================
# DATASET DESCRIPTION
# =============================================================================
# The 'michelson' dataset from MASS package contains measurements of the
# speed of light conducted by Albert Michelson in 1879.
#
# Variables:
# - Expt: Experiment number (1-5)
# - Run: Run number within experiment (1-20)
# - Speed: Measured speed of light (in km/s, with 299000 subtracted)
#
# Total: 100 measurements (5 experiments × 20 runs each)

# =============================================================================
# LOAD DATA AND BASIC EXPLORATION
# =============================================================================

# Load MASS library
library(MASS)

# Examine the dataset
summary(michelson)
head(michelson)

cat("Dataset structure:\n")
str(michelson)

cat("\n\nBasic statistics:\n")
cat("Number of measurements:", nrow(michelson), "\n")
cat("Number of experiments:", length(unique(michelson$Expt)), "\n")

# =============================================================================
# CALCULATE SUMMARY STATISTICS
# =============================================================================

# Mean and standard deviation of all measurements
mu <- mean(michelson$Speed)
sigma <- sd(michelson$Speed)
n <- length(michelson$Speed)

cat("\n\nOverall statistics:\n")
cat("Mean speed:", round(mu, 2), "\n")
cat("Standard deviation:", round(sigma, 2), "\n")
cat("Variance:", round(var(michelson$Speed), 2), "\n")

# =============================================================================
# LAW OF LARGE NUMBERS: CUMULATIVE MEAN
# =============================================================================
# As we include more measurements, the empirical mean should converge
# to the true mean (which we estimate with all 100 measurements)

# Calculate cumulative mean
# cumsum() gives cumulative sum: [x1, x1+x2, x1+x2+x3, ...]
# Divide by position to get mean: [x1/1, (x1+x2)/2, (x1+x2+x3)/3, ...]
cumulative_means <- cumsum(michelson$Speed) / (1:n)

# Plot convergence
plot(1:n,
     cumulative_means,
     type = "l",
     col = "blue",
     lwd = 2,
     xlab = "Number of measurements used (n)",
     ylab = "Cumulative mean",
     main = "Law of Large Numbers: Convergence of Empirical Mean",
     ylim = range(c(cumulative_means, mu)))

# Add horizontal line at final mean
abline(h = mu,
       col = "red",
       lwd = 2,
       lty = 2)

# Add grid for readability
grid()

# Add legend
legend("topright",
       legend = c("Cumulative mean", "Final mean (all 100 measurements)"),
       col = c("blue", "red"),
       lty = c(1, 2),
       lwd = 2)

# =============================================================================
# OBSERVATION OF CONVERGENCE
# =============================================================================

# Show how empirical mean changes at key points
key_points <- c(1, 5, 10, 20, 50, 100)

cat("\n\nConvergence of empirical mean:\n")
cat(sprintf("%-6s | %-12s | %-10s\n", "n", "Emp. Mean", "Error"))
cat(strrep("-", 35), "\n")

for (i in key_points) {
  emp_mean <- cumulative_means[i]
  error <- abs(emp_mean - mu)
  cat(sprintf("%6d | %12.3f | %10.3f\n", i, emp_mean, error))
}

# =============================================================================
# VISUALIZE VARIABILITY REDUCTION
# =============================================================================
# Show how the "spread" of possible means decreases with sample size

# Calculate rolling standard error: SE = σ/√n
standard_errors <- sigma / sqrt(1:n)

# Plot mean with confidence envelope
plot(1:n,
     cumulative_means,
     type = "l",
     col = "darkblue",
     lwd = 2,
     xlab = "Number of measurements (n)",
     ylab = "Cumulative mean ± 1 SE",
     main = "Convergence with Standard Error Bands",
     ylim = c(min(cumulative_means - standard_errors),
              max(cumulative_means + standard_errors)))

# Add confidence bands (±1 standard error)
lines(1:n, cumulative_means + standard_errors,
      col = "gray", lty = 3)
lines(1:n, cumulative_means - standard_errors,
      col = "gray", lty = 3)

# Add true mean line
abline(h = mu,
       col = "red",
       lwd = 2,
       lty = 2)

legend("topright",
       legend = c("Cumulative mean", "True mean", "±1 SE"),
       col = c("darkblue", "red", "gray"),
       lty = c(1, 2, 3),
       lwd = c(2, 2, 1))

grid()

# =============================================================================
# ALTERNATIVE VISUALIZATION: Multiple Hypothetical Orders
# =============================================================================
# The Law of Large Numbers holds regardless of measurement order
# Show this by plotting multiple random orderings

n_simulations <- 10
plot(NULL,
     xlim = c(1, n),
     ylim = range(cumulative_means),
     xlab = "Number of measurements",
     ylab = "Cumulative mean",
     main = "LLN: Convergence for Different Measurement Orders")

# Simulate different random orders
set.seed(42)
for (sim in 1:n_simulations) {
  # Randomly reorder measurements
  shuffled_speeds <- sample(michelson$Speed)
  shuffled_means <- cumsum(shuffled_speeds) / (1:n)

  lines(1:n,
        shuffled_means,
        col = rainbow(n_simulations, alpha = 0.6)[sim],
        lwd = 1.5)
}

# Add true mean
abline(h = mu,
       col = "black",
       lwd = 3,
       lty = 2)

legend("topright",
       legend = c("Different orderings", "True mean"),
       col = c(rainbow(n_simulations)[1], "black"),
       lty = c(1, 2),
       lwd = c(1.5, 3))

grid()

# =============================================================================
# KEY INSIGHTS
# =============================================================================
cat("\n\nKey Insights from Law of Large Numbers:\n")
cat("1. Empirical mean converges to true mean as n increases\n")
cat("2. Convergence is NOT monotonic (zigzag pattern)\n")
cat("3. Standard error decreases as 1/√n\n")
cat("4. Convergence holds regardless of measurement order\n")
cat("5. Final estimate (n=100): μ̂ =", round(mu, 2), "\n")
