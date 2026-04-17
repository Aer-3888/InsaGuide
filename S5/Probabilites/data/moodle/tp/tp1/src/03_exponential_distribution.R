# TP1 - Exercise 4.1.3: Exponential Distribution Simulation
# Study exponential distributions with different parameters

# =============================================================================
# THEORY
# =============================================================================
# Exponential distribution with parameter λ:
# - PDF: f(x) = λ * exp(-λ * x) for x ≥ 0
# - Mean: E(X) = 1/λ
# - Variance: Var(X) = 1/λ²
# - Standard deviation: σ = 1/λ

# =============================================================================
# PART 1: VISUALIZE EXPONENTIAL CURVES
# =============================================================================

# Create empty plot with appropriate ranges
plot(NULL,
     xlim = c(0, 5),
     ylim = c(0, 2),
     xlab = "x",
     ylab = "f(x) = λ * exp(-λ * x)",
     main = "Exponential Distribution Density Functions")

# Define parameters
lambdas <- c(0.5, 1, 2)
colors <- c("green", "red", "blue")

# Plot density curves for each λ
for (i in 1:length(lambdas)) {
  lambda <- lambdas[i]

  # Plot exponential density: f(x) = λ * exp(-λ * x)
  curve(lambda * exp(-lambda * x),
        from = 0,
        to = 5,
        add = TRUE,
        col = colors[i],
        lwd = 2)
}

# Add legend
legend("topright",
       legend = c("λ = 0.5", "λ = 1", "λ = 2"),
       col = colors,
       lwd = 2)

# Add grid for readability
grid()

# =============================================================================
# PART 2: SIMULATE EXPONENTIAL SAMPLES
# =============================================================================

# Generate 80 samples from exponential distribution with λ = 2
set.seed(123)
n_samples <- 80
lambda <- 2
samples <- rexp(n_samples, rate = lambda)

# Theoretical values for λ = 2
theoretical_mean <- 1 / lambda      # = 0.5
theoretical_sd <- 1 / lambda        # = 0.5

# Empirical values from samples
empirical_mean <- mean(samples)
empirical_sd <- sd(samples)

cat("Exponential Distribution with λ = 2:\n")
cat("Theoretical mean:", theoretical_mean, "\n")
cat("Empirical mean:", round(empirical_mean, 3), "\n")
cat("Theoretical SD:", theoretical_sd, "\n")
cat("Empirical SD:", round(empirical_sd, 3), "\n\n")

# =============================================================================
# PART 3: HISTOGRAM VS THEORETICAL DENSITY
# =============================================================================

# Create histogram of samples
hist(samples,
     freq = FALSE,      # Display density not frequency
     breaks = 10,
     probability = TRUE,
     main = "Exponential Samples vs Theoretical Density\n(λ = 2, n = 80)",
     xlab = "x",
     ylab = "Density",
     col = "lightblue",
     border = "black")

# Overlay theoretical density curve
curve(lambda * exp(-lambda * x),
      from = 0,
      to = max(samples),
      add = TRUE,
      col = "red",
      lwd = 2)

# Add legend
legend("topright",
       legend = c("Empirical samples", "Theoretical density"),
       fill = c("lightblue", NA),
       border = c("black", NA),
       col = c(NA, "red"),
       lwd = c(NA, 2))

# =============================================================================
# PART 4: LAW OF LARGE NUMBERS
# =============================================================================
# Demonstrate that empirical mean converges to theoretical mean

# Generate samples of increasing size
sample_sizes <- c(10, 50, 100, 500, 1000, 5000, 10000)
empirical_means <- numeric(length(sample_sizes))

set.seed(456)
for (i in 1:length(sample_sizes)) {
  n <- sample_sizes[i]
  samples_n <- rexp(n, rate = lambda)
  empirical_means[i] <- mean(samples_n)
}

# Plot convergence
plot(sample_sizes,
     empirical_means,
     type = "b",
     pch = 19,
     col = "blue",
     log = "x",  # Log scale for x-axis
     xlab = "Sample size (n)",
     ylab = "Empirical mean",
     main = "Convergence to Theoretical Mean (Law of Large Numbers)",
     ylim = c(0.4, 0.6))

# Add theoretical mean line
abline(h = theoretical_mean,
       col = "red",
       lwd = 2,
       lty = 2)

# Add legend
legend("bottomright",
       legend = c("Empirical mean", "Theoretical mean (1/λ)"),
       col = c("blue", "red"),
       pch = c(19, NA),
       lty = c(1, 2),
       lwd = 2)

grid()

# =============================================================================
# PART 5: COMPARING DIFFERENT λ VALUES
# =============================================================================

# Generate samples for different λ values
set.seed(789)
n <- 1000
lambdas_compare <- c(0.5, 1, 2)

par(mfrow = c(1, 3))  # 3 plots side by side

for (lambda in lambdas_compare) {
  samples <- rexp(n, rate = lambda)

  hist(samples,
       freq = FALSE,
       breaks = 30,
       main = paste("λ =", lambda),
       xlab = "x",
       ylab = "Density",
       col = "lightgreen",
       border = "white",
       xlim = c(0, max(samples)))

  curve(lambda * exp(-lambda * x),
        from = 0,
        to = max(samples),
        add = TRUE,
        col = "darkgreen",
        lwd = 2)
}

par(mfrow = c(1, 1))  # Reset to single plot

# =============================================================================
# KEY INSIGHTS
# =============================================================================
# 1. Higher λ → more concentrated near 0, faster decay
# 2. Lower λ → more spread out, slower decay
# 3. Mean = 1/λ: smaller λ → larger mean (distribution shifts right)
# 4. As sample size increases, empirical mean → theoretical mean
