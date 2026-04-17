# TP1 - Exercise 4.2.5: Dice Rolling Frequency
# Demonstration of the Law of Large Numbers

# =============================================================================
# PROBLEM STATEMENT
# =============================================================================
# Roll a fair die multiple times and observe how the frequency of a target
# outcome (e.g., rolling a 5) converges to the theoretical probability (1/6)
# as the number of rolls increases.

# =============================================================================
# FREQUENCY CALCULATION FUNCTION
# =============================================================================

Freq <- function(n, cible) {
  # n: number of dice rolls
  # cible: target value (1-6)

  # Create a fair 6-sided die
  de <- 1:6

  # Roll the die n times (with replacement)
  tirages <- sample(de, n, replace = TRUE)

  # Calculate frequency of target value
  frequence <- sum(tirages == cible) / n

  return(frequence)
}

# =============================================================================
# EXPERIMENT WITH DIFFERENT SAMPLE SIZES
# =============================================================================

# Test with different numbers of rolls
experience <- c(10, 100, 1000, 10000)
cible <- 5  # Looking for rolling a 5

set.seed(42)

cat("Observing frequency of rolling a", cible, ":\n")
cat("Theoretical probability: 1/6 =", round(1/6, 4), "\n\n")

for (n in experience) {
  freq <- Freq(n, cible)
  error <- abs(freq - 1/6)
  cat(sprintf("n = %5d rolls: frequency = %.4f (error: %.4f)\n", n, freq, error))
}

# =============================================================================
# VISUALIZE CONVERGENCE TO THEORETICAL PROBABILITY
# =============================================================================

# Generate a sequence of cumulative frequencies
max_rolls <- 1000
cible <- 1  # Target any value (all have same probability)

set.seed(123)
de <- 1:6
tirages <- sample(de, max_rolls, replace = TRUE)

# Calculate cumulative frequency
is_cible <- (tirages == cible)
cumulative_successes <- cumsum(is_cible)
cumulative_frequency <- cumulative_successes / (1:max_rolls)

# Plot convergence
plot(1:max_rolls,
     cumulative_frequency,
     type = "l",
     col = "blue",
     lwd = 2,
     xlab = "Number of rolls (n)",
     ylab = "Frequency of target outcome",
     main = paste("Law of Large Numbers: Frequency of rolling", cible),
     ylim = c(0, 0.5))

# Add theoretical probability line
abline(h = 1/6,
       col = "red",
       lwd = 2,
       lty = 2)

# Add confidence bands (approximate)
# Standard error: sqrt(p(1-p)/n)
p <- 1/6
n_seq <- 1:max_rolls
se <- sqrt(p * (1 - p) / n_seq)

lines(n_seq, rep(p, max_rolls) + 1.96 * se,
      col = "gray",
      lty = 3)
lines(n_seq, rep(p, max_rolls) - 1.96 * se,
      col = "gray",
      lty = 3)

# Add legend
legend("topright",
       legend = c("Empirical frequency",
                  "Theoretical probability (1/6)",
                  "95% confidence band"),
       col = c("blue", "red", "gray"),
       lty = c(1, 2, 3),
       lwd = c(2, 2, 1))

grid()

# =============================================================================
# MULTIPLE REALIZATIONS
# =============================================================================
# Show that different experiments converge to the same value

n_experiments <- 10
max_rolls <- 500
cible <- 3

set.seed(456)

plot(NULL,
     xlim = c(1, max_rolls),
     ylim = c(0, 0.5),
     xlab = "Number of rolls (n)",
     ylab = "Cumulative frequency",
     main = paste(n_experiments, "Independent Experiments: Convergence to 1/6"))

# Run multiple experiments
for (exp in 1:n_experiments) {
  tirages <- sample(1:6, max_rolls, replace = TRUE)
  is_cible <- (tirages == cible)
  cumulative_freq <- cumsum(is_cible) / (1:max_rolls)

  lines(1:max_rolls,
        cumulative_freq,
        col = rainbow(n_experiments)[exp],
        lwd = 1.5,
        type = "l")
}

# Add theoretical line
abline(h = 1/6,
       col = "black",
       lwd = 3,
       lty = 2)

legend("topright",
       legend = c("Individual experiments", "Theoretical (1/6)"),
       col = c(rainbow(n_experiments)[1], "black"),
       lwd = c(1.5, 3),
       lty = c(1, 2))

grid()

# =============================================================================
# DISTRIBUTION OF ALL OUTCOMES
# =============================================================================
# Show that all faces converge to uniform distribution

max_rolls <- 10000
set.seed(789)
tirages <- sample(1:6, max_rolls, replace = TRUE)

# Count frequency of each face
face_counts <- table(tirages)
face_frequencies <- face_counts / max_rolls

# Barplot
barplot(face_frequencies,
        main = paste("Frequency Distribution of Dice Rolls\n(n =", max_rolls, ")"),
        xlab = "Die face",
        ylab = "Frequency",
        col = rainbow(6),
        ylim = c(0, 0.25),
        border = "white")

# Add theoretical probability line
abline(h = 1/6,
       col = "black",
       lwd = 2,
       lty = 2)

legend("topright",
       legend = "Theoretical (1/6)",
       col = "black",
       lty = 2,
       lwd = 2)

# Print results
cat("\n\nFrequency distribution after", max_rolls, "rolls:\n")
for (face in 1:6) {
  freq <- face_frequencies[as.character(face)]
  error <- abs(freq - 1/6)
  cat(sprintf("Face %d: %.4f (error: %.4f)\n", face, freq, error))
}

cat("\nMax deviation from 1/6:", round(max(abs(face_frequencies - 1/6)), 4), "\n")

# =============================================================================
# KEY INSIGHTS
# =============================================================================
# 1. Law of Large Numbers: empirical frequency → theoretical probability
# 2. Convergence is NOT monotonic (zigzag pattern)
# 3. Variability decreases as n increases (confidence bands narrow)
# 4. Different experiments converge to same theoretical value
# 5. Standard error decreases as sqrt(1/n)
