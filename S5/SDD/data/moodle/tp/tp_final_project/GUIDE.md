# TP SDD - Files de Priorité et Algorithme de Dijkstra

Ce guide accompagne le TP de Structures de Données et Algorithmes (SDD). Le projet couvre 4 parties progressives : implémentation de files de priorité avec des tas, algorithme de Dijkstra, résolution du jeu "Le Compte est Bon", et une application de recadrage intelligent d'images (Seam Carving).

## Structure du Projet

```
sdd-tp-gitlab/
├── src/
│   ├── main/
│   │   ├── java/fr/insa_rennes/sdd/
│   │   │   ├── priority_queue/    # Partie I: Files de priorité
│   │   │   ├── graph/             # Partie II: Graphes
│   │   │   ├── dijkstra/          # Partie II: Algorithme de Dijkstra
│   │   │   ├── seam_carving/      # Partie IV: Recadrage intelligent
│   │   │   └── javafx/            # Interface graphique
│   │   └── resources/
│   │       └── demo.jpg           # Image de démonstration
│   └── test/java/                 # Tests unitaires JUnit
├── figures/                       # Images du README
├── pom.xml                        # Configuration Maven
└── README.md                      # Sujet détaillé du TP
```

## Technologies Utilisées

- **Java 11** - Langage de programmation
- **Maven** - Gestion de dépendances et build
- **JUnit 5** - Framework de tests unitaires
- **JUnit QuickCheck** - Tests basés sur les propriétés
- **JavaFX 11** - Interface graphique pour l'application Seam Carving
- **JMH** - Benchmarking de performances

## Prérequis et Installation

### Installation Java et Maven
```bash
# Vérifier Java (version 11 minimum)
java -version

# Vérifier Maven
mvn -version
```

### Compiler le Projet
```bash
# Compiler
mvn clean compile

# Exécuter tous les tests
mvn test

# Exécuter un test spécifique
mvn -Dtest=HeapPQTest test

# Compiler et packager
mvn package
```

## Vue d'Ensemble des Parties

### Partie I - Files de Priorité avec Tas
**Packages :** `fr.insa_rennes.sdd.priority_queue`  
**Concepts :** Tas binaire, files de priorité, complexité algorithmique

**Objectif :** Implémenter une file de priorité efficace en utilisant un tas (heap).

**Interface à implémenter :**
```java
public interface PriorityQueue<T> {
    boolean isEmpty();
    int size();
    void add(T e);
    T peek();
    T poll();
}
```

**Classes fournies :**
- `PriorityQueue<T>` - Interface à implémenter
- `OrderedArrayPQ<T>` - Implémentation inefficace de référence (O(n) pour add/poll)
- `HeapPQ<T>` - Classe à compléter (doit être O(log n) pour add/poll)

**Méthodes de l'interface :**
- `isEmpty()` - Retourne `true` si la file est vide
- `size()` - Retourne la taille de la file
- `add(T e)` - Ajoute un élément dans la file
- `peek()` - Retourne l'élément en tête sans le retirer
- `poll()` - Retourne et retire l'élément en tête

**Points clés à comprendre dans `OrderedArrayPQ` :**

1. **Comparateur (ligne 3)** - Permet d'ordonner les éléments. Si non fourni, utilise l'ordre naturel (ligne 17):
```java
comparator == null ? (t1, t2) -> ((Comparable<? super T>)t1).compareTo(t2) : comparator;
```

2. **Redimensionnement (ligne 25)** - La méthode `grow()` redimensionne le tableau quand il devient trop petit. Utilisez cette méthode dans votre `HeapPQ`.

**Tests à lancer dans l'ordre :**
1. `HeapPQTest` - Tests unitaires de base
2. `HeapPQQuickCheckTest` - Tests basés sur les propriétés
3. `AllPQQuickCheckTest` - Tests comparatifs toutes implémentations

**Commandes :**
```bash
mvn -Dtest=HeapPQTest test
mvn -Dtest=HeapPQQuickCheckTest test
mvn -Dtest=AllPQQuickCheckTest test
```

**Benchmark de performances :**
```bash
mvn compile exec:java -Dexec.mainClass="fr.insa_rennes.sdd.main.PoorBenchmarkPQ"
```

