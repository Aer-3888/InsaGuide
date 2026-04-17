# =============================================================================
# TP4: ANOVA (Analyse de la variance)
# Statistiques Descriptives - INSA Rennes 3ème année
# =============================================================================
# Sujets: ANOVA à 1 facteur, ANOVA à 2 facteurs, tests de comparaisons multiples,
#         package emmeans, contraintes de modélisation
# =============================================================================

# Package requis
# install.packages("emmeans")
library(emmeans)

# Définir le répertoire de travail
setwd("TP4_Donnees")


# =============================================================================
# EXERCICE 1: ANOVA à un facteur - Types de hotdogs
# =============================================================================
# Objectif: Déterminer si le type de viande (boeuf, volaille, mélange) influe
#           sur les caractéristiques nutritionnelles des hotdogs

# Q1: Importation et nettoyage des données
tab <- read.table("hotdogs.txt", header = TRUE)
attach(tab)

# Supprimer les lignes avec Type = 4 (une seule ligne aberrante)
tab <- tab[-which(tab$Type == 4), ]

# Convertir Type en facteur
tab$Type <- as.factor(tab$Type)
# Type passe de int à factor ("1", "2", "3")
# 1 = Boeuf, 2 = Mélange, 3 = Volaille

# Q2: Statistiques descriptives
cat("=== Statistiques descriptives ===\n")
cat("\nCalories:\n")
print(summary(Calories))
cat("\nSodium:\n")
print(summary(Sodium))

cat("\n=== Résumé par type ===\n")
print(by(tab, tab$Type, summary))

# Visualisation avec boîtes à moustaches
par(mfrow = c(1, 2))
boxplot(Calories ~ Type, data = tab,
        main = "Calories par type de hotdog",
        xlab = "Type (1=Boeuf, 2=Mélange, 3=Volaille)",
        ylab = "Calories",
        col = c("red", "orange", "lightblue"))

boxplot(Sodium ~ Type, data = tab,
        main = "Sodium par type de hotdog",
        xlab = "Type",
        ylab = "Sodium (mg)",
        col = c("red", "orange", "lightblue"))
par(mfrow = c(1, 1))

cat("\nObservations:\n")
cat("- Boeuf et mélange: assez hauts en calories\n")
cat("- Volaille: moins riche en calories\n")
cat("- Boeuf: globalement moins riche en sel mais peut atteindre des taux élevés\n")

# Q3: Modèle d'ANOVA à 1 facteur pour les calories
cat("\n=== ANOVA pour les Calories ===\n")

# Modèle: Pour tout i=1,2,3 et pour tout j=1,...,nᵢ
#         Calories_ij = μ + αᵢ + εᵢⱼ
#         avec εᵢⱼ iid ~ N(0, σ²)

mod1 <- lm(Calories ~ Type, data = tab)

# Note: R utilise par défaut la "contrainte témoin" (α₁ = 0)
# Pour forcer la "contrainte naturelle" (Σαᵢ = 0), utiliser:
# mod1 <- lm(Calories ~ Type, data = tab, contrasts = list(Type = "contr.sum"))

# Graphiques de diagnostic
par(mfrow = c(2, 2))
plot(mod1)
par(mfrow = c(1, 1))

cat("\nInterprétation des graphiques:\n")
cat("- Residuals vs Fitted: Résidus alignés sur 3 valeurs (les 3 niveaux du facteur)\n")
cat("                       Répartition homogène autour de 0, homoscédastique ✓\n")
cat("- Q-Q plot: Léger écart par rapport à la droite normale aux extrémités\n")

# Table d'ANOVA
cat("\n=== Table d'ANOVA ===\n")
anova_tab <- anova(mod1)
print(anova_tab)

cat("\nExplication des colonnes:\n")
cat("- Df: degrés de liberté\n")
cat("- Sum Sq: sommes des carrés (SCM et SCR)\n")
cat("- Mean Sq: carrés moyens (CCM et CCR)\n")
cat("- F value: F₀ = CCM / CCR\n")
cat("- Pr(>F): probabilité critique (p-value)\n")

