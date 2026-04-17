# =============================================================================
# TP1: Introduction au logiciel R
# Statistiques Descriptives - INSA Rennes 3ème année
# =============================================================================
# Sujets: Vecteurs, matrices, calcul matriciel, importation de données,
#         visualisation, manipulation de data frames
# =============================================================================

# =============================================================================
# EXERCICE 1: Création et manipulation de vecteurs
# =============================================================================

# Q1: Créer trois vecteurs différents avec rep()
vec1 <- rep(1:5, 3)                    # Répète la séquence 1-5 trois fois
vec2 <- rep(c(1:5), each=3)            # Répète chaque élément 3 fois
vec3 <- rep(c(1:4), c(2:5))            # Répète 1 deux fois, 2 trois fois, etc.

# Q2: Remplacer les NA par 0
q2 <- c(1, 2, 3, NA, 4, NA, 5)
q2[is.na(q2)] <- 0                     # Sélectionne les NA et les remplace par 0
print(q2)

# Q3: Transformer les valeurs négatives en valeurs positives
q3 <- runif(15, -1, 1)                 # Génère 15 nombres aléatoires entre -1 et 1
q3[q3 < 0] <- -q3[q3 < 0]             # Prend l'opposé des valeurs négatives
print(q3)

# Q4: Calculer la somme d'une expression vectorielle
# Somme de (i³ + 4i²) pour i de 10 à 100
q4 <- sum((10:100)^3 + 4*(10:100)^2)
print(q4)

# Q5: Manipulation avancée de vecteurs
x <- rnorm(100)                        # 100 valeurs aléatoires normales
y <- sample(0:99)                      # Permutation aléatoire de 0 à 99
z <- y[-1] - x[-100]                  # Différence entre vecteurs décalés
z2 <- sin(y[-100]) / cos(x[-1])       # Opérations trigonométriques


# =============================================================================
# EXERCICE 2: Création et manipulation de matrices
# =============================================================================

# Q1: Créer une matrice 4x4
M <- matrix(c(1,0,3,4, 5,5,0,4, 5,6,3,4, 0,1,3,2), 4, 4)
print(M)

# Q2: Extraire la diagonale
print(diag(M))

# Q3: Extraire les 2 premières lignes
print(M[1:2, ])

# Q4: Extraire les 2 premières colonnes
print(M[, 1:2])

# Q5: Extraire toutes les colonnes sauf la 3ème
print(M[, -3])

# Q6: Calculer déterminant et inverse
det_M <- det(M)
inv_M <- solve(M)
print(paste("Déterminant:", det_M))
print("Inverse:")
print(inv_M)
print("Vérification M * M^-1:")
print(M %*% inv_M)

# Q7: Calculer la moyenne de chaque colonne
print(apply(M, 2, mean))              # 2 = colonnes, 1 = lignes


# =============================================================================
# EXERCICE 3: Calcul matriciel - Régression multiple
# =============================================================================

# Utilisation du jeu de données mtcars
df <- mtcars

# Q1: Créer le vecteur y (variable à expliquer)
y <- mtcars$mpg

# Q2: Créer la matrice X (variables explicatives + intercept)
X <- cbind(1, mtcars$hp, mtcars$wt)   # 1 pour l'intercept

# Q3: Transposée de X
print(t(X))

# Q4: Produit matriciel t(X) %*% X
print(t(X) %*% X)

# Q5: Inverse de t(X) %*% X
print(solve(t(X) %*% X))

# Q6: Produit t(X) %*% y
print(t(X) %*% y)

# Q7: Calculer les coefficients de régression: β = (X'X)^-1 X'y
beta <- solve(t(X) %*% X) %*% (t(X) %*% y)
print("Coefficients calculés manuellement:")
print(beta)

# Vérification avec lm()
print("Coefficients avec lm():")
print(lm(mpg ~ hp + wt, data=mtcars))


# =============================================================================
# EXERCICE 4: Importation des données et fusion de tables
# =============================================================================

# Note: Ajuster les chemins selon votre répertoire de travail
setwd("Donnees_TP1")

# Q1: Lire les fichiers de test avec différentes options
test1 <- read.csv2("test1.csv")
test2 <- read.csv2("test2.csv", dec = ".")
test3 <- read.csv2("test3.csv", dec = ".")

# Q2: Lire les fichiers d'état avec différents séparateurs
etat1 <- read.csv2("etat1.csv")                           # sep=";"
etat2 <- read.csv("etat2.csv", dec = ".")                 # sep=","
etat3 <- read.table("etat3.csv", header = TRUE, sep = " ") # sep=" "

# Notes sur les fonctions de lecture:
# - read.csv()  : sep = ","
# - read.csv2() : sep = ";"
# - Les deux reposent sur read.table()

