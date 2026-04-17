---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
# Traitement Automatique des Langues : Syntaxe

_Cours de Pascale Sébillot - Résumé exhaustif_

## Introduction générale

La syntaxe étudie les principes et contraintes qui gouvernent la combinaison des mots en phrases grammaticalement correctes. Le cours couvre trois aspects principaux :

1. L'étiquetage morpho-syntaxique (POS tagging)
2. L'analyse syntaxique et le parsing
3. L'analyse partielle/superficielle (chunking)

---

## 1. ÉTIQUETAGE MORPHO-SYNTAXIQUE (POS TAGGING)

### 1.1 Concepts fondamentaux

**Parties du discours (POS)**

- Ensembles de mots présentant un comportement syntaxique similaire
- Test de substitution pour déterminer l'appartenance à une même classe
- Catégories grammaticales : noms (entités), verbes (actions, états), etc.

**Objectif du POS tagging**

- Labelliser chaque mot d'une phrase avec sa catégorie appropriée
- Ne constitue pas une analyse complète, juste une pré-disambiguation
- Utile pour : recherche d'information, systèmes de questions-réponses, extraction d'information

### 1.2 Jeux d'étiquettes (Tagsets)

**Caractéristiques**

- Plusieurs tagsets disponibles selon les langues (Brown, Penn Treebank pour l'anglais)
- 40 à 400 étiquettes selon la précision requise
- Classes ouvertes (lexicales) : nom, verbe, adjectif, adverbe
- Classes fermées (fonctionnelles) : déterminant, pronom, préposition

**Penn Treebank Tagset (45 étiquettes)**

- Exemples : NN (nom singulier), NNS (nom pluriel), VB (verbe base), VBD (verbe passé)
- CC (conjonction coordination), DT (déterminant), JJ (adjectif)

### 1.3 Difficultés de l'étiquetage

**Ambiguïté lexicale**

- Mots ambigus : "book" (nom/verbe), "ferme" (adj/nom/verbe)
- Exemple français : "La belle ferme le voile" (2 analyses possibles)
- 85-86% de mots non ambigus, mais 55-67% des tokens sont ambigus

**Problèmes additionnels**

- Mots inconnus : entités nommées, termes spécialisés
- Formes compressées : "gonna", "cannot"
- Expressions multi-mots : "pomme de terre"
- Mentions métalinguistiques

### 1.4 Sources d'information pour l'étiquetage

**Contexte (étiquettes environnantes)**

- Certaines séquences plus fréquentes que d'autres
- En français : Det Adj Nom plus fréquent que Det Adj Verbe
- Seul le contexte : ~77% de réussite

**Le mot lui-même**

- Fréquence d'usage : "belle" plus souvent adjectif que nom
- Assignation de l'étiquette la plus fréquente : 90-92% de précision

### 1.5 Évaluation

**Métriques**

- Précision actuelle : 96-97% sur tous les mots
- Nécessite une vérité de terrain annotée manuellement
- 96-97% = 3-4 erreurs par 100 mots ≈ 1 erreur par phrase
- Maximum théorique : 98%

### 1.6 Algorithmes d'étiquetage

**Trois familles principales**

1. **Approche symbolique** (transformation-based taggers)
    
    - Transformations successives d'un étiquetage initial
    - Brill's tagger : outil emblématique des années 90
2. **Approche probabiliste** (HMM, CRF)
    
3. **Approche neuronale** (RNN)
    

### 1.7 Étiquetage basé sur les HMM

**Cadre probabiliste**

- Mots = observations, étiquettes POS = états cachés
- Objectif : trouver la séquence d'étiquettes la plus probable
- Formule : t̂₁ⁿ = argmax P(t₁ⁿ|w₁ⁿ) = argmax P(t₁ⁿ)P(w₁ⁿ|t₁ⁿ)

**Hypothèses simplificatrices**

1. Indépendance conditionnelle : probabilité d'un mot dépend seulement de son étiquette
2. Hypothèse bigramme : probabilité d'une étiquette dépend seulement de l'étiquette précédente

**Estimation des probabilités**

- Par comptage sur corpus d'entraînement étiquetéé
- Probabilités de transition : P(tᵢ|tᵢ₋₁) = C(tᵢ₋₁,tᵢ)/C(tᵢ₋₁)
- Probabilités d'émission : P(wᵢ|tᵢ) = C(tᵢ,wᵢ)/C(tᵢ)

**Algorithme de Viterbi**

- Programmation dynamique pour éviter l'énumération de toutes les séquences possibles
- Complexité polynomiale au lieu d'exponentielle

### 1.8 Étiquetage basé sur les CRF

**Modélisation directe**

- Modélise directement la probabilité a posteriori P(t|w)
- Formule : P(t|w) = 1/Z(w) × exp(Σᵢ λᵢfᵢ(t,w))
- Inférence par algorithme type Viterbi

**Fonctions de caractéristiques**

- Fonctions binaires (0/1) dépendant de (tₖ₋₁, tₖ, w, k)
- Templates définis : <tᵢ,wᵢ>, <tᵢ,tᵢ₋₁>, <tᵢ,wᵢ₋₁,wᵢ₊₁>
- Caractéristiques pour mots inconnus : forme des mots, préfixes/suffixes, capitalisation

**Outils disponibles**

- CRF++, Mallet, Wapiti

### 1.9 Approches neuronales

**RNN pour l'étiquetage**

- Entrées : embeddings de mots
- Sorties : probabilités d'étiquettes via softmax
- RNN bidirectionnels préférables

**LSTM-CRF**

- Combine LSTM (prédiction individuelle) + CRF (dépendances entre étiquettes)
- État de l'art actuel

---

## 2. ANALYSE SYNTAXIQUE (PARSING)

### 2.1 Introduction à l'analyse syntaxique

**Objectifs**

- Détermination de la structure des phrases
- Compréhension du sens via la structure
- Deux approches : constituants vs dépendances

### 2.2 Analyse en constituants

**Constituants (syntagmes)**

- Groupes de mots se comportant comme unités
- Types : syntagme nominal (NP), verbal (VP), adjectival (AP), prépositionnel (PP)
- Structure : tête + spécifieurs/qualificateurs + compléments
- Exemple : ((Le chat)ₙₚ ((pose (sa tête)ₙₚ)ᵥₚ (sur (un coussin)ₙₚ)ₚₚ)ᵥₚ)ₛ

### 2.3 Grammaires formelles

**Définition de Chomsky**

- G = (Vₙ, Vₜ, R, S)
- Vₙ : vocabulaire non-terminal, Vₜ : vocabulaire terminal
- R : règles de production, S : symbole de départ

**Hiérarchie de Chomsky**

- Type 0 : aucune contrainte
- Type 1 (context-sensitive) : uXv → uYv
- Type 2 (context-free) : X → Y (un non-terminal à gauche)
- Type 3 (regular) : au plus un non-terminal à droite

### 2.4 Grammaires hors-contexte (CFG)

**Structure**

- Règles + lexique
- Lexique : POS → mot
- Règles : non-terminal → séquence de terminaux/non-terminaux

**Exemple de grammaire jouet**

```
S → NP VP
NP → Det N | Det N PP | Pro
VP → V | V NP | V NP PP
PP → Prep NP
Det → la | le
N → chat | souris | lait
V → mange | court | donne
```

### 2.5 Ambiguïté syntaxique

**Sources d'ambiguïté**

- Attachement prépositionnel : "I saw a man with a telescope"
- Coordination : "old men and women"
- Complément/modifieur : "Je mange la tarte" vs "Je mange le matin"

### 2.6 Limites des CFG

**Problèmes**

- Accord : nécessité de multiplier les catégories
- Constituants discontinus
- Dépendances à distance
- Absence de lien actif/passif

**Solutions proposées**

- Grammaires transformationnelles (Chomsky)
- Grammaires à unification : LFG, GPSG, HPSG, TAG

### 2.7 Algorithmes d'analyse

**Stratégies**

- Top-down : des règles vers les mots
- Bottom-up : des mots vers S

**Limites**

- Top-down : hypothèses incompatibles avec les mots actuels
- Bottom-up : pas guidé par les contraintes des règles
- Problème de réanalyse des mêmes constituants

### 2.8 Algorithme CKY

**Principe**

- Programmation dynamique pour CFG en forme normale de Chomsky
- Stockage des arbres partiels bien formés dans une table
- Stratégie bottom-up

**Forme normale de Chomsky**

- Productions : A → BC ou A → a
- Transformations nécessaires :
    1. Éliminer les règles epsilon
    2. Gérer les symboles mixtes terminaux/non-terminaux
    3. Éliminer les productions unaires
    4. Binariser les règles longues

**Complexité**

- O(n³ × |R|²) pour une phrase de longueur n et |R| règles

### 2.9 Grammaires probabilistes (PCFG)

**Motivation**

- Choisir l'analyse la plus probable parmi plusieurs correctes
- Exemple : "Astronomers saw stars with ears"

**Définition**

- G = (Vₙ, Vₜ, R, S, P) avec P : fonction de probabilité
- Contrainte : ∀X∈Vₙ, Σ P(X→γ) = 1
- Probabilité d'un arbre = produit des probabilités des règles

**Apprentissage**

- À partir de corpus annotés syntaxiquement (treebanks)
- Penn Treebank : 1M mots du Wall Street Journal
- French Treebank : 1M mots du Monde

**Limites des PCFG**

- Invariance positionnelle (pronoms plus fréquents en sujet)
- Seules les POS considérées, pas les mots eux-mêmes
- Solution : lexicalisation des grammaires

### 2.10 CKY neuronal

**Principe**

- Classifier pour assigner un score à chaque constituant
- Modification de CKY pour combiner les scores
- Pas de grammaire explicite, apprentissage des représentations

**Architecture (Kitaev et al. 2019)**

- Embeddings de mots (BERT + post-traitement)
- Représentation des spans par différence des fenceposts
- Classifieur MLP pour scorer chaque span possible
- Décodage par programmation dynamique

### 2.11 Évaluation des analyseurs

**Métriques**

- Précision étiquetée : constituants corrects dans l'hypothèse / constituants dans l'hypothèse
- Rappel étiqueté : constituants corrects dans l'hypothèse / constituants dans la référence
- F-mesure, crossing-brackets

### 2.12 Analyse en dépendances

**Principe**

- Relations binaires dirigées étiquetées entre mots
- Arc de la tête (gouverneur) vers le dépendant (modifieur/argument)
- Nœud racine marquant la tête de la structure

**Types de relations**

- Relations clausales : rôle syntaxique par rapport à un prédicat
- Relations de modification : caractérisation des dépendants

**Universal Dependencies**

- Projet de développement de relations cross-linguistiques
- Treebanks UD pour de nombreuses langues

### 2.13 Contraintes sur les arbres de dépendance

**Propriétés structurelles**

- Un seul mot dépendant de ROOT
- ROOT seul nœud sans arc entrant
- Chaque vertex (sauf ROOT) a exactement un arc entrant
- Chemin unique de ROOT vers chaque vertex
- Pas de cycles
- Arcs croisés autorisés ou non (projectif/non-projectif)

### 2.14 Algorithmes d'analyse en dépendances

**Familles d'algorithmes**

1. Programmation dynamique (Eisner 1996)
2. Satisfaction de contraintes (Karlsson 1990)
3. Algorithmes de graphes (McDonald et al. 2005 - MSTParser)
4. Analyse transition-based (Nivre and Hall 2005 - MaltParser)

### 2.15 Analyse transition-based

**Composants**

- Pile (σ) : commence avec ROOT
- Buffer (β) : commence avec la phrase d'entrée
- Ensemble d'arcs de dépendance (A) : commence vide
- Ensemble d'actions possibles : Shift, Left-Arc, Right-Arc

**Apprentissage de l'oracle**

- Classifieur discriminant sur chaque mouvement légal
- Maximum 3 choix non-typés ou 2×Nb_rel+1 typés
- Données d'entraînement : paires configuration-transition

### 2.16 Classifieurs pour l'analyse

**Basés sur des caractéristiques**

- Caractéristiques manuelles : mots du sommet de pile, premier du buffer, lemmes, POS
- Templates de caractéristiques : <s₁.w, op>, <s₂.t, op>
- MaltParser : précision légèrement sous l'état de l'art mais très rapide

**Classifieurs neuronaux**

- Limites des caractéristiques manuelles : creuses, incomplètes, coûteuses
- Embeddings des mots/étiquettes/labels d'arcs
- Concaténation + réseau feed-forward + softmax

### 2.17 Évaluation des analyseurs en dépendances

**Métriques**

- UAS (Unlabeled Attachment Score) : assignation correcte tête-dépendant
- LAS (Labeled Attachment Score) : + relation correcte
- Exemple : UAS=5/6, LAS=2/3 pour un exemple donné

**Performances**

- MaltParser : UAS=89.8%, LAS=87.2%, 469 phrases/s
- État de l'art 2017 : UAS=95.74%, LAS=94.08% (Dozat & Manning)

---

## 3. ANALYSE PARTIELLE/SUPERFICIELLE (CHUNKING)

### 3.1 Motivation

**Contexte**

- Arbres syntaxiques complets pas toujours requis ou possibles
- Analyse robuste/partielle nécessaire
- Analyse superficielle suffisante pour certaines tâches

### 3.2 Définition du chunking

**Chunks selon Abney (1991)**

- Segments prosodiques naturels
- Exemple : "[I begin] [with an intuition]: [when I read] [a sentence]"
- Un accent fort par chunk, pauses probables entre chunks

**Propriétés des chunks**

- "Phrases" non-récursives correspondant aux POS majeurs (NP, VP, PP, AP)
- Ne contiennent pas récursivement de constituants du même type
- Souvent : mot-tête + matériel pré-tête (pas post-tête en anglais)

### 3.3 Tâche de chunking

**Objectif**

- Identifier des constituants non-chevauchants
- Classer (étiqueter) ces constituants
- Exemple : [ₙₚThe AF210 flight] [ₚₚfrom] [ₙₚParis] [ₚₚto] [ₙₚNew-York]

### 3.4 Approches pour le chunking

**Règles manuscrites**

- Expressions régulières, automates finis
- Application sur texte étiqueté POS
- Exemple : NP → Det Adj* N
- Processus glouton

**Apprentissage supervisé**

- Un classifieur par étiquette
- Caractéristiques extraites d'une fenêtre contextuelle (+2/-2 mots)
- Caractéristiques : mot, POS, étiquette de chunk

### 3.5 Chunking comme étiquetage de séquence

**Encodage IOB**

- B_NP : début d'un chunk NP
- I_NP : à l'intérieur d'un chunk NP
- O : à l'extérieur de tout chunk
- Si n types de chunks : 2n+1 étiquettes

**Exemple**

```
The AF210 flight from Paris has arrived
B_NP I_NP I_NP O B_NP O O
```

**Techniques utilisables**

- HMM, CRF, méthodes neuronales
- Mêmes principes que pour le POS tagging

### 3.6 Évaluation du chunking

**Métriques**

- Précision = chunks corrects produits / total chunks produits
- Rappel = chunks corrects produits / total chunks référence
- F-mesure
- "Correct" = mêmes frontières ET étiquettes

**Sources d'erreurs**

- Précision de l'étiqueteur POS en amont
- Coordination : "[late arrivals and departures]" vs "[late arrivals] and [cancellations]"

### 3.7 Ressources et outils

**Analyseurs disponibles**

- Illinois Chunker
- TreeTagger
- Intégration dans frameworks NLP (NLTK, Stanford CoreNLP)

---

## RESSOURCES ET RÉFÉRENCES

### Outils mentionnés

- **POS Tagging** : TreeTagger, Stanford NLP, SpaCy, Brill's tagger
- **Parsing constitutants** : Stanford CoreNLP, Berkeley neural parser, Talismane
- **Parsing dépendances** : MaltParser, MSTParser, Stanford Parser, SyntaxNet
- **Chunking** : Illinois Chunker, TreeTagger

### Corpus et ressources

- **Penn Treebank** : 1M mots WSJ + Brown corpus
- **French Treebank** : 1M mots Le Monde 1989-1993
- **Universal Dependencies** : treebanks multilingues

### Références principales

- Jurafsky & Martin : Speech and Language Processing (2e éd. 2009, 3e éd. draft 2023-2024)
- Manning & Schütze : Foundations of Statistical NLP (1999)
- Supports de cours de Philippe Langlais et Christopher Manning

---

## POINTS CLÉS À RETENIR

1. **POS Tagging** : 96-97% de précision actuelle, HMM/CRF/Neural, ambiguïté principale difficulté
    
2. **Parsing constitutants** : CFG + CKY, ambiguïté résolue par PCFG ou approches neuronales
    
3. **Parsing dépendances** : relations binaires tête-dépendant, transition-based vs graph-based
    
4. **Chunking** : analyse partielle suffisante, encodage IOB, techniques d'étiquetage de séquence
    
5. **Évolution** : passage progressif des approches symboliques vers probabilistes puis neuronales
    
6. **Évaluation** : métriques spécifiques à chaque tâche (précision/rappel pour chunks, UAS/LAS pour dépendances)