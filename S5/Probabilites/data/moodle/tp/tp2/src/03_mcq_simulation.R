# TP2 - Part 3: MCQ Simulation - Binomial Distribution
# Model random guessing on a multiple-choice exam

# =============================================================================
# PROBLEM SETUP
# =============================================================================
# - 10 questions
# - 4 choices per question, only 1 correct
# - Student guesses randomly
# - Pass requires ≥ 6 correct answers
#
# Probability model:
# - Single question: Bernoulli(p = 1/4 = 0.25)
# - Total correct: X ~ Binomial(n = 10, p = 0.25)
# - We want: P(X ≥ 6)

# =============================================================================
# PART 1: EXACT PROBABILITY CALCULATION
# =============================================================================

n_questions <- 10
p_correct <- 0.25
pass_threshold <- 6

# Method 1: Using binomial CDF
# P(X ≥ 6) = 1 - P(X ≤ 5)
prob_pass_exact <- 1 - pbinom(pass_threshold - 1, size = n_questions, prob = p_correct)

cat("Exact probability calculation:\n")
cat("P(pass) = P(X ≥ 6) =", round(prob_pass_exact, 5), "\n")
cat("P(fail) = P(X < 6) =", round(1 - prob_pass_exact, 5), "\n\n")

# Method 2: Summing individual probabilities
# P(X ≥ 6) = P(X=6) + P(X=7) + P(X=8) + P(X=9) + P(X=10)
prob_pass_sum <- sum(dbinom(6:10, size = n_questions, prob = p_correct))
cat("Verification by summing P(X=k) for k=6..10:", round(prob_pass_sum, 5), "\n\n")

# Show probability distribution
x_values <- 0:n_questions
prob_values <- dbinom(x_values, size = n_questions, prob = p_correct)

cat("Complete probability distribution:\n")
for (i in 1:length(x_values)) {
  cat(sprintf("P(X = %2d) = %.5f %s\n",
              x_values[i],
              prob_values[i],
              ifelse(x_values[i] >= pass_threshold, "<-- PASS", "")))
}

# =============================================================================
# PART 2: SIMULATE MANY EXAMS
# =============================================================================

n_simulations <- 5000
set.seed(42)

# Simulate: each simulation is one complete exam (10 questions)
# rbinom(n, size, prob) generates n experiments, each with 'size' trials
exam_scores <- rbinom(n_simulations, size = n_questions, prob = p_correct)

# Determine which exams passed
exam_passed <- (exam_scores >= pass_threshold)
n_passed <- sum(exam_passed)

# Empirical pass rate
empirical_pass_rate <- n_passed / n_simulations

cat("\n\nSimulation results (", n_simulations, "exams):\n", sep = "")
cat("Number passed:", n_passed, "\n")
cat("Empirical pass rate:", round(empirical_pass_rate, 5), "\n")
cat("Exact pass rate:", round(prob_pass_exact, 5), "\n")
cat("Difference:", round(abs(empirical_pass_rate - prob_pass_exact), 5), "\n")

# =============================================================================
# PART 3: LAW OF LARGE NUMBERS - PASS RATE CONVERGENCE
# =============================================================================

# Calculate cumulative pass rate
cumulative_passes <- cumsum(exam_passed)
cumulative_pass_rate <- cumulative_passes / (1:n_simulations)

# Plot convergence
plot(1:n_simulations,
     cumulative_pass_rate,
     type = "l",
     col = "blue",
     lwd = 2,
     xlab = "Number of simulated exams",
     ylab = "Pass rate",
     main = "Law of Large Numbers: Convergence to Theoretical Pass Rate",
     ylim = c(0, max(cumulative_pass_rate) * 1.1))

# Add theoretical probability line
abline(h = prob_pass_exact,
       col = "red",
       lwd = 2,
       lty = 2)

legend("topright",
       legend = c("Empirical pass rate", "Theoretical pass rate"),
       col = c("blue", "red"),
       lty = c(1, 2),
       lwd = 2)

grid()

# =============================================================================
# PART 4: DISTRIBUTION OF SCORES
# =============================================================================

# Compare empirical vs theoretical distribution
hist(exam_scores,
     breaks = -0.5:(n_questions + 0.5),  # Center bars on integers
     freq = FALSE,
     col = "lightblue",
     border = "white",
     xlab = "Number of correct answers",
     ylab = "Probability",
     main = paste("Score Distribution:", n_simulations, "Simulated Exams"))

# Overlay theoretical probabilities
points(x_values,
       prob_values,
       pch = 19,
       col = "red",
       cex = 1.5)

lines(x_values,
      prob_values,
      col = "red",
      lwd = 2)

# Add vertical line at pass threshold
abline(v = pass_threshold - 0.5,
       col = "darkgreen",
       lwd = 2,
       lty = 3)

legend("topright",
       legend = c("Empirical (simulated)", "Theoretical (binomial)", "Pass threshold"),
       col = c("lightblue", "red", "darkgreen"),
       lwd = c(10, 2, 2),
       lty = c(1, 1, 3),
       pch = c(NA, 19, NA))

# =============================================================================
# PART 5: EFFECT OF NUMBER OF QUESTIONS
# =============================================================================

# How does pass rate change with different number of questions?
# Keep p=0.25 and pass threshold at 60% (6/10, 12/20, etc.)

question_counts <- c(10, 20, 30, 40, 50)
pass_rates <- numeric(length(question_counts))

for (i in 1:length(question_counts)) {
  n_q <- question_counts[i]
  threshold <- ceiling(0.6 * n_q)  # 60% to pass
  pass_rates[i] <- 1 - pbinom(threshold - 1, size = n_q, prob = p_correct)
}

plot(question_counts,
     pass_rates,
     type = "b",
     pch = 19,
     col = "purple",
     lwd = 2,
     xlab = "Number of questions",
     ylab = "P(pass with random guessing)",
     main = "Pass Probability vs Exam Length\n(60% threshold, 25% correct rate)")

grid()

cat("\n\nPass probability by exam length:\n")
for (i in 1:length(question_counts)) {
  cat(sprintf("%2d questions (≥%2d correct): %.6f\n",
              question_counts[i],
              ceiling(0.6 * question_counts[i]),
              pass_rates[i]))
}

# =============================================================================
# PART 6: COMPARISON TABLE
# =============================================================================

cat("\n\nEmpirical vs Theoretical Frequencies:\n")
cat(sprintf("%-8s | %-12s | %-12s | %-10s\n", "Score", "Empirical", "Theoretical", "Difference"))
cat(strrep("-", 50), "\n")

for (score in 0:n_questions) {
  empirical_freq <- sum(exam_scores == score) / n_simulations
  theoretical_freq <- dbinom(score, size = n_questions, prob = p_correct)
  diff <- abs(empirical_freq - theoretical_freq)

  cat(sprintf("%8d | %12.5f | %12.5f | %10.5f\n",
              score, empirical_freq, theoretical_freq, diff))
}

# =============================================================================
# KEY INSIGHTS
# =============================================================================
cat("\n\nKey Insights:\n")
cat("1. Random guessing on MCQ: X ~ Binomial(n, 1/4)\n")
cat("2. Passing by random guessing is very unlikely:", round(prob_pass_exact * 100, 2), "%\n")
cat("3. Expected score:", n_questions * p_correct, "correct answers\n")
cat("4. Law of Large Numbers: empirical → theoretical as simulations increase\n")
cat("5. More questions → even harder to pass by guessing (if threshold is constant %)\n")
