---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
# Résumé Exhaustif - Modélisation du Langage Naturel (TALEO)

## Structure du Cours

**Cours TALEO** par Guillaume Gravier (guillaume.gravier@irisa.fr)

- **14h de cours** : Introduction NLP, représentation des mots et documents, recherche d'information, modèles de séquences, modélisation du langage, analyse syntaxique
- **12h de TP** : Word embeddings (2h), recherche d'information (6h), classification de documents (4h)

## 1. Introduction aux Modèles de Langage

### Définition et Utilité

Un **modèle de langage** définit une distribution de probabilité sur les phrases d'un vocabulaire V.

- Exemples : P["Cette phrase est très probable"] vs P["Phrase cette pas très probable est"]
- **Applications principales** :
    - Identification de langue
    - Reconnaissance vocale et traduction automatique
    - Correction orthographique et prédiction de texte
    - Grammaires probabilistes

### Types d'Approches

- **Grammaires probabilistes** : puissantes mais complexes et peu robustes
- **Modèles n-grammes** : simples, robustes et efficaces
- **Modèles neuronaux** : plus sophistiqués et performants

## 2. Définition du Vocabulaire

### Étapes de Préparation

1. **Sélection des mots** : garder les k mots les plus fréquents (64k-200k en pratique)
2. **Tokenisation** pour améliorer la couverture :
    - URLs, nombres, unités
    - Traits d'union et apostrophes (prud'homme, d', l', s')
    - Locutions (ad_hoc, il_y_a, c'est_à_dire)
    - Suppression de ponctuation

### Gestion du Vocabulaire

- **Vocabulaire ouvert vs fermé** : technique du token `<unk>`
- **Tokenisation sous-mot** (implique vocabulaire fermé)
- **Exemple de normalisation** :
    - Original : "Si jamais il devait arriver malheur à Karl Wendlinger..."
    - Normalisé : "si jamais il devait arriver malheur à Karl_Wendlinger..."

## 3. L'Approximation N-gramme

### Problème de la Probabilité de Phrase

Calcul exact : P[Jean aime Marie qui aime Paul] = P[Jean] × P[aime|Jean] × P[Marie|Jean aime] × ...

### Solution N-gramme

**Approximation** : P[wi|w1, w2, ..., wi-1] ≈ P[wi|wi-n+1, ..., wi-1]

**Exemples** :

- **Bigramme (n=2)** : P[wi|wi-1]
- **Trigramme (n=3)** : P[wi|wi-2, wi-1]

### Représentations

- **Tables de distribution** : ensemble de tables de probabilités pour chaque historique possible
- **Graphe stochastique** : représentation sous forme de graphe avec transitions probabilistes

### Génération de Texte

Échantillonnage depuis les distributions P[w|h] :

1. Choisir mot initial selon P[u|ε]
2. Choisir mots suivants selon P[wi|historique]
3. Similaire à une marche aléatoire dans le graphe du modèle

**Exemples de génération** :

- Ordre 1 : "REPRESENTING AND SPEEDILY IS AN GOOD APT..."
- Ordre 2 : "THE HEAD AND IN FRONTAL ATTACK ON AN ENGLISH WRITER..."

## 4. Évaluation : La Perplexité

### Définition

**Perplexité** : mesure de la qualité de prédiction d'une distribution de probabilité

- Dérivée de l'entropie croisée : H(q,p̃) = -∑x p̃(x) log2(q(x))
- **Formule** : P(q, x1n) = 2^(-1/n ∑ log2(q(xi)))

### Propriétés

- **Plus la perplexité est faible, meilleur est le modèle**
- Interprétée comme le nombre moyen de suppositions pour prédire le mot suivant
- **Relation avec la vraisemblance** : P(q,w) = k√(1/Pq(w1,...,wk))
- Toujours mesurée par rapport à un corpus donné

## 5. Estimation des Probabilités

### Estimation par Maximum de Vraisemblance

**Formule** : P_ML[w|h] = C(hw)/C(h) = (nombre d'occurrences de hw)/(nombre d'occurrences de h)

### Problème de Zipf

**Observations empiriques** sur différentes tailles de corpus :

- Les **singletons** (mots n'apparaissant qu'une fois) sont très nombreux
- Plus l'ordre n augmente, plus le nombre de n-grammes distincts explose
- Problème de **sparsité des données**

## 6. Techniques de Lissage (Smoothing)

### Principe du Discounting

Emprunter de la masse probabiliste aux événements observés et la redistribuer aux événements non observés.

### Techniques Principales

#### Lissage de Laplace (Add-One)

- c*(hw) = c(hw) + 1
- P[w|h] = (c(hw) + 1)/(c(h) + |V|)

#### Lissage Dirichlet Unigramme

- c*(hw) = c(hw) + λP[w]
- P[w|h] = (c(hw) + λP[w])/(∑v c(hv) + λP[v])

#### Techniques Avancées

- **Discounting absolu** : f*(hw) = max(c(hw) - δ, 0)/∑v c(hv)
- **Discounting Kneser-Ney** : raffinement où δ dépend de h
- **Discounting Good-Turing** : c*(hw) = (c(hw) + 1) × nc(hw)+1/nc(hw)

## 7. Interpolation et Back-off

### Interpolation Linéaire

Les n-grammes avec historiques courts sont mieux estimés.

**Types** :

- **Standard** : PI[w|hn] = ∑i=0n λi PML[w|hi]
- **Récursive** : PI[w|hn] = λ(hnw)PML[w|hn] + (1-λ(hnw))PI[w|hn-1]

### Back-off (Retour en Arrière)

Utiliser estimation biaisée si assez d'observations, sinon revenir à un historique plus court :

Pbo[w|h] = { c*(hnw)/C(hn) si c(hnw) > 0 α(hn)Pbo[w|hn-1] sinon }

### Combinaison Good-Turing + Back-off

Pk[w|hn] = { c(hnw)/C(hn) si c(hnw) > k c*(hnw)/C(hn) si 0 < c(hnw) < k α(hn)Pk[w|hn-1] sinon }

## 8. Au-delà des N-grammes

### Limitations des N-grammes

- Dépendances à court terme uniquement
- Modèle simpliste malgré son efficacité

### Approches Alternatives

#### Modèles de Classes

P[wk|wi wj] = P[ck|ci cj] × P[wk|ck]

#### Modèles d'Entropie Maximale

P[wi|wi-1...wi-n+1] = (1/Z) exp(∑i λi fi(wi,...,wi-n+1))

#### Modèles de Cache et Trigger

Taille d'historique variable selon le contexte.

## 9. Modèles de Langage Neuronaux

### Modèle Feed-Forward (Bengio et al. 2003)

**Architecture** :

1. **Embedding** c() : mapping des tokens vers Rd
2. **MLP avec softmax** : P[wi|wi-1...wi-n+1] = exp(ywi)/∑k exp(yk)

**Formules** :

- y = U tanh(Hx + b) ou y = b + Wx + U tanh(Hx + b)
- **Fonction objectif** : J = (1/T)∑t log f(wit,...,wit-n+1; Θ) + R(Θ)

### Modèles Récurrents (RNN)

#### Architecture de Base

- Utilisation de l'état caché hi-1 comme résumé de l'historique
- P[wi|wi-1...w1] ≈ f(wi, hi-1)
- **Beaucoup moins de paramètres** que l'approche feed-forward

#### Entraînement

- **Auto-supervisé** sur grandes quantités de texte
- **Objectif** : maximiser log-vraisemblance (minimiser entropie croisée)
- J(Θ) = ∑t log(yt(index(wt+1)))

#### Modèles Bidirectionnels

- **Principe** : P[w1...wn] = P[wn]P[wn-1|wn]...P[w1|w2...wn]
- **Architecture** :
    - ht = f(ht-1, wt) : encode w1,...,wt → prédit wt+1
    - h't = f'(h't+1, wt) : encode wt,...,wn → prédit wt-1
    - **Prédiction** : yt = softmax(A[ht-1 h't+1] + b)

### Applications Pratiques

- **Génération de texte** par échantillonnage
- **Modélisation contextuelle** (LSTM pour génération d'images avec légendes)
- **Amélioration continue** des performances

## Points Clés pour Questions d'Examen

1. **Concepts fondamentaux** : définition modèle de langage, perplexité, approximation n-gramme
2. **Estimation** : maximum de vraisemblance, problème de sparsité
3. **Techniques de lissage** : Laplace, Good-Turing, interpolation, back-off
4. **Évaluation** : calcul et interprétation de la perplexité
5. **Modèles avancés** : réseaux de neurones feed-forward et récurrents
6. **Applications pratiques** : génération de texte, reconnaissance vocale, traduction

## Formules Importantes à Retenir

- **N-gramme** : P[wi|wi-n+1,...,wi-1]
- **Perplexité** : P(q,w) = 2^(-1/k ∑ log2(q(wi))) = k√(1/Pq(w))
- **ML Estimation** : PML[w|h] = C(hw)/C(h)
- **Laplace** : P[w|h] = (c(hw) + 1)/(c(h) + |V|)
- **Interpolation** : PI[w|hn] = ∑λi PML[w|hi]