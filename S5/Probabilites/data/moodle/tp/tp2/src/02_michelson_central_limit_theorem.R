# TP2 - Part 2: Michelson Data - Central Limit Theorem
# Demonstrate CLT using Michelson's speed of light measurements

# =============================================================================
# CENTRAL LIMIT THEOREM RECAP
# =============================================================================
# The CLT states that the distribution of sample means approaches a normal
# distribution as sample size increases, regardless of the original distribution.
#
# For X̄ₙ (sample mean of n observations):
#   X̄ₙ ~ N(μ, σ²/n) approximately as n → ∞

# =============================================================================
# LOAD DATA
# =============================================================================

library(MASS)
data <- michelson

# Calculate parameters
mu <- mean(data$Speed)
sigma <- sd(data$Speed)
n_total <- length(data$Speed)

cat("Original data statistics:\n")
cat("Mean (μ):", round(mu, 2), "\n")
cat("SD (σ):", round(sigma, 2), "\n")
cat("Total measurements:", n_total, "\n\n")

# =============================================================================
# PART 1: DISTRIBUTION OF ALL MEASUREMENTS
# =============================================================================

# Plot histogram of all 100 measurements
hist(data$Speed,
     freq = FALSE,  # Show density not counts
     breaks = 25,
     col = "lightblue",
     border = "white",
     xlab = "Speed (km/s - 299000)",
     ylab = "Density",
     main = "Distribution of All Measurements (n=100)")

# Overlay theoretical normal distribution N(μ, σ)
curve(dnorm(x, mean = mu, sd = sigma),
      from = min(data$Speed),
      to = max(data$Speed),
      add = TRUE,
      col = "red",
      lwd = 2)

legend("topright",
       legend = c("Empirical distribution", "Normal N(μ, σ)"),
       fill = c("lightblue", NA),
       border = c("black", NA),
       col = c(NA, "red"),
       lwd = c(NA, 2))

# =============================================================================
# PART 2: DISTRIBUTION OF EXPERIMENT MEANS (n=20)
# =============================================================================
# Each experiment has 20 measurements. According to CLT, the means of these
# experiments should follow N(μ, σ²/20)

# Calculate mean for each experiment using tapply()
# tapply(VALUES, GROUPS, FUNCTION)
experiment_means <- tapply(data$Speed, data$Expt, mean)

cat("Experiment means (n=20 each):\n")
print(experiment_means)

# Theoretical parameters for distribution of means
mu_xbar <- mu
sigma_xbar <- sigma / sqrt(20)  # Standard error of mean

cat("\n\nCentral Limit Theorem prediction:\n")
cat("Mean of X̄₂₀:", round(mu_xbar, 2), "\n")
cat("SD of X̄₂₀ (SE):", round(sigma_xbar, 2), "\n")

# Empirical statistics
cat("\nEmpirical (from 5 experiments):\n")
cat("Mean of experiment means:", round(mean(experiment_means), 2), "\n")
cat("SD of experiment means:", round(sd(experiment_means), 2), "\n")

# =============================================================================
# VISUALIZATION: COMPARE DISTRIBUTIONS
# =============================================================================

# Create overlapping histogram
hist(data$Speed,
     freq = FALSE,
     breaks = 25,
     col = rgb(0.7, 0.7, 1, 0.5),  # Semi-transparent blue
     border = "white",
     xlab = "Speed",
     ylab = "Density",
     main = "CLT: Individual Measurements vs Experiment Means",
     xlim = range(c(data$Speed, experiment_means)))

# Overlay histogram of experiment means
hist(experiment_means,
     freq = FALSE,
     breaks = 5,
     col = rgb(0.7, 1, 0.7, 0.5),  # Semi-transparent green
     border = "white",
     add = TRUE)

# Add theoretical curves
curve(dnorm(x, mean = mu, sd = sigma),
      from = min(data$Speed) - 10,
      to = max(data$Speed) + 10,
      add = TRUE,
      col = "blue",
      lwd = 2,
      lty = 2)