**Complexité attendue :**
- `OrderedArrayPQ` : O(n) pour add et poll
- `HeapPQ` : O(log n) pour add et poll
- La différence de performance devrait être très visible !

### Partie II - Algorithme de Dijkstra
**Packages :** `fr.insa_rennes.sdd.graph`, `fr.insa_rennes.sdd.dijkstra`  
**Concepts :** Graphes, plus court chemin, algorithme de Dijkstra

**Objectif :** Implémenter l'algorithme de Dijkstra pour trouver le plus court chemin dans un graphe.

**Interface de graphe :**
```java
public interface Graph<T> {
    int numberOfVertices();
    int numberOfEdges();
    void addVertex(T v);
    void addEdge(T u, T v, double weight);
    Iterable<VertexAndWeight<T>> neighbors(T u);
}
```

**Classes fournies :**
- `Graph<T>` - Interface de graphe
- `VertexAndWeight<T>` - Couple (sommet, poids)
- `IndexedGraph` - Implémentation exemple avec sommets entiers
- `DijkstraNode<T>` - Nœud pour l'algorithme (distance + sommet + prédécesseur)
- `Dijkstra<T>` - Classe à compléter

**Classe `Dijkstra<T>` à compléter :**
```java
public class Dijkstra<T> {
    private final PriorityQueue<DijkstraNode<T>> pq;
    private final Map<T, Double> cost = new HashMap<>();  // Distance minimale à la source
    private final Map<T, T> prev = new HashMap<>();        // Prédécesseur pour reconstruire le chemin
    
    private void solve(Graph<T> graph, T source) {
        // À IMPLÉMENTER
    }
    
    public Deque<T> getPathTo(T v) {
        // À IMPLÉMENTER - Reconstruire le chemin avec 'prev'
    }
}
```

**Algorithme de Dijkstra (LazyDijkstra) :**
1. Initialement, ajouter la source dans `pq` avec distance 0
2. Tant que `pq` n'est pas vide :
   - Retirer le premier `DijkstraNode n` de la file
   - Si `n.vertex` est déjà dans `cost`, continuer (déjà traité)
   - Mettre à jour `cost` et `prev` avec les valeurs de `n`
   - Pour chaque voisin `v` de `n.vertex` :
     - Calculer la distance à `v` via `n`
     - Ajouter un nouveau `DijkstraNode` à `pq`

**Ressources :**
- Animation : https://www.cs.usfca.edu/~galles/visualization/Dijkstra.html
- Explications LazyDijkstra : https://www.cs.princeton.edu/courses/archive/spr10/cos226/lectures/15-44ShortestPaths-2x2.pdf

**Test :**
```bash
mvn -Dtest=DijkstraTest test
```

### Partie III - Le Compte est Bon
**Packages :** `fr.insa_rennes.sdd.graph`, `fr.insa_rennes.sdd.dijkstra`  
**Concepts :** Recherche dans un espace d'états, notation polonaise inverse, graphe implicite

**Objectif :** Créer un solveur pour le jeu "Le Compte est Bon" en utilisant Dijkstra sur un graphe d'états.

**Principe du jeu :**
- 6 plaques (nombres)
- 4 opérateurs : +, -, *, /
- Objectif : atteindre un nombre cible avec des opérations valides

**Classes :**
- `LeCompteEstBonGraph` - Graphe implicite d'états de calcul
- `LeCompteEstBonGraph.State` - État de calcul (notation polonaise inverse)
- `LeCompteEstBonSolver` - Solveur fourni (utilise Dijkstra)

**Classe `State` - Représentation :**
- Utilise la notation polonaise inverse : `10 5 - 2 +` = `(10 - 5) + 2 = 7`
- Stocke le calcul dans une pile compactée (attribut `long stack`)
- Constantes :
  - `UNFINISHED` (-1) : calcul incomplet (ex: `1 2 3 +`)
  - `IMPOSSIBLE` (-2) : calcul impossible (ex: `1 2 + +`)
  - `ADD` (6), `MINUS` (7), `TIMES` (8), `DIV` (9) : opérateurs

