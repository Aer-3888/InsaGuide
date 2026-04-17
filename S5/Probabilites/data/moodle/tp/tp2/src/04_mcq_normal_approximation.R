# TP2 - Part 4: MCQ - Normal Approximation (Central Limit Theorem)
# Use CLT to approximate binomial distribution with normal distribution

# =============================================================================
# THEORY: NORMAL APPROXIMATION TO BINOMIAL
# =============================================================================
# For X ~ Binomial(n, p), when n is large:
#   X ≈ N(μ = np, σ² = np(1-p))
#
# For sample proportions p̂ = X/n:
#   p̂ ≈ N(p, p(1-p)/n)
#
# Rule of thumb: approximation works well when np ≥ 5 AND n(1-p) ≥ 5

# =============================================================================
# SETUP
# =============================================================================

n_questions <- 10
p_correct <- 0.25
pass_threshold <- 6

# Check if normal approximation is appropriate
np <- n_questions * p_correct
n_1_minus_p <- n_questions * (1 - p_correct)

cat("Normal approximation suitability check:\n")
cat("np =", np, "(should be ≥ 5)\n")
cat("n(1-p) =", n_1_minus_p, "(should be ≥ 5)\n")

if (np < 5 || n_1_minus_p < 5) {
  cat("\n⚠ WARNING: Normal approximation may not be accurate!\n")
  cat("Consider using exact binomial calculations instead.\n\n")
}

# =============================================================================
# PART 1: EXACT vs NORMAL APPROXIMATION (WITHOUT CONTINUITY CORRECTION)
# =============================================================================

# Exact binomial probability
prob_pass_exact <- 1 - pbinom(pass_threshold - 1, size = n_questions, prob = p_correct)

# Normal approximation for number of correct answers
# X ~ N(μ = np, σ² = np(1-p))
mu_X <- n_questions * p_correct
sigma_X <- sqrt(n_questions * p_correct * (1 - p_correct))

# P(X ≥ 6) using normal approximation
# Without continuity correction: P(X ≥ 6) ≈ P(Z ≥ (6 - μ)/σ)
z_score_no_cc <- (pass_threshold - mu_X) / sigma_X
prob_pass_normal_no_cc <- 1 - pnorm(pass_threshold, mean = mu_X, sd = sigma_X)

cat("\n\nProbability P(X ≥ 6):\n")
cat("Exact (binomial):", round(prob_pass_exact, 6), "\n")
cat("Normal approx (no correction):", round(prob_pass_normal_no_cc, 6), "\n")
cat("Error:", round(abs(prob_pass_exact - prob_pass_normal_no_cc), 6), "\n")
cat("Relative error:", round(abs(prob_pass_exact - prob_pass_normal_no_cc) / prob_pass_exact * 100, 2), "%\n")

# =============================================================================
# PART 2: CONTINUITY CORRECTION
# =============================================================================
# Binomial is discrete, normal is continuous
# Continuity correction: P(X ≥ k) ≈ P(X > k - 0.5) for continuous X

# P(X ≥ 6) ≈ P(X > 5.5) with continuity correction
prob_pass_normal_cc <- 1 - pnorm(pass_threshold - 0.5, mean = mu_X, sd = sigma_X)

cat("\nWith continuity correction:\n")
cat("Normal approx (with CC):", round(prob_pass_normal_cc, 6), "\n")
cat("Error:", round(abs(prob_pass_exact - prob_pass_normal_cc), 6), "\n")
cat("Relative error:", round(abs(prob_pass_exact - prob_pass_normal_cc) / prob_pass_exact * 100, 2), "%\n")

# =============================================================================
# PART 3: USING SAMPLE PROPORTIONS
# =============================================================================
# Instead of counting successes, look at proportion: p̂ = X/n
# p̂ ~ N(p, p(1-p)/n)

# Pass threshold as proportion
p_threshold <- pass_threshold / n_questions  # 0.6

# Parameters for proportion
mu_p <- p_correct
sigma_p <- sqrt(p_correct * (1 - p_correct) / n_questions)

cat("\n\nUsing sample proportions:\n")
cat("Pass threshold:", p_threshold, "(60% correct)\n")
cat("Mean proportion:", mu_p, "\n")
cat("SD of proportion:", round(sigma_p, 4), "\n")

# P(p̂ ≥ 0.6) without continuity correction
prob_pass_prop_no_cc <- 1 - pnorm(p_threshold, mean = mu_p, sd = sigma_p)

# P(p̂ ≥ 0.6) with continuity correction: use 0.55 instead of 0.6
# Because (6-0.5)/10 = 0.55
prob_pass_prop_cc <- 1 - pnorm((pass_threshold - 0.5) / n_questions, mean = mu_p, sd = sigma_p)

