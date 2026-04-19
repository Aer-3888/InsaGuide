# Graphes et Algorithme de Dijkstra

## Theorie

### Definitions

Un **graphe** G = (V, E) est compose de :
- **V** : ensemble de sommets (vertices)
- **E** : ensemble d'aretes/arcs (edges)

Types :
- **Oriente** (directed) : les arcs ont une direction (u → v)
- **Non oriente** (undirected) : les aretes vont dans les deux sens
- **Pondere** (weighted) : les aretes ont des couts/poids
- **Non pondere** (unweighted) : toutes les aretes ont un cout egal

```
Directed weighted graph:

    (0)---3--->(1)
     |         / |
    10       4   1
     |      /    |
     v    v      v
    (3)<-------(2)
     |
     3
     v
    (4)
```

### Representations

#### Liste d'adjacence (Adjacency List)

Chaque sommet stocke une liste de ses voisins.

```
0: [(1, 3), (3, 10)]      <- vertex 0 has edges to 1 (weight 3) and 3 (weight 10)
1: [(2, 4), (3, 1)]
2: []
3: [(4, 3)]
4: [(3, 2)]
```

- Espace : O(V + E)
- Verifier l'existence d'une arete : O(degre)
- Iterer les voisins : O(degre)

#### Matrice d'adjacence (Adjacency Matrix)

Tableau 2D ou matrice[u][v] = poids de l'arete u->v (infini si pas d'arete).

```
     0    1    2    3    4
0  [ 0    3   inf  10  inf]
1  [inf   0    4    1  inf]
2  [inf  inf   0   inf inf]
3  [inf  inf  inf   0    3]
4  [inf  inf  inf   2    0]
```

- Espace : O(V^2)
- Verifier l'existence d'une arete : O(1)
- Iterer les voisins : O(V)


## Implementation Java (du TP8)

### Interface Graph

```java
public interface Graph<T> {
    int numberOfVertices();
    int numberOfEdges();
    void addVertex(T v);
    void addEdge(T u, T v, double weight);
    Iterable<VertexAndWeight<T>> neighbors(T u);
}
```

### IndexedGraph (liste d'adjacence avec sommets entiers)

```java
public class IndexedGraph implements Graph<Integer> {
    private final int numberOfVertices;
    private int numberOfEdges;
    private boolean oriented;
    private List<VertexAndWeight<Integer>>[] adjacency;

    public IndexedGraph(int numberOfVertices, boolean oriented) {
        this.numberOfVertices = numberOfVertices;
        this.oriented = oriented;
        adjacency = new ArrayList[numberOfVertices];
        for (int i = 0; i < numberOfVertices; i++)
            adjacency[i] = new ArrayList<>();
    }

    public void addEdge(Integer u, Integer v, double weight) {
        adjacency[u].add(new VertexAndWeight<>(v, weight));
        if (!oriented)
            adjacency[v].add(new VertexAndWeight<>(u, weight));
    }

    public Iterable<VertexAndWeight<Integer>> neighbors(Integer u) {
        return adjacency[u];
    }
}
```

### VertexAndWeight

```java
public class VertexAndWeight<T> {
    public final T vertex;
    public final double weight;

    public VertexAndWeight(T vertex, double weight) {
        this.vertex = vertex;
        this.weight = weight;
    }
}
```


## BFS et DFS

### BFS (Parcours en largeur)

Utilise une **file**. Explore niveau par niveau.

```java
void bfs(Graph<T> g, T source) {
    Set<T> visited = new HashSet<>();
    Queue<T> queue = new ArrayDeque<>();
    queue.offer(source);
    visited.add(source);

    while (!queue.isEmpty()) {
        T u = queue.poll();
        process(u);
        for (VertexAndWeight<T> neighbor : g.neighbors(u)) {
            if (!visited.contains(neighbor.vertex)) {
                visited.add(neighbor.vertex);
                queue.offer(neighbor.vertex);
            }
        }
    }
}
```

Complexite : O(V + E)

### DFS (Parcours en profondeur)

Utilise une **pile** (ou la recursion). Va en profondeur d'abord.

```java
void dfs(Graph<T> g, T source) {
    Set<T> visited = new HashSet<>();
    Deque<T> stack = new ArrayDeque<>();
    stack.push(source);

    while (!stack.isEmpty()) {
        T u = stack.pop();
        if (visited.contains(u)) continue;
        visited.add(u);
        process(u);
        for (VertexAndWeight<T> neighbor : g.neighbors(u))
            if (!visited.contains(neighbor.vertex))
                stack.push(neighbor.vertex);
    }
}
```

Complexite : O(V + E)


## Algorithme de Dijkstra

### Principe

Trouve le **plus court chemin** depuis un sommet source vers tous les autres sommets dans un graphe pondere avec des **poids non negatifs**.

Utilise une **file de priorite** (tas min) pour toujours traiter le sommet non visite le plus proche.

### Algorithme (Lazy Dijkstra -- du TP8)

```
1. Insert source into PQ with distance 0
2. While PQ is not empty:
   3. Pop the node n with smallest distance
   4. If n.vertex is already in 'cost': skip (already processed)
   5. Record n.vertex in cost and prev
   6. For each neighbor v of n.vertex:
      7. Add new node (cost = n.cost + edge_weight) to PQ
```

### Implementation Java (du TP8)