**Attribut `stack` :**
Pile compactée dans un `long`. Exemple pour `10 25 3 + *` avec plaques `[1, 3, 7, 10, 25, 100]` :
```
Index   Valeur      Signification
  5     TIMES (8)   Opérateur *
  4     ADD (6)     Opérateur +
  3     1           Indice de 3 dans plaques
  2     4           Indice de 25 dans plaques  
  1     3           Indice de 10 dans plaques
  0     5           Taille de la pile
```

**Méthodes utilitaires fournies :**
- `int get(long stack, int index)` - Obtenir l'élément à l'indice i
- `int size(long stack)` - Taille de la pile
- `long push(long stack, int v)` - Créer nouvelle pile avec v ajouté

**Méthodes à implémenter :**

1. `int compte(long stack)` - Évaluer le calcul représenté par la pile
   - Retourne le résultat si le calcul est valide et complet
   - Retourne `IMPOSSIBLE` si le calcul est invalide
   - Retourne `UNFINISHED` si le calcul est incomplet
   - Utilisez `ArrayDeque` pour évaluer la notation polonaise inverse

2. `HashSet<VertexAndWeight<State>> neighbors()` - Générer tous les états successeurs
   - Ajouter chaque plaque non utilisée
   - Ajouter chaque opérateur si applicable
   - Utiliser `getOperatorCost(op)` pour le poids des arcs
   - Vérifier que les opérations sont valides :
     - Résultat positif
     - Division entière seulement
     - Une plaque utilisée au maximum une fois

**Tests :**
```bash
# Test de la méthode compte
mvn -Dtest=LeCompteEstBonGraphTest#testCompte test

# Test de la méthode neighbors
mvn -Dtest=LeCompteEstBonGraphTest#testNeighbors test
```

**Lancer l'application :**
```bash
mvn package
mvn exec:java -Dexec.mainClass="fr.insa_rennes.sdd.dijkstra.LeCompteEstBonSolver"
```

### Partie IV - Recadrage Intelligent (Seam Carving)
**Packages :** `fr.insa_rennes.sdd.seam_carving`, `fr.insa_rennes.sdd.graph`, `fr.insa_rennes.sdd.javafx`  
**Concepts :** Recadrage intelligent, programmation dynamique, optimisation

**Objectif :** Implémenter le seam carving pour redimensionner des images intelligemment.

**Principe :**
1. Calculer une matrice d'énergie pour chaque pixel (importance du pixel)
2. Construire un graphe à partir de cette matrice
3. Trouver le chemin de moindre énergie (seam) avec Dijkstra
4. Supprimer les pixels du chemin
5. Répéter pour réduire progressivement l'image

**Ressources :**
- Démonstration interactive : https://www.aryan.app/seam-carving/
- Article original : http://www.faculty.idc.ac.il/arik/SCWeb/imret/imret.pdf

**Classes fournies :**
- `SeamCarver` - Classe abstraite avec calcul d'énergie
- `Picture` - Représentation d'une image
- `Coordinate` - Coordonnées dans l'image (avec `Left`, `Right`, `Top`, `Bottom`)
- `LeftToRightGridGraph` - Graphe pour réduction horizontale
- `TopToBottomGridGraph` - Graphe pour réduction verticale

**Classe abstraite `SeamCarver` :**
- `energyMap()` - Calcule la matrice d'énergie (fourni)
- `cropHorizontal(Deque<Coordinate> seam)` - Supprime un seam horizontal (fourni)
- `cropVertical(Deque<Coordinate> seam)` - Supprime un seam vertical (fourni)

#### Implémentation A : Avec Dijkstra

**Classe `SeamCarverDijkstra` à compléter :**

```java
public class SeamCarverDijkstra extends SeamCarver {
    public Deque<Coordinate> horizontalSeam() {
        // Créer LeftToRightGridGraph depuis energyMap()
        // Utiliser Dijkstra pour trouver le chemin Left -> Right
        // Retourner les coordonnées (sans Left/Right)
    }
    
    public Deque<Coordinate> verticalSeam() {
        // Créer TopToBottomGridGraph depuis energyMap()
        // Utiliser Dijkstra pour trouver le chemin Top -> Bottom
        // Retourner les coordonnées (sans Top/Bottom)
    }
    
    public void reduceToSize(int width, int height) {
        // Réduire horizontalement jusqu'à atteindre 'width'
        // Puis réduire verticalement jusqu'à atteindre 'height'
        // Utiliser cropHorizontal() et cropVertical()
        // Recalculer energyMap() après chaque réduction
    }
}
```

