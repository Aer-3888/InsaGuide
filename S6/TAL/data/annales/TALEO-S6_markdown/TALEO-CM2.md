---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
# Résumé Exhaustif - Traitement Automatique du Langage : Représentation des Mots

## 1. CONTEXTE GÉNÉRAL ET STRUCTURE DU COURS

### Organisation du cours TALEO

- **Lectures (14h)** : Introduction TAL, Représentation mots/documents, Recherche d'information, Outils fondamentaux, Modélisation du langage, Analyse syntaxique
- **Travaux pratiques (12h)** : Word embeddings (2h), Recherche d'information (6h), Classification de documents (4h)
- **Enseignant** : Guillaume Gravier (guillaume.gravier@irisa.fr)

### Problématique centrale

Le texte brut n'est pas directement exploitable pour les algorithmes d'apprentissage automatique. Nécessité de transformer les mots en représentations numériques adaptées.

## 2. FONDAMENTAUX : TOKENS, MOTS ET CONCEPTS LINGUISTIQUES

### Définitions essentielles

- **Token** : chaîne graphique normalisée, sans signification propre
- **Forme (wordform)** : signe linguistique avec autonomie fonctionnelle et cohésion interne
- **Lexème** : ensemble de formes différenciées par flexion (ex: am, are, is, was = même lexème)
- **Lemme** : forme canonique arbitraire représentant un lexie (ex: "aimer" pour toutes ses conjugaisons)
- **Radical (stem)** : support morphologique portant le signifié (ex: "aim-")

### Ambiguïté de la notion de "mot"

1. **Surface** : "His answer was only two-words long: certainly not"
2. **Signe linguistique** : Am, are, is, was = formes du même mot

## 3. TOKENISATION : TRAITEMENT AU NIVEAU GRAPHIQUE

### Principe de la tokenisation

- Division du texte en **phrases** puis en **tokens**
- Basée sur ponctuation et espaces + nombreuses règles et exceptions
- Exemples de difficultés :
    - j'ai → j' + ai vs aujourd'hui → aujourd'hui
    - 31/12/2019 → 31/12/2019 vs 31 décembre 2019
    - Gestion des guillemets, parenthèses

### Outils de tokenisation

- **Stanford** : https://nlp.stanford.edu/software/tokenizer.shtml
- **NLTK** : http://www.nltk.org/api/nltk.tokenize.html
- **spaCy** : https://spacy.io/api/tokenizer

### Exemples pratiques NLTK/spaCy

```python
s='A $2 example\nof a sentence. And a 2nd sentence.'
# NLTK
word_tokenize(s) → ['A', '$', '2', 'example', 'of', 'a', 'sentence', '.', 'And', 'a', '2nd', 'sentence', '.']
# spaCy
[A, $, 2, example, , of, a, sentence, ., And, a, 2nd, sentence, .]
```

## 4. LIMITATIONS DES REPRÉSENTATIONS SYMBOLIQUES

### Représentation par chaînes de caractères

- **Avantages** : simple à implémenter, comparaison efficace avec tables de hachage
- **Inconvénients majeurs** :
    - Pauvre information sémantique (vélo ≠ bicyclette dans le domaine des formes)
    - Difficile d'encoder relations sémantiques avec comparaison binaire
    - Problème des formes fléchies (manger ≠ mangera ≠ mangerait)
    - Peu pratique pour réseaux de neurones

## 5. LEXIQUES ET RÉSEAUX SÉMANTIQUES

### FrameNet

- **Contenu** : 13k sens de mots, 1,2k frames
- **Focus** : principalement verbes avec rôles sémantiques
- **Version française** : ASFALDA (limitée)

### WordNet

- **URL** : https://wordnet.princeton.edu
- **Contenu** : 100k+ noms, 20k+ adjectifs, 10k+ verbes
- **Organisation** : synsets (ensembles de synonymes cognitifs)
- **Relations** : sémantiques et lexicales entre synsets
- **Version française** : Wordnet Libre du Français (WOLF)

### SentiWordNet

- **URL** : https://github.com/aesuli/sentiwordnet
- **Fonction** : annotation des synsets WordNet avec indices de sentiment
- **Mesures** : positivité, négativité, objectivité

### Structure hiérarchique WordNet

