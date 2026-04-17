# Cheat Sheet -- Parallelisme (Revision et Annales)

> **Objectif :** Cette fiche condense tout ce qu'il faut savoir pour le DS. Elle est organisee par theme et inclut une analyse des annales (2021, 2023, 2024, 2025) pour identifier les patterns de questions recurrents.

---

## 1. Analyse des annales -- Structure typique du DS

### 1.1 Format general

D'apres les annales INSA Rennes (2021-2025), le DS de parallelisme dure generalement **2 heures** et est compose de :

| Partie | Poids approximatif | Contenu |
|--------|-------------------|---------|
| Partie 1 : Questions de cours | ~30% | Definitions, loi d'Amdahl, taxonomie Flynn, vrai/faux |
| Partie 2 : OpenMP | ~30% | Analyser/ecrire du code OpenMP, identifier les bugs |
| Partie 3 : MPI | ~25% | Ecrire des communications collectives, analyser un programme |
| Partie 4 : GPU/CUDA (si traite) | ~15% | Architecture, ecrire un kernel simple |

### 1.2 Questions types par theme

#### Loi d'Amdahl et performance (revient CHAQUE annee)

- "Calculer le speedup maximal pour f = 0.8 et p = 16 processeurs"
- "Quelle fraction du code doit etre parallelisable pour atteindre un speedup de 8 ?"
- "Calculer le speedup et l'efficacite a partir de temps mesures"
- "Expliquer pourquoi le speedup n'est pas lineaire"

#### OpenMP (revient CHAQUE annee)

- "Paralleliser cette boucle avec OpenMP" (ajouter les bons pragmas)
- "Ce code contient une race condition, identifiez-la et corrigez-la"
- "Quelle clause utiliser pour cette variable (shared/private/firstprivate/reduction) ?"
- "Quelle politique de schedule choisir et pourquoi ?"
- "Expliquer le faux partage et comment l'eviter"

#### MPI (revient CHAQUE annee)

- "Completer ce programme MPI pour distribuer les donnees"
- "Ce programme MPI peut-il provoquer un deadlock ? Pourquoi ?"
- "Remplacer les Send/Recv par des communications collectives"
- "Ecrire un produit matrice-vecteur distribue"

#### GPU/CUDA (revient la plupart du temps)

- "Calculer l'index global d'un thread"
- "Combien de blocs faut-il pour traiter N elements ?"
- "Ecrire un kernel simple (addition de vecteurs, etc.)"
- "Expliquer la hierarchie grille/bloc/thread"

---

## 2. Formules essentielles

### Speedup et efficacite

```
Speedup :      S(p) = T(1) / T(p)
Efficacite :   E(p) = S(p) / p
```

### Loi d'Amdahl

```
S_max(p) = 1 / ((1 - f) + f/p)

Limite :  S_max(infini) = 1 / (1 - f)
```

Ou `f` = fraction parallelisable, `1-f` = fraction sequentielle.

### Loi de Gustafson

```
S_scaled(p) = p - alpha * (p - 1)
```

Ou `alpha` = fraction sequentielle.

### Exercice type : "Trouver f"

"Le speedup avec 8 processeurs est de 5. Quelle est la fraction parallelisable ?"

```
5 = 1 / ((1-f) + f/8)
(1-f) + f/8 = 1/5 = 0.2
1 - f + f/8 = 0.2
1 - 7f/8 = 0.2
7f/8 = 0.8
f = 0.8 * 8/7 = 0.914  (91.4% parallelisable)
```

---

## 3. Aide-memoire OpenMP

### Directives essentielles

```c
#pragma omp parallel                     /* Creer une equipe de threads */
#pragma omp for                          /* Distribuer une boucle (dans un parallel) */
#pragma omp parallel for                 /* Combine parallel + for */
#pragma omp parallel for reduction(+:s)  /* Boucle avec reduction */
#pragma omp critical                     /* Section critique (1 thread a la fois) */
#pragma omp atomic                       /* Operation atomique (1 variable) */
#pragma omp barrier                      /* Barriere de synchronisation */
#pragma omp single                       /* 1 seul thread execute */
#pragma omp master                       /* Seul thread 0 execute (pas de barriere) */
#pragma omp sections                     /* Parallelisme de taches */
#pragma omp section                      /* Une tache dans sections */
```