**Construction des graphes :**
```java
// Graphe horizontal (Left -> Right)
Graph<Coordinate> graph = new LeftToRightGridGraph(energyMap());
Dijkstra<Coordinate> dijkstra = new Dijkstra<>(graph, Coordinate.Left);
Deque<Coordinate> path = dijkstra.getPathTo(Coordinate.Right);

// Graphe vertical (Top -> Bottom)
Graph<Coordinate> graph = new TopToBottomGridGraph(energyMap());
Dijkstra<Coordinate> dijkstra = new Dijkstra<>(graph, Coordinate.Top);
Deque<Coordinate> path = dijkstra.getPathTo(Coordinate.Bottom);
```

**Lancer l'application JavaFX :**
```bash
mvn javafx:run
```

**Utilisation de l'interface :**
- Menu File → Load Image : charger `src/main/resources/demo.jpg`
- Menu Action → Show Horizontal Seam : visualiser le seam horizontal
- Menu Action → Show Vertical Seam : visualiser le seam vertical
- Flèche gauche : réduire horizontalement
- Flèche bas : réduire verticalement
- Redimensionner la fenêtre : recadrage intelligent automatique

#### Implémentation B : Avec Programmation Dynamique

**Objectif :** Optimiser les performances en exploitant la structure du graphe.

**Complexité :**
- Dijkstra : O((V + E) * log V)
- Programmation dynamique : O(V + E)

**Principe pour graphe Left → Right :**
1. Initialiser première colonne avec les énergies
2. Pour chaque colonne suivante, de gauche à droite :
   - Pour chaque pixel, calculer le coût minimal depuis la gauche
   - Utiliser les coûts de la colonne précédente
3. Reconstruire le chemin à rebours

**Classe `SeamCarverDP` à compléter :**

Mêmes méthodes que `SeamCarverDijkstra`, mais implémentation avec programmation dynamique au lieu de Dijkstra.

**Pour tester :**
Modifier `Controller.loadImage()` dans `fr.insa_rennes.sdd.javafx.controller.Controller` :
```java
// Ligne 7 : remplacer
new SeamCarverDijkstra(...)
// par
new SeamCarverDP(...)
```

Puis relancer `mvn javafx:run` et constater l'amélioration des performances.

## Concepts Algorithmiques Couverts

### 1. Files de Priorité et Tas Binaires
- Structure de données : tas min/max
- Propriété de tas : parent ≤ enfants
- Opérations : heapify up, heapify down
- Complexité : O(log n) pour insertion et extraction
- Applications : ordonnancement, algorithmes de graphes

### 2. Graphes
- Représentations : listes d'adjacence, matrice d'adjacence
- Graphes orientés et pondérés
- Graphes implicites (Le Compte est Bon)
- Graphes de grille (Seam Carving)

### 3. Algorithme de Dijkstra
- Plus court chemin depuis une source
- Utilisation d'une file de priorité
- LazyDijkstra : tolérer les doublons dans la file
- Complexité : O((V + E) * log V) avec tas
- Fonctionne uniquement avec des poids positifs

### 4. Notation Polonaise Inverse
- Représentation sans parenthèses
- Évaluation avec une pile
- Exemple : `2 3 + 4 *` = `(2 + 3) * 4 = 20`

### 5. Recherche dans un Espace d'États
- Modéliser un problème comme un graphe
- États = sommets, transitions = arcs
- Coût = métrique à minimiser
- Application : jeux, puzzles, planification

### 6. Programmation Dynamique
- Principe d'optimalité de Bellman
- Sous-problèmes qui se chevauchent
- Mémorisation des résultats
- Bottom-up vs top-down
- Application : plus courts chemins dans DAG

### 7. Traitement d'Images
- Représentation RGB
- Calcul d'énergie (gradients)
- Recadrage content-aware
- Suppression de seams (chemins de pixels)

