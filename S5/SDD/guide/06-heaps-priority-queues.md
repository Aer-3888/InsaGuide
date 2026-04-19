# Tas et Files de Priorite (Heaps & Priority Queues)

## Theorie

### File de priorite (Priority Queue)

Une **file de priorite** est un type abstrait de donnees ou chaque element a une priorite. L'element de plus haute priorite (plus petite valeur pour un tas min) est retire en premier.

Operations :
- `add(e)` -- inserer un element avec sa priorite
- `poll()` -- retirer et retourner l'element de plus haute priorite
- `peek()` -- retourner l'element de plus haute priorite sans le retirer
- `isEmpty()` / `size()`

### Tas binaire (Binary Heap)

Un **tas binaire** est l'implementation standard d'une file de priorite.

Proprietes :
1. **Arbre binaire complet** : tous les niveaux sont remplis sauf eventuellement le dernier, rempli de gauche a droite
2. **Propriete de tas** :
   - **Tas min** : parent &lt;= enfants (la racine est le minimum)
   - **Tas max** : parent >= enfants (la racine est le maximum)

```
Min-heap:
           [1]              Index mapping (0-based):
          /   \             parent(i) = (i-1)/2
        [3]   [2]           left(i)   = 2*i + 1
        / \   /             right(i)  = 2*i + 2
      [5] [4][6]

Array representation: [1, 3, 2, 5, 4, 6]
Index:                 0  1  2  3  4  5
```

### Representation en tableau

Un arbre binaire complet se mappe parfaitement dans un tableau :

```
Tree:          [10]                Array: [10, 20, 30, 40, 50]
              /    \               Index:  0   1   2   3   4
           [20]    [30]
           /  \
        [40]  [50]

parent(1) = (1-1)/2 = 0  -> array[0] = 10  (correct)
left(0)   = 2*0+1   = 1  -> array[1] = 20  (correct)
right(0)  = 2*0+2   = 2  -> array[2] = 30  (correct)
left(1)   = 2*1+1   = 3  -> array[3] = 40  (correct)
```


## Operations

### ShiftUp (Percolation vers le haut)

Apres insertion a la fin, remonter pour restaurer la propriete de tas.

```
Insert 1 into min-heap:

Step 0: [3, 5, 4, 7, 6, 8, 1]    1 inserted at end
                                    parent(6) = 2, array[2]=4 > 1 -> swap

Step 1: [3, 5, 1, 7, 6, 8, 4]    parent(2) = 0, array[0]=3 > 1 -> swap

Step 2: [1, 5, 3, 7, 6, 8, 4]    at root, done!
```

```java
private void shiftUp(int i) {
    while (i > 0 && compare_at(parent(i), i) > 0) {
        swap(parent(i), i);
        i = parent(i);
    }
}
```

### ShiftDown (Percolation vers le bas)

Apres suppression de la racine (remplacee par le dernier element), descendre.

```
Poll from min-heap [1, 3, 2, 5, 4, 6]:

Step 0: Remove 1, replace with last:
        [6, 3, 2, 5, 4]          6 at root
        left(0)=1 (val 3), right(0)=2 (val 2)
        min child = 2, 6 > 2 -> swap

Step 1: [2, 3, 6, 5, 4]          6 at index 2
        left(2)=5 (val ?), right(2)=6 (val ?)
        no more children below -> done!
```

```java
private void shiftDown(int i) {
    boolean finish = false;
    int k = i;
    while (k < size / 2 && !finish) {
        int index = leftChild(k);
        // Pick the smaller child (if right child exists and is smaller)
        if (index < size && compare_at(index, rightChild(k)) > 0) {
            index = rightChild(k);
        }
        // If the smaller child is still >= current, heap property holds
        if (compare_at(index, k) > 0) {
            finish = true;
        } else {
            swap(k, index);
            k = index;
        }
    }
}
```

Note : La condition `compare_at(index, rightChild(k)) > 0` verifie si l'enfant gauche est plus grand que le droit. La garde `index < size` devrait techniquement etre `rightChild(k) < size` pour verifier que l'enfant droit existe. Dans le code source du TP8, cette verification est `index < size` qui peut acceder a `heap[rightChild(k)]` meme quand rightChild(k) >= size. Cela fonctionne uniquement parce que les tableaux Java sont initialises a zero et le comparateur gere null, mais c'est un probleme de limite latent.


## Implementation Java (du TP8)

### Interface

```java
public interface PriorityQueue<T> {
    boolean isEmpty();
    int size();
    void add(T e);
    T peek();
    T poll();
}
```