### Clauses de partage

```c
shared(x)          /* x partagee (defaut pour variables externes) */
private(x)         /* Copie privee, NON initialisee */
firstprivate(x)    /* Copie privee, initialisee avec la valeur actuelle */
lastprivate(x)     /* Copie privee, derniere valeur copiee apres */
reduction(op:x)    /* Copies locales combinees par op (+, *, min, max...) */
```

### Politiques de schedule

```c
schedule(static)         /* Blocs egaux, repartition a l'avance */
schedule(static, chunk)  /* Blocs de taille chunk en round-robin */
schedule(dynamic)        /* A la demande, chunk = 1 par defaut */
schedule(dynamic, chunk) /* A la demande, blocs de taille chunk */
schedule(guided)         /* Blocs decroissants, a la demande */
schedule(auto)           /* Le compilateur/runtime decide */
```

### Fonctions

```c
omp_get_thread_num()     /* Mon numero (0 a N-1) */
omp_get_num_threads()    /* Nombre de threads actifs */
omp_get_max_threads()    /* Maximum possible */
omp_set_num_threads(n)   /* Fixer le nombre de threads */
omp_get_wtime()          /* Temps mur (chronometre) */
```

### Compilation

```bash
gcc -fopenmp programme.c -o programme -lm
OMP_NUM_THREADS=4 ./programme
```

### Erreurs classiques au DS

| Erreur | Correction |
|--------|------------|
| Race condition sur une somme | Utiliser `reduction(+:somme)` |
| Variable privee non initialisee | Utiliser `firstprivate` au lieu de `private` |
| Paralleliser une boucle avec dependance | Verifier que `tab[i]` ne depend pas de `tab[i-1]` |
| Oublier `-fopenmp` | Les pragmas sont ignores silencieusement |
| Mesurer avec `clock()` | Utiliser `omp_get_wtime()` |

---

## 4. Aide-memoire MPI

### Initialisation

```c
#include <mpi.h>

MPI_Init(&argc, &argv);
MPI_Comm_rank(MPI_COMM_WORLD, &rang);
MPI_Comm_size(MPI_COMM_WORLD, &nb_proc);
/* ... programme ... */
MPI_Finalize();
```

### Point a point

```c
/* Envoyer */
MPI_Send(&donnee, count, MPI_DOUBLE, dest, tag, MPI_COMM_WORLD);

/* Recevoir */
MPI_Recv(&buffer, count, MPI_DOUBLE, source, tag, MPI_COMM_WORLD, MPI_STATUS_IGNORE);

/* Envoyer ET recevoir (pas de deadlock) */
MPI_Sendrecv(&envoi, cnt, type, dest, tag,
             &recep, cnt, type, src, tag,
             MPI_COMM_WORLD, MPI_STATUS_IGNORE);
```

### Communications collectives

```c
/* Diffusion (1 -> tous) */
MPI_Bcast(&donnee, count, type, root, MPI_COMM_WORLD);

/* Distribution (decouper un tableau) */
MPI_Scatter(tab_complet, count_par_proc, type,
            mon_morceau, count_par_proc, type,
            root, MPI_COMM_WORLD);

/* Rassemblement (recoller les morceaux) */
MPI_Gather(mon_morceau, count_par_proc, type,
           tab_complet, count_par_proc, type,
           root, MPI_COMM_WORLD);

/* Reduction (combiner avec une operation) */
MPI_Reduce(&ma_valeur, &resultat, count, type,
           MPI_SUM, root, MPI_COMM_WORLD);

/* Reduction + diffusion du resultat */
MPI_Allreduce(&ma_valeur, &resultat, count, type,
              MPI_SUM, MPI_COMM_WORLD);

/* Barriere */
MPI_Barrier(MPI_COMM_WORLD);
```

