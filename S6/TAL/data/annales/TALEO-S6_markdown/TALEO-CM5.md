---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
# Résumé - Modèles de séquence pour les tâches d'étiquetage (TALEO)

## Introduction générale

Ce cours fait partie du programme TALEO (14h de cours + 12h de TP) couvrant le traitement automatique du langage naturel, incluant la représentation des mots et documents, la recherche d'information, la modélisation de langue et l'analyse syntaxique.

## Les tâches d'étiquetage

### Définition et exemples

Les tâches d'étiquetage consistent à assigner une étiquette unique à chaque token dans une phrase. Exemples typiques :

**Détection de limites de phrase :**

- "The cat is black The dog is brown" → [0 0 0 1 0 0 0 1]

**Compréhension de langue (slot filling) :**

- "Je veux un resto italien à Rennes" → [nil nil nil quoi_1 quoi_2 nil où]

**Étiquetage d'entités nommées :**

- "À Marseille Jean-Claude Gaudin est élu depuis 1995"
- → [O B-LOC B-NP I O O O B-TIME]

### Le système BIO

Système fondamental avec trois étiquettes spéciales :

- **B** : Beginning (début d'entité)
- **I** : Inside (à l'intérieur d'entité)
- **O** : Outside (hors entité)

Se généralise à diverses tâches comme le chunking, slot filling, parsing.

## Approches naïves

### Approches basées sur des règles

- Lister toutes les étiquettes possibles pour chaque token
- Appliquer des règles locales pour désambiguïser
- Limité par l'ambiguïté des étiquettes

### Classificateurs locaux

- Classificateur appliqué indépendamment à chaque token
- Regarde le contexte environnant
- Simple et efficace computationnellement
- **Problème** : ignore les dépendances entre étiquettes et les dépendances à long terme

## Modèles probabilistes d'étiquetage

### Formulation générale

- Séquence observée : w = {w₁, ..., wₙ}
- Séquence latente d'étiquettes : t = {t₁, ..., tₙ}
- Objectif : t̂ = arg max_t p(t|w) = arg max_t p(w,t)

Deux modèles principaux :

1. **Modèles de Markov cachés (HMM)**
2. **Champs aléatoires conditionnels linéaires (CRF)**

## Modèles de Markov Cachés (HMM)

### Modélisation

p(t,w) = p(w|t)p(t)

**Hypothèses simplificatrices :**

- **Hypothèse de Markov** sur t (ordre 2) : P[t₁,...,tₙ] = ∏ P[tᵢ|tᵢ₋₁]
- **Indépendance conditionnelle** de w|t : P[w₁,...,wₙ|t₁...tₙ] = ∏ P[wᵢ|tᵢ]

**Expression finale :** P[w,t] = P[t₁]P[w₁|t₁] ∏ᵢ₌₂ⁿ P[tᵢ|tᵢ₋₁]P[wᵢ|tᵢ]

### Chaînes de Markov - Rappel théorique

- Processus de Markov avec observations Xₜ dans un espace d'états discret [1,N]
- Simplifie la règle de chaîne : P[X₁,...,Xₙ] = P[X₁] ∏ P[Xᵢ|Xᵢ₋₁]

**Paramètres d'une chaîne homogène :**

- Probabilités initiales : πᵢ = P[X₁ = i]
- Probabilités de transition : aᵢⱼ = P[Xₜ = j|Xₜ₋₁ = i] avec Σⱼ aᵢⱼ = 1

**Exemple météo** avec 3 états {pluie, nuage, soleil} :

- Matrice de transition A et probabilités initiales π
- Calcul de probabilité d'une séquence par produit des transitions

### Modèle HMM complet

**Paramètres du modèle λ = (A, B, π) :**

- A : matrice de transition entre états
- B : matrice d'émission (probabilités d'observation par état)
- π : distribution initiale

**Probabilités d'émission :** P[wᵢ = w|tᵢ = k] = bₖ(w) (modèle homogène)

### Inférence avec HMM

**Recherche de la meilleure séquence :** t̂ = arg max ln(P[t₁]P[w₁|t₁] ∏ᵢ₌₂ⁿ P[tᵢ|tᵢ₋₁]P[wᵢ|tᵢ])

**Algorithme de Viterbi :** Récursion efficace sur H(i,k) = max probabilité jusqu'à la position k avec état i

**Estimation des paramètres :** Par comptage sur données d'entraînement étiquetées, possiblement avec lissage

### Performance des HMM

- Excellent pour tâches basiques (étiquetage POS ~98% de précision)
- Moins efficace pour étiquettes complexes (entités nommées, dépendances, slot filling)
- **Limitations :** hypothèse de Markov et indépendance conditionnelle trop restrictives

## Champs Aléatoires Conditionnels (CRF)

### Motivation

Les HMM ont des limitations pour les tâches complexes car :

- L'hypothèse de Markov est moins pertinente
- L'indépendance conditionnelle n'est certainement pas vraie

Solution : modèles d'entropie maximale pour exprimer p(t|w) comme un CRF linéaire

### Théorie de l'entropie maximale

