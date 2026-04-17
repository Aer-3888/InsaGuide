# Propositions et Predicats -- Guide complet (S6)

Guide de logique formelle pour le cours de 3e annee INSA Rennes. Couvre le calcul propositionnel, le calcul des predicats, la deduction naturelle, la resolution et l'unification.

---

## Plan du guide

```
Calcul propositionnel ──> Formes normales ──> Resolution
        │                                         │
        └──> Calcul des predicats ──> Unification ─┘
                    │                              │
                    └──────> Deduction naturelle <──┘
                                    │
                           Completude & Solidite
```

---

## Table des matieres

| # | Chapitre | Description |
|---|----------|-------------|
| 01 | [Logique propositionnelle](01_logique_propositionnelle.md) | Syntaxe, semantique, tables de verite, connecteurs, tautologies, contradictions |
| 02 | [Formes normales](02_formes_normales.md) | FNC, FND, algorithmes de conversion, satisfiabilite |
| 03 | [Deduction naturelle](03_deduction_naturelle.md) | Regles d'introduction/elimination, strategies de preuve |
| 04 | [Calcul des sequents](04_calcul_des_sequents.md) | Sequents, regles structurelles, coupure |
| 05 | [Logique des predicats](05_logique_des_predicats.md) | Quantificateurs, variables libres/liees, substitution, portee |
| 06 | [Semantique des predicats](06_semantique_des_predicats.md) | Interpretations, modeles, validite, satisfiabilite |
| 07 | [Unification et resolution](07_unification_et_resolution.md) | Algorithme d'unification, principe de resolution, skolemisation, forme clausale |
| 08 | [Completude et solidite](08_completude_et_solidite.md) | Theoreme de completude de Godel, solidite, decidabilite |
| -- | [Cheat Sheet](cheat_sheet.md) | Toutes les regles d'inference, equivalences, procedures -- en un seul endroit |

---

## Prerequis

- Savoir ce qu'est une proposition (un enonce vrai ou faux).
- Aucun logiciel requis : tout se fait a la main.

## Comment utiliser ce guide

1. Lire dans l'ordre pour une progression naturelle, ou sauter au chapitre qui t'interesse.
2. Refaire les exemples a la main sur papier.
3. Consulter la cheat sheet pour reviser avant le DS.
4. Travailler les exercices dans le dossier `../exercises/` et les annales dans `../exam-prep/`.
