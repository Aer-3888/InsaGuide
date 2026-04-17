# =============================================================================
# TP2: Régression linéaire simple
# Statistiques Descriptives - INSA Rennes 3ème année
# =============================================================================
# Sujets: Régression linéaire simple, analyse des résidus, validation du modèle,
#         prédiction, intervalles de confiance, transformations de variables
# =============================================================================

# Définir le répertoire de travail
setwd("TP2_Donnees")


# =============================================================================
# EXERCICE 1: Nombre de lettres et poids du courrier
# =============================================================================
# Objectif: Modéliser la relation entre le poids du courrier et le nombre de lettres

courrier <- read.table("Courrier.txt", header = TRUE)
attach(courrier)  # Permet d'utiliser directement les noms de variables

# Q2: Représentation graphique des données
plot(Poids, Nb_lettres,
     xlab = "Poids du courrier (t)",
     ylab = "Nombre de lettres",
     pch = 19,
     xlim = c(9, 39),
     ylim = c(700, 2500),
     main = "Relation entre poids et nombre de lettres")

# Observation: graphiquement, un modèle linéaire semble justifié

# Q3: Ajuster une régression linéaire simple
# Modèle: Nb_lettres = β₀ + β₁ * Poids + ε
reg <- lm(Nb_lettres ~ Poids, data = courrier)
resume <- summary(reg)
print(resume)

# Q4: Tracer la droite de régression
x <- c(min(Poids), max(Poids))
y <- 198 + 57.7 * x  # Coefficients obtenus de la régression
lines(x, y, col = "blue", lwd = 3)

# Q5: Coefficient de détermination R²
cat("R² =", resume$r.squared, "\n")
# Interprétation: 96.28% de la variabilité du nombre de lettres est expliquée par le poids

# Q6: Graphe des résidus pour valider le modèle
plot(reg$fitted.values, reg$residuals,
     xlab = "Valeurs ajustées",
     ylab = "Résidus",
     main = "Analyse des résidus")
abline(h = 0, col = "blue", lwd = 2)
abline(h = -2*resume$sigma, col = "red", lty = 2)
abline(h = 2*resume$sigma, col = "red", lty = 2)

# Interprétation: résidus uniformément répartis autour de 0 → hypothèse de linéarité validée
# Les résidus sont homoscédastiques (variance constante)

# Q7: Test de significativité du coefficient β₁
# H₀: β₁ = 0 (pas d'influence du poids)
# H₁: β₁ ≠ 0 (influence significative du poids)
if (resume$coefficients[2, 4] < 0.05) {
  cat("Le coefficient β₁ (57.7) est significativement différent de 0 (p < 0.05)\n")
  cat("Le poids a une influence significative sur le nombre de lettres\n")
}

# Q8: Prédiction ponctuelle pour un poids de 27.5 tonnes
pred_ponctuelle <- 198 + 57.7 * 27.5
cat("Prédiction manuelle:", pred_ponctuelle, "\n")
cat("Prédiction avec predict():", predict(reg, data.frame(Poids = 27.5)), "\n")

# Q9: Intervalle de prédiction à 95%
pred_intervalle <- predict(reg, data.frame(Poids = 27.5), interval = "prediction")
print(pred_intervalle)

# Q10: Tracer les intervalles de prédiction sur un graphique
I <- predict(reg, data.frame(Poids = 0:40), interval = "prediction")
plot(Poids, Nb_lettres,
     xlab = "Poids (t)",
     ylab = "Nombre de lettres",
     main = "Régression avec intervalles de prédiction")
lines(0:40, I[, "lwr"], col = "red", lty = 2)
lines(0:40, I[, "upr"], col = "red", lty = 2)
lines(0:40, I[, "fit"], col = "blue", lwd = 2)

detach(courrier)


# =============================================================================
# EXERCICE 2: Les dangers de la régression simple
# =============================================================================
# Objectif: Analyser le quatuor d'Anscombe (jeu de données de Tomassone)
# Montre l'importance de l'analyse graphique et des résidus

tomassone <- read.table("tomassone.txt", header = TRUE)
attach(tomassone)

