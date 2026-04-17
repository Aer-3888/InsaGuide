# Guide TALEO -- Traitement Automatique du Langage Ecrit et Oral

> INSA Rennes -- 3A INFO -- S6
> Enseignants : G. Gravier, P. Sebillot, C. Corro, C. Raymond

## Objectifs du guide

Ce guide couvre l'integralite du cours TALEO (14h CM + 12h TP). Il est concu pour :
- Comprendre les concepts fondamentaux du TAL de zero
- Preparer efficacement le DS (1h, sans document)
- Avoir des exemples concrets et du code Python exploitable

## Organisation du cours

| CM | Theme | Chapitre du guide |
|----|-------|-------------------|
| 1 | Introduction au TAL | [01_intro_tal.md](01_intro_tal.md) |
| 2 | Representation des mots | [02_representation_mots.md](02_representation_mots.md) |
| 3 | Representation des documents | [03_representation_documents.md](03_representation_documents.md) |
| 4 | Recherche d'information | [04_recherche_information.md](04_recherche_information.md) |
| 5 | Etiquetage de sequences (HMM, CRF) | [05_etiquetage_sequences.md](05_etiquetage_sequences.md) |
| 6 | Modeles de langage | [06_modeles_langage.md](06_modeles_langage.md) |
| 7 | Analyse syntaxique | [07_analyse_syntaxique.md](07_analyse_syntaxique.md) |

## Ressources complementaires

- [Cheat Sheet DS](cheat_sheet.md) -- Formules, algorithmes cles, pieges frequents
- Jurafsky & Martin (2025) : Speech and Language Processing, 3e edition
- Goldberg (2017) : Neural Network Methods for NLP
- Manning & Schutze (1999) : Foundations of Statistical NLP

## Parcours de revision recommande

```
Phase 1 : Fondations (chapitres 1 a 3)
  +-- Intro TAL, tokenisation, niveaux linguistiques
  +-- Word embeddings (Word2Vec, GloVe, FastText)
  +-- Document embeddings (BoW, TF-IDF, RNN)

Phase 2 : Applications (chapitres 4 et 5)
  +-- Recherche d'information (modeles, evaluation, PageRank)
  +-- Etiquetage de sequences (HMM, CRF, RNN)

Phase 3 : Modeles avances (chapitres 6 et 7)
  +-- Modeles de langage (n-grammes, lissage, RNN)
  +-- Analyse syntaxique (CFG, PCFG, CKY, dependances)

Phase 4 : Preparation DS
  +-- Cheat sheet avec formules et pieges
  +-- Annales commentees (2016-2023)
```

## Structure de chaque chapitre

Chaque chapitre suit la meme progression :
1. Concept simple et intuitif
2. Schema (Mermaid ASCII)
3. Explication progressive et detaillee
4. Algorithmes et formules
5. Exemples concrets avec code Python (spaCy, NLTK)
6. Pieges classiques a eviter
7. Recapitulatif

## Travaux pratiques

| TP | Theme | Lien avec les CM |
|----|-------|------------------|
| TP1 | Word embeddings | CM2 |
| TP2-4 | Recherche d'information | CM3, CM4 |
| TP5-6 | Classification de documents | CM3, CM5 |

Les TP spaCy et recherche d'information sont directement lies aux chapitres du guide.

## Format du DS

- Duree : 1 heure
- Sans document, calculatrice autorisee
- Questions independantes couvrant plusieurs themes
- Mix de questions de cours, exercices de calcul et schemas
- Voir la [cheat sheet](cheat_sheet.md) pour la preparation
