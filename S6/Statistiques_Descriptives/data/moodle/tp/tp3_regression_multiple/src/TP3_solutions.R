# =============================================================================
# TP3: Régression linéaire multiple
# Statistiques Descriptives - INSA Rennes 3ème année
# =============================================================================
# Sujets: Régression multiple, corrélation, sélection de variables (backward),
#         AIC, graphiques 3D, calcul matriciel avancé
# =============================================================================

# Packages requis
# install.packages("rgl")
# install.packages("car")
library(rgl)
library(car)

# Définir le répertoire de travail
setwd("TP3_Donnees")


# =============================================================================
# EXERCICE 1: Effet de la publicité sur les ventes d'un produit
# =============================================================================
# Objectif: Analyser l'impact de 3 médias publicitaires (TV, Radio, Journaux)
#           sur les ventes d'un produit

pub <- read.csv("Advertising.csv")
attach(pub)

# Q2: Matrice de corrélation
cat("=== Matrice de corrélation ===\n")
print(cor(pub))
# Observation: TV et Sales sont plutôt corrélés (correlation positive)

# Q3: Régression simple Sales ~ TV
plot(TV, Sales,
     main = "Ventes vs Publicité TV",
     xlab = "Budget TV (milliers $)",
     ylab = "Ventes (milliers d'unités)",
     pch = 19)

reg_tv <- lm(Sales ~ TV, data = pub)
resume <- summary(reg_tv)
print(resume)

lines(TV, predict(reg_tv), col = "blue", lwd = 3)

# R² pas exceptionnel
# p-value petite → on rejette H₀ → influence de la pub TV sur les ventes

# Analyse des résidus
plot(reg_tv$fitted.values, reg_tv$residuals,
     main = "Résidus du modèle Sales ~ TV",
     xlab = "Valeurs ajustées", ylab = "Résidus")
abline(h = 0, col = "blue")
abline(h = -2*resume$sigma, col = "red")
abline(h = 2*resume$sigma, col = "red")

# Observation: Non homoscédastique → essayer transformation log
plot(TV, log(Sales),
     main = "log(Ventes) vs Publicité TV",
     xlab = "Budget TV", ylab = "log(Ventes)",
     pch = 19)

reg_tv_log <- lm(log(Sales) ~ TV, data = pub)
resume_log <- summary(reg_tv_log)
print(resume_log)

lines(TV, predict(reg_tv_log), col = "blue", lwd = 3)

# Vérifier les résidus
plot(reg_tv_log$fitted.values, reg_tv_log$residuals,
     ylim = c(-2, 2),
     main = "Résidus du modèle log(Sales) ~ TV",
     xlab = "Valeurs ajustées", ylab = "Résidus")
abline(h = 0, col = "blue")
abline(h = -2*resume_log$sigma, col = "red")
abline(h = 2*resume_log$sigma, col = "red")

# Observation: 2 valeurs s'éloignent mais globalement satisfaisant

# Q4: Tester les autres variables
# Radio vs TV
plot(TV, Radio,
     main = "Budget Radio vs Budget TV",
     xlab = "Budget TV", ylab = "Budget Radio",
     pch = 19)

reg_radio_tv <- lm(Radio ~ TV, data = pub)
resume_radio <- summary(reg_radio_tv)
print(resume_radio)

lines(TV, predict(reg_radio_tv), col = "blue", lwd = 3)

plot(reg_radio_tv$fitted.values, reg_radio_tv$residuals,
     ylim = c(-30, 30),
     main = "Résidus Radio ~ TV")
abline(h = 0, col = "blue")
abline(h = -2*resume_radio$sigma, col = "red")
abline(h = 2*resume_radio$sigma, col = "red")

# Newspaper vs TV
plot(TV, Newspaper,
     main = "Budget Journaux vs Budget TV",
     xlab = "Budget TV", ylab = "Budget Journaux",
     pch = 19)

reg_news_tv <- lm(Newspaper ~ TV, data = pub)
resume_news <- summary(reg_news_tv)
print(resume_news)

lines(TV, predict(reg_news_tv), col = "blue", lwd = 3)

plot(reg_news_tv$fitted.values, reg_news_tv$residuals,
     ylim = c(-80, 80),
     main = "Résidus Newspaper ~ TV")
abline(h = 0, col = "blue")
abline(h = -2*resume_news$sigma, col = "red")
abline(h = 2*resume_news$sigma, col = "red")

