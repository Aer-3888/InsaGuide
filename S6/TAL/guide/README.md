# Guide TALEO -- Traitement Automatique du Langage Ecrit et Oral

> INSA Rennes -- 3A INFO -- S6
> Enseignants : G. Gravier, P. Sebillot, C. Corro, C. Raymond

## Objectifs du guide

Ce guide couvre l'integralite du cours TALEO (14h CM + 12h TP). Il est concu pour :
- Comprendre les concepts fondamentaux du TAL de zero
- Preparer efficacement le DS (1h, sans document, calculatrice autorisee)
- Avoir des traces d'algorithmes concrets et des formules exploitables

## Organisation du cours

| CM | Theme | Chapitre du guide |
|----|-------|-------------------|
| 1 | Introduction au TAL | [01_fondamentaux_tal.md](01_fondamentaux_tal.md) |
| 2 | Modeles de langage | [02_modeles_langage.md](02_modeles_langage.md) |
| 3 | Representation du texte | [03_representation_texte.md](03_representation_texte.md) |
| 4 | Etiquetage POS et NER | [04_etiquetage_pos_ner.md](04_etiquetage_pos_ner.md) |
| 5 | Analyse syntaxique | [05_analyse_syntaxique.md](05_analyse_syntaxique.md) |
| 6 | Entites nommees et extraction | [06_ner_extraction.md](06_ner_extraction.md) |
| 7 | Classification de texte | [07_classification_texte.md](07_classification_texte.md) |
| 8 | Grammaires formelles | [08_grammaires_formelles.md](08_grammaires_formelles.md) |
| -- | Recherche d'information | [09_recherche_information.md](09_recherche_information.md) |

## Parcours de revision recommande

```
Phase 1 : Fondations (chapitres 1, 3, 8)
  +-- Intro TAL, niveaux linguistiques, tokenisation
  +-- Representations : BoW, TF-IDF, Word2Vec, GloVe, FastText
  +-- Grammaires : Chomsky, CFG, PCFG, CNF

Phase 2 : Algorithmes cles (chapitres 2, 4, 5)
  +-- Modeles de langage : n-grammes, perplexite, lissage
  +-- Etiquetage : HMM, Viterbi, CRF
  +-- Parsing : CKY, dependances, transition-based

Phase 3 : Applications (chapitres 6, 7, 9)
  +-- NER : systeme BIO, sequence labeling
  +-- Classification : Naive Bayes, Laplace, SVM
  +-- RI : BM25, PageRank, evaluation (MAP, nDCG)

Phase 4 : Preparation DS
  +-- Annales commentees (2016-2023)
  +-- Exercices types avec traces d'algorithmes
```

## Format du DS (base sur annales 2016-2023)

- Duree : 1 heure
- Sans document, calculatrice autorisee
- 4-5 sections independantes, ~20 points total
- Sections typiques :
  - Recherche d'information (3 pts) : modele booleen vs vectoriel, cosinus, IDF
  - Analyse syntaxique en dependances (2 pts) : trace de transition-based parser
  - Questions de cours (4 pts) : definitions, hypothese distributionnelle, lexemes
  - Classification (7 pts) : calcul TF-IDF + Naive Bayes avec Laplace
  - Modeles de langue (4 pts) : RNN, perplexite, lissage

## Ressources complementaires

- Jurafsky & Martin (2025) : Speech and Language Processing, 3e edition
- Manning & Schutze (1999) : Foundations of Statistical NLP
- Goldberg (2017) : Neural Network Methods for NLP