# Test d'hypothèse
cat("\nTest d'hypothèse:\n")
cat("H₀: Le type n'a pas d'influence → α₁ = α₂ = α₃ = 0\n")
cat("H₁: Le type a une influence → ∃i tel que αᵢ ≠ 0\n")
cat("\n")

if (anova_tab[1, 5] < 0.05) {
  cat("p-value =", anova_tab[1, 5], "< 0.05\n")
  cat("→ On rejette H₀ avec un risque de 5%\n")
  cat("→ Le type de hotdog a une influence significative sur les calories\n")
  cat("→ Au moins un αᵢ ≠ 0\n")
}

# Estimation des paramètres
cat("\n=== Estimation des paramètres ===\n")
resume <- summary(mod1)
print(resume)

cat("\nInterprétation (contrainte témoin α₁ = 0):\n")
cat("μ̂ =", coef(mod1)[1], "→ Nombre de calories moyen pour les hotdogs de type 1 (boeuf)\n")
cat("α̂₂ =", coef(mod1)[2], "→ Différence de calories entre type 2 (mélange) et type 1\n")
cat("α̂₃ =", coef(mod1)[3], "→ Différence de calories entre type 3 (volaille) et type 1\n")

cat("\nPrédictions par type:\n")
cat("Type 1 (Boeuf):", coef(mod1)[1], "calories\n")
cat("Type 2 (Mélange):", coef(mod1)[1] + coef(mod1)[2], "calories\n")
cat("Type 3 (Volaille):", coef(mod1)[1] + coef(mod1)[3], "calories\n")

cat("\nR² =", resume$r.squared, "\n")
cat("σ̂ =", resume$sigma, "\n")

# Comparaisons multiples avec emmeans
cat("\n=== Comparaisons multiples (Bonferroni) ===\n")
comp <- emmeans(mod1, pairwise ~ Type, adjust = "bonferroni")
print(comp)

cat("\nInterprétation:\n")
cat("- Bonferroni ajuste le niveau de confiance pour les comparaisons multiples\n")
cat("- $emmeans: intervalles de confiance sur les moyennes\n")
cat("- $contrasts: tests de comparaison deux à deux\n")

cat("\nConclusion:\n")
cat("Le sandwich le moins calorique est le sandwich à la volaille (Type 3)\n")

# Q4: ANOVA pour le Sodium
cat("\n\n=== ANOVA pour le Sodium ===\n")
mod1_sodium <- lm(Sodium ~ Type, data = tab)
anova_sodium <- anova(mod1_sodium)
print(anova_sodium)

if (anova_sodium[1, 5] < 0.05) {
  cat("\nLe type de hotdog a une influence significative sur le sodium (p < 0.05)\n")

  comp_sodium <- emmeans(mod1_sodium, pairwise ~ Type, adjust = "bonferroni")
  print(comp_sodium)
} else {
  cat("\nLe type de hotdog n'a pas d'influence significative sur le sodium (p >= 0.05)\n")
}

detach(tab)


# =============================================================================
# EXERCICE 2: Comparaison de l'acidité de trois cafés - ANOVA à 2 facteurs
# =============================================================================
# Objectif: Déterminer l'effet du type de café et du juge sur l'acidité perçue

cafe <- read.csv("cafe.csv")
attach(cafe)

# Convertir les variables en facteurs
cafe$cafe <- as.factor(cafe$cafe)
cafe$juge <- as.factor(cafe$juge)

cat("\n=== Structure des données ===\n")
str(cafe)

# Q1: Modèle d'ANOVA à 2 facteurs sans interaction
# Modèle: Yᵢⱼ = μ + αᵢ + βⱼ + εᵢⱼ
#         où i = type de café, j = juge
#         εᵢⱼ iid ~ N(0, σ²)

mod_cafe <- lm(acidite ~ cafe + juge, data = cafe)
anova_cafe <- anova(mod_cafe)
print(anova_cafe)

cat("\n=== Interprétation ===\n")
cat("Test pour le facteur 'cafe':\n")
cat("H₀: α₁ = α₂ = α₃ = 0 (pas d'effet du type de café)\n")
cat("H₁: ∃i tel que αᵢ ≠ 0 (effet du type de café)\n")