# Notes sur la fusion de data frames:
# - cbind(df1, df2) : ajoute les colonnes de df2 à df1 (même nombre de lignes requis)
# - rbind(df1, df2) : ajoute les lignes de df2 à df1 (mêmes noms de colonnes requis)
# - merge(df1, df2, by='nomColonne') : fusion sur une colonne commune (2 df à la fois)

# Q3: Fusionner les trois data frames
etat <- merge(etat1, etat2, by="etat")
etat <- merge(etat, etat3, by="region")
print(head(etat))


# =============================================================================
# EXERCICE 5: Comparaison de distributions
# =============================================================================

# Comparer la loi normale et la loi de Student avec différents degrés de liberté
curve(dnorm(x), from = -4, to = 4,
      main = "Comparaison de distributions",
      ylab = "Densité", xlab = "x",
      ylim = c(0, 0.4))

# Ajouter la loi de Student avec df=5 (queues plus épaisses)
curve(dt(x, 5), from = -4, to = 4, col = "red", add = TRUE)

# Ajouter la loi de Student avec df=30 (proche de la normale)
curve(dt(x, 30), from = -4, to = 4, col = "green", add = TRUE)

# Ajouter une légende
legend(x = -4, y = 0.4,
       legend = c("Loi normale", "Student df=5", "Student df=30"),
       col = 1:3, lty = 1)


# =============================================================================
# EXERCICE 6: Tracé de fonctions par morceaux
# =============================================================================

# Tracer plusieurs fonctions sur le même graphique
curve(x^2 + 1, from = -3, to = 3, col = "red", ylim = c(-10, 10),
      ylab = "y", xlab = "x", main = "Fonctions diverses")

curve(x*0, col = "blue", add = TRUE)                      # Ligne y=0
curve(2*x + 2, col = "green", add = TRUE)                 # Droite

# Fonction définie par morceaux (en noir)
curve(x^2 + 2*x + 3, from = -3, to = 0, col = "black", add = TRUE)
curve(x + 3, from = 0, to = 2, col = "black", add = TRUE)
curve(x^2 + 4*x - 7, from = 2, to = 3, col = "black", add = TRUE)

legend(x = -3, y = 0,
       legend = c("f", "0", "g", "h"),
       col = c("red", "blue", "green", "black"),
       lty = 1)


# =============================================================================
# EXERCICE 7: Étude des ouragans
# =============================================================================

# Q1: Importer les données
intensite <- read.table("Intensite.txt", header = TRUE)
dommages <- read.table("Dommages.txt", header = TRUE, dec = ",")
mortalite <- read.csv2("Mortalite.csv")

# Trier mortalite par nom
mortalite <- mortalite[order(mortalite$nom), ]

# Notes sur l'indexation:
# df[1, ]  : sélectionne la ligne 1
# df[, 1]  : sélectionne la colonne 1

# Q2: Filtrer les ouragans avec noeuds >= 64
intensite <- subset(intensite, noeuds >= 64)
# Alternative: intensite <- intensite[intensite$noeuds >= 64, ]

# Q3: Supprimer les lignes contenant des NA dans dommages
dommages <- dommages[apply(!is.na(dommages), 1, all), ]

# Q4: Créer une variable catégorielle pour la catégorie d'ouragan
# Échelle de Saffir-Simpson basée sur la vitesse du vent (noeuds)
categorie <- rep("ouragan 5", nrow(intensite))
categorie[intensite$noeuds <= 135] <- "ouragan 4"
categorie[intensite$noeuds <= 113] <- "ouragan 3"
categorie[intensite$noeuds <= 95] <- "ouragan 2"
categorie[intensite$noeuds <= 82] <- "ouragan 1"
categorie <- as.factor(categorie)
intensite <- cbind(intensite, categorie)

# Q5: Fusionner les trois tables
Ouragan <- merge(intensite, dommages)
Ouragan <- merge(Ouragan, mortalite)

# Q6: Trier par année
Ouragan <- Ouragan[order(Ouragan$annee), ]

# Q7: Calculer le coût moyen par catégorie
print("Coût moyen par catégorie d'ouragan:")
print(by(Ouragan$cout, Ouragan$categorie, mean))

# Q8: Visualiser la distribution des ouragans par année
hist(Ouragan$annee,
     main = "Distribution des ouragans par année",
     xlab = "Année", ylab = "Fréquence",
     col = "lightblue")

barplot(table(Ouragan$annee),
        main = "Nombre d'ouragans par année",
        xlab = "Année", ylab = "Nombre",
        col = "coral")

# =============================================================================
# FIN DU TP1
# =============================================================================