### Types MPI courants

| MPI | C |
|-----|---|
| `MPI_INT` | `int` |
| `MPI_LONG` | `long` |
| `MPI_FLOAT` | `float` |
| `MPI_DOUBLE` | `double` |
| `MPI_CHAR` | `char` |

### Operations de reduction

| Operation | Resultat |
|-----------|----------|
| `MPI_SUM` | Somme |
| `MPI_PROD` | Produit |
| `MPI_MAX` | Maximum |
| `MPI_MIN` | Minimum |
| `MPI_MAXLOC` | Max + rang |
| `MPI_MINLOC` | Min + rang |

### Compilation et execution

```bash
mpicc programme.c -o programme -lm
mpiexec -n 4 ./programme
```

### Erreurs classiques au DS

| Erreur | Correction |
|--------|------------|
| Deadlock Send/Send | Alterner : un Send, l'autre Recv |
| Bcast seulement dans le `if (rang==0)` | Bcast doit etre appele par TOUS les processus |
| Confondre count et taille en octets | count = nombre d'elements, pas sizeof |
| N non divisible par nb_proc | Utiliser Scatterv/Gatherv ou verifier avec assert |
| Oublier MPI_Finalize | Messages perdus, terminaison incorrecte |

---

## 5. Aide-memoire CUDA

### Structure d'un programme

```c
/* 1. Allouer GPU */     cudaMalloc(&d_ptr, taille);
/* 2. Copier CPU->GPU */ cudaMemcpy(d_ptr, h_ptr, taille, cudaMemcpyHostToDevice);
/* 3. Lancer kernel */   kernel<<<nb_blocs, taille_bloc>>>(d_ptr, N);
/* 4. Synchroniser */    cudaDeviceSynchronize();
/* 5. Copier GPU->CPU */ cudaMemcpy(h_ptr, d_ptr, taille, cudaMemcpyDeviceToHost);
/* 6. Liberer GPU */     cudaFree(d_ptr);
```

### Calcul de l'index global (LA formule a connaitre)

```c
int i = blockIdx.x * blockDim.x + threadIdx.x;
```

### Calcul du nombre de blocs

```c
int nb_blocs = (N + taille_bloc - 1) / taille_bloc;   /* = ceil(N / taille_bloc) */
```

### Variables built-in dans un kernel

| Variable | Signification |
|----------|---------------|
| `threadIdx.x` | Index du thread dans son bloc (0 a blockDim.x-1) |
| `blockIdx.x` | Index du bloc dans la grille (0 a gridDim.x-1) |
| `blockDim.x` | Nombre de threads par bloc |
| `gridDim.x` | Nombre de blocs dans la grille |

### Memoire partagee

```c
__shared__ float cache[256];    /* Visible par tous les threads du bloc */
__syncthreads();                /* Barriere intra-bloc (OBLIGATOIRE avant de lire) */
```

### Qualificateurs de fonction

| Qualificateur | Appele depuis | Execute sur |
|---------------|---------------|-------------|
| `__global__` | CPU | GPU |
| `__device__` | GPU | GPU |
| `__host__` | CPU | CPU |

---

## 6. Aide-memoire Pthreads

### Fonctions essentielles

```c
#include <pthread.h>

/* Creer un thread */
pthread_create(&thread, NULL, fonction, argument);

/* Attendre un thread */
pthread_join(thread, NULL);

/* Mutex */
pthread_mutex_t m = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_lock(&m);
/* section critique */
pthread_mutex_unlock(&m);

/* Variable de condition */
pthread_cond_t c = PTHREAD_COND_INITIALIZER;
pthread_cond_wait(&c, &m);      /* Dormir (AVEC while autour !) */
pthread_cond_signal(&c);        /* Reveiller UN thread */
pthread_cond_broadcast(&c);     /* Reveiller TOUS les threads */
```

### Patron producteur-consommateur (resume)

