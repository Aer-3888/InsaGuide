# TP1 - Part 1: Basic R Operations
# Introduction to R syntax, types, and data structures

# =============================================================================
# 1. TYPE CONVERSION
# =============================================================================

# Convert string to integer
txt <- "33"
nbr <- as.integer(txt)

# Verify type
print(is.numeric(nbr))  # TRUE
print(is.integer(nbr))  # TRUE

# =============================================================================
# 2. STRING MANIPULATION
# =============================================================================

# Concatenate strings with paste()
mot <- "petite"
text1 <- paste("une", mot, "phrase")
print(text1)  # "une petite phrase"

# Count characters
text2 <- paste(text1, "compte", nchar(text1), "lettres")
print(text2)  # "une petite phrase compte 17 lettres"

# =============================================================================
# 3. VARIABLE MANAGEMENT
# =============================================================================

# Create variables
pipo <- "une var texte"
nombre <- 3

# Remove specific variable
rm(pipo)

# List all variables in environment
variables <- ls()
print("Les variables sont :")
print(variables)

# =============================================================================
# 4. SPECIAL VALUES: Inf and NA
# =============================================================================

# Division by zero creates Infinity
tmp <- 3/0
print(tmp)  # Inf

# NA represents missing/not assigned values
nsp <- NA

# Operations with special values
resultat <- paste(tmp, tmp+1, tmp+nsp)
print(resultat)  # "Inf Inf NA"

# =============================================================================
# 5. VECTORS
# =============================================================================

# Method 1: Explicit construction with c()
vecteur1 <- c(1, 3, 5, 7, 9)

# Method 2: Sequence with step (like a for loop)
vecteur2 <- seq(from=0, to=10, by=2)  # Equivalent to for(i=0; i<=10; i+=2)

# Method 3: Range operator (inclusive)
vecteur3 <- 0:10  # Creates [0, 1, 2, ..., 10]

# Method 4: Repeat pattern
vecteur4 <- rep(1:2, 5)  # Repeats [1, 2] five times: [1, 2, 1, 2, 1, 2, 1, 2, 1, 2]

# =============================================================================
# 6. DATA FRAMES
# =============================================================================

# Create component vectors
v1 <- c(175, 182, 165, 187, 158)  # Heights
v2 <- c(19, 18, 21, 22, 20)       # Ages
v3 <- c("Louis", "Paule", "Pierre", "Rémi", "Claude")  # Names

# Create data frame with named columns
tableau <- data.frame(prenom=v3, taille=v1, age=v2)

# Access data frame information
print(names(tableau))      # Column names: "prenom" "taille" "age"
print(tableau$prenom)      # Access specific column
print(tableau[1, ])        # Access first row
print(tableau[, "taille"]) # Access column by name

# Export to CSV
write.table(tableau, "sortie.csv", sep=";", row.names=FALSE, col.names=FALSE)

# View data frame structure
str(tableau)
summary(tableau)