curve(dnorm(x, mean = mu_xbar, sd = sigma_xbar),
      from = min(experiment_means) - 10,
      to = max(experiment_means) + 10,
      add = TRUE,
      col = "darkgreen",
      lwd = 2,
      lty = 2)

legend("topleft",
       legend = c("Individual measurements (n=1)",
                  "Experiment means (n=20)",
                  "N(μ, σ)",
                  "N(μ, σ/√20)"),
       col = c(rgb(0.7, 0.7, 1, 0.5),
               rgb(0.7, 1, 0.7, 0.5),
               "blue",
               "darkgreen"),
       lwd = c(10, 10, 2, 2),
       lty = c(1, 1, 2, 2),
       cex = 0.8)

# =============================================================================
# PART 3: SIMULATED CLT DEMONSTRATION
# =============================================================================
# Generate many sample means to show CLT more clearly

# Simulate: draw 1000 samples of size 20, calculate mean of each
n_simulations <- 1000
sample_size <- 20

set.seed(42)
simulated_means <- replicate(n_simulations, {
  # Resample from original data with replacement
  sample_data <- sample(data$Speed, sample_size, replace = TRUE)
  mean(sample_data)
})

# Plot histogram of simulated sample means
hist(simulated_means,
     freq = FALSE,
     breaks = 30,
     col = "lightgreen",
     border = "white",
     xlab = "Sample mean",
     ylab = "Density",
     main = paste("CLT: Distribution of", n_simulations, "Sample Means (n=20)"))

# Overlay theoretical normal distribution
curve(dnorm(x, mean = mu, sd = sigma/sqrt(sample_size)),
      from = min(simulated_means),
      to = max(simulated_means),
      add = TRUE,
      col = "darkgreen",
      lwd = 3)

# Add actual experiment means as points
points(experiment_means,
       rep(0, length(experiment_means)),
       pch = 19,
       col = "red",
       cex = 1.5)

legend("topright",
       legend = c("Simulated means",
                  "Theoretical N(μ, σ²/n)",
                  "Actual experiment means"),
       fill = c("lightgreen", NA, NA),
       border = c("black", NA, NA),
       col = c(NA, "darkgreen", "red"),
       lwd = c(NA, 3, NA),
       pch = c(NA, NA, 19),
       cex = 0.9)

# =============================================================================
# PART 4: COMPARE DIFFERENT SAMPLE SIZES
# =============================================================================
# Show how CLT improves with larger n

sample_sizes <- c(5, 10, 20, 50)
par(mfrow = c(2, 2))

for (n_sample in sample_sizes) {
  # Generate sample means
  set.seed(123)
  means_n <- replicate(1000, mean(sample(data$Speed, n_sample, replace = TRUE)))

  # Theoretical parameters
  se_n <- sigma / sqrt(n_sample)

  # Plot
  hist(means_n,
       freq = FALSE,
       breaks = 30,
       col = "skyblue",
       border = "white",
       main = paste("Sample size n =", n_sample),
       xlab = "Sample mean",
       ylab = "Density",
       xlim = c(mu - 4*sigma/sqrt(5), mu + 4*sigma/sqrt(5)))

  curve(dnorm(x, mean = mu, sd = se_n),
        add = TRUE,
        col = "red",
        lwd = 2)

  legend("topright",
         legend = c("Empirical", "Theoretical"),
         fill = c("skyblue", NA),
         border = c("black", NA),
         col = c(NA, "red"),
         lwd = c(NA, 2),
         cex = 0.8)
}

par(mfrow = c(1, 1))

# =============================================================================
# KEY INSIGHTS
# =============================================================================
cat("\n\nKey Insights from Central Limit Theorem:\n")
cat("1. Distribution of sample means is approximately normal\n")
cat("2. Mean of sample means ≈ population mean μ\n")
cat("3. SD of sample means (SE) = σ/√n\n")
cat("4. Larger n → narrower distribution → more precise estimates\n")
cat("5. CLT works even if original distribution is not normal\n")
cat("6. Variance of means = σ²/n (decreases with sample size)\n")
