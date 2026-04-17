# TP3: Confidence Intervals - Consolidated Solutions
# Topics: Quantiles, Mean CI (σ known/unknown), Variance CI, Chi-squared

# =============================================================================
# EXERCISE 1: QUANTILES AND OVERBOOKING
# =============================================================================

# Airline overbooking problem
# 150 seats, passengers show up with probability 0.75
# X ~ Binomial(n, p) where n = tickets sold

n <- 150
p <- 0.75
capacity <- 150

# Q1: With 150 tickets, 95% confidence max passengers?
max_passengers_95 <- qbinom(0.95, size=n, prob=p)
cat("Q1: 95% confident ≤", max_passengers_95, "passengers show up\n")

# Q2: How many tickets to sell to be 95% sure everyone fits?
n_tickets <- 150
while(qbinom(0.95, size=n_tickets, prob=p) <= capacity) {
  n_tickets <- n_tickets + 1
}
n_tickets <- n_tickets - 1  # Back up one
cat("Q2: Can sell", n_tickets, "tickets with 95% confidence\n")

# Alternative using pbinom
n_search <- 150
while(pbinom(capacity, size=n_search, prob=p) > 0.95) {
  n_search <- n_search + 1
}
cat("Q2 (verification):", n_search-1, "tickets\n\n")

# =============================================================================
# EXERCISE 2: CONFIDENCE INTERVALS FOR MEAN (σ KNOWN)
# =============================================================================

# Load execution time data
data <- read.csv2("vitesse.csv")
data$vecNum <- as.factor(data$vecNum)
data$vecVitesses <- as.numeric(data$vecVitesses)

# Known parameters
mu_true <- 120      # True mean
sigma_true <- 10    # True SD (σ² = 100)
n_per_week <- 6     # Measurements per week
alpha <- 0.05       # For 95% CI

# Calculate weekly means
weekly_means <- tapply(data$vecVitesses, data$vecNum, mean)

# Calculate confidence intervals (σ known)
z_crit <- qnorm(1 - alpha/2)  # ≈ 1.96
se <- sigma_true / sqrt(n_per_week)

IC_lower <- weekly_means - z_crit * se
IC_upper <- weekly_means + z_crit * se

# Check coverage
contains_true_mean <- (mu_true >= IC_lower) & (mu_true <= IC_upper)
coverage_rate <- mean(contains_true_mean)

cat("Mean Confidence Intervals (σ known):\n")
cat("Critical value z:", round(z_crit, 3), "\n")
cat("Standard error:", round(se, 3), "\n")
cat("Coverage rate:", round(coverage_rate * 100, 2), "%\n")
cat("Expected: 95%\n\n")

# Visualize first 40 intervals
n_plot <- 40
plot(c(IC_lower[1:n_plot], IC_upper[1:n_plot]),
     c(1:n_plot, 1:n_plot),
     pch=4, col="gray",
     xlab="Runtime (s)", ylab="Week number",
     main="Confidence Intervals for Mean (σ known)")

# Draw intervals
for(i in 1:n_plot) {
  line_color <- ifelse(contains_true_mean[i], "blue", "red")
  segments(IC_lower[i], i, IC_upper[i], i, col=line_color, lwd=2)
}

# Add true mean line
abline(v=mu_true, col="darkgreen", lwd=2)

legend("topright",
       legend=c("Contains μ", "Misses μ", "True μ"),
       col=c("blue", "red", "darkgreen"),
       lwd=2)

# =============================================================================
# EXERCISE 3: CHI-SQUARED AND VARIANCE CONFIDENCE INTERVALS
# =============================================================================

# Calculate weekly variances
weekly_vars <- tapply(data$vecVitesses, data$vecNum, var)

# Chi-squared confidence intervals for variance
chi2_upper <- qchisq(1 - alpha/2, df=n_per_week-1)
chi2_lower <- qchisq(alpha/2, df=n_per_week-1)

# CI for variance: [(n-1)S²/χ²_upper, (n-1)S²/χ²_lower]
# Note: inverted bounds!
IC_var_lower <- (n_per_week - 1) * weekly_vars / chi2_upper
IC_var_upper <- (n_per_week - 1) * weekly_vars / chi2_lower

# Check coverage for variance
var_true <- sigma_true^2
contains_true_var <- (var_true >= IC_var_lower) & (var_true <= IC_var_upper)
coverage_var <- mean(contains_true_var)

cat("Variance Confidence Intervals:\n")
cat("Chi-squared critical values:", round(chi2_lower, 2), "and", round(chi2_upper, 2), "\n")
cat("Coverage rate:", round(coverage_var * 100, 2), "%\n\n")

# Visualize variance intervals (as SD intervals)
IC_sd_lower <- sqrt(IC_var_lower)
IC_sd_upper <- sqrt(IC_var_upper)

plot(c(IC_sd_lower[1:n_plot], IC_sd_upper[1:n_plot]),
     c(1:n_plot, 1:n_plot),
     pch=4, col="gray",
     xlab="Standard Deviation", ylab="Week number",
     main="Confidence Intervals for Standard Deviation")

for(i in 1:n_plot) {
  line_color <- ifelse(contains_true_var[i], "purple", "orange")
  segments(IC_sd_lower[i], i, IC_sd_upper[i], i, col=line_color, lwd=2)
}

abline(v=sigma_true, col="darkgreen", lwd=2)

legend("topright",
       legend=c("Contains σ", "Misses σ", "True σ"),
       col=c("purple", "orange", "darkgreen"),
       lwd=2)

# =============================================================================
# EXERCISE 4: STUDENT'S T-DISTRIBUTION (σ UNKNOWN)
# =============================================================================

# When σ is unknown, use t-distribution instead of normal
# CI: X̄ ± t_(n-1, α/2) × (S'/√n)

t_crit <- qt(1 - alpha/2, df=n_per_week-1)
weekly_sds <- tapply(data$vecVitesses, data$vecNum, sd)

IC_t_lower <- weekly_means - t_crit * weekly_sds / sqrt(n_per_week)
IC_t_upper <- weekly_means + t_crit * weekly_sds / sqrt(n_per_week)

# Compare with z-based intervals
cat("Student's t vs Normal:\n")
cat("z critical value:", round(z_crit, 3), "\n")
cat("t critical value:", round(t_crit, 3), "\n")
cat("Difference:", round(t_crit - z_crit, 3), "\n")
cat("t intervals are", round((t_crit/z_crit - 1)*100, 1), "% wider\n\n")

# =============================================================================
# COMPARISON: NORMAL VS T-DISTRIBUTION
# =============================================================================

# Visualize difference
curve(dnorm(x), from=-4, to=4,
      col="blue", lwd=2,
      xlab="Value", ylab="Density",
      main="Standard Normal vs Student's t (df=5)")

curve(dt(x, df=5), from=-4, to=4,
      add=TRUE, col="red", lwd=2, lty=2)

legend("topright",
       legend=c("Normal N(0,1)", "Student t(5)"),
       col=c("blue", "red"),
       lwd=2, lty=c(1, 2))

# =============================================================================
# KEY INSIGHTS
# =============================================================================
cat("\nKey Insights:\n")
cat("1. CI for mean (σ known): X̄ ± z × σ/√n\n")
cat("2. CI for mean (σ unknown): X̄ ± t × S'/√n\n")
cat("3. CI for variance: [(n-1)S²/χ²_upper, (n-1)S²/χ²_lower]\n")
cat("4. t-distribution has heavier tails than normal\n")
cat("5. As df→∞, t→N(0,1)\n")
cat("6. Coverage rates should match confidence level\n")