```c
/* Producteur */
lock(mutex);
while (buffer_plein) cond_wait(pas_plein, mutex);
ajouter_element();
cond_signal(pas_vide);
unlock(mutex);

/* Consommateur */
lock(mutex);
while (buffer_vide) cond_wait(pas_vide, mutex);
retirer_element();
cond_signal(pas_plein);
unlock(mutex);
```

### Compilation

```bash
gcc -pthread programme.c -o programme
```

---

## 7. Comparatif rapide des technologies

| Critere | Pthreads | OpenMP | MPI | CUDA |
|---------|----------|--------|-----|------|
| Modele memoire | Partagee | Partagee | Distribuee | Separee (CPU/GPU) |
| Niveau d'abstraction | Bas | Haut | Moyen | Moyen |
| Facilite | Difficile | Facile | Moyen | Difficile |
| Scalabilite | 1 machine | 1 machine | Cluster | 1 GPU |
| Parallelisme | Quelques threads | Quelques threads | Dizaines de processus | Milliers de threads |
| Compilation | `gcc -pthread` | `gcc -fopenmp` | `mpicc` | `nvcc` |

---

## 8. Patron "checklist" pour le DS

### Si on te demande de paralleliser une boucle avec OpenMP :

1. Verifier que les iterations sont **independantes** (pas de `tab[i-1]` dans `tab[i]`)
2. Identifier les variables **partagees** vs **privees**
3. Reperer les **accumulations** (sommes, max, compteurs) --> `reduction`
4. Choisir le `schedule` si les iterations sont inegales
5. Ajouter `#pragma omp parallel for` avec les clauses appropriees

### Si on te demande d'ecrire un programme MPI :

1. `MPI_Init`, `Comm_rank`, `Comm_size`
2. Le processus 0 initialise les donnees
3. `Bcast` pour les donnees partagees, `Scatter` pour distribuer
4. Chaque processus calcule sa part
5. `Gather` ou `Reduce` pour rassembler
6. `MPI_Finalize`

### Si on te demande d'ecrire un kernel CUDA :

1. Calculer l'index global : `int i = blockIdx.x * blockDim.x + threadIdx.x;`
2. Verifier les bornes : `if (i < N)`
3. Ecrire le calcul pour UN element
4. Cote host : allouer, copier, lancer `<<<blocs, threads>>>`, copier, liberer

### Si on te donne du code a debugger :

1. Chercher les **race conditions** (variable partagee modifiee sans protection)
2. Chercher les **deadlocks** (Send/Send, ordre de lock)
3. Verifier les types et tailles (`count` vs `sizeof`)
4. Verifier que les collectives sont appelees par **tous** les processus
5. Verifier les indices (hors bornes, GPU sans `if (i < N)`)

---

## 9. Formules rapides a retenir

| Formule | Usage |
|---------|-------|
| `S(p) = T(1)/T(p)` | Speedup |
| `E(p) = S(p)/p` | Efficacite |
| `1/((1-f)+f/p)` | Amdahl |
| `1/(1-f)` | Amdahl limite (p infini) |
| `p - alpha*(p-1)` | Gustafson |
| `blockIdx.x*blockDim.x+threadIdx.x` | Index global CUDA |
| `(N+B-1)/B` | Nombre de blocs (ceil(N/B)) |

---

## 10. Mots-cles a placer dans une copie

Si tu as un trou de memoire au DS, retiens ces mots-cles. Les placer dans ta reponse montre que tu maitrises les concepts :

| Contexte | Mots-cles |
|----------|-----------|
| Performance | Speedup, efficacite, loi d'Amdahl, fraction sequentielle, surcout |
| Problemes | Race condition, deadlock, faux partage, desequilibrage de charge |
| OpenMP | Region parallele, fork-join, reduction, section critique, barriere implicite |
| MPI | SPMD, communicateur, communication collective, point a point, rang |
| CUDA | Kernel, grille, bloc, warp, memoire globale/partagee, acces coalescent |
| Synchronisation | Mutex, barriere, atomique, exclusion mutuelle |