# Q5: Régression multiple avec les 3 variables
regm <- lm(Sales ~ TV + Radio + Newspaper, data = pub)
resume_mult <- summary(regm)
print(resume_mult)

cat("\n=== Interprétation ===\n")
cat("R² =", resume_mult$r.squared, "\n")
cat("89% de la variabilité des ventes est expliquée par les 3 médias\n")

# Q6: Test global du modèle
# H₀: β_TV = β_Radio = β_Newspaper = 0 (aucune influence)
# H₁: Au moins un βᵢ ≠ 0
cat("\nF-statistic =", resume_mult$fstatistic[1], "\n")
cat("p-value < 2.2e-16 → on rejette H₀\n")
cat("Au moins une variable a une influence significative\n\n")

# Tests individuels
cat("Tests individuels (p-values):\n")
cat("TV:", resume_mult$coefficients["TV", 4], "→ significatif\n")
cat("Radio:", resume_mult$coefficients["Radio", 4], "→ significatif\n")
cat("Newspaper:", resume_mult$coefficients["Newspaper", 4], "→ NON significatif\n")

# Q8: Régression multiple sans Newspaper
reg2 <- lm(Sales ~ TV + Radio, data = pub)
resume2 <- summary(reg2)
print(resume2)

cat("\n=== Comparaison des coefficients ===\n")
cat("TV:", coef(reg2)["TV"], "\n")
cat("Radio:", coef(reg2)["Radio"], "\n")
cat("La Radio a une influence plus forte (coefficient plus élevé)\n")

# Q9: Visualisation 3D
scatter3d(Sales ~ TV + Radio,
          data = pub,
          surface = TRUE,
          grid = TRUE,
          ellipsoid = TRUE)

# Q10: Prédiction pour TV=100, Radio=20
x0 <- data.frame(TV = 100, Radio = 20)
pred <- predict(reg2, newdata = x0, interval = "prediction")
cat("\n=== Prédiction pour TV=100, Radio=20 ===\n")
print(pred)

detach(pub)


# =============================================================================
# EXERCICE 2: Composition du lait et rendement fromager
# =============================================================================
# Objectif: Prédire le rendement fromager à partir de la composition du lait
#           Sélection automatique de variables avec step()

lait <- read.table("lait.txt", header = TRUE)
attach(lait)

# Q2: Matrice de corrélation
cat("\n=== Matrice de corrélation ===\n")
print(cor(lait[, 1:5]))

cat("\nObservations:\n")
cat("- ExSec ~ Densite: corrélation 0.76\n")
cat("- TxCase ~ TxProt: très corrélés 0.96 → redondance d'information\n")
cat("Un modèle avec moins de variables peut fonctionner aussi bien\n")

# Q3: Visualiser les relations bivariées
par(mfrow = c(2, 3))
plot(Densite, Rendement, main = "Rendement vs Densité", pch = 19)
plot(TxButy, Rendement, main = "Rendement vs Taux Butyrique", pch = 19)
plot(TxProt, Rendement, main = "Rendement vs Taux Protéique", pch = 19)
plot(TxCase, Rendement, main = "Rendement vs Taux Caséine", pch = 19)
plot(ExSec, Rendement, main = "Rendement vs Extrait Sec", pch = 19)
par(mfrow = c(1, 1))

# Q4: Régression multiple complète
reg_complet <- lm(Rendement ~ Densite + TxButy + TxProt + TxCase + ExSec, data = lait)
resume_complet <- summary(reg_complet)
print(resume_complet)

cat("\n=== Variables significatives (p < 0.05) ===\n")
cat("TxButy:", resume_complet$coefficients["TxButy", 4], "\n")
cat("ExSec:", resume_complet$coefficients["ExSec", 4], "\n")
cat("Ces deux variables ont un effet significatif\n")

# Exemple de calcul avec les coefficients
exemple <- 5*coef(reg_complet)["TxButy"] + 5*coef(reg_complet)["TxProt"] - 2*coef(reg_complet)["TxCase"]
cat("\nExemple de calcul:", exemple, "\n")

# Graphe des résidus
par(mfrow = c(2, 2))
plot(reg_complet)
par(mfrow = c(1, 1))