# -------------------------
# Analyse de Y1 vs X
# -------------------------
cat("\n=== Analyse de Y1 ===\n")
plot(X, Y1, main = "Y1 vs X", pch = 19)
reg1 <- lm(Y1 ~ X, data = tomassone)
resume1 <- summary(reg1)
print(resume1)

abline(reg1, col = "blue", lwd = 3)

# Graphe des résidus
plot(reg1$fitted.values, reg1$residuals,
     main = "Résidus de Y1",
     xlab = "Valeurs ajustées", ylab = "Résidus")
abline(h = 0, col = "blue")

# Conclusion: Points répartis uniformément, modèle linéaire approprié

# -------------------------
# Analyse de Y2 vs X
# -------------------------
cat("\n=== Analyse de Y2 ===\n")
plot(X, Y2, main = "Y2 vs X", pch = 19)
reg2 <- lm(Y2 ~ X, data = tomassone)
resume2 <- summary(reg2)
print(resume2)

abline(reg2, col = "red", lwd = 3)

# Graphe des résidus
plot(reg2$fitted.values, reg2$residuals,
     main = "Résidus de Y2",
     xlab = "Valeurs ajustées", ylab = "Résidus")
abline(h = 0, col = "blue")

# Observation: Tendance parabolique visible, R² = 0.62 (faible)
# Résidus non uniformément répartis → modèle linéaire inadapté

# Solution: Ajouter X² comme variable explicative
X2 <- tomassone[, "X"]^2
tomassone2 <- cbind(tomassone, X2)
reg2_poly <- lm(Y2 ~ X + X2, data = tomassone2)
resume2_poly <- summary(reg2_poly)
print(resume2_poly)

plot(X, Y2, main = "Y2 vs X avec modèle polynomial", pch = 19)
lines(X, predict(reg2_poly), col = "blue", lwd = 3)

# -------------------------
# Analyse de Y3 vs X
# -------------------------
cat("\n=== Analyse de Y3 ===\n")
plot(X, Y3, main = "Y3 vs X", pch = 19)
reg3 <- lm(Y3 ~ X, data = tomassone)
resume3 <- summary(reg3)
print(resume3)

abline(reg3, col = "green", lwd = 3)

# Graphe des résidus
plot(reg3$fitted.values, reg3$residuals,
     ylim = c(-10, 10),
     main = "Résidus de Y3",
     xlab = "Valeurs ajustées", ylab = "Résidus")
abline(h = 0, col = "blue")
abline(h = -2*resume3$sigma, col = "red")
abline(h = 2*resume3$sigma, col = "red")

# Observation: Une valeur aberrante (point 16) affecte fortement le modèle

# Solution: Refaire la régression sans la valeur aberrante
tomassone3 <- tomassone[-16, ]
reg3_clean <- lm(Y3 ~ X, data = tomassone3)
resume3_clean <- summary(reg3_clean)
print(resume3_clean)

plot(tomassone3$X, tomassone3$Y3,
     main = "Y3 vs X (sans outlier)", pch = 19)
abline(reg3_clean, col = "blue", lwd = 3)

# Vérifier les résidus
plot(reg3_clean$fitted.values, reg3_clean$residuals,
     ylim = c(-3, 3),
     main = "Résidus de Y3 (sans outlier)")
abline(h = 0, col = "blue")
abline(h = -2*resume3_clean$sigma, col = "red")
abline(h = 2*resume3_clean$sigma, col = "red")

# -------------------------
# Analyse de Y4 vs X
# -------------------------
cat("\n=== Analyse de Y4 ===\n")
plot(X, Y4, main = "Y4 vs X", pch = 19)
reg4 <- lm(Y4 ~ X, data = tomassone)
resume4 <- summary(reg4)
print(resume4)

abline(reg4, col = "purple", lwd = 3)

# Graphe des résidus
plot(reg4$fitted.values, reg4$residuals,
     ylim = c(-8, 8),
     main = "Résidus de Y4")
