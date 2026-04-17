# Exercices -- Solutions detaillees des TP

Ce repertoire contient les guides de solutions pas-a-pas pour chaque TP du cours de Parallelisme / Calcul Hautes Performances.

Chaque fichier contient :
- Le code source complet avec annotations ligne par ligne
- Les commandes de compilation exactes (flags, Makefile)
- Les commandes d'execution avec differents nombres de threads/processus
- Des tableaux de performance avec calculs de speedup et efficacite
- L'analyse des race conditions et comment elles sont evitees
- La transformation sequentiel vers parallele pour chaque exercice
- Les techniques de debugging specifiques au paradigme

| TP | Sujet | Technologie | Fichier |
|----|-------|-------------|---------|
| TP1 | Prise en main OpenMP (threads, boucles, PI) | OpenMP | [tp1_openmp_bases.md](tp1_openmp_bases.md) |
| TP2-3 | Chaleur + Crible + Jacobi | OpenMP | [tp2_3_openmp_avance.md](tp2_3_openmp_avance.md) |
| TP4 | Calcul de PI distribue (Bcast, Reduce) | MPI | [tp4_mpi_pi.md](tp4_mpi_pi.md) |
| TP5 | Produit matrice-vecteur (Scatter, Gather) | MPI | [tp5_mpi_matvec.md](tp5_mpi_matvec.md) |
| TP6 | Chaleur distribuee (SPMD, ghost zones, Isend) | MPI | [tp6_mpi_chaleur.md](tp6_mpi_chaleur.md) |
