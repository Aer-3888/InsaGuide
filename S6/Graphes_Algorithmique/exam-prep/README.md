# Preparation aux examens -- Graphes et Algorithmique

Ce dossier contient une analyse des annales (2015-2024), des strategies d'examen et des exercices types avec solutions detaillees.

---

## Structure du DS (analyse des 8 annales disponibles)

Les DS de Graphes et Algorithmique a l'INSA Rennes suivent un format assez stable :

| Partie | Contenu typique | Frequence | Poids |
|--------|----------------|-----------|-------|
| Definitions et proprietes | Degres, types de graphes, representations | 8/8 | 15-20% |
| Connexite et parcours | BFS/DFS, composantes, forte connexite | 6/8 | 10-15% |
| Cycles (Euler/Hamilton) | Conditions, trouver un cycle/chaine | 7/8 | 15-20% |
| Coloration | Nombre chromatique, algorithme glouton | 5/8 | 10-15% |
| ACM (Kruskal/Prim) | Derouler l'algorithme sur un graphe | 6/8 | 10-15% |
| Plus courts chemins | Dijkstra et/ou Bellman-Ford | 7/8 | 15-20% |
| Ordonnancement | MPM, dates, marges, chemin critique | 4/8 | 10-15% |
| Flots | Ford-Fulkerson, coupe min | 5/8 | 10-15% |

### Tendances observees

- Les sujets recents (2021-2024) insistent davantage sur le **deroulage pas a pas** des algorithmes
- Les questions de **preuve** sont presentes dans quasiment tous les sujets
- La **modelisation** (transformer un probleme concret en graphe) est de plus en plus demandee
- Les questions sur la **planarite** et la **coloration** sont souvent combinees

---

## Table des matieres

| # | Fichier | Contenu |
|---|---------|---------|
| 01 | [Strategie d'examen](01_exam_strategy.md) | Methodologie, gestion du temps, erreurs a eviter |
| 02 | [Sujets types par theme](02_typical_problems.md) | Questions classiques avec solutions detaillees |
| 03 | [Algorithmes a savoir derouler](03_algorithm_traces.md) | Traces completes de Dijkstra, Kruskal, Ford-Fulkerson, etc. |
| 04 | [Preuves recurrentes](04_common_proofs.md) | Preuves classiques demandees en DS |

---

## Repartition recommandee du temps de revision

| Priorite | Theme | Temps |
|----------|-------|-------|
| 1 (critique) | Dijkstra / Bellman-Ford | 20% |
| 2 (critique) | Kruskal / Prim | 15% |
| 3 (critique) | Ford-Fulkerson / coupe min | 15% |
| 4 (important) | Euler / Hamilton | 15% |
| 5 (important) | Coloration | 10% |
| 6 (important) | Ordonnancement MPM | 10% |
| 7 (base) | Definitions, degres, representations | 10% |
| 8 (base) | Planarite, arbres, preuves | 5% |