- **Point d'entrée** : sense = synset
- **Synset** : sens + liste de lemmes désignant cette signification
- **Relations** : synonyme/antonyme, hyponyme/hyperonyme, méronyme/holonyme

## 6. MESURES DE SIMILARITÉ WORDNET

### Similarité basée sur le chemin

```
simpath(c1, c2) = 1 / (1 + shortest_path_length(c1, c2))
```

### Généralisation aux mots

```
simword(w1, w2) = max(simpath(c1, c2)) pour c1∈S1, c2∈S2
avec Si = senses(wi)
```

### Mesure Wu-Palmer

```
Wu_Palmer(c1, c2) = 2 * depth(lcs(c1, c2)) / (depth(c1) + depth(c2))
```

### Exemple pratique

```python
rat.wup_similarity(wn.synset('man.n.01')) → 0.54
rat.lowest_common_hypernyms(wn.synset('man.n.01')) → [Synset('organism.n.01')]
```

## 7. DÉSAMBIGUÏSATION SÉMANTIQUE

### Problématique

Associer un sens/signification à une forme de mot en mappant vers l'entrée correspondante dans un lexique ou réseau sémantique.

### Approches principales

1. **Méthodes basées sur la connaissance** : chevauchement entre définition du sens et contexte d'occurrence
2. **Méthodes basées sur la classification** : représentation par caractéristiques et apprentissage du mapping

### Difficulté

Tâche non triviale nécessitant des méthodes sophistiquées.

## 8. REPRÉSENTATIONS DISTRIBUÉES (EMBEDDINGS)

### Concept fondamental

Représenter les mots dans un espace euclidien avec propriétés sémantiques intéressantes.

### Questions clés

- Quelles propriétés pour wi ?
- Comment obtenir wi ?
- Comment évaluer wi ?

## 9. SÉMANTIQUE DISTRIBUTIONNELLE

### Idées fondatrices

- **Harris (1954)** : "les parties d'une langue n'apparaissent pas arbitrairement les unes par rapport aux autres : chaque élément apparaît dans certaines positions relatives à certains autres éléments"
- **Firth (1957)** : "You should know a word by the company it keeps"

### Principe pratique

Représenter les mots par leur contexte d'apparition (typiquement noms et verbes, possiblement lemmatisés).

## 10. MATRICE DE CO-OCCURRENCE

### Méthode directe

1. **Créer matrice de co-occurrence** des tokens dans une fenêtre contextuelle
2. **Décomposition matricielle** :
    - Décomposition en valeurs propres : X = UΛU^t
    - Décomposition en valeurs singulières : X = USV^t
3. **Utiliser vecteurs propres tronqués** ui comme représentation du mot i

### Variantes possibles

- Pondération selon position dans la fenêtre
- Minimiser l'impact des mots fonctionnels
- Utiliser coefficients de corrélation au lieu de comptes

### Limitations

- Taille de matrice et coût computationnel
- Coût d'ajout de nouveaux mots

## 11. WORD2VEC

### Principe révolutionnaire

Apprendre directement les vecteurs de mots sans examiner les co-occurrences explicitement.

### Deux variantes

1. **CBOW** : prédire mot central à partir des mots environnants
2. **Skip-gram** : prédire mots environnants à partir du mot central

### Objectif Skip-gram

```
J(θ) = Σt Σj∈[-m,m],j≠0 ln p(wt+j | wt)
```

### Probabilité contextuelle

```
p(o|c) = exp(u'o vc) / Σw∈V exp(u'w vc)
```

où :

- uo = vecteur représentant mot de contexte/sortie o
- vc = vecteur représentant mot central c

## 12. APPROXIMATION SKIP-GRAM

### Échantillonnage négatif

```
J(θ) = Σt,j [σ(u'wt+j vwt) + Σw~P[w] σ(-u'w vwt)]
```

### Principe minimax