## Commandes Maven Utiles

```bash
# Compilation
mvn clean compile

# Tests
mvn test                                    # Tous les tests
mvn -Dtest=HeapPQTest test                 # Un test spécifique
mvn -Dtest=LeCompteEstBonGraphTest#testCompte test  # Une méthode de test

# Packaging
mvn package                                 # Créer le JAR

# Exécution
mvn exec:java -Dexec.mainClass="fr.insa_rennes.sdd.main.PoorBenchmarkPQ"
mvn exec:java -Dexec.mainClass="fr.insa_rennes.sdd.dijkstra.LeCompteEstBonSolver"
mvn javafx:run                             # Lancer l'interface JavaFX

# Nettoyage
mvn clean

# Afficher les dépendances
mvn dependency:tree
```

## Ordre de Réalisation Recommandé

### Séance 1 - Files de Priorité (2-3h)
1. Comprendre l'interface `PriorityQueue<T>`
2. Étudier `OrderedArrayPQ` (comparateur, redimensionnement)
3. Implémenter `HeapPQ` avec un tas binaire
4. Lancer les tests : `HeapPQTest`, `HeapPQQuickCheckTest`, `AllPQQuickCheckTest`
5. Comparer les performances avec `PoorBenchmarkPQ`

### Séance 2 - Dijkstra (2-3h)
1. Comprendre l'interface `Graph<T>`
2. Étudier `IndexedGraph` (exemple simple)
3. Implémenter `Dijkstra.solve()` selon l'algorithme
4. Implémenter `Dijkstra.getPathTo()` avec reconstruction du chemin
5. Tester avec `DijkstraTest`

### Séance 3 - Le Compte est Bon (3-4h)
1. Comprendre la classe `LeCompteEstBonGraph.State`
2. Comprendre la représentation de la pile (`stack`)
3. Implémenter `compte()` : évaluation de la notation polonaise inverse
4. Tester avec `testCompte`
5. Implémenter `neighbors()` : génération des états successeurs
6. Tester avec `testNeighbors`
7. Lancer le solveur et résoudre des parties !

### Séance 4 - Seam Carving avec Dijkstra (2-3h)
1. Comprendre le principe du seam carving
2. Étudier `energyMap()` dans `SeamCarver`
3. Implémenter `horizontalSeam()` dans `SeamCarverDijkstra`
4. Implémenter `verticalSeam()` dans `SeamCarverDijkstra`
5. Implémenter `reduceToSize()` dans `SeamCarverDijkstra`
6. Tester avec `mvn javafx:run`

### Séance 5 - Seam Carving avec Programmation Dynamique (2-3h)
1. Comprendre l'optimisation possible
2. Implémenter la programmation dynamique dans `SeamCarverDP`
3. Comparer les performances avec `SeamCarverDijkstra`
4. Expérimenter avec différentes images et tailles

## Tests et Validation

### Types de Tests

**Tests Unitaires (JUnit 5) :**
- `HeapPQTest` - Tests de base de la file de priorité
- `DijkstraTest` - Tests de l'algorithme de Dijkstra
- `LeCompteEstBonGraphTest` - Tests du graphe du Compte est Bon

**Tests basés sur les Propriétés (QuickCheck) :**
- `HeapPQQuickCheckTest` - Génération automatique de cas de test
- `AllPQQuickCheckTest` - Tests comparatifs

**Commandes de test :**
```bash
# Tous les tests
mvn test

# Un fichier de test
mvn -Dtest=HeapPQTest test

# Une méthode de test
mvn -Dtest=LeCompteEstBonGraphTest#testCompte test

# Avec output détaillé
mvn test -X
```

### Validation Visuelle

**Le Compte est Bon :**
```bash
mvn exec:java -Dexec.mainClass="fr.insa_rennes.sdd.dijkstra.LeCompteEstBonSolver"
```
Vérifier que le solveur trouve des solutions correctes.

**Seam Carving :**
```bash
mvn javafx:run
```
- Charger une image
- Visualiser les seams (doivent éviter les zones importantes)
- Redimensionner (doit préserver les éléments importants)

## Debugging et Troubleshooting