# Q5: Sélection automatique de variables (backward)
cat("\n=== Sélection backward avec step() ===\n")
reg_backward <- step(reg_complet, direction = "backward")
# L'algorithme:
# - Calcule l'AIC du modèle complet
# - Enlève une variable à chaque tour et recalcule l'AIC
# - Compare les AIC
# - Objectif: minimiser l'AIC
# - S'arrête quand aucune amélioration n'est possible

cat("\nModèle sélectionné:", formula(reg_backward), "\n")
# Modèle conservé: Densite + TxButy + TxProt + ExSec

# Q6: Modèle sans intercept
reg_no_intercept <- lm(Rendement ~ -1 + Densite + TxButy + TxProt + ExSec, data = lait)
# -1 ou 0 enlève l'ordonnée à l'origine → force le passage par (0, 0)

# Q7: Comparaison des modèles avec AIC et R²
cat("\n=== Comparaison des modèles ===\n")
cat("Modèle complet:\n")
cat("  AIC =", extractAIC(reg_complet)[2], "\n")
cat("  R² ajusté =", summary(reg_complet)$adj.r.squared, "\n")

cat("Modèle backward:\n")
cat("  AIC =", extractAIC(reg_backward)[2], "\n")
cat("  R² ajusté =", summary(reg_backward)$adj.r.squared, "\n")

cat("Modèle sans intercept:\n")
cat("  AIC =", extractAIC(reg_no_intercept)[2], "\n")
cat("  R² ajusté =", summary(reg_no_intercept)$adj.r.squared, "\n")

cat("\nConclusion: On garde le modèle 3 (sans intercept)\n")
cat("R² plus intéressant même si AIC > modèle backward\n")

# Q8: Prédiction pour deux vaches
# Vache 1: Holstein
# Vache 2: Normande
df_vaches <- data.frame(
  rbind(
    c(Densite = 1.032, TxButy = 39.7, TxProt = 31.9, ExSec = 130),
    c(Densite = 1.032, TxButy = 42.8, TxProt = 34.5, ExSec = 130)
  )
)

pred_vaches <- predict(reg_no_intercept, newdata = df_vaches, interval = "prediction")
cat("\n=== Prédiction du rendement fromager ===\n")
cat("Vache Holstein:\n")
print(pred_vaches[1, ])
cat("\nVache Normande:\n")
print(pred_vaches[2, ])

if (pred_vaches[1, "fit"] < pred_vaches[2, "fit"]) {
  cat("\nLa meilleure vache est la Normande (rendement plus élevé)\n")
} else {
  cat("\nLa meilleure vache est la Holstein (rendement plus élevé)\n")
}

detach(lait)


# =============================================================================
# EXERCICE 3: Hauteur des eucalyptus
# =============================================================================
# Objectif: Prédire la hauteur des eucalyptus à partir de leur circonférence
#           Calcul matriciel manuel des coefficients de régression

eucal <- read.table("eucalyptus.txt", header = TRUE)
attach(eucal)

# Q2: Variable à expliquer = hauteur (ht), variable explicative = circonférence (circ)
plot(circ, ht,
     main = "Hauteur vs Circonférence des eucalyptus",
     xlab = "Circonférence (cm)",
     ylab = "Hauteur (m)",
     pch = 19,
     col = "darkgreen")

# Q3: Modèle linéaire simple
# Modèle: Yᵢ = β₀ + β₁*xᵢ + εᵢ
# où εᵢ iid ~ N(0, σ²)

reg_simple <- lm(ht ~ circ, data = eucal)
resume_simple <- summary(reg_simple)
print(resume_simple)

cat("\nCoefficients:\n")
cat("β₀ =", coef(reg_simple)[1], "\n")
cat("β₁ =", coef(reg_simple)[2], "\n")

# Q4: Tracer la droite et analyser les résidus
lines(circ, predict(reg_simple), col = "red", lwd = 3)

plot(reg_simple$fitted.values, reg_simple$residuals,
     ylim = c(-10, 10),
     main = "Résidus du modèle simple",
     xlab = "Valeurs ajustées", ylab = "Résidus")
abline(h = 0, col = "blue")
abline(h = -2*resume_simple$sigma, col = "red")
abline(h = 2*resume_simple$sigma, col = "red")

# Observation: Non homoscédastique

# Q5: CALCUL MATRICIEL MANUEL - Régression avec circ et sqrt(circ)