if (anova_cafe["cafe", "Pr(>F)"] < 0.05) {
  cat("p-value < 0.05 → On rejette H₀\n")
  cat("Le type de café a un effet significatif sur l'acidité perçue\n\n")
}

cat("Test pour le facteur 'juge':\n")
cat("H₀: β₁ = β₂ = ... = β₆ = 0 (pas d'effet du juge)\n")
cat("H₁: ∃j tel que βⱼ ≠ 0 (effet du juge)\n")

if (anova_cafe["juge", "Pr(>F)"] < 0.05) {
  cat("p-value < 0.05 → On rejette H₀\n")
  cat("Le juge a un effet significatif sur la note d'acidité\n")
  cat("Interprétation: Il est intéressant de prendre en compte l'effet juge\n")
  cat("car cela permet d'isoler l'effet café en contrôlant la variabilité due aux juges\n\n")
}

# Q3: Intégrer l'effet juge dans le modèle
cat("=== Intérêt d'intégrer l'effet juge ===\n")
cat("En contrôlant l'effet juge, on peut mieux estimer l'effet du café\n")
cat("On réduit la variance résiduelle en expliquant une partie de la variabilité\n")
cat("par les différences de notation entre juges\n\n")

# Q4: Modèle avec interaction
cat("=== ANOVA à 2 facteurs avec interaction ===\n")
# Modèle: Yᵢⱼₖ = μ + αᵢ + βⱼ + (αβ)ᵢⱼ + εᵢⱼₖ

mod_cafe_inter <- lm(acidite ~ cafe * juge, data = cafe)
# Équivalent à: lm(acidite ~ cafe + juge + cafe:juge, data = cafe)

anova_cafe_inter <- anova(mod_cafe_inter)
print(anova_cafe_inter)

cat("\nTest d'interaction:\n")
cat("H₀: Pas d'interaction entre café et juge\n")
cat("H₁: Il existe une interaction\n")

if (anova_cafe_inter["cafe:juge", "Pr(>F)"] < 0.05) {
  cat("p-value < 0.05 → Interaction significative\n")
  cat("L'effet du type de café dépend du juge\n")
} else {
  cat("p-value >= 0.05 → Pas d'interaction significative\n")
  cat("L'effet du café est homogène entre les juges\n")
}

# Q5: Retrouver les estimations par calcul manuel
cat("\n=== Calcul manuel des paramètres ===\n")
# Moyenne générale
mu_hat <- mean(cafe$acidite)
cat("μ̂ =", mu_hat, "\n")

# Effets des cafés
for (i in levels(cafe$cafe)) {
  alpha_i <- mean(cafe$acidite[cafe$cafe == i]) - mu_hat
  cat("α̂_", i, "=", alpha_i, "\n")
}

# Effets des juges
for (j in levels(cafe$juge)) {
  beta_j <- mean(cafe$acidite[cafe$juge == j]) - mu_hat
  cat("β̂_", j, "=", beta_j, "\n")
}

# Q6: Quel café recommander ?
cat("\n=== Recommandation ===\n")
moyennes_cafe <- by(cafe$acidite, cafe$cafe, mean)
print(moyennes_cafe)

cafe_moins_acide <- names(which.min(moyennes_cafe))
cat("\nRecommandation: Choisir le café", cafe_moins_acide, "\n")
cat("C'est le café perçu comme le moins acide en moyenne\n")

# Comparaisons multiples
comp_cafe <- emmeans(mod_cafe, pairwise ~ cafe, adjust = "bonferroni")
print(comp_cafe)

detach(cafe)


# =============================================================================
# EXERCICE 3: Résistance d'un textile à l'usure
# =============================================================================
# Objectif: Évaluer l'effet du type de textile sur la résistance à l'usure
#           en contrôlant les facteurs position et cycle

resistance <- read.table("resistance_textile.txt", header = TRUE)
attach(resistance)

# Convertir les variables en facteurs
resistance$position <- as.factor(resistance$position)
resistance$cycle <- as.factor(resistance$cycle)
resistance$textile <- as.factor(resistance$textile)

cat("\n=== Structure des données ===\n")
str(resistance)

