# Quadtrees

## Theorie

Un **quadtree** est une structure arborescente ou chaque noeud interne a exactement quatre enfants, representant les quatre quadrants d'un espace 2D. Ils sont utilises pour le partitionnement spatial, la compression d'images et les systemes d'information geographique.

### Types de Quadtrees

1. **Point Quadtree** : stocke des points dans un espace 2D
2. **Region Quadtree** : subdivise recursivement une region carree en quatre quadrants egaux (utilise dans le TP7)

### Region Quadtree (du TP7)

Chaque noeud est soit :
- Une **feuille** avec une couleur uniforme (toute la region est d'une seule couleur)
- Un noeud avec **4 enfants** (la region est subdivisee en quadrants)

Numerotation des quadrants (telle qu'utilisee dans le TP7) :
```
  +-------+-------+
  |       |       |
  |  NW   |  NE   |
  |  (0)  |  (1)  |
  +-------+-------+
  |       |       |
  |  SW   |  SE   |
  |  (3)  |  (2)  |
  +-------+-------+
```

### Exemple de compression d'image

Image originale 4x4 (chaque cellule est une couleur de pixel) :
```
  +--+--+--+--+
  |R |R |B |B |
  +--+--+--+--+
  |R |R |B |B |
  +--+--+--+--+
  |G |G |G |G |
  +--+--+--+--+
  |G |G |G |G |
  +--+--+--+--+
```

Representation en quadtree :
```
           [null]           <- root (not uniform)
          /  |  \  \
        /    |    \  \
      [R]  [B]  [G]  [G]   <- children are uniform
      NW    NE   SE   SW
```

Le carre 2x2 en haut a gauche est tout Rouge → feuille [R].
Le carre 2x2 en haut a droite est tout Bleu → feuille [B].
Les carres 2x2 en bas a droite et en bas a gauche sont tout Vert → feuille [G].

Sans quadtree : 16 pixels a stocker.
Avec quadtree : 4 noeuds feuilles. Compression !

### Region non uniforme

Si un quadrant n'est pas uniforme, subdiviser recursivement :
```
  +--+--+--+--+
  |R |R |B |G |
  +--+--+--+--+
  |R |R |G |B |
  +--+--+--+--+
  |G |G |G |G |
  +--+--+--+--+
  |G |G |G |G |
  +--+--+--+--+

Le carre 2x2 en haut a droite n'est PAS uniforme (B,G,G,B), donc on subdivise :

             [null]
            /  |   \    \
          /    |     \    \
        [R]  [null]  [G]  [G]
              / | \ \
            [B][G][B][G]
```


## Implementation Java (du TP7)

### Interface QuadTree

```java
public interface QuadTree {
    boolean isEmpty();
    boolean outOfTree();
    void prune(int threshold);
    void goToRoot();
    void goToParent();
    void goToChild(int i);       // i = 0,1,2,3
    boolean onRoot();
    boolean onLeaf();
    boolean hasChild(int i);
    Color getValue();
    void setValue(Color c);
    void addChildren(Color[] c); // add 4 children
    void createRoot(Color c);
    void delete();
    void recreate(Image c);      // tree -> image
}
```

### Implementation Tree (navigation par curseur)

```java
public class Tree implements QuadTree {
    private static class Node {
        Color value;
        List<Node> children;
        Node parent;

        public Node(Color c, Node p) {
            this.value = c;
            this.parent = p;
            this.children = new ArrayList<>();
        }

        public void addChild(Node n) {
            if (children.size() == 4)
                throw new RuntimeException("List full");
            n.parent = this;
            children.add(n);
        }
    }

    private Node root;
    private Node current;  // cursor for navigation
```

### Construction depuis une image (subdivision recursive)

```java
    private Node buildFromImageRec(Image u,
            int low_x, int low_y, int high_x, int high_y) {
        // Base case: single pixel
        if (low_x + 1 == high_x && low_y + 1 == high_y) {
            return new Node(u.getPixel(low_x, low_y), null);
        }
        // Recursive case: divide into 4 quadrants
        Node ch = new Node(null, null);
        int mx = (low_x + high_x) / 2;
        int my = (low_y + high_y) / 2;
        ch.addChild(buildFromImageRec(u, low_x, low_y, mx, my));     // NW (0)
        ch.addChild(buildFromImageRec(u, mx, low_y, high_x, my));    // NE (1)
        ch.addChild(buildFromImageRec(u, mx, my, high_x, high_y));   // SE (2)
        ch.addChild(buildFromImageRec(u, low_x, my, mx, high_y));    // SW (3)
        return ch;
    }

    public Tree(Image u) {
        int size = u.getSize();
        this.root = buildFromImageRec(u, 0, 0, size, size);
        this.current = this.root;
        this.prune(0);  // merge identical quadrants
    }
```

### Elagage (Compression)

L'elagage fusionne les enfants dans leur parent s'ils sont suffisamment similaires :

```java
    public void prune(int threshold) {
        if (this.onLeaf()) {
            if (this.onRoot()) return;
        } else {
            // Recursively prune all children
            for (int i = 0; i < 4; i++) {
                this.goToChild(i);
                prune(threshold);
                this.goToParent();
            }
            // Check if all children are leaves with similar colors
            for (int i = 0; i < 4; i++) {
                goToChild(i);
                if (current.value == null) { goToParent(); return; }
                goToParent();
                for (int j = 0; j < i; j++) {
                    if (!current.children.get(i).value
                         .near(current.children.get(j).value, threshold))
                        return;  // too different, don't merge
                }
            }
            // All similar -> merge: compute average color
            Color avg = /* weighted average of 4 children */;
            current.removeChildren();
            current.value = avg;
        }
    }
```

threshold = 0: only merge if all children are exactly the same color
threshold > 0: merge if colors are "close enough" (lossy compression)

### Reconstruction de l'image depuis l'arbre

```java
    private void recreateRec(Image out,
            int low_x, int low_y, int high_x, int high_y) {
        if (this.onLeaf()) {
            // Paint the entire region with this color
            Color c = this.getValue();
            for (int x = low_x; x < high_x; x++)
                for (int y = low_y; y < high_y; y++)
                    out.setPixel(x, y, c);
        } else {
            int mx = (high_x + low_x) / 2;
            int my = (high_y + low_y) / 2;
            goToChild(0); recreateRec(out, low_x, low_y, mx, my);
            goToChild(1); recreateRec(out, mx, low_y, high_x, my);
            goToChild(2); recreateRec(out, mx, my, high_x, high_y);
            goToChild(3); recreateRec(out, low_x, my, mx, high_y);
        }
        goToParent();
    }
```


## Complexite

| Operation | Complexite | Notes |
|-----------|-----------|-------|
| Construction depuis image n x n | O(n^2) | Visite chaque pixel |
| Elagage (threshold=0) | O(n^2) | Visite tous les noeuds |
| Requete ponctuelle | O(log n) | Profondeur = log4(n^2) = log2(n) |
| Reconstruction d'image | O(n^2) | Ecrit chaque pixel |
| Espace (pire cas) | O(n^2) | Pas de compression |
| Espace (meilleur cas) | O(1) | Image entiere d'une seule couleur |
| Espace (typique) | O(n) | Depend de l'image |

Profondeur de l'arbre pour une image n x n : log4(n^2) = log2(n)

### Comparaison avec l'image brute

| Representation | Espace | Requete ponctuelle | Requete de region |
|---------------|--------|-------------------|-------------------|
| Tableau de pixels brut | O(n^2) | O(1) | O(taille_region) |
| Quadtree (non compresse) | O(n^2) | O(log n) | O(log n + resultat) |
| Quadtree (compresse) | O(k) &lt;&lt; O(n^2) | O(log n) | O(log n + resultat) |


## Distance de couleur et moyenne

Extrait de la classe Color (TP7) :

```java
// Euclidean distance per channel
public Color distance(final Color c) {
    return new Color(
        Math.abs(this.getRed()   - c.getRed()),
        Math.abs(this.getGreen() - c.getGreen()),
        Math.abs(this.getBlue()  - c.getBlue()),
        Math.abs(this.getAlpha() - c.getAlpha())
    );
}

// Are two colors "close enough"?
public boolean near(final Color c, final int threshold) {
    Color d = this.distance(c);
    return d.getRed()   <= threshold
        && d.getGreen() <= threshold
        && d.getBlue()  <= threshold
        && d.getAlpha() <= threshold;
}

// Weighted average
public Color average(final Color c, final double weight) {
    return new Color(
        (int)(weight * getRed()   + (1 - weight) * c.getRed()),
        (int)(weight * getGreen() + (1 - weight) * c.getGreen()),
        (int)(weight * getBlue()  + (1 - weight) * c.getBlue()),
        (int)(weight * getAlpha() + (1 - weight) * c.getAlpha())
    );
}
```


## AIDE-MEMOIRE

```
QUADTREE (REGION)
=================
Each node: either LEAF (uniform color) or 4 CHILDREN (subdivided)

Quadrants:     +----+----+
               | NW | NE |
               | 0  | 1  |
               +----+----+
               | SW | SE |
               | 3  | 2  |
               +----+----+

BUILD:  recursive subdivision until single pixel -> O(n^2)
PRUNE:  merge similar children into parent leaf -> compression
RECREATE: walk tree, paint regions -> O(n^2)

NAVIGATION: cursor-based (goToRoot, goToChild(i), goToParent)
DEPTH: log2(n) for n x n image
SPACE: O(k) where k = number of distinct regions

IMAGE SIZE MUST BE POWER OF 2 (2^k x 2^k)
```