cat("\nP(proportion ≥ 0.6):\n")
cat("No CC:", round(prob_pass_prop_no_cc, 6), "\n")
cat("With CC:", round(prob_pass_prop_cc, 6), "\n")
cat("Exact:", round(prob_pass_exact, 6), "\n")

# =============================================================================
# PART 4: VISUALIZATION - BINOMIAL vs NORMAL
# =============================================================================

# Generate data for both distributions
x_discrete <- 0:n_questions
x_continuous <- seq(-1, n_questions + 1, length.out = 300)

# Binomial PMF
pmf_binomial <- dbinom(x_discrete, size = n_questions, prob = p_correct)

# Normal PDF (no continuity correction)
pdf_normal <- dnorm(x_continuous, mean = mu_X, sd = sigma_X)

# Plot comparison
plot(x_continuous,
     pdf_normal,
     type = "l",
     col = "red",
     lwd = 2,
     xlab = "Number of correct answers",
     ylab = "Probability / Density",
     main = "Binomial Distribution vs Normal Approximation",
     ylim = c(0, max(c(pmf_binomial, pdf_normal)) * 1.1))

# Add binomial bars
for (i in 1:length(x_discrete)) {
  segments(x_discrete[i], 0, x_discrete[i], pmf_binomial[i],
           col = "blue", lwd = 5)
}

# Add points at top of bars
points(x_discrete, pmf_binomial,
       pch = 19, col = "blue", cex = 1.2)

# Add pass threshold line
abline(v = pass_threshold - 0.5,
       col = "darkgreen",
       lwd = 2,
       lty = 3)

legend("topright",
       legend = c("Binomial (exact)", "Normal approximation", "Pass threshold (with CC)"),
       col = c("blue", "red", "darkgreen"),
       lwd = c(5, 2, 2),
       lty = c(1, 1, 3))

grid()

# =============================================================================
# PART 5: SIMULATION VERIFICATION
# =============================================================================

n_simulations <- 10000
set.seed(123)

# Simulate exam scores
exam_scores <- rbinom(n_simulations, size = n_questions, prob = p_correct)

# Empirical pass rate
empirical_pass_rate <- sum(exam_scores >= pass_threshold) / n_simulations

# Histogram with overlays
hist(exam_scores,
     breaks = -0.5:(n_questions + 0.5),
     freq = FALSE,
     col = "lightblue",
     border = "white",
     xlab = "Number of correct answers",
     ylab = "Density",
     main = paste("Simulated Scores vs Theoretical Distributions\n(", n_simulations, "simulations)"))

# Overlay binomial
points(x_discrete, pmf_binomial,
       pch = 19, col = "blue", cex = 1.5)
lines(x_discrete, pmf_binomial,
      col = "blue", lwd = 2)

# Overlay normal
curve(dnorm(x, mean = mu_X, sd = sigma_X),
      from = -1, to = n_questions + 1,
      add = TRUE,
      col = "red",
      lwd = 2,
      lty = 2)

legend("topright",
       legend = c("Simulated", "Binomial", "Normal"),
       fill = c("lightblue", NA, NA),
       border = c("black", NA, NA),
       col = c(NA, "blue", "red"),
       lwd = c(NA, 2, 2),
       lty = c(NA, 1, 2),
       pch = c(NA, 19, NA))

# =============================================================================
# PART 6: COMPARISON FOR LARGER n
# =============================================================================
# Show that normal approximation improves with larger n

par(mfrow = c(2, 2))

n_values <- c(10, 20, 50, 100)

for (n in n_values) {
  # Parameters
  mu_n <- n * p_correct
  sigma_n <- sqrt(n * p_correct * (1 - p_correct))

  # Binomial
  x_n <- 0:n
  pmf_n <- dbinom(x_n, size = n, prob = p_correct)

  # Plot
  plot(x_n, pmf_n,
       type = "h",
       lwd = 2,
       col = "blue",
       xlab = "Number correct",
       ylab = "Probability",
       main = paste("n =", n))

  # Overlay normal
  curve(dnorm(x, mean = mu_n, sd = sigma_n),
        from = 0, to = n,
        add = TRUE,
        col = "red",
        lwd = 2)
}

par(mfrow = c(1, 1))

# =============================================================================
# KEY INSIGHTS
# =============================================================================
cat("\n\nKey Insights:\n")
cat("1. Normal approximation: X ~ Binomial(n,p) ≈ N(np, np(1-p))\n")
cat("2. Works well when np ≥ 5 AND n(1-p) ≥ 5\n")
cat("3. Continuity correction improves accuracy for small n\n")
cat("4. Without CC: P(X ≥ k) ≈ P(Z ≥ (k-μ)/σ)\n")
cat("5. With CC: P(X ≥ k) ≈ P(Z ≥ (k-0.5-μ)/σ)\n")
cat("6. For this problem (n=10, p=0.25): approximation is poor!\n")
cat("7. Larger n → better approximation\n")