# Q3: Visualisation de la perte de poids par textile
plot(perte_poids ~ textile, data = resistance,
     main = "Perte de poids par type de textile",
     xlab = "Type de textile",
     ylab = "Perte de poids (dixièmes de mg)",
     col = c("lightblue", "coral", "lightgreen", "yellow"))
abline(h = mean(perte_poids), col = "red", lwd = 3)

cat("\nObservations:\n")
cat("- Le textile A perd moins de poids en moyenne → plus résistant\n")
cat("- Le textile B perd le plus de poids → moins résistant\n")

# Q4: ANOVA à 1 facteur (textile uniquement)
cat("\n=== ANOVA à 1 facteur (textile) ===\n")
mod1_textile <- lm(perte_poids ~ textile, data = resistance)

par(mfrow = c(2, 2))
plot(mod1_textile)
par(mfrow = c(1, 1))

anova_textile1 <- anova(mod1_textile)
print(anova_textile1)

cat("\nTest d'hypothèse:\n")
cat("H₀: Le type de textile n'a pas d'effet sur la perte de poids\n")
cat("H₁: Le type de textile a un effet\n")

if (anova_textile1[1, 5] < 0.05) {
  cat("p-value =", anova_textile1[1, 5], "< 0.05\n")
  cat("→ On rejette H₀ avec un risque de 5%\n")
  cat("→ Il y a un effet significatif du type de textile sur la perte de poids\n")
}

# Q5: ANOVA à 3 facteurs (textile + position + cycle)
cat("\n=== ANOVA à 3 facteurs ===\n")
mod2_textile <- lm(perte_poids ~ textile + position + cycle, data = resistance)

par(mfrow = c(2, 2))
plot(mod2_textile)
par(mfrow = c(1, 1))

cat("\nInterprétation des graphiques:\n")
cat("- Résidus répartis de manière homogène autour de 0 ✓\n")
cat("- Variance constante (homoscédasticité) ✓\n")

anova_textile2 <- anova(mod2_textile)
print(anova_textile2)

cat("\n=== Tests d'hypothèse ===\n")
for (var in c("textile", "position", "cycle")) {
  cat("\nFacteur:", var, "\n")
  if (anova_textile2[var, "Pr(>F)"] < 0.05) {
    cat("p-value < 0.05 → Effet significatif\n")
  } else {
    cat("p-value >= 0.05 → Effet non significatif\n")
  }
}

cat("\nConclusion:\n")
cat("Les trois variables (textile, position, cycle) ont une influence\n")
cat("significative sur la perte de poids avec un risque de 5%\n")

# Q6: Test du coefficient du textile D
cat("\n=== Test du coefficient du textile D ===\n")
resume_textile <- summary(mod2_textile)
print(resume_textile)

coef_D <- resume_textile$coefficients["textileD", ]
cat("\nCoefficient du textile D:\n")
print(coef_D)

if (coef_D[4] < 0.05) {
  cat("\np-value =", coef_D[4], "< 0.05\n")
  cat("→ Le coefficient associé au textile D est significativement différent de 0\n")
  cat("   avec un risque de 5%\n")
}

# Q7: Comparaisons multiples et recommandation
cat("\n=== Comparaisons multiples (Bonferroni) ===\n")
comp_textile <- emmeans(mod2_textile, pairwise ~ textile, adjust = "bonferroni")
print(comp_textile)

cat("\n=== Interprétation ===\n")
cat("Différences significatives (p < 0.05):\n")
contrasts_df <- as.data.frame(comp_textile$contrasts)
sig_contrasts <- contrasts_df[contrasts_df$p.value < 0.05, ]
print(sig_contrasts)

cat("\n=== Recommandation ===\n")
moyennes_textile <- by(resistance$perte_poids, resistance$textile, mean)
print(moyennes_textile)

textile_resistant <- names(which.min(moyennes_textile))
cat("\nLe textile le plus résistant à l'usure est le textile", textile_resistant, "\n")
cat("Il présente la plus faible perte de poids moyenne\n")

cat("\nConclusion pour l'entreprise:\n")
cat("Recommandation: Choisir le textile", textile_resistant, "\n")
cat("C'est le textile qui résiste le mieux à l'usure dans les conditions testées\n")

detach(resistance)

# =============================================================================
# FIN DU TP4
# =============================================================================
