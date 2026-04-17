# TP5: Random Vectors - Consolidated Solutions
# Topics: Joint distributions, marginal/conditional, multinomial

# =============================================================================
# EXERCISE 1: DISCRETE JOINT DISTRIBUTION
# =============================================================================

# Joint probability table P(X=xi, Y=yj)
prob_matrix <- matrix(c(0.02, 0.06, 0.02, 0.10,
                        0.04, 0.15, 0.20, 0.10,
                        0.01, 0.15, 0.14, 0.01),
                      nrow=3, ncol=4, byrow=TRUE)

rownames(prob_matrix) <- c("X=0", "X=5", "X=10")
colnames(prob_matrix) <- c("Y=0", "Y=5", "Y=10", "Y=15")

cat("Joint probability distribution:\n")
print(prob_matrix)
cat("\nSum of all probabilities:", sum(prob_matrix), "\n\n")

# Marginal distribution of X: P(X=xi)
px <- apply(prob_matrix, 1, sum)
cat("Marginal distribution P(X):\n")
print(px)

# Marginal distribution of Y: P(Y=yj)
py <- apply(prob_matrix, 2, sum)
cat("\nMarginal distribution P(Y):\n")
print(py)

# Conditional distribution P(X | Y=5)
# P(X=xi | Y=5) = P(X=xi, Y=5) / P(Y=5)
y5_col <- 2  # Second column is Y=5
px_given_y5 <- prob_matrix[, y5_col] / sum(prob_matrix[, y5_col])

cat("\nConditional distribution P(X | Y=5):\n")
print(px_given_y5)

# Using rje library (if available)
# library(rje)
# margin.table(as.table(prob_matrix), 1)
# margin.table(as.table(prob_matrix), 2)

# =============================================================================
# EXERCISE 2: MULTINOMIAL DISTRIBUTION (ROULETTE)
# =============================================================================

# Roulette: 18 red, 18 black, 2 green (out of 38 total)
# 12 spins
n_spins <- 12
probs <- c(18/38, 18/38, 2/38)  # Red, Black, Green

cat("\n\nRoulette multinomial model:\n")
cat("Number of spins:", n_spins, "\n")
cat("Probabilities: Red =", round(probs[1], 3), 
    ", Black =", round(probs[2], 3),
    ", Green =", round(probs[3], 3), "\n\n")

# Generate all possible outcomes (x1, x2, x3) where x1+x2+x3=12
outcomes <- expand.grid(red=0:n_spins, black=0:n_spins)
outcomes$green <- n_spins - outcomes$red - outcomes$black

# Filter valid outcomes (green >= 0)
outcomes <- outcomes[outcomes$green >= 0, ]

# Calculate probability for each outcome using multinomial
outcomes$prob <- apply(outcomes[, c("red", "black", "green")], 1, 
                       function(x) dmultinom(x, prob=probs))

cat("Number of possible outcomes:", nrow(outcomes), "\n")
cat("Sum of probabilities:", round(sum(outcomes$prob), 6), "\n\n")

# Most likely outcome
max_idx <- which.max(outcomes$prob)
cat("Most likely outcome:\n")
cat("Red:", outcomes$red[max_idx], 
    ", Black:", outcomes$black[max_idx],
    ", Green:", outcomes$green[max_idx], "\n")
cat("Probability:", round(outcomes$prob[max_idx], 4), "\n\n")

# Expected values
cat("Expected values:\n")
cat("E(Red) =", n_spins * probs[1], "\n")
cat("E(Black) =", n_spins * probs[2], "\n")
cat("E(Green) =", n_spins * probs[3], "\n\n")

# 3D visualization (if scatterplot3d available)
# library(scatterplot3d)
# scatterplot3d(outcomes$red, outcomes$black, outcomes$green,
#               color=grey(0.9 - outcomes$prob*5),
#               pch=16,
#               main="Multinomial Distribution (Roulette)")

# =============================================================================
# SIMULATION: VERIFY EMPIRICAL vs THEORETICAL
# =============================================================================

# Simulate 10000 sets of 12 spins
n_simulations <- 10000
set.seed(42)

simulated <- rmultinom(n_simulations, size=n_spins, prob=probs)
# Result is 3×n_simulations matrix: rows are red, black, green

# Average outcomes
avg_red <- mean(simulated[1, ])
avg_black <- mean(simulated[2, ])
avg_green <- mean(simulated[3, ])

cat("Simulation (n=", n_simulations, "):\n", sep="")
cat("Average red:", round(avg_red, 2), 
    "(expected:", round(n_spins*probs[1], 2), ")\n")
cat("Average black:", round(avg_black, 2),
    "(expected:", round(n_spins*probs[2], 2), ")\n")
cat("Average green:", round(avg_green, 2),
    "(expected:", round(n_spins*probs[3], 2), ")\n\n")

# =============================================================================
# KEY INSIGHTS
# =============================================================================
cat("Key Insights:\n")
cat("1. Joint distribution: P(X, Y) for all combinations\n")
cat("2. Marginal: sum over other variable\n")
cat("3. Conditional: P(X|Y) = P(X,Y) / P(Y)\n")
cat("4. Multinomial: extension of binomial to k categories\n")
cat("5. E(Xi) = n × pi for multinomial\n")
