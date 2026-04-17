# TP1 - Exercise 4.2.4: Urn Problem
# Drawing balls from an urn without replacement

# =============================================================================
# PROBLEM STATEMENT
# =============================================================================
# An urn contains p red balls and q black balls.
# Draw k balls without replacement.
# Model this process and visualize the results.

# =============================================================================
# SOLUTION: URN FUNCTION
# =============================================================================

Urne <- function(k, p, q) {
  # Create urn with p red balls and q black balls
  # rep(value, times) repeats a value multiple times
  urne <- c(rep("Rouge", p), rep("Noire", q))

  # Draw k balls without replacement
  # sample(x, size, replace=FALSE) performs random sampling
  tirages <- sample(urne, k, replace = FALSE)

  return(tirages)
}

# =============================================================================
# EXAMPLE: DRAW 6 BALLS FROM URN WITH 8 RED AND 5 BLACK
# =============================================================================

set.seed(42)  # For reproducibility

# Single draw
k <- 6  # Number of balls to draw
p <- 8  # Number of red balls
q <- 5  # Number of black balls

single_draw <- Urne(k, p, q)
print("Single draw result:")
print(single_draw)

# Count occurrences
counts <- table(single_draw)
print("\nCounts:")
print(counts)

# =============================================================================
# VISUALIZATION
# =============================================================================

# Perform multiple draws to see distribution
n_experiments <- 1000
red_counts <- numeric(n_experiments)

set.seed(123)
for (i in 1:n_experiments) {
  draw <- Urne(k, p, q)
  red_counts[i] <- sum(draw == "Rouge")
}

# Create histogram of red ball counts
hist(red_counts,
     breaks = 0:k + 0.5,  # Center bars on integers
     col = "lightcoral",
     border = "white",
     main = paste("Distribution of Red Balls Drawn\n(", n_experiments, "experiments)"),
     xlab = "Number of red balls",
     ylab = "Frequency",
     freq = TRUE)

# Add empirical mean line
abline(v = mean(red_counts),
       col = "darkred",
       lwd = 2,
       lty = 2)

# Add theoretical mean (hypergeometric distribution mean)
theoretical_mean <- k * p / (p + q)
abline(v = theoretical_mean,
       col = "blue",
       lwd = 2,
       lty = 2)

legend("topright",
       legend = c("Empirical mean", "Theoretical mean"),
       col = c("darkred", "blue"),
       lty = 2,
       lwd = 2)

cat("\nStatistics for", n_experiments, "draws:\n")
cat("Empirical mean:", round(mean(red_counts), 3), "\n")
cat("Theoretical mean:", round(theoretical_mean, 3), "\n")
cat("Empirical SD:", round(sd(red_counts), 3), "\n")

# =============================================================================
# COMPARISON WITH DIFFERENT URN COMPOSITIONS
# =============================================================================

# Barplot for a single draw
set.seed(456)
single_experiment <- Urne(k, p, q)
draw_counts <- table(single_experiment)

barplot(draw_counts,
        main = paste("Single Draw: k =", k, "balls from", p, "red +", q, "black"),
        xlab = "Color",
        ylab = "Count",
        col = c("black", "red"),
        names.arg = c("Black", "Red"),
        border = "white")

# =============================================================================
# THEORETICAL BACKGROUND: HYPERGEOMETRIC DISTRIBUTION
# =============================================================================
# When drawing without replacement, the number of successes follows
# a hypergeometric distribution: H(N, K, n)
# where:
#   N = total balls = p + q
#   K = success states (red balls) = p
#   n = draws = k

# Calculate theoretical probabilities using hypergeometric distribution
N <- p + q
K <- p
n <- k

# Possible outcomes: 0 to min(k, p) red balls
max_red <- min(k, p)
possible_values <- 0:max_red

theoretical_probs <- dhyper(possible_values, m = K, n = N - K, k = n)

# Compare empirical vs theoretical distribution
empirical_probs <- table(red_counts) / n_experiments

# Plot comparison
barplot(rbind(theoretical_probs, empirical_probs[as.character(possible_values)]),
        beside = TRUE,
        col = c("steelblue", "lightcoral"),
        names.arg = possible_values,
        main = "Theoretical vs Empirical Distribution",
        xlab = "Number of red balls drawn",
        ylab = "Probability",
        legend.text = c("Theoretical (Hypergeometric)", "Empirical"),
        args.legend = list(x = "topright"))

# =============================================================================
# KEY INSIGHTS
# =============================================================================
# 1. Drawing without replacement → Hypergeometric distribution
# 2. Expected red balls = k * p / (p + q)
# 3. With large populations, hypergeometric → binomial approximation
# 4. sample() function is key for random sampling in R
