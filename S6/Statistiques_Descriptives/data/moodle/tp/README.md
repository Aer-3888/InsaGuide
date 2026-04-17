# TPs Statistiques Descriptives

**INSA Rennes - 3ème année INFO DS & MI**  
**Année universitaire 2021-2022**

## Vue d'ensemble

Ce répertoire contient les solutions complètes et commentées des 4 TPs de Statistiques Descriptives, couvrant les fondamentaux de l'analyse statistique avec R.

## Structure

```
tp/
├── README.md                         # Ce fichier
├── tp1_intro_r/                      # Introduction à R
│   ├── README.md                     # Guide détaillé
│   ├── Sujet TP1.pdf                 # Sujet local
│   ├── sujet_moodle.pdf              # Sujet depuis Moodle
│   ├── src/
│   │   └── TP1_solutions.R           # Solutions commentées
│   └── Donnees_TP1/                  # Jeux de données
├── tp2_regression_simple/            # Régression linéaire simple
│   ├── README.md
│   ├── Sujet TP2.pdf
│   ├── sujet_moodle.pdf
│   ├── TP 2 ex 2 correction.pdf
│   ├── src/
│   │   └── TP2_solutions.R
│   └── TP2_Donnees/
├── tp3_regression_multiple/          # Régression linéaire multiple
│   ├── README.md
│   ├── Sujet TP3.pdf
│   ├── src/
│   │   └── TP3_solutions.R
│   └── TP3_Donnees/
└── tp4_anova/                        # ANOVA
    ├── README.md
    ├── Sujet TP4.pdf
    ├── tp_note_2024-2025.pdf
    ├── src/
    │   └── TP4_solutions.R
    └── TP4_Donnees/
```

## Contenu des TPs

### TP1: Introduction au logiciel R
**Concepts:** Vecteurs, matrices, calcul matriciel, importation de données, visualisation

**Exercices:**
1. Création et manipulation de vecteurs
2. Matrices et opérations matricielles
3. Calcul matriciel pour régression multiple
4. Importation et fusion de données
5. Comparaison de distributions (loi normale vs Student)
6. Tracé de fonctions par morceaux
7. **Cas pratique:** Analyse des ouragans (fusion de tables, catégorisation, analyse descriptive)

**Compétences acquises:**
- Manipulation de structures de données R
- Algèbre matricielle pour la régression
- Import/export de fichiers
- Visualisation avec `curve()`, `hist()`, `barplot()`

### TP2: Régression linéaire simple
**Concepts:** Modèle linéaire, analyse des résidus, R², prédiction, transformations

**Exercices:**
1. **Courrier:** Régression idéale (R²=0.96)
2. **Quatuor d'Anscombe (tomassone):** Les dangers de la régression
   - Y1: cas idéal
   - Y2: non-linéarité → ajout de X²
   - Y3: valeur aberrante → détection et suppression
   - Y4: transformation log nécessaire
3. **Freinage:** Distance d'arrêt vs vitesse (modèle polynomial)
4. **Porcs:** Gain en protéines (modèle avec seuil)

**Compétences acquises:**
- Ajuster un modèle linéaire avec `lm()`
- Valider les hypothèses (graphe des résidus)
- Interpréter R², p-values, coefficients
- Calculer des prédictions et intervalles de confiance
- Diagnostiquer et corriger les problèmes (outliers, non-linéarité, hétéroscédasticité)

**Message clé:** Ne jamais se fier uniquement aux statistiques. Toujours visualiser et analyser les résidus!

### TP3: Régression linéaire multiple
**Concepts:** Régression multiple, corrélation, sélection de variables, AIC, calcul matriciel

**Exercices:**
1. **Publicité:** Impact de 3 médias (TV, Radio, Journaux) sur les ventes
   - Analyse de corrélation
   - Régression multiple
   - Tests globaux et individuels
   - Visualisation 3D avec `scatter3d()`
2. **Lait:** Prédire le rendement fromager (5 variables)
   - Multicolinéarité
   - Sélection automatique avec `step()` (backward)
   - Comparaison de modèles (AIC, R² ajusté)
   - Modèle sans intercept
