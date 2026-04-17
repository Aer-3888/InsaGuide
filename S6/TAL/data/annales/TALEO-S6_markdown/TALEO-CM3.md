---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
# Résumé complet : Représentation de documents (TALEO Cours #3)

## Structure générale du cours TALEO

**Cours magistraux (14h) :**

- Lecture 1 : Introduction au NLP
- Lecture 2 : Représentation des mots
- **Lecture 3 : Représentation des documents** (ce cours)
- Lecture 4 : Recherche d'information
- Lecture 5 : Outils fondamentaux pour le NLP
- Lecture 6 : Modélisation du langage
- Lecture 7 : Application à l'analyse syntaxique

**Travaux pratiques (12h) :**

- Word embeddings (2h)
- Recherche d'information (6h)
- Classification de documents (4h)

## 1. Définition et tokenisation des documents

### Qu'est-ce qu'un document ?

- **Définition large** : tout contenu textuel (livre, chapitre, paragraphe, phrase, article de journal/web, tweet, post Facebook/blog)
- **Prérequis** : documents pré-tokenisés → un document = ensemble ordonné de tokens
- **Exemple concret** : `['[CLS]', 'i', 'never', 'heard', 'of', 'this', 'film', 'til', 'it', 'played', 'as', 'part', 'of', 'a', 'robert', 'mitch', '##um', 'retrospective', ...]`

### Objectifs de la représentation

Représenter les documents comme **vecteurs de caractéristiques de dimension fixe** pour :

