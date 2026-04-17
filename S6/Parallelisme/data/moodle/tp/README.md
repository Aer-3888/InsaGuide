# Travaux Pratiques - Parallélisme / Calcul Hautes Performances

INSA Rennes - 3INFO SLE/SECU - Année 2016-2017

## Vue d'ensemble

Ce dossier contient les solutions complètes des 6 TPs du cours de Calcul Hautes Performances, couvrant deux paradigmes majeurs de programmation parallèle:

- **OpenMP** (TP1-3): Parallélisme à mémoire partagée (multi-threading)
- **MPI** (TP4-6): Parallélisme à mémoire distribuée (passage de messages)

## Structure du dossier

```
tp/
├── README.md                    # Ce fichier
├── Sujets_TP/                   # Énoncés des TPs (PDF)
├── tp1/                         # OpenMP - Prise en main
│   ├── README.md
│   └── src/
├── tp2/                         # OpenMP - Propagation chaleur
│   ├── README.md
│   └── src/
├── tp3/                         # OpenMP - Crible, Jacobi
│   ├── README.md
│   └── src/
├── tp4/                         # MPI - Calcul de PI
│   ├── README.md
│   └── src/
├── tp5/                         # MPI - Produit scalaire
│   ├── README.md
│   └── src/
├── tp6/                         # MPI - Propagation chaleur distribuée
│   ├── README.md
│   └── src/
└── _originals/                  # Code source original
```

## Prérequis

### Compilation

- **OpenMP**: GCC avec support OpenMP
  ```bash
  gcc -fopenmp programme.c -o programme -lm
  ```

- **MPI**: Implémentation MPI (OpenMPI ou MPICH)
  ```bash
  mpicc programme.c -o programme -lm
  ```

### Exécution

- **OpenMP**: Variable d'environnement pour contrôler le nombre de threads
  ```bash
  export OMP_NUM_THREADS=4
  ./programme
  ```

- **MPI**: Lancer avec mpiexec/mpirun
  ```bash
  mpiexec -n 4 ./programme
  ```

## Résumé des TPs

### TP1 - OpenMP: Prise en main
- **Exercice 1**: Création de threads OpenMP, affichage des rangs
- **Exercice 2**: Découpage de boucles avec `#pragma omp parallel for`
- **Exercice 3**: Calcul de PI parallèle, mesures de performance et speedup
- **Exercice 4**: Utilisation du cluster (24 cœurs), analyse de scalabilité

**Concepts clés**: threads, parallel regions, variables privées/partagées, réductions

### TP2 - OpenMP: Propagation de la chaleur
- **Exercice 1**: Simulation 2D de propagation de chaleur sur plaque rectangulaire
- Algorithme itératif avec convergence (équation aux 5 points)
- Parallélisation avec OpenMP, mesures de speedup

**Concepts clés**: calcul stencil, synchronisation implicite, optimisation cache

### TP3 - OpenMP: Algorithmes avancés
- **Exercice 1**: Crible d'Ératosthène (nombres premiers)
- **Exercice 2**: Méthode de Jacobi (résolution systèmes linéaires)
- Parallélisation d'algorithmes itératifs complexes

**Concepts clés**: dépendances de données, faux partage (false sharing)

### TP4 - MPI: Calcul de PI
- Version séquentielle du calcul de PI (méthode des trapèzes)
- Version parallèle MPI avec distribution des intervalles
- `MPI_Bcast`, `MPI_Reduce`, mesures de performance

**Concepts clés**: initialisation MPI, broadcast, réduction, mesure de temps

### TP5 - MPI: Produit matrice-vecteur
- **Implémentation 1**: Distribution par blocs de lignes
- **Implémentation 2**: Maître-esclave, distribution dynamique
- `MPI_Scatter`, `MPI_Gather`, comparaison des stratégies

**Concepts clés**: distribution de données, communications collectives

### TP6 - MPI: Propagation chaleur distribuée (SPMD)
- Application complète SPMD (Single Program Multiple Data)
- Distribution 1D de la matrice entre processus
- Communications point-à-point avec recouvrement (ghost zones)
- Convergence distribuée avec `MPI_Allreduce`

**Concepts clés**: SPMD, halo exchange, communications non-bloquantes, réduction globale

## Compilation rapide

Chaque TP dispose d'un Makefile. Pour compiler tous les exercices:

```bash
cd tpN/src
make
```

## Concepts de parallélisme

### OpenMP (mémoire partagée)
- Tous les threads accèdent à la même mémoire
- Synchronisation implicite (barrières automatiques)
- Idéal pour machines multi-cœurs (SMP)
- Directives `#pragma omp` ajoutées au code séquentiel

### MPI (mémoire distribuée)
- Chaque processus a sa propre mémoire
- Communications explicites (send/recv)
- Scalabilité sur clusters de machines
- Nécessite restructuration du code pour distribuer les données

## Métriques de performance

### Speedup
```
S(p) = T(1) / T(p)
```
Où `T(p)` est le temps avec `p` processeurs/threads.

- **Speedup linéaire**: S(p) = p (idéal)
- **Speedup sous-linéaire**: S(p) < p (typique)
- **Speedup super-linéaire**: S(p) > p (rare, effets de cache)

### Efficacité
```
E(p) = S(p) / p
```
Pourcentage d'utilisation effective des ressources.

### Loi d'Amdahl
Limite théorique du speedup en fonction de la partie séquentielle:
```
S_max = 1 / ((1-P) + P/N)
```
Où P = fraction parallélisable, N = nombre de processeurs.

## Ressources

- **OpenMP**: https://www.openmp.org/specifications/
- **MPI**: https://www.mpi-forum.org/docs/
- **Fichier CPU**: `/proc/cpuinfo` (Linux) pour info matériel
- **Cluster INSA**: `ssh cluster-infomath-tete.educ.insa-rennes.fr`

## Notes

- Les mesures de temps utilisent `omp_get_wtime()` (OpenMP) et `MPI_Wtime()` (MPI)
- Toujours compiler avec optimisations (`-O2`, `-O3`) pour mesures réalistes
- Attention aux variables partagées vs privées (OpenMP)
- Attention aux deadlocks avec MPI (ordre send/recv)
