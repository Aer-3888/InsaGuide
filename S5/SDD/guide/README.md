# SDD -- Structures de Donnees

## Presentation du cours

SDD est le cours fondamental de structures de donnees a l'INSA Rennes (3e annee, Semestre 5). Il couvre la conception, l'implementation et l'analyse des structures de donnees fondamentales en Java, avec un accent sur les types abstraits de donnees, la separation interface/implementation et la complexite algorithmique.

**Langage :** Java (generiques, interfaces, iterateurs, framework de collections)
**Evaluation :** Examen ecrit (DS) -- implementer des operations, tracer des algorithmes, prouver des complexites

## Sujets

| # | Sujet | Guide | Concepts cles |
|---|-------|-------|---------------|
| 1 | [Listes chainees](01-linked-lists.md) | Simplement/doublement chainees, sentinelles, patron curseur | O(1) insertion/suppression au curseur |
| 2 | [Iterateurs et Design Patterns](02-iterators.md) | Patron iterateur, Java Iterator/Iterable, patron adaptateur | Separation des preoccupations |
| 3 | [Piles et Files](03-stacks-queues.md) | LIFO/FIFO, implementations tableau/chainee | Evaluation d'expressions, BFS |
| 4 | [Tables de hachage](04-hash-tables.md) | Fonctions de hachage, chainage, adressage ouvert, facteur de charge | O(1) recherche en moyenne |
| 5 | [Arbres binaires](05-binary-trees.md) | ABR, AVL, rotations, parcours | O(log n) operations equilibrees |
| 6 | [Tas et Files de priorite](06-heaps-priority-queues.md) | Tas min/max, heapify, tri par tas | O(log n) insertion/extraction-min |
| 7 | [Graphes et Dijkstra](07-graphs-dijkstra.md) | Liste/matrice d'adjacence, BFS, DFS, Dijkstra | Plus courts chemins |
| 8 | [Quadtrees](08-quadtrees.md) | Structures spatiales, quadtrees de region, elagage | Compression d'images |
| 9 | [Analyse de complexite](09-complexity.md) | Big-O, Theta, Omega, analyse amortie | Techniques de preuve |

## Tableau de complexite general

| Structure de donnees | Acces | Recherche | Insertion | Suppression | Espace | Notes |
|---------------------|-------|-----------|-----------|-------------|--------|-------|
| Tableau | O(1) | O(n) | O(n) | O(n) | O(n) | O(log n) recherche si trie |
| Liste chainee (au curseur) | O(n) | O(n) | O(1) | O(1) | O(n) | O(1) ops a position connue |
| Liste avec tableau | O(1) | O(n) | O(n) | O(n) | O(n) | O(1) amorti en ajout a la fin |
| Pile | O(n) | O(n) | O(1) | O(1) | O(n) | Acces LIFO uniquement |
| File | O(n) | O(n) | O(1) | O(1) | O(n) | Acces FIFO uniquement |
| Table de hachage | -- | O(1)* | O(1)* | O(1)* | O(n) | *Cas moyen ; O(n) pire cas |
| ABR (equilibre) | O(log n) | O(log n) | O(log n) | O(log n) | O(n) | Degenere en O(n) si desequilibre |
| Arbre AVL | O(log n) | O(log n) | O(log n) | O(log n) | O(n) | Equilibre garanti |
| Tas min/max | O(1)** | O(n) | O(log n) | O(log n) | O(n) | **Peek seulement ; pas d'acces arbitraire |
| File de priorite (tas) | -- | -- | O(log n) | O(log n) | O(n) | add + poll |
| File de priorite (tableau trie) | -- | -- | O(n) | O(n) | O(n) | add utilise recherche dichotomique + decalage ; poll decale tous les elements |
| Quadtree | -- | O(log n)*** | O(log n)*** | O(log n)*** | O(n) | ***Pour requetes spatiales |
| Graphe (liste adj.) | -- | O(V+E) | O(1) | O(E) | O(V+E) | Operations sur aretes |
| Graphe (matrice adj.) | -- | O(1) | O(1) | O(1) | O(V^2) | Couteux en espace |

## Patrons Java utilises dans ce cours

### 1. Separation interface / implementation
```
Liste<T>  (interface)
  |-- ListeDoubleChainee<T>  (linked implementation)
  |-- ListeTabulee<T>         (array implementation)
```

### 2. Patron Iterateur
```
Liste<T> --creates--> Iterateur<T>
  |                      |
  |-- ListeDoubleChainee |-- ListeDoubleChaineeIterateur
  |-- ListeTabulee       |-- ListeTabuleeIterateur
```

### 3. Patron Adaptateur
```
Liste<T> --adapted by--> ListeEngine<T> implements java.util.List<T>
Iterateur<T> --adapted by--> IterateurEngine<T> implements java.util.Iterator<T>
```

### 4. Generiques
```java
public class ListeDoubleChainee<T> implements Liste<T> { ... }
public class HeapPQ<T> implements PriorityQueue<T> { ... }
public class Dijkstra<T> { ... }
```

## Comment utiliser ce guide

1. **Avant un TP** : Lire le guide du sujet correspondant pour la theorie
2. **Pendant les revisions** : Utiliser les aide-memoire a la fin de chaque sujet
3. **Avant l'examen** : Se concentrer sur la section [Preparation a l'examen](../exam-prep/)
4. **Pour s'exercer** : Travailler les [Solutions d'exercices](../exercises/) avec le code source des TP

## Fichiers cles a connaitre

| Fichier | Role |
|---------|------|
| `MyList&lt;T&gt;` | Interface liste originale (TP1) |
| `Liste&lt;T&gt;` / `Iterateur&lt;T&gt;` | Interfaces raffinées separant liste et iterateur (TP2-3) |
| `ListeEngine&lt;T&gt;` / `IterateurEngine&lt;T&gt;` | Adaptateurs reliant listes personnalisees a `java.util.List` (TP3) |
| `Arbre` | Interface arbre binaire (TP6) |
| `TreeTwo` | Implementation arbre binaire avec parcours postfixe (TP6) |
| `ExprArith` | Evaluateur d'expressions arithmetiques par arbre (TP6) |
| `QuadTree` / `Tree` | Interface et implementation quadtree pour images (TP7) |
| `PriorityQueue&lt;T&gt;` / `HeapPQ&lt;T&gt;` | File de priorite avec tas binaire (TP8) |
| `Graph&lt;T&gt;` / `IndexedGraph` | Interface graphe et implementation par liste d'adjacence (TP8) |
| `Dijkstra&lt;T&gt;` | Algorithme de plus court chemin (TP8) |
