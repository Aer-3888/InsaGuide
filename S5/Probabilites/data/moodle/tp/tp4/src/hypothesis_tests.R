# TP4: Hypothesis Testing - Consolidated Solutions
# Topics: t-tests, power analysis, conformity, homogeneity

# =============================================================================
# EXERCISE 1: OCTOPUS WEIGHTS - ONE-SAMPLE T-TEST
# =============================================================================

# 15 octopus weights (grams)
poids_poulpe <- c(1150, 1500, 1700, 1800, 1800, 1850, 2200, 2700, 
                   2900, 3000, 3100, 3500, 3900, 4000, 5400)

n <- length(poids_poulpe)
alpha <- 0.10  # 90% confidence

# Estimate parameters
mean_empirical <- mean(poids_poulpe)
sd_empirical <- sd(poids_poulpe)

cat("Octopus weight statistics:\n")
cat("Sample size:", n, "\n")
cat("Mean:", round(mean_empirical, 2), "g\n")
cat("SD:", round(sd_empirical, 2), "g\n\n")

# Confidence interval (σ unknown → use t-distribution)
t_crit <- qt(1 - alpha/2, df = n-1)
se <- sd_empirical / sqrt(n)

CI_lower <- mean_empirical - t_crit * se
CI_upper <- mean_empirical + t_crit * se

cat("90% Confidence Interval for mean:\n")
cat("[", round(CI_lower, 2), ",", round(CI_upper, 2), "]\n\n")

# Conformity test: Is μ = 3000g?
mu_0 <- 3000

# Manual calculation
test_statistic <- (mean_empirical - mu_0) / (sd_empirical / sqrt(n))
critical_lower <- -qt(1 - alpha/2, df = n-1)
critical_upper <- qt(1 - alpha/2, df = n-1)

cat("Conformity test: H0: μ = 3000g\n")
cat("Test statistic:", round(test_statistic, 3), "\n")
cat("Critical region: [-∞,", round(critical_lower, 3), "] ∪ [", 
    round(critical_upper, 3), ", ∞]\n")

if (abs(test_statistic) > critical_upper) {
  cat("Decision: REJECT H0\n")
} else {
  cat("Decision: FAIL TO REJECT H0\n")
}

# Using t.test()
test_result <- t.test(poids_poulpe, mu = mu_0, conf.level = 1 - alpha)
cat("\nUsing t.test():\n")
print(test_result)

# =============================================================================
# EXERCISE 2: TWO-SAMPLE T-TEST (HOMOGENEITY)
# =============================================================================

# Group A: n=12, mean=1.5, sd=0.95
# Group B: n=8, mean=2.35, sd=1.35
# Assume equal variances (σA = σB)

na <- 12
nb <- 8
mean_a <- 1.5
mean_b <- 2.35
sd_a <- 0.95
sd_b <- 1.35
alpha <- 0.05

# Pooled variance estimate
sp2 <- ((na-1)*sd_a^2 + (nb-1)*sd_b^2) / (na + nb - 2)
sp <- sqrt(sp2)

# Test statistic
diff_means <- mean_a - mean_b
se_diff <- sp * sqrt(1/na + 1/nb)
t_stat <- diff_means / se_diff

# Critical value
df <- na + nb - 2
t_critical <- qt(1 - alpha/2, df = df)

cat("\n\nTwo-sample t-test (equal variances):\n")
cat("Group A: n=", na, ", mean=", mean_a, ", sd=", sd_a, "\n", sep="")
cat("Group B: n=", nb, ", mean=", mean_b, ", sd=", sd_b, "\n", sep="")
cat("\nPooled SD:", round(sp, 3), "\n")
cat("Test statistic:", round(t_stat, 3), "\n")
cat("Critical value:", round(t_critical, 3), "\n")

if (abs(t_stat) > t_critical) {
  cat("Decision: REJECT H0 (means are significantly different)\n")
} else {
  cat("Decision: FAIL TO REJECT H0 (no significant difference)\n")
}

# Repeat with larger samples (na=120, nb=80)
na_large <- 120
nb_large <- 80

sp2_large <- ((na_large-1)*sd_a^2 + (nb_large-1)*sd_b^2) / (na_large + nb_large - 2)
sp_large <- sqrt(sp2_large)
se_diff_large <- sp_large * sqrt(1/na_large + 1/nb_large)
t_stat_large <- diff_means / se_diff_large

cat("\n\nWith larger samples (na=120, nb=80):\n")
cat("Test statistic:", round(t_stat_large, 3), "\n")
cat("Decision:", ifelse(abs(t_stat_large) > qt(0.975, na_large+nb_large-2), 
                        "REJECT H0", "FAIL TO REJECT H0"), "\n")

# =============================================================================
# EXERCISE 3: POWER ANALYSIS
# =============================================================================

# Milk bottle filling: σ=1ml, target μ=1000ml, n=40 bottles
# Detect if mean shifts by 0.2ml

sigma <- 1
mu_0 <- 1000
n_bottles <- 40
alpha <- 0.05
effect <- 0.2  # Shift to detect

# Under H0: μ = 1000, under H1: μ = 1000.2
mu_1 <- mu_0 + effect

# Test statistic under H0: Z = (X̄ - μ0)/(σ/√n) ~ N(0,1)
# Critical value
z_crit <- qnorm(1 - alpha/2)

# Under H1, test statistic ~ N(effect/(σ/√n), 1)
# Power = P(reject H0 | H1 true)

# Standardized effect
z_effect <- effect / (sigma / sqrt(n_bottles))

# Power = P(|Z| > z_crit | Z ~ N(z_effect, 1))
power <- 1 - pnorm(z_crit, mean = z_effect, sd = 1)

cat("\n\nPower analysis:\n")
cat("Effect size:", effect, "ml\n")
cat("Standardized effect:", round(z_effect, 3), "\n")
cat("Power (n=40):", round(power, 4), "\n")
cat("Interpretation:", round(power*100, 1), "% chance of detecting 0.2ml shift\n")

# Find n needed for 90% power
target_power <- 0.90
n_needed <- 40

while (TRUE) {
  z_eff_n <- effect / (sigma / sqrt(n_needed))
  power_n <- 1 - pnorm(z_crit, mean = z_eff_n, sd = 1)
  if (power_n >= target_power) break
  n_needed <- n_needed + 1
}

cat("\nSample size for 90% power:", n_needed, "bottles\n")

# =============================================================================
# KEY INSIGHTS
# =============================================================================
cat("\n\nKey Insights:\n")
cat("1. One-sample t-test: Compare mean to hypothesized value\n")
cat("2. Two-sample t-test: Compare means of two groups\n")
cat("3. Larger n → more power to detect differences\n")
cat("4. Power = P(reject H0 | H1 true)\n")
cat("5. p-value < α → reject H0\n")
cat("6. Effect size matters: small effects need large n\n")