Pour une variable A prenant valeurs dans {a₁,...,aₙ} avec contraintes exprimées par m fonctions de caractéristiques fₖ(a) :

**Distribution d'entropie maximale :** P[A = aᵢ] = (1/Z) exp(Σₖ λₖfₖ(aᵢ))

où Z est la fonction de partition normalisatrice.

### CRF linéaire pour séquences

**Expression générale :** P[t|w] = (1/Z(w)) exp(Σₖ λₖfₖ(t,w))

**Fonctions de caractéristiques :** fₖ(t₁,w₁,...,tₙ,wₙ) = Σₛ fₖ(tₛ₋₁,tₛ,w,s)

### Passage HMM → CRF

Les HMM peuvent être vus comme cas particulier de CRF :

**Dans HMM :** P[w,t] = ∏ₛ atₛ₋₁,tₛ btₛ(wₛ) = exp(Σₛ Σᵢ,ⱼ λᵢⱼδ(tₛ₋₁=j,tₛ=i) + Σₛ Σᵢ,ᵤ λ'ᵢᵤδ(tₛ=i,wₛ=u))

**Fonctions de caractéristiques types :**

- f₁(tₛ₋₁,tₛ) = δ(tₛ₋₁=j,tₛ=i) : transition de j vers i
- f₂(tₛ,w) = δ(tₛ=i,wₛ=u) : mot u avec étiquette i

### Fonctions de caractéristiques avancées

Les CRF permettent des fonctions arbitraires tant qu'elles respectent la décomposition :

**Exemples :**

- f₁(tₛ₋₁,tₛ,w,s) = δ(tₛ₋₁=j,tₛ=i,wₛ=v)
- f₂(tₛ₋₁,tₛ,w,s) = δ(tₛ=i,wₛ₋₄=u,wₛ₊₂=v)
- f₃(tₛ₋₁,tₛ,w,s) = δ(tₛ=i,wₛ₋₁=u,wₛ=v,posₛ='ADJ')

### Définition pratique des caractéristiques

**Templates dans les outils (CRF++, Wapiti) :**

```
U00:%x[-2,0]    # regarde w_{k-2}
U01:%x[-1,0]    # regarde w_{k-1}
U17:%x[1,0]/%x[1,1]  # regarde w_{k+1} et pos_{k+1}
```

**Génération automatique :** À partir des templates, génération de fonctions binaires pour chaque combinaison étiquette/observation

### Inférence avec CRF

**Recherche de la meilleure séquence :** t̂ = arg max Σᵢ λᵢfᵢ(t,w) = arg max Σₛ gₛ(tₛ₋₁,tₛ)

**Algorithme type Viterbi :** Récursion efficace similaire aux HMM

**Estimation des paramètres :**

- Optimisation par gradient (BFGS, iterative scaling)
- Outils disponibles : CRF++, Wapiti

## Réseaux de neurones récurrents (RNN)

### Architecture de base

**Composants :**

- Couche d'embedding : xₜ = C(wₜ)
- Couche de fusion : x̃ₜ = cₜ + hₜ₋₁
- Prédiction d'état : hₜ = σ(Ux̃ₜ)
- Prédiction de sortie : ŷₜ = softmax(Vhₜ)

**Décision :** ĉₜ = arg maxᵢ ŷₜ(i)

**Fonction objectif :** Entropie croisée catégorielle J(θ = {C,U,V}) = -ΣᵢΣₜΣⱼ δ(y⁽ᵢ⁾ₜ = j) ln(ŷ⁽ᵢ⁾ₜ(j))

### RNN bidirectionnels

**Principe :**

- hᵢ : résumé de la séquence jusqu'à la position i
- h'ᵢ : résumé à partir de la position i
- hᵢ + h'ᵢ : représentation de wᵢ dans le contexte complet de la phrase

### Extensions avancées

**RNN hiérarchiques :** Architecture multi-niveaux pour capture de structures complexes

**RNN compositionnels :** Intégration de représentations caractère-niveau pour vocabulaire ouvert

## Comparaison des approches

### HMM

**Avantages :**

- Simple et efficace
- Bon pour tâches basiques
- Interprétation probabiliste claire

**Inconvénients :**

- Hypothèses restrictives
- Performance limitée sur tâches complexes

### CRF

**Avantages :**

- Flexibilité dans les fonctions de caractéristiques
- Meilleure performance sur tâches complexes
- Modèle discriminant (p(t|w) directement)

**Inconvénients :**

- Plus complexe à implémenter
- Définition manuelle des caractéristiques

### RNN

**Avantages :**

- Apprentissage automatique des représentations
- Capture des dépendances à long terme
- Flexible et puissant

**Inconvénients :**

- Boîte noire
- Nécessite beaucoup de données
- Plus coûteux computationnellement

## Applications pratiques

**Domaines d'application :**

- Étiquetage morpho-syntaxique
- Reconnaissance d'entités nommées
- Analyse de sentiments au niveau token
- Segmentation de mots
- Compréhension de langue parlée

**Considérations pratiques :**

- Choix du modèle selon la complexité de la tâche
- Quantité de données disponibles
- Contraintes computationnelles
- Besoin d'interprétabilité