3. **Eucalyptus:** Hauteur vs circonférence
   - **Calcul matriciel manuel:** β̂ = (X'X)⁻¹X'Y
   - Calcul de σ, SE(β̂), tests d'hypothèse
   - Vérification avec `lm()`

**Compétences acquises:**
- Régression multiple: `lm(Y ~ X1 + X2 + X3)`
- Interpréter les coefficients (effet d'une variable toutes choses égales par ailleurs)
- Détecter la multicolinéarité
- Sélection de variables (backward, forward, stepwise)
- Comparer des modèles avec AIC
- Comprendre les calculs matriciels derrière `lm()`

**Packages:** `rgl`, `car`

### TP4: ANOVA (Analyse de la variance)
**Concepts:** Comparaison de moyennes, ANOVA à 1 et 2 facteurs, comparaisons multiples

**Exercices:**
1. **Hotdogs:** Comparer 3 types de viande (ANOVA à 1 facteur)
   - Calories et sodium selon le type
   - Interprétation de la table d'ANOVA
   - Graphiques de diagnostic
   - Comparaisons multiples avec Bonferroni
2. **Cafés:** Acidité évaluée par 6 juges (ANOVA à 2 facteurs)
   - Effet café et effet juge
   - Modèle avec/sans interaction
   - Intérêt de contrôler l'effet juge
3. **Textiles:** Résistance à l'usure (ANOVA à 3 facteurs)
   - Facteurs: textile, position, cycle
   - Contrôle de facteurs parasites
   - Recommandation du meilleur textile

**Compétences acquises:**
- ANOVA à 1 facteur: `lm(Y ~ Facteur)`
- ANOVA à 2 facteurs: `lm(Y ~ F1 + F2)` ou `lm(Y ~ F1 * F2)`
- Interpréter une table d'ANOVA (Df, Sum Sq, Mean Sq, F, p-value)
- Comprendre les contraintes (naturelle vs témoin)
- Tests de comparaisons multiples avec `emmeans`
- Graphiques de diagnostic pour vérifier les hypothèses

**Package:** `emmeans`

## Progression pédagogique

```
TP1: Bases de R
  ↓
TP2: Régression simple (1 variable explicative)
  ↓
TP3: Régression multiple (plusieurs variables quantitatives)
  ↓
TP4: ANOVA (variables catégorielles)
```

## Concepts transversaux

### 1. Validation des modèles
Tous les TPs insistent sur la validation:
- **Visualisation:** scatter plots, boxplots
- **Graphe des résidus:** détecter les problèmes
- **Graphiques de diagnostic:** `plot(modele)`
- **Tests d'hypothèses:** normalité, homoscédasticité

### 2. Interprétation
- R²: pourcentage de variabilité expliquée
- p-values: significativité statistique
- Coefficients: effet d'une variable (interprétation différente selon le contexte)
- Intervalles de confiance vs intervalles de prédiction

### 3. Diagnostics et solutions

| Problème | Symptôme | Solution |
|----------|----------|----------|
| Non-linéarité | Résidus paraboliques | Ajouter X², X³, log, √ |
| Hétéroscédasticité | Résidus en entonnoir | Transformation log(Y) |
| Outliers | Points isolés > 2σ | Vérifier, éventuellement supprimer |
| Multicolinéarité | Coefficients instables | Enlever une variable corrélée |
| Non-normalité | Q-Q plot non linéaire | Transformation ou tests non paramétriques |

### 4. Workflow type

```r
# 1. Import
data <- read.table("file.txt", header=TRUE)
data$Facteur <- as.factor(data$Facteur)

# 2. Exploration
summary(data)
plot(X, Y)
boxplot(Y ~ Facteur)
cor(data)

# 3. Modélisation
mod <- lm(Y ~ X, data=data)          # Régression simple
mod <- lm(Y ~ X1 + X2, data=data)    # Régression multiple
mod <- lm(Y ~ Facteur, data=data)    # ANOVA

# 4. Validation
summary(mod)
anova(mod)
par(mfrow=c(2,2))
plot(mod)
par(mfrow=c(1,1))

# 5. Prédiction
predict(mod, newdata=new_df, interval="prediction")

# 6. Comparaisons (ANOVA)
library(emmeans)
emmeans(mod, pairwise ~ Facteur, adjust="bonferroni")
```

## Packages R utilisés

```r
# Installation (une fois)
install.packages("rgl")      # TP3: visualisation 3D
install.packages("car")      # TP3: outils graphiques
install.packages("emmeans")  # TP4: comparaisons multiples

# Chargement (à chaque session)
library(rgl)
library(car)
library(emmeans)
```

## Commandes R essentielles

### Manipulation de données
```r
read.table(), read.csv(), read.csv2()
attach(), detach()
subset(), merge(), cbind(), rbind()
as.factor(), order(), by()
```

### Statistiques descriptives
```r
summary(), mean(), sd(), var()
cor(), cov()
table(), by()
```

### Visualisation
```r
plot(), lines(), points(), abline()
curve(), hist(), barplot(), boxplot()
legend(), par(mfrow=c(2,2))
scatter3d()  # package car
```

### Modélisation
```r
lm()             # Régression / ANOVA
summary()        # Statistiques complètes
anova()          # Table d'ANOVA
coef()           # Coefficients
residuals()      # Résidus
fitted.values()  # Valeurs ajustées
predict()        # Prédictions
```

### Sélection de modèles
```r
step()           # Sélection automatique
extractAIC()     # Critère AIC
AIC(), BIC()     # Critères d'information
```

### Comparaisons multiples
```r
emmeans()        # Package emmeans
pairwise ~ Facteur, adjust="bonferroni"
```

### Algèbre matricielle
```r
t()              # Transposée
%*%              # Produit matriciel
solve()          # Inverse
diag(), det()    # Diagonale, déterminant
```

## Ressources

### Documentation R
- `help(fonction)` ou `?fonction`: aide sur une fonction
- `help.search("keyword")`: rechercher dans l'aide
- `example(fonction)`: exemples d'utilisation

### Jeux de données intégrés
- `data()`: lister les jeux de données disponibles
- `?mtcars`, `?iris`, etc.: documentation

### Environnement
- **RStudio:** IDE recommandé (coloration syntaxique, autocomplétion, graphiques intégrés)
- **Notebooks R Markdown:** combiner code et texte (fichiers .Rmd)

### Sites web
- CRAN: https://cran.r-project.org/
- RStudio: https://www.rstudio.com/
- Quick-R: https://www.statmethods.net/

## Notes importantes

### Indexation R
- **Les indices commencent à 1** (pas 0 comme en Python/C)
- `df[1, ]`: première ligne
- `df[, 1]`: première colonne
- `df[-3]`: tout sauf la colonne 3

### Différences CSV
- `read.csv()`: sep=",", dec="."
- `read.csv2()`: sep=";", dec=","
- Adapter selon le format de vos données

### attach() vs $
```r
# Avec attach()
attach(data)
plot(X, Y)
detach(data)

# Sans attach()
plot(data$X, data$Y)
```
**Attention:** `attach()` peut créer des conflits de noms. Utiliser avec précaution.

### Formules R
- `Y ~ X`: Y en fonction de X
- `Y ~ X1 + X2`: modèle additif
- `Y ~ X1 * X2`: modèle avec interaction (équivalent à `X1 + X2 + X1:X2`)
- `Y ~ .`: Y en fonction de toutes les autres colonnes
- `Y ~ -1 + X` ou `Y ~ 0 + X`: sans intercept
- `Y ~ X + I(X^2)`: transformation dans la formule

## Exécution des TPs

### Option 1: Par TP
```r
# TP1
setwd("~/Documents/Project/Insa/S6/Statistiques_Descriptives/tp/tp1_intro_r")
source("src/TP1_solutions.R")

# TP2
setwd("~/Documents/Project/Insa/S6/Statistiques_Descriptives/tp/tp2_regression_simple")
source("src/TP2_solutions.R")

# etc.
```

### Option 2: Interactif (RStudio)
1. Ouvrir le fichier .R dans RStudio
2. Exécuter ligne par ligne: `Ctrl+Enter`
3. Exécuter un bloc: sélectionner + `Ctrl+Enter`
4. Exécuter tout: `Ctrl+Shift+Enter`

### Option 3: Par exercice
Chaque fichier .R est structuré en sections commentées. Exécuter uniquement les sections qui vous intéressent.

## Conseils pour l'apprentissage

1. **Pratiquer:** Refaire les exercices sans regarder les solutions
2. **Expérimenter:** Modifier les paramètres, tester d'autres jeux de données
3. **Visualiser:** Toujours tracer avant de modéliser
4. **Comprendre:** Ne pas se contenter d'exécuter, comprendre chaque ligne
5. **Documenter:** Commenter son code pour se souvenir du raisonnement

## Fichiers originaux

Les fichiers originaux (scripts non commentés, notebooks RMD) ont été déplacés dans `_originals/` pour référence. Les versions dans `src/` sont nettoyées, commentées et organisées.

## Auteurs

- **Solutions originales:** Léandre, Hugo (2021-2022)
- **Documentation et nettoyage:** Claude Code (2026)

---

**Bon courage pour vos révisions !** 📊📈

Pour toute question, se référer aux README de chaque TP qui contiennent des explications détaillées.
