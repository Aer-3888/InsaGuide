# Complexity Analysis (Analyse de Complexite)

## Notation asymptotique

### Grand-O : O(f(n)) -- Borne superieure

f(n) = O(g(n)) means there exist constants c > 0 and n0 such that:
  f(n) &lt;= c * g(n) for all n >= n0

"f ne croit pas plus vite que g"

### Grand-Omega : Omega(f(n)) -- Borne inferieure

f(n) = Omega(g(n)) means there exist constants c > 0 and n0 such that:
  f(n) >= c * g(n) for all n >= n0

"f croit au moins aussi vite que g"

### Grand-Theta : Theta(f(n)) -- Borne exacte

f(n) = Theta(g(n)) means f(n) = O(g(n)) AND f(n) = Omega(g(n))

"f croit au meme rythme que g"


## Classes de complexite courantes

```
O(1) < O(log n) < O(n) < O(n log n) < O(n^2) < O(n^3) < O(2^n) < O(n!)

n=1000:
  O(1)        = 1
  O(log n)    = ~10
  O(n)        = 1,000
  O(n log n)  = ~10,000
  O(n^2)      = 1,000,000
  O(n^3)      = 1,000,000,000
  O(2^n)      = (astronomically large)
```


## Complexite des structures de donnees SDD

### Liste chainee

| Operation | Singly Linked | Doubly Linked (at cursor) |
|-----------|--------------|---------------------------|
| Access i-th | O(n) | O(n) |
| Insert at cursor | O(1) | O(1) |
| Delete at cursor | O(n)* | O(1) |
| Search | O(n) | O(n) |
| Insert at head | O(1) | O(1) |
| Insert at tail | O(n)** | O(1) |

*Necessite le predecesseur en simplement chainee.
**O(1) si on maintient un pointeur de queue.

### Table de hachage

| Operation | Average | Worst Case |
|-----------|---------|------------|
| Insert | O(1) | O(n) |
| Search | O(1) | O(n) |
| Delete | O(1) | O(n) |

Pire cas : toutes les cles hashent vers le meme bucket.
Cas moyen suppose un hachage uniforme et un facteur de charge alpha &lt; 1.

### Arbre binaire de recherche

| Operation | Balanced (AVL) | Worst (degenerate) |
|-----------|---------------|-------------------|
| Search | O(log n) | O(n) |
| Insert | O(log n) | O(n) |
| Delete | O(log n) | O(n) |
| Traversal | O(n) | O(n) |

### Tas / File de priorite

| Operation | Binary Heap |
|-----------|------------|
| Insert (add) | O(log n) |
| Extract min/max (poll) | O(log n) |
| Peek | O(1) |
| Build heap (heapify) | O(n) |
| Heap sort | O(n log n) |

### Algorithmes de graphes

| Algorithm | Time | Space |
|-----------|------|-------|
| BFS | O(V + E) | O(V) |
| DFS | O(V + E) | O(V) |
| Dijkstra (heap) | O((V + E) log V) | O(V + E) |


## Analyse amortie

### Concept

Certaines operations sont couteuses occasionnellement mais bon marche la plupart du temps. L'analyse amortie donne le **cout moyen par operation** sur une sequence de pire cas.

### Exemple : Tableau dynamique (ArrayList)

Quand le tableau est plein, doubler sa capacite (copier tous les elements).

```
Operation costs for n insertions:
  Insert 1:  cost 1
  Insert 2:  cost 1 + 2 (copy)  = 3
  Insert 3:  cost 1
  Insert 4:  cost 1 + 4 (copy)  = 5
  Insert 5:  cost 1
  ...
  Insert 8:  cost 1 + 8 (copy)  = 9

Total for n insertions: n + (1 + 2 + 4 + ... + n) = n + 2n - 1 < 3n
Amortized cost per insertion: O(3n/n) = O(1)
```

### Exemple : Rehachage de table de hachage

When load factor exceeds threshold, create 2x larger table and rehash all entries.

```
n insertions with doubling at alpha = 1:
  Total work: n + (1 + 2 + 4 + ... + n) = O(n)
  Amortized per insert: O(1)
```