# a) Écriture matricielle Y = X*B + E
Y <- ht
X0 <- rep(1, length(circ))              # Intercept
X1 <- circ                              # Circonférence
X2 <- sqrt(circ)                        # Racine carrée de la circonférence
X <- cbind(X0, X1, X2)

cat("\n=== Dimensions des matrices ===\n")
cat("Y:", dim(as.matrix(Y)), "\n")
cat("X:", dim(X), "\n")

# b) Calcul des coefficients: B = (X'X)⁻¹ X'Y
B <- solve(t(X) %*% X) %*% t(X) %*% Y
cat("\n=== Coefficients calculés manuellement ===\n")
cat("β₀ =", B[1], "\n")
cat("β₁ =", B[2], "\n")
cat("β₂ =", B[3], "\n")

# c) Calcul de σ (écart-type des résidus)
y_fit <- B[1] + B[2]*circ + B[3]*sqrt(circ)   # Valeurs ajustées
e <- ht - y_fit                                # Résidus
n <- length(e)
p <- 2                                         # Nombre de variables explicatives (sans intercept)
sigma <- sqrt(sum(e^2) / (n - p - 1))
cat("\nσ =", sigma, "\n")

# d) Calcul des écarts-types des coefficients
# Var(β) = σ²(X'X)⁻¹
var_beta <- sigma^2 * solve(t(X) %*% X)
se_B0 <- sqrt(var_beta[1, 1])
se_B1 <- sqrt(var_beta[2, 2])
se_B2 <- sqrt(var_beta[3, 3])

cat("\n=== Écarts-types des coefficients ===\n")
cat("SE(β₀) =", se_B0, "\n")
cat("SE(β₁) =", se_B1, "\n")
cat("SE(β₂) =", se_B2, "\n")

# e) Test de significativité de β₂
# H₀: β₂ = 0 (racine carrée n'a pas d'influence)
# H₁: β₂ ≠ 0 (racine carrée a une influence)
# Statistique de test: T₀ = β₂ / SE(β₂) ~ t_{n-p-1}

T0 <- B[2] / se_B2
ddl <- n - p - 1
t_critique <- qt(0.975, ddl)  # Quantile à 97.5% pour test bilatéral

cat("\n=== Test de significativité de β₂ ===\n")
cat("T₀ =", T0, "\n")
cat("t_{", ddl, ", 0.975} =", t_critique, "\n")
cat("Région de rejet: ]-∞,", -t_critique, "] ∪ [", t_critique, ", +∞[\n")

if (abs(T0) > t_critique) {
  cat("T₀ appartient à la région de rejet\n")
  cat("→ On rejette H₀ avec un risque de 5%\n")
  cat("→ La racine de la circonférence influe sur la hauteur\n")
} else {
  cat("T₀ n'appartient pas à la région de rejet\n")
  cat("→ On ne peut pas rejeter H₀\n")
}

# f) Vérification avec lm()
eucal2 <- cbind.data.frame(eucal, rcirc = sqrt(eucal[, "circ"]))
reg_complet <- lm(ht ~ circ + rcirc, data = eucal2)
resume_complet <- summary(reg_complet)
print(resume_complet)

cat("\n=== Comparaison avec lm() ===\n")
cat("Calcul manuel - β₀:", B[1], "| lm() - β₀:", coef(reg_complet)[1], "\n")
cat("Calcul manuel - β₁:", B[2], "| lm() - β₁:", coef(reg_complet)[2], "\n")
cat("Calcul manuel - β₂:", B[3], "| lm() - β₂:", coef(reg_complet)[3], "\n")

# g) Comparaison graphique des deux modèles
plot(circ, ht,
     main = "Comparaison modèle simple vs modèle avec √circ",
     xlab = "Circonférence (cm)",
     ylab = "Hauteur (m)",
     pch = 19,
     col = "darkgreen")

# Modèle simple
lines(circ, predict(reg_simple), col = "red", lwd = 3, lty = 2)

# Modèle avec racine carrée
x_seq <- seq(min(circ), max(circ), length = 100)
result <- B[1] + B[2]*x_seq + B[3]*sqrt(x_seq)
lines(x_seq, result, col = "blue", lwd = 3)

legend("topleft",
       legend = c("Modèle simple", "Modèle avec √circ"),
       col = c("red", "blue"),
       lwd = 3,
       lty = c(2, 1))

detach(eucal)

# =============================================================================
# FIN DU TP3
# =============================================================================
