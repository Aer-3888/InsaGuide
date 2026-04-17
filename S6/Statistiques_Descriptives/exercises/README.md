# Exercices resolus -- Statistiques Descriptives (S6)

Ce dossier contient les solutions detaillees des TD et TP du cours. Les TPs incluent le code R complet, les sorties console attendues, et l'interpretation statistique de chaque resultat.

## TD (Travaux Diriges)

| Fichier | Theme | Exercices couverts |
|---------|-------|--------------------|
| [TD1 -- Estimation](td1_estimation.md) | Methode des moments, MLE, IC, convergence | Geometrique, Gamma, Uniforme, Poisson, Delta, Exponentielle |
| [TD2 -- Tests](td2_tests.md) | Tests d'hypothese sur moyenne, variance, proportion | Normal, Exponentiel, Disques durs, Proportion, Poisson, Airbags |
| [TD3 -- Modeles lineaires](td3_modeles_lineaires.md) | Regression multiple, calcul matriciel, ANOVA | Regression matricielle, ANOVA 1 facteur |

## TP (Travaux Pratiques) -- Walkthroughs detailles

Chaque TP inclut :
- Le contexte et les donnees brutes
- Le code R complet pour chaque question
- Les sorties console (summary, anova, predict)
- L'interpretation statistique de chaque nombre (R^2, p-values, coefficients)
- Les graphiques de diagnostic et leur lecture
- La procedure en 5 etapes pour chaque test d'hypothese
- Un arbre de decision / resume en fin de TP

| Fichier | Theme | Donnees | Points cles |
|---------|-------|---------|-------------|
| [TP1 -- Introduction a R](tp1_intro_r.md) | Vecteurs, matrices, import, visualisation | mtcars, ouragans | rep(), merge(), apply(), calcul beta = (X'X)^-1 X'Y |
| [TP2 -- Regression simple](tp2_regression_simple.md) | Regression, residus, prediction | Courrier, Anscombe, Freinage, Porcs | Diagnostic des residus, transformations, modele a seuil |
| [TP3 -- Regression multiple](tp3_regression_multiple.md) | Regression multiple, AIC, step(), matriciel | Publicite, Lait, Eucalyptus | Multicolinearite, backward selection, calcul matriciel complet |
| [TP4 -- ANOVA](tp4_anova.md) | ANOVA 1 et 2 facteurs, emmeans | Hotdogs, Cafe, Textile | Table ANOVA decomposee, Bonferroni, controle facteurs parasites |

## TP Note (Examen pratique)

| Fichier | Theme |
|---------|-------|
| [TP Note 2024](tp_note_2024.md) | Regression (tabac, masse grasse) + ANOVA (textile) |