- Classification thématique
- Détection de polarité et sentiment
- Comparaison de documents (recherche d'information)
- **Hypothèse fondamentale** : "bag of words" = l'ordre des tokens n'importe pas
- Implémentation possible d'une sélection de vocabulaire pertinent

## 2. Approche Naive Bayes

### Principe théorique

**Règle de Bayes simplifiée** :

```
p(c|d) = p(d|c)p(c)
```

**Hypothèse d'indépendance** : chaque mot w ∈ d = {w₁, ..., wₙ} est indépendant

```
p(d|c) = ∏(i=1 à n) p(wᵢ|c)
```

### Estimation des probabilités conditionnelles

**Deux estimateurs possibles** :

1. **Estimateur binaire** (présence/absence) :

```
p(w|c) = Σ(d∈Dc) δ(w,d) / Σ(v∈V) Σ(d∈Dc) δ(v,d)
```

2. **Estimateur fréquentiel** (nombre d'occurrences) :

```
p(w|c) = Σ(d∈Dc) n(w,d) / Σ(v∈V) Σ(d∈Dc) n(v,d)
```

Où : δ(w,d) = 1 si w dans d, 0 sinon ; n(w,d) = nombre d'occurrences de w dans d

### Exemple pratique

**Données d'entraînement** :

1. classe = love, contenu = {aimer: 5, manger: 0, Paul: 1, Virginie: 1, je: 5}
2. classe = love, contenu = {aimer: 3, manger: 0, Paul: 0, Virginie: 0, je: 4}
3. classe = food, contenu = {aimer: 0, manger: 2, Paul: 0, Virginie: 1, je: 5}
4. classe = food, contenu = {aimer: 2, manger: 2, Paul: 0, Virginie: 0, je: 3}

**Résultats avec estimateur binaire** :

- Classe love : P[aimer]=2/6, P[manger]=0/6, P[Paul]=1/6, P[Virginie]=1/6, P[je]=2/6
- Classe food : P[aimer]=1/6, P[manger]=2/6, P[Paul]=0/6, P[Virginie]=1/6, P[je]=2/6

## 3. Régularisation et lissage

### Problème des probabilités nulles

**Cas problématique** : document d = {aimer: 0, manger: 10, Paul: 1, Virginie: 0, je: 0}

- P[d|c=love] = 0.5 × (0)¹⁰ × 1/6 = 0
- P[d|c=food] = 0.5 × (2/6)¹⁰ × 0 = 0

### Solutions de lissage

1. **Lissage additif (Laplace)** :

```
p(w|c) = (1 + Σ(d∈Dc) n(w,d)) / (|V| + Σ(d∈Dc) nd)
```

2. **Lissage par interpolation** :

```
p(w|c) = (λP[w] + Σ(d∈Dc) n(w,d)) / (λ + Σ(d∈Dc) nd)
```

3. **Lissage Good-Turing** : redistribution des probabilités basée sur les fréquences

```
n*(w) = (n(w) + 1) × nc(w)+1 / nc(w)
```

### Loi de Zipf et importance du lissage

**Observation fondamentale** : les événements fréquents sont rares et les événements rares sont fréquents

```
rang(w) × fréq(w) = constante
```

**Exemple statistiques du Monde 2003** :

- Rang 1 : "de" (227306 occurrences)
- Rang 2 : "la" (59053 occurrences)
- Rang 274928 : "académisé" (1 occurrence)

## 4. Maximum d'entropie

### Principe théorique

**Objectif** : modéliser directement p(c|d) sous le principe du maximum d'entropie **Entropie** : H(X) = E[-log P(x)] = -Σᵢ P(xᵢ) log P(xᵢ)

### Distribution de maximum d'entropie

**Forme générale** :

```
P[A = aᵢ] = (1/Z) exp(Σ(k=1 à m) λₖ fₖ(aᵢ))
```

Où :

- λₖ : paramètres déterminés par les contraintes
- Z : fonction de normalisation (fonction de partition)
- fₖ(a) : fonctions de caractéristiques mesurables

### Application à la classification

**Modèle résultant** :

```
P[C = k|d] = exp(λ₀⁽ᵏ⁾ + λ₁⁽ᵏ⁾x₁ + ... + λₙ⁽ᵏ⁾xₙ) / Σᵢ exp(λ₀⁽ⁱ⁾ + λ₁⁽ⁱ⁾x₁ + ... + λₙ⁽ⁱ⁾xₙ)
```

**≡ Régression logistique multinomiale**

### Fonctions de caractéristiques

**Exemples de faits mesurables fᵢ(d)** :

- Proportion de mots traduits d'une certaine manière
- Proportion de mots positifs/négatifs/neutres
- Proportion de mots grossiers ou d'arrêt
- Proportion de pronoms personnels
- Présence de mots dans une liste de fruits
- etc.

## 5. Modèle sac de mots (Bag-of-Words)

### Principe

Assigner un poids à chaque mot possible dans un vocabulaire de taille fixe selon son apparition dans le document.

### Étapes de construction

#### Étape 1 : Sélection des termes

- **Tokenisation et normalisation**
- **Lemmatisation, racinisation** ou aucune
- **Sélection de termes pertinents** :
    - Par fréquence, POS (Nom/Verbe/Adjectif)
    - Listes de mots vides (stop lists)
    - Crucial pour la recherche, moins pour la classification

#### Étape 2 : Attribution des poids

1. **Indicateur binaire** : δ(w,d) → encodage 1-hot
2. **Nombre d'occurrences** : n(w,d)
3. **Fréquence d'occurrence** : n(w,d) / Σ(v∈V) n(v,d)

**Problème** : mots fréquents, généralement peu informatifs (mots fonctionnels)

## 6. Pondération TF-IDF

### Formule complète

```
f(w,d) = [n(w,d) / Σ(v∈V) n(v,d)] × log[|D| / Σ(d'∈D) δ(w,d')]⁻¹
```

**Composantes** :

- **TF (Term Frequency)** : fréquence du terme normalisée
- **IDF (Inverse Document Frequency)** : inverse de la fréquence documentaire

### Exemple pratique

**Données** : mêmes 4 documents que précédemment

**Pour "aimer"** :

- Apparaît dans 3 documents sur 4 : idf(aimer) = log(4/3) ≃ 0.125
- 5 occurrences dans doc1 sur 12 tokens : tf(aimer,doc1) = 5/12 ≃ 0.417
- **Poids final** : tf(aimer,doc1) × idf(aimer) ≃ 0.052

**Tableau complet** :

|Mot|IDF|Doc1|Doc2|Doc3|Doc4|
|---|---|---|---|---|---|
|aimer|0.125|0.052|0.054|0|0.036|
|manger|0.301|0|0|0.077|0.089|
|Paul|0.602|0.050|0|0|0|
|Virginie|0.301|0.025|0|0.038|0|
|je|0|0|0|0|0|

## 7. Modèle d'espace vectoriel

### Métriques fondamentales

**Dans l'espace vectoriel, définition de métriques** :

- **Produit scalaire** : x·y = Σᵢ xᵢyᵢ
- **Norme L2** : ||x-y|| = √(Σᵢ(xᵢ-yᵢ)²)
- **Cosinus** : cosine(x,y) = (x·y)/(||x|| ||y||)

### Applications en classification

**Tous les classificateurs basés sur les caractéristiques peuvent être utilisés** :

1. **k-plus proches voisins** dans l'espace vectoriel
2. **Régression logistique** : p(c|d) = 1/(1 + exp(α₀ + Σ(w∈d) αw f(w,d)))
3. **Machines à vecteurs de support** : ĉ = sign(Σ(w∈V) αw f(w,d) - α₀)
4. **Réseaux de neurones feed-forward**

## 8. Variantes avec variables latentes

### Limites du modèle BoW

- **Pas d'ordre des mots** (prix à payer pour la simplicité)
- **Représentation très parcimonieuse, haute dimension**
- **Absence de sémantique distributionnelle** (chat ≠ minou)
- **Impossible de comparer des documents sans mots communs**

### Solution : représentations compactes et efficaces

Recherche de représentations de petite taille, compactes et efficaces utilisables directement plutôt que les vecteurs BoW.

## 9. Plongements de documents (Document Embeddings)

### Couche d'embedding

**Opération de base** : convertir un token en représentation embeddings dans ℝᵈ

- Matrice d'embedding A entraînable comme tout paramètre de réseau de neurones

### Moyenne des embeddings de mots

**Solution simple et efficace** :

```
d⃗ = (1/nd) Σ(i=1 à nd) embedding(wᵢ)
```

- Peut être combinée avec sélection de termes
- Pas nécessairement besoin de sélection

## 10. Auto-encodeurs

**Mention** : technique d'apprentissage de représentations compactes (détails non développés dans les slides)

## 11. Réseaux de neurones récurrents (RNN)

### Principe de base

```
hᵢ = f(hᵢ₋₁, wᵢ) = résumé de l'entrée jusqu'à wᵢ
hₙ = f(hₙ₋₁, wₙ) = résumé du document
```

### Réseau d'Elman simple

**Composantes** :

- **Couche d'embedding** : xᵢ = c(wᵢ)
- **Couche de fusion** : yᵢ = xᵢ + hᵢ₋₁
- **Prédiction d'état** : hᵢ = σ(Uyᵢ) ou σ(Uccᵢ + Uhhᵢ₋₁)

### Cellules récurrentes complexes

#### LSTM (Long Short-Term Memory)

```
iₜ = σᵢ(Wᵢxₜ + Uᵢhₜ₋₁ + bᵢ)     # gate d'entrée
fₜ = σf(Wfxₜ + Ufhₜ₋₁ + bf)     # gate d'oubli
oₜ = σ(Wₒxₜ + Uₒhₜ₋₁ + bₒ)      # gate de sortie
cₜ = fₓ ⊙ cₜ₋₁ + iₜ ⊙ σc(Wcxₜ + Uchₜ₋₁)  # état de cellule
hₜ = oₜ ⊙ σh(cₜ)                # état caché
```

#### GRU (Gated Recurrent Unit)

```
zₜ = σz(Wzxₜ + Uzhₜ₋₁ + bz)     # gate de mise à jour
rₜ = σr(Wrxₜ + Urhₜ₋₁ + br)     # gate de reset
h̃ₜ = σh(Whxₜ + Uh(rₜ ⊙ hₜ₋₁) + bh)  # candidat d'état
hₜ = (1-zₜ) ⊙ hₜ₋₁ + zₜ ⊙ h̃ₜ    # état final
```

## 12. Évaluation des embeddings de phrases

### Évaluations intrinsèques

**Semantic Textual Similarity Benchmark** :

- Exemple : "We must find other ways" vs "Other ways are needed" → score 4.4
- Contre-exemple : "I absolutely do believe there was an iceberg..." vs "I don't believe there was any iceberg..." → score 1.2

### Évaluations extrinsèques (basées sur tâches)

#### GLUE (General Language Understanding Evaluation) pour l'anglais

1. **CoLA** : Corpus of Linguistic Acceptability (phrase grammaticale ou non)
2. **SST** : Stanford Sentiment Treebank (prédiction de valence)
3. **MRPC** : Microsoft Research Paraphrase (équivalence sémantique)
4. **QQP** : Quora Question Pairs (équivalence sémantique)
5. **MNLI** : Multi-Genre Natural Language Inference (prédiction d'implication)
6. **RTE** : Recognizing Textual Entailment
7. **SQuAD** : Stanford Question Answering (paragraphe contient réponse)
8. **WSC** : Winograd Schema Challenge (prédiction de référence)

#### FLUE : équivalent français récent de GLUE

Développé par Hang Le et al. (2019) avec FlauBERT

## 13. Classification avec embeddings

### Approches principales

**Document embedding = espace vectoriel** → tout classificateur fonctionne

**Utilisations courantes avec réseaux feed-forward** :

- **Embeddings pré-entraînés fixes**
- **Ré-entraînement de la couche d'embedding**

### Application au ranking en recherche d'information

**Fonctions de perte spécifiques, ex. triplet loss** :

```
L(a,p,n) = max(||f(a) - f(p)||² - ||f(a) - f(n)||² + α, 0)
```

Où :

- a : ancre (requête)
- p : exemple positif (document pertinent)
- n : exemple négatif (document non pertinent)
- α : marge
- f : fonction d'embedding

## Concepts clés à retenir

1. **Hypothèse bag-of-words** : l'ordre n'importe pas pour beaucoup d'applications
2. **TF-IDF** : pondération fondamentale pour équilibrer fréquence locale et globale
3. **Naive Bayes** : approche probabiliste simple mais efficace
4. **Maximum d'entropie** : équivalent à la régression logistique multinomiale
5. **Embeddings** : représentations denses vs représentations parcimonieuses
6. **RNNs** : prise en compte de l'ordre séquentiel pour les embeddings
7. **Évaluation** : importance des benchmarks standardisés (GLUE/FLUE)
8. **Lissage** : crucial à cause de la loi de Zipf et de la parcimonie des données