abline(h = 0, col = "blue")
abline(h = -2*resume4$sigma, col = "red")
abline(h = 2*resume4$sigma, col = "red")

# Observation: Résidus non uniformes → transformation logarithmique nécessaire
reg4_log <- lm(log(Y4) ~ X, data = tomassone)
plot(X, log(Y4), main = "log(Y4) vs X", pch = 19)
abline(reg4_log, col = "blue", lwd = 3)

# Amélioration avec modèle polynomial sur log(Y4)
X2 <- tomassone[, "X"]^2
tomassone4 <- cbind(tomassone, X2)
reg4_poly <- lm(log(Y4) ~ X + X2, data = tomassone4)
resume4_poly <- summary(reg4_poly)
print(resume4_poly)

plot(X, log(Y4), main = "log(Y4) avec modèle polynomial", pch = 19)
lines(X, predict(reg4_poly), col = "blue", lwd = 3)

# Vérifier les résidus
plot(reg4_poly$fitted.values, reg4_poly$residuals,
     ylim = c(-0.5, 0.5),
     main = "Résidus du modèle polynomial sur log(Y4)")
abline(h = 0, col = "blue")
abline(h = -2*resume4_poly$sigma, col = "red")
abline(h = 2*resume4_poly$sigma, col = "red")

detach(tomassone)


# =============================================================================
# EXERCICE 3: Distance de freinage
# =============================================================================
# Objectif: Modéliser la distance d'arrêt en fonction de la vitesse

freinage <- read.table("freinage.txt", header = TRUE)
attach(freinage)

# Q2: Variable à expliquer = Dist, variable explicative = Vitesse
plot(Vitesse, Dist,
     main = "Distance de freinage vs Vitesse",
     xlab = "Vitesse (km/h)",
     ylab = "Distance d'arrêt (m)",
     pch = 19)

# Q3: Régression linéaire simple
reg <- lm(Dist ~ Vitesse, data = freinage)
resume <- summary(reg)
print(resume)

cat("\nCoefficients:\n")
cat("β₀ =", coef(reg)[1], "\n")
cat("β₁ =", coef(reg)[2], "\n")
cat("R² =", resume$r.squared, "→ 98% de variabilité expliquée\n")
cat("p-value <", resume$coefficients[2, 4], "→ influence significative\n")

# Q4: Tracer la droite de régression
lines(Vitesse, predict(reg), col = "blue", lwd = 3)

# Q5: Analyse des résidus
plot(reg$fitted.values, reg$residuals,
     ylim = c(-10, 10),
     main = "Résidus du modèle linéaire",
     xlab = "Valeurs ajustées", ylab = "Résidus")
abline(h = 0, col = "blue")
abline(h = -2*resume$sigma, col = "red")
abline(h = 2*resume$sigma, col = "red")

# Observation: Allure parabolique → ajouter Vitesse²
Vitesse2 <- freinage[, "Vitesse"]^2
freinage2 <- cbind(freinage, Vitesse2)

reg2 <- lm(Dist ~ Vitesse + Vitesse2, data = freinage2)
resume2 <- summary(reg2)
print(resume2)

plot(Vitesse, Dist,
     main = "Distance de freinage avec modèle polynomial",
     xlab = "Vitesse (km/h)", ylab = "Distance (m)",
     pch = 19)
lines(Vitesse, predict(reg2), col = "red", lwd = 3)

# Vérifier les résidus du modèle polynomial
plot(reg2$fitted.values, reg2$residuals,
     ylim = c(-10, 10),
     main = "Résidus du modèle polynomial")
abline(h = 0, col = "blue")
abline(h = -2*resume2$sigma, col = "red")
abline(h = 2*resume2$sigma, col = "red")

# Conclusion: Résidus répartis aléatoirement et homoscédastiques

# Q6: Prédiction pour une vitesse de 85 km/h
# Distance d'arrêt = distance de réaction + distance de freinage
# Distance de réaction = vitesse × temps de réaction (2 secondes)

p1 <- predict(reg, data.frame(Vitesse = 85))     # Modèle linéaire
p2 <- predict(reg2, data.frame(Vitesse = 85, Vitesse2 = 85^2))  # Modèle polynomial