### Le projet ne compile pas
```bash
# Nettoyer et recompiler
mvn clean compile

# Vérifier la version de Java
java -version  # Doit être >= 11

# Résoudre les dépendances
mvn dependency:resolve
```

### Les tests échouent
- Lire attentivement le message d'erreur
- Vérifier la logique de l'algorithme
- Ajouter des `System.out.println()` pour debugger
- Utiliser le debugger d'IntelliJ/Eclipse

### HeapPQ ne passe pas les tests
- Vérifier la propriété de tas après chaque opération
- `add()` : insertion puis heapify up
- `poll()` : swap root avec dernier, retirer, heapify down
- Vérifier les indices (parent: i, enfants: 2*i+1 et 2*i+2)

### Dijkstra ne trouve pas le bon chemin
- Vérifier l'initialisation de `pq` avec la source
- Vérifier la condition "déjà traité" (ligne 4 de l'algorithme)
- Vérifier la mise à jour de `cost` et `prev`
- Vérifier le calcul de la distance aux voisins

### Le Compte est Bon génère trop d'états
- Vérifier qu'une plaque n'est utilisée qu'une fois
- Vérifier que les divisions sont entières
- Vérifier que les résultats sont positifs
- Éviter les états `IMPOSSIBLE`

### JavaFX ne se lance pas
```bash
# Vérifier que JavaFX est installé
mvn dependency:tree | grep javafx

# Sur Linux, installer openjfx
sudo apt install openjfx

# Relancer
mvn clean javafx:run
```

### L'application seam carving est lente
- C'est normal avec `SeamCarverDijkstra` sur de grandes images
- Implémenter `SeamCarverDP` pour améliorer les performances
- Tester sur des images plus petites d'abord

## Ressources Supplémentaires

### Algorithmes et Structures de Données
- **Livre** : Algorithms, 4th Edition - Sedgewick & Wayne
  - Site : https://algs4.cs.princeton.edu/
  - Priority queues : https://algs4.cs.princeton.edu/24pq/
  - Dijkstra : https://algs4.cs.princeton.edu/44sp/

### Notation Polonaise Inverse
- http://www-stone.ch.cam.ac.uk/documentation/rrf/rpn.html

### Algorithme de Dijkstra
- Wikipedia : https://fr.wikipedia.org/wiki/Algorithme_de_Dijkstra
- Animation : https://www.cs.usfca.edu/~galles/visualization/Dijkstra.html
- Cours Princeton : https://www.cs.princeton.edu/courses/archive/spr10/cos226/lectures/15-44ShortestPaths-2x2.pdf

### Seam Carving
- Démonstration interactive : https://www.aryan.app/seam-carving/
- Article original : http://www.faculty.idc.ac.il/arik/SCWeb/imret/imret.pdf
- Wikipedia : https://en.wikipedia.org/wiki/Seam_carving

### Le Compte est Bon
- Simulateur en ligne : http://a.vouillon.online.fr/comptbon.htm
- Émission : https://www.youtube.com/watch?v=t_4dAYk5ySY

### Java et Maven
- Java 11 API : https://docs.oracle.com/en/java/javase/11/docs/api/
- Maven : https://maven.apache.org/
- JUnit 5 : https://junit.org/junit5/docs/current/user-guide/
- JavaFX 11 : https://openjfx.io/

## Bonnes Pratiques

### Implémentation
- Commencer simple, optimiser ensuite
- Tester chaque méthode individuellement
- Utiliser les méthodes utilitaires fournies
- Respecter les interfaces et signatures

### Tests
- Lancer les tests fréquemment
- Lire les messages d'erreur attentivement
- Ajouter des prints pour debugger
- Utiliser le debugger pour les cas complexes

### Performance
- Mesurer avant d'optimiser
- Utiliser les structures de données appropriées
- Éviter les allocations inutiles
- Profiler avec JMH pour les benchmarks sérieux

### Code
- Noms de variables explicites
- Commentaires pour la logique complexe
- Respecter les conventions Java
- Factoriser le code dupliqué

## Support

- Consultez le README.md pour les détails techniques
- Utilisez les tests fournis pour valider votre implémentation
- Demandez de l'aide pendant les séances de TP
- Consultez les ressources en ligne mentionnées ci-dessus