## Techniques de preuve

### Prouver O(f(n))

1. Trouver des constantes c et n0 telles que T(n) &lt;= c * f(n) pour tout n >= n0
2. Souvent : identifier le terme dominant et montrer qu'il borne T(n)

**Exemple** : T(n) = 3n^2 + 5n + 7 est O(n^2)

Preuve : Pour n >= 1 : 3n^2 + 5n + 7 &lt;= 3n^2 + 5n^2 + 7n^2 = 15n^2
Donc c = 15, n0 = 1.

### Prouver Theta(f(n))

Il faut prouver a la fois O(f(n)) et Omega(f(n)).

**Exemple** : T(n) = 3n^2 + 5n + 7 est Theta(n^2)

Borne superieure : montre ci-dessus, O(n^2)
Borne inferieure : Pour n >= 1 : 3n^2 + 5n + 7 >= 3n^2, donc Omega(n^2) avec c = 3.

### Relations de recurrence

De nombreux algorithmes d'arbre ont des recurrences :

**Binary search**: T(n) = T(n/2) + O(1) → T(n) = O(log n)
**Merge sort**: T(n) = 2T(n/2) + O(n) → T(n) = O(n log n)
**Tree traversal**: T(n) = T(k) + T(n-1-k) + O(1) → T(n) = O(n)

### Theoreme maitre

For T(n) = aT(n/b) + O(n^d):

| Condition | Result |
|-----------|--------|
| d > log_b(a) | T(n) = O(n^d) |
| d = log_b(a) | T(n) = O(n^d * log n) |
| d &lt; log_b(a) | T(n) = O(n^(log_b(a))) |


## Comparaison des algorithmes de tri

| Algorithme | Meilleur | Moyen | Pire | Espace | Stable ? |
|-----------|----------|-------|------|--------|----------|
| Tri bulle | O(n) | O(n^2) | O(n^2) | O(1) | Oui |
| Tri selection | O(n^2) | O(n^2) | O(n^2) | O(1) | Non |
| Tri insertion | O(n) | O(n^2) | O(n^2) | O(1) | Oui |
| Tri fusion | O(n log n) | O(n log n) | O(n log n) | O(n) | Oui |
| Tri rapide | O(n log n) | O(n log n) | O(n^2) | O(log n) | Non |
| Tri par tas | O(n log n) | O(n log n) | O(n log n) | O(1) | Non |
| Tri comptage | O(n+k) | O(n+k) | O(n+k) | O(k) | Oui |

Borne inferieure pour le tri par comparaison : Omega(n log n).


## Erreurs courantes

1. **Confondre O et Theta** : O(n^2) ne signifie PAS exactement n^2 etapes
2. **Supprimer les constantes trop tot** : 100n est O(n) mais compte en pratique
3. **Ignorer l'amortissement** : ArrayList.add est O(1) amorti, pas pire cas
4. **Mauvaise recurrence** : ne compter que les appels recursifs en oubliant le travail a chaque niveau
5. **Supposer un ABR equilibre** : un ABR desequilibre peut etre O(n) pour toutes les operations


## AIDE-MEMOIRE

```
NOTATION:
  O(f)     : upper bound  (at most)
  Omega(f) : lower bound  (at least)
  Theta(f) : tight bound  (exactly)

GROWTH RATES:
  1 < log n < sqrt(n) < n < n log n < n^2 < n^3 < 2^n < n!

KEY COMPLEXITIES:
  Hash table:     O(1) avg, O(n) worst
  BST balanced:   O(log n) all ops
  Heap add/poll:  O(log n)
  Heap build:     O(n)
  Dijkstra:       O((V+E) log V)
  BFS/DFS:        O(V+E)
  Sorting lower:  Omega(n log n) comparison-based

AMORTIZED:
  Dynamic array append: O(1) amortized (doubling strategy)
  Hash table insert with rehash: O(1) amortized

MASTER THEOREM: T(n) = aT(n/b) + O(n^d)
  d > log_b(a) => O(n^d)
  d = log_b(a) => O(n^d log n)
  d < log_b(a) => O(n^(log_b a))
```