# Conversion: 85 km/h = 85/3.6 = 23.6 m/s
Da1 <- p1 + (85/3.6) * 2    # Distance totale avec modèle 1
Da2 <- p2 + (85/3.6) * 2    # Distance totale avec modèle 2

cat("\nPrédiction pour 85 km/h:\n")
cat("Distance de freinage (modèle linéaire):", p1, "m\n")
cat("Distance de freinage (modèle polynomial):", p2, "m\n")
cat("Distance totale d'arrêt (modèle 1):", Da1, "m\n")
cat("Distance totale d'arrêt (modèle 2):", Da2, "m\n")

detach(freinage)


# =============================================================================
# EXERCICE 4: Gain en protéines chez les porcs
# =============================================================================
# Objectif: Modéliser le gain journalier en protéines en fonction de l'ingestion

porcs <- read.csv2("porcs.csv")
attach(porcs)

# Q2: Variable à expliquer = gain, variable explicative = ingestion
plot(ingestion, gain,
     main = "Gain en protéines vs Ingestion",
     xlab = "Ingestion journalière",
     ylab = "Gain journalier en protéines",
     pch = 19)

# Q3: Régression linéaire simple
reg <- lm(gain ~ ingestion, data = porcs)
resume <- summary(reg)
print(resume)

cat("\nCoefficients:\n")
cat("β₀ =", coef(reg)[1], "\n")
cat("β₁ =", coef(reg)[2], "\n")
cat("R² =", resume$r.squared, "→ 63% de variabilité expliquée\n")
cat("p-value <", resume$coefficients[2, 4], "→ influence significative\n")

# Q4: Tracer la droite
lines(ingestion, predict(reg), col = "blue", lwd = 3)

# Q5: Analyse des résidus
plot(reg$fitted.values, reg$residuals,
     ylim = c(-50, 50),
     main = "Résidus du modèle linéaire",
     xlab = "Valeurs ajustées", ylab = "Résidus")
abline(h = 0, col = "blue")
abline(h = -2*resume$sigma, col = "red")
abline(h = 2*resume$sigma, col = "red")

# Observation: Forme parabolique → ajouter ingestion²
ingestion2 <- porcs[, "ingestion"]^2
porcs2 <- cbind(porcs, ingestion2)

reg2 <- lm(gain ~ ingestion + ingestion2, data = porcs2)
resume2 <- summary(reg2)
print(resume2)

plot(ingestion, gain,
     main = "Gain en protéines avec modèle polynomial",
     pch = 19)
lines(porcs2$ingestion, predict(reg2), col = "red", lwd = 3)

# Vérifier les résidus
plot(reg2$fitted.values, reg2$residuals,
     ylim = c(-40, 40),
     main = "Résidus du modèle polynomial")
abline(h = 0, col = "blue")
abline(h = -2*resume2$sigma, col = "red")
abline(h = 2*resume2$sigma, col = "red")

# Q6: Modèle avec seuil (contrainte de continuité)
# Hypothèse: gain augmente linéairement jusqu'à ingestion=28, puis plafonne

porcs_inf28 <- porcs[ingestion <= 28, ]
reg3 <- lm(gain ~ ingestion, data = porcs_inf28)
resume3 <- summary(reg3)
print(resume3)

cat("\nModèle avec seuil:\n")
cat("β₀ =", coef(reg3)[1], "\n")
cat("β₁ =", coef(reg3)[2], "\n")

# Visualisation
plot(ingestion, gain,
     main = "Modèle avec seuil à ingestion=28",
     pch = 19)
lines(porcs_inf28$ingestion, predict(reg3), col = "blue", lwd = 3)

# Pour ingestion > 28, valeur constante
x_sup28 <- porcs[ingestion > 28, ]$ingestion
y_sup28 <- rep(predict(reg3, data.frame(ingestion = 28)), length(x_sup28))
lines(x_sup28, y_sup28, col = "blue", lwd = 3)

detach(porcs)

# =============================================================================
# FIN DU TP2
# =============================================================================