```java
public class Dijkstra<T> {
    private final PriorityQueue<DijkstraNode<T>> pq;
    private final Map<T, Double> cost = new HashMap<>();
    private final Map<T, T> prev = new HashMap<>();

    public Dijkstra(Graph<T> graph, T source,
                    PriorityQueue<DijkstraNode<T>> pq) {
        this.pq = pq;
        solve(graph, source);
    }

    private void solve(Graph<T> graph, T source) {
        // Step 1: insert source
        pq.add(new DijkstraNode<>(0.0, source));

        // Step 2: while PQ not empty
        while (!pq.isEmpty()) {
            // Step 3: pop minimum
            DijkstraNode<T> node = pq.poll();

            // Step 4: skip if already processed
            if (cost.containsKey(node.vertex)) continue;

            // Step 5: record cost and predecessor
            cost.put(node.vertex, node.cost);
            prev.put(node.vertex, node.prev);

            // Step 6: relax neighbors
            for (VertexAndWeight<T> neighbor : graph.neighbors(node.vertex)) {
                pq.add(new DijkstraNode<>(
                    neighbor.weight + node.cost,
                    neighbor.vertex,
                    node.vertex
                ));
            }
        }
    }

    // Reconstruire le chemin de la source vers v
    public Deque<T> getPathTo(T v) {
        Deque<T> path = new ArrayDeque<>();
        path.push(v);
        T road = v;
        while (cost.get(road) != 0) {
            road = prev.get(road);
            path.push(road);
        }
        return path;
    }

    public double getCost(T v) {
        return cost.getOrDefault(v, Double.POSITIVE_INFINITY);
    }
}
```

### DijkstraNode

```java
public class DijkstraNode<T> implements Comparable<DijkstraNode<T>> {
    final Double cost;
    final T vertex;
    final T prev;

    @Override
    public int compareTo(DijkstraNode<T> node) {
        return Double.compare(cost, node.cost);
    }
}
```

### Exemple de trace

```
Graph (directed, weighted):
  (0)--3-->(1)--4-->(2)
   |        |
  10        1
   |        |
   v        v
  (3)-------(3 is target of both edges)
   |
   3
   v
  (4)--2-->(3)   [edge from 4 back to 3]

Edges: 0->1 (w=3), 0->3 (w=10), 1->2 (w=4), 1->3 (w=1), 3->4 (w=3), 4->3 (w=2)

Dijkstra from 0:

PQ: [(0, cost=0)]
  Pop (0, 0). cost={0:0}. Add neighbors: (1,3), (3,10)
PQ: [(1, 3), (3, 10)]
  Pop (1, 3). cost={0:0, 1:3}. Add: (2, 3+4=7), (3, 3+1=4)
PQ: [(3, 4), (2, 7), (3, 10)]
  Pop (3, 4). cost={0:0, 1:3, 3:4}. Add: (4, 4+3=7)
PQ: [(2, 7), (4, 7), (3, 10)]
  Pop (2, 7). cost={0:0, 1:3, 3:4, 2:7}. No outgoing edges from 2.
PQ: [(4, 7), (3, 10)]
  Pop (4, 7). cost={0:0, 1:3, 3:4, 2:7, 4:7}. Add: (3, 7+2=9)
PQ: [(3, 9), (3, 10)]
  Pop (3, 9). Already in cost -> skip.
  Pop (3, 10). Already in cost -> skip.
PQ empty. Done!

Final costs: {0:0, 1:3, 2:7, 3:4, 4:7}
Path to 4: 0 -> 1 -> 3 -> 4
```


## Complexite

| Algorithme | Complexite temps | Espace |
|-----------|-----------------|--------|
| BFS | O(V + E) | O(V) |
| DFS | O(V + E) | O(V) |
| Dijkstra (binary heap) | O((V + E) log V) | O(V) |
| Dijkstra (sorted array PQ) | O(V^2 + E) | O(V) |
| Dijkstra (Fibonacci heap) | O(V log V + E) | O(V) |

Note : Dijkstra necessite des **poids non negatifs**. Pour des poids negatifs, utiliser Bellman-Ford.


## Applications dans le TP8

### Seam Carving (Recadrage intelligent)

Convertir la carte d'energie d'une image en un graphe grille, utiliser Dijkstra pour trouver le chemin d'energie minimale (seam), et le supprimer pour redimensionner l'image.

### Le Compte est Bon

Modeliser le jeu arithmetique comme un graphe ou les etats sont des piles de calcul (Notation Polonaise Inverse). Utiliser Dijkstra pour trouver la sequence optimale d'operations.


## AIDE-MEMOIRE

```
GRAPH REPRESENTATIONS:
  Adjacency list:  O(V+E) space, O(deg) edge check
  Adjacency matrix: O(V^2) space, O(1) edge check

TRAVERSALS:
  BFS: queue, level-by-level, O(V+E)
  DFS: stack/recursion, goes deep, O(V+E)

DIJKSTRA (with min-heap):
  1. PQ.add(source, cost=0)
  2. While PQ not empty:
     3. node = PQ.poll()
     4. If node.vertex in cost: skip
     5. cost[node.vertex] = node.cost
     6. For each neighbor v:
        PQ.add(v, node.cost + weight(node, v))

  Time: O((V+E) log V)
  Requires: non-negative weights

PATH RECONSTRUCTION:
  prev[v] = predecessor of v on shortest path
  Follow prev backwards from target to source
```