### HeapPQ -- File de priorite a base de tas

```java
public class HeapPQ<T> implements PriorityQueue<T> {
    private Comparator<? super T> comparator;
    private int size;
    T[] heap;

    @SuppressWarnings("unchecked")
    public HeapPQ(int initialCapacity, Comparator<? super T> comparator) {
        heap = (T[]) new Object[initialCapacity];
        this.comparator = comparator == null
            ? (t1, t2) -> ((Comparable<? super T>) t1).compareTo(t2)
            : comparator;
    }

    // Index calculations
    private int parent(int i)     { return (i - 1) / 2; }
    private int leftChild(int i)  { return 2 * i + 1; }
    private int rightChild(int i) { return 2 * i + 2; }

    @Override
    public void add(T e) {
        if (e == null) throw new NullPointerException();
        if (size >= heap.length) grow();  // resize array
        heap[size] = e;
        shiftUp(size);
        size++;
    }

    @Override
    public T poll() {
        if (size == 0) return null;
        T result = heap[0];
        heap[0] = heap[size - 1];
        size--;
        shiftDown(0);
        return result;
    }

    @Override
    public T peek() {
        return (size == 0) ? null : heap[0];
    }
}
```

### OrderedArrayPQ -- Alternative avec tableau trie

```java
public class OrderedArrayPQ<T> implements PriorityQueue<T> {
    // Keeps array sorted at all times
    // add: binary search for position, shift right, insert -> O(n)
    // poll: return first element, shift left -> O(n)
    // peek: return first element -> O(1)
}
```


## Comparaison : Tas vs. Tableau trie

| Operation | HeapPQ | OrderedArrayPQ |
|-----------|--------|----------------|
| add | **O(log n)** | O(n) |
| poll | **O(log n)** | O(n) |
| peek | O(1) | O(1) |
| isEmpty | O(1) | O(1) |
| Construction depuis n elements | **O(n)** | O(n log n) |

Le tas est considerablement plus rapide pour l'algorithme de Dijkstra.


## Tri par tas (Heap Sort)

1. Construire un tas max a partir du tableau : O(n)
2. Extraire le max de maniere repetee et le placer a la fin : O(n log n)

```
Array: [4, 1, 3, 2, 5]

Build max-heap: [5, 4, 3, 2, 1]

Extract max:
  [5, 4, 3, 2, 1] -> swap 5 with 1 -> [1, 4, 3, 2 | 5]
  heapify -> [4, 2, 3, 1 | 5]
  swap 4 with 1 -> [1, 2, 3 | 4, 5]
  heapify -> [3, 2, 1 | 4, 5]
  swap 3 with 1 -> [1, 2 | 3, 4, 5]
  heapify -> [2, 1 | 3, 4, 5]
  swap 2 with 1 -> [1 | 2, 3, 4, 5]

Result: [1, 2, 3, 4, 5]
```

**Complexite** : O(n log n) en temps, O(1) en espace supplementaire (en place).


## Heapify (Construction du tas)

Pour construire un tas a partir d'un tableau non trie en O(n) :
- Commencer au dernier noeud interne (index n/2 - 1)
- Appliquer shiftDown a chaque noeud en remontant vers la racine

```java
for (int i = size / 2 - 1; i >= 0; i--) {
    shiftDown(i);
}
```

Pourquoi O(n) et non O(n log n) ?
- La plupart des noeuds sont pres du bas et necessitent peu d'echanges
- Somme : n/4 * 1 + n/8 * 2 + n/16 * 3 + ... = O(n)


## AIDE-MEMOIRE

```
BINARY HEAP (MIN-HEAP)
======================
Array:  [min, ..., ..., ...]
Index:   0    1    2    3   4   5   6

PARENT(i) = (i-1)/2
LEFT(i)   = 2*i + 1
RIGHT(i)  = 2*i + 2

ADD:   place at end, shiftUp      -> O(log n)
POLL:  swap root with last, shiftDown -> O(log n)
PEEK:  return root                -> O(1)
BUILD: shiftDown from n/2-1 to 0 -> O(n)

SHIFT UP:   while parent > current: swap, go to parent
SHIFT DOWN: while current > min child: swap, go to min child

HEAP SORT: build max-heap O(n), extract n times O(n log n)
           Total: O(n log n), in-place

JAVA:
  PriorityQueue<Integer> pq = new PriorityQueue<>();  // min-heap
  PriorityQueue<Integer> maxPQ = new PriorityQueue<>(Comparator.reverseOrder());
```
