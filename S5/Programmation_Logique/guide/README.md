# Programmation Logique (Prolog) -- Guide de Cours

## Vue d'ensemble

Ce cours couvre la programmation logique avec Prolog, un paradigme declaratif ou l'on exprime **ce que l'on veut** plutot que **comment le calculer**. Prolog repose sur la logique du premier ordre et le mecanisme de resolution par unification et backtracking.

**Environnement** : ECLiPSe Prolog (compatible SWI-Prolog pour la plupart des predicats).

## Structure du cours

| Chapitre | Contenu | Fichier |
|----------|---------|---------|
| 1. Bases de Prolog | Faits, regles, requetes, atomes, variables | [01-prolog-basics.md](01-prolog-basics.md) |
| 2. Unification et Resolution | Algorithme d'unification, resolution SLD, arbre de recherche | [02-unification-resolution.md](02-unification-resolution.md) |
| 3. Listes en Prolog | Tete/queue, operations classiques, append, member | [03-lists.md](03-lists.md) |
| 4. Recursion en Prolog | Predicats recursifs, accumulateurs, terminaison | [04-recursion.md](04-recursion.md) |
| 5. Arithmetique | is/2, operateurs de comparaison, Peano, binaire | [05-arithmetic.md](05-arithmetic.md) |
| 6. Cut et Negation | Cut (!), green/red cut, negation par echec (\+) | [06-cut-negation.md](06-cut-negation.md) |
| 7. Sujets avances | findall, bagof, setof, assert/retract, BDD deductives | [07-advanced-topics.md](07-advanced-topics.md) |
| 8. Arbres de resolution | Dessiner les arbres d'execution, visualiser le backtracking | [08-resolution-trees.md](08-resolution-trees.md) |

## Correspondance avec les TPs

| TP | Theme | Chapitres |
|----|-------|-----------|
| TP1 | Bases de donnees (restaurant, Valois) | 1, 4 |
| TP2 | Termes construits (poker) | 1, 2 |
| TP3 | Listes et ensembles | 3, 4 |
| TP4 | Arbres binaires | 3, 4, 6 |
| TP5 | Arithmetique (Peano, binaire) | 4, 5 |
| TP6 | BDD deductives (constructeur auto) | 6, 7 |
| TP8 | Puzzle des dominos | 3, 4, 7 |

## Points cles pour l'examen

1. **Ecriture de predicats** : savoir ecrire des regles Prolog a partir d'un enonce
2. **Trace d'execution** : suivre pas a pas l'execution d'un predicat (Call, Exit, Redo, Fail)
3. **Arbre de resolution** : dessiner l'arbre SLD complet avec backtracking
4. **Unification** : determiner si deux termes s'unifient et donner le substituteur
5. **Cut** : comprendre l'impact du cut sur l'arbre de recherche
6. **Recursion** : ecrire et analyser des predicats recursifs sur listes et arbres