- **Maximiser** produit scalaire pour mots co-occurents → σ(u'o vc)
- **Minimiser** produit scalaire pour mots non co-occurents → σ(-u'w vc)

### Résultat final

Après entraînement : u'a vb ≃ ln P[a|b] pour tokens arbitraires a et b.

### Détails pratiques

- P[w] = unigram(w)^(3/4) / Z pour minimiser impact mots fréquents
- Optimisation : descente de gradient stochastique ou mini-batch
- Initialisation aléatoire des vecteurs
- Combinaison de u et v pour sortie finale

## 13. COMPARAISON CBOW VS SKIP-GRAM

### CBOW

- **Avantages** : rapide, adapté aux petites données
- **Focus** : aspects syntaxiques

### Skip-gram

- **Avantages** : précis, adapté aux grandes données
- **Focus** : aspects sémantiques

## 14. GLOVE (GLOBAL VECTORS)

### Motivation

Word2vec ne utilise pas les statistiques globales du corpus et peut être lent.

### Objectif GloVe

```
J(θ) = 1/2 Σi,j∈V×V f(Pij)(u'i vj - ln Pij)²
```

### Avantages

- Rapide et efficace
- Évolutif (scalable)
- Besoin de moins de données

## 15. ÉVALUATION INTRINSÈQUE

### Similarité sémantique

- Utilisation du produit scalaire (similarité cosinus)
- Corrélation avec jugement humain
- Exemples de scores :
    - love, sex : 6.77
    - tiger, cat : 7.35
    - tiger, tiger : 10
    - book, paper : 7.46

### Base de données

http://www.cs.technion.ac.il/~gabr/resources/data/wordsim353/

## 16. TOKENISATION SOUS-MOT

### Problématique

Méthodes précédentes supposent que tous les mots ont été vus en entraînement, ce qui est rarement vrai.

### Solution traditionnelle

Mapper vers token inconnu (`<UNK>`) mais pas nécessairement optimal.

## 17. FASTTEXT

### Principe

Plonger des unités sous-mot plutôt que des mots entiers.

### Méthode

- Décomposer mot comme sac de n-grammes avec n ∈ [3,6]
- Exemple : "where" = (<wh + whe + her + ere + re> + <whe + ...)
- Embedding de mot = somme des embeddings sous-mots
- Similarité : s(w,c) = Σg∈Gw zg vc

## 18. TOKENISATION SOUS-MOT MODERNE

### Méthodes récentes

Basées sur fréquence d'occurrence de sous-chaînes dans grandes quantités de données :

#### Byte Pair Encoding (BPE)

- **Utilisé dans** : GPT-3
- **Principe** : regroupement itératif des paires les plus fréquentes

#### WordPiece

- **Utilisé dans** : BERT
- **Exemple** : 'Using a Transformer network is simple' → ['Using', 'a', 'transform', '##er', 'network', 'is', 'simple']

#### Unigram/SentencePiece

- Approche probabiliste alternative

### Exemple détaillé BPE

Départ : ("hug", 10), ("pug", 5), ("pun", 12), ("bun", 4), ("hugs", 5)

1. Diviser en lettres : ("h" "u" "g", 10), ("p" "u" "g", 5), ...
2. Regrouper paire la plus fréquente → u g
3. Itérer → u n → h ug
4. Arrêter à nombre fixe d'unités sous-mot

## 19. COUCHE D'EMBEDDING

### Principe technique

Opération de base pour convertir token en représentation plongée dans R^d où la matrice d'embedding A peut être entraînée comme tout autre paramètre d'un réseau de neurones.

### Embedding orienté tâche

Les embeddings peuvent être appris spécifiquement pour une tâche donnée, pas seulement distribués.

## 20. POINTS CLÉS ET CONCEPTS TRANSVERSAUX

### Évolution historique

1. **Représentations symboliques** → limitations sémantiques
2. **Réseaux sémantiques** → WordNet, FrameNet
3. **Matrices de co-occurrence** → coût computationnel
4. **Word2vec** → révolution des embeddings
5. **GloVe** → combinaison statistiques globales/locales
6. **FastText** → gestion mots inconnus
7. **Tokenisation sous-mot** → robustesse moderne

### Enjeux techniques permanents

- **Sparsité** vs **densité** des représentations
- **Sémantique** vs **syntaxe**
- **Mots connus** vs **mots inconnus**
- **Efficacité computationnelle** vs **qualité**
- **Évaluation intrinsèque** vs **extrinsèque**

### Applications pratiques

- Classification de sentiments
- Recherche d'information
- Traduction automatique
- Analyse syntaxique
- Question-réponse

Cette synthèse couvre l'ensemble des 35 slides avec tous les concepts théoriques, formules mathématiques, exemples pratiques et références techniques nécessaires pour une compréhension exhaustive du domaine.