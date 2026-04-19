# Binary Trees (Arbres Binaires)

## Theorie

Un **arbre binaire** est une structure hierarchique ou chaque noeud a au plus deux enfants (gauche et droit).

```
         [A]           <- root (racine)
        /   \
      [B]   [C]        <- internal nodes
      / \     \
    [D] [E]   [F]      <- leaves (feuilles) = no children
```

Terminologie :
- **Racine** (root) : noeud sommet, sans parent
- **Feuille** (leaf) : noeud sans enfants
- **Noeud interne** : noeud avec au moins un enfant
- **Hauteur** (height) : longueur du plus long chemin de la racine a une feuille
- **Profondeur** d'un noeud : distance de la racine a ce noeud
- **Sous-arbre** (subtree) : un noeud + tous ses descendants

### Arbre Binaire de Recherche (ABR / BST)

Un ABR satisfait : pour chaque noeud N,
- Toutes les valeurs du sous-arbre gauche &lt; N.value
- Toutes les valeurs du sous-arbre droit > N.value

```
         [7]
        /   \
      [3]   [10]
      / \      \
    [1] [6]   [14]
        /
       [4]
```

Note : Inserer 7 a nouveau -- puisque l'ABR utilise `>=` pour le placement a gauche (voir `placer()` dans le code d'examen), un doublon 7 irait dans le sous-arbre gauche de 10. Le placement exact depend de la politique de gestion des doublons de l'ABR.

**Recherche** : suivre a gauche si cible &lt; noeud, a droite si cible > noeud.

### Arbre AVL

Un **ABR auto-equilibrant** ou pour chaque noeud, les hauteurs des sous-arbres gauche et droit different d'au plus 1.

**Facteur d'equilibre** = hauteur(gauche) - hauteur(droite)
- Si |facteur d'equilibre| > 1 : reequilibrer avec des rotations

#### Rotations

**Rotation droite** (right rotation) -- quand lourd a gauche :
```
Before:        After:
    [C]          [B]
    /            / \
  [B]          [A] [C]
  /
[A]
```

**Rotation gauche** (left rotation) -- quand lourd a droite :
```
Before:        After:
[A]              [B]
  \              / \
  [B]          [A] [C]
    \
    [C]
```

**Double rotation gauche-droite** :
```
Before:          After left on B:     After right on C:
    [C]              [C]                  [B]
    /                /                    / \
  [A]              [B]                  [A] [C]
    \              /
    [B]          [A]
```

**Double rotation droite-gauche** : miroir de la gauche-droite.


## Parcours (Traversals)

Quatre parcours fondamentaux d'arbre :

```
         [+]
        /   \
      [*]   [3]
      / \
    [2] [4]
```

### Infixe (Inorder) -- Gauche, Racine, Droit
```
2, *, 4, +, 3     (donne l'ordre trie pour un ABR)
Expression infixe : (2 * 4) + 3
```

### Prefixe (Preorder) -- Racine, Gauche, Droit
```
+, *, 2, 4, 3
Prefix expression: + * 2 4 3
```

### Postfixe (Postorder) -- Gauche, Droit, Racine
```
2, 4, *, 3, +
Postfix (RPN): 2 4 * 3 +
```

### Parcours en largeur (BFS / Level-order)
```
+, *, 3, 2, 4     (level by level, using a queue)
```

### Modele de parcours recursif

```java
void inorder(Node n) {
    if (n == null) return;
    inorder(n.left);     // left subtree
    process(n);          // root
    inorder(n.right);    // right subtree
}

void preorder(Node n) {
    if (n == null) return;
    process(n);          // root
    preorder(n.left);
    preorder(n.right);
}

void postorder(Node n) {
    if (n == null) return;
    postorder(n.left);
    postorder(n.right);
    process(n);          // root
}
```


## Implementation Java (du TP6)

### Interface : Arbre

```java
public interface Arbre {
    Object racine();            // root value
    Arbre arbreG();             // left subtree
    Arbre arbreD();             // right subtree
    boolean estVide();          // is empty?
    void vider();               // empty the tree
    int hauteur();              // height
    void modifRacine(Object r); // change root value
    void modifArbreD(Arbre a);  // change right subtree
    void modifArbreG(Arbre a);  // change left subtree
    void dessiner();            // draw the tree
}
```

### Implementation : TreeTwo

```java
public class TreeTwo implements Arbre {
    private static class Noeud {
        private Object value;
        private Noeud droit;
        private Noeud gauche;
        public Noeud(Object value) { this.value = value; }
    }

    private Noeud root;

    public TreeTwo(Object root) { this.root = new Noeud(root); }

    public boolean estVide() {
        return root.getValue() == null
            && root.gauche == null
            && root.droit == null;
    }

    // Height: max of left and right subtree heights
    private int recursiveHeight(Noeud r) {
        if (r == null) return 0;
        return 1 + Math.max(recursiveHeight(r.gauche),
                            recursiveHeight(r.droit));
    }

    public int hauteur() {
        return Math.max(recursiveHeight(root.gauche),
                        recursiveHeight(root.droit));
    }
```

### Parcours postfixe (toString)

```java
    private String postfixTraversal(Noeud r) {
        StringBuilder res = new StringBuilder();
        if (r.gauche != null) res.append(postfixTraversal(r.gauche));
        if (r.droit != null)  res.append(postfixTraversal(r.droit));
        if (r.value != null) {
            res.append(r.value.toString());
            res.append(" ");
        }
        return res.toString();
    }
```

### Compter les occurrences (parcours iteratif avec pile)

```java
    public int denombrer(String n) {
        ArrayList<Noeud> lr = new ArrayList<>();
        int count = 0;
        lr.add(this.root);
        while (lr.size() > 0) {
            Noeud e = lr.remove(lr.size() - 1);  // pop last = DFS
            if (e.gauche != null) lr.add(e.gauche);
            if (e.droit != null) lr.add(e.droit);
            if (e.value != null && e.value.toString().equals(n))
                count++;
        }
        return count;
    }
```

### Arbre d'expression arithmetique (ExprArith, TP6)

```
Expression: (3 + 4) * 2

Tree:        [*]
            /   \
          [+]   [2]
          / \
        [3] [4]

Postfix: 3 4 + 2 *
Evaluation: recursive descent
```

```java
public class ExprArith {
    protected Arbre arbre;
    protected final HashMap<String, Double> associations;

    public double evaluer() {
        return this.recursiveEvaluation(this.arbre);
    }

    private double recursiveEvaluation(Arbre root) {
        if (root.estVide())
            throw new RuntimeException("NULL ROOT TREE");
        Arbre gauche = root.arbreG();
        Arbre droit = root.arbreD();
        String renter = (String) root.racine();

        if (gauche.estVide() || droit.estVide()) {
            // Leaf: numeric literal or variable
            try { return Double.parseDouble(renter); }
            catch (NumberFormatException e) {}
            return this.valeur(renter);  // variable lookup via associations
        } else {
            double dgauche = recursiveEvaluation(gauche);
            double ddroite = recursiveEvaluation(droit);
            switch (renter) {
                case "+": return dgauche + ddroite;
                case "-": return dgauche - ddroite;
                case "*": return dgauche * ddroite;
                case "/": return dgauche / ddroite;
                default: throw new IllegalArgumentException("UNKNOWN OPERATION");
            }
        }
    }
}
```


## Operations ABR

### Recherche dans un ABR

```java
Node search(Node root, int key) {
    if (root == null || root.value == key) return root;
    if (key < root.value) return search(root.left, key);
    return search(root.right, key);
}
```

### Insertion dans un ABR (extrait examen 2020)

```java
public void placer(int i) {
    if (vide()) { modifRacine(i); return; }
    if (valec() >= i) {
        if (!aFilsG()) modifFilsG(i);
        else arbreG().placer(i);
    } else {
        if (!aFilsD()) modifFilsD(i);
        else arbreD().placer(i);
    }
}
```

### Suppression dans un ABR (extrait examen 2020)

Pour supprimer un noeud avec deux enfants :
1. Trouver la **plus grande valeur** dans le sous-arbre gauche (noeud le plus a droite du sous-arbre gauche)
2. Remplacer la valeur du noeud par cette valeur
3. Supprimer le noeud trouve (qui a au plus un enfant)

```java
public void supprimerEc() {
    if (!aFilsD() || !aFilsG()) {
        oterEc();  // 0 or 1 child: simple removal
    } else {
        oterPlusGrandInf();  // 2 children: replace with max of left
    }
}
```


## Complexite

| Operation | ABR (equilibre) | ABR (pire cas) | AVL |
|-----------|----------------|---------------|-----|
| Recherche | O(log n) | O(n) | O(log n) |
| Insertion | O(log n) | O(n) | O(log n) |
| Suppression | O(log n) | O(n) | O(log n) |
| Parcours | O(n) | O(n) | O(n) |
| Hauteur | O(log n) | O(n) | O(log n) |

Pire cas pour un ABR : inserer des donnees triees cree un arbre "liste chainee".

```
Insert: 1, 2, 3, 4, 5

     [1]
       \
       [2]
         \
         [3]
           \
           [4]
             \
             [5]

Height = n-1 = 4   (all operations O(n))
```


## AIDE-MEMOIRE

```
BINARY TREE
============
             [root]
            /      \
        [left]    [right]
        /   \       /  \
       ...   ...  ...   ...

TRAVERSALS:
  Inorder  (LNR): left, node, right  -> sorted for BST
  Preorder (NLR): node, left, right  -> copy tree
  Postorder(LRN): left, right, node  -> delete tree / RPN

BST PROPERTY: left < node < right

INSERT: follow BST property to find correct leaf position
DELETE:
  0 children: just remove
  1 child:    replace with child
  2 children: replace with max(left subtree), delete that

AVL BALANCE: |height(L) - height(R)| <= 1
  Left-heavy   -> Right rotation
  Right-heavy  -> Left rotation
  Left-Right   -> Left on child, then Right on node
  Right-Left   -> Right on child, then Left on node

HEIGHT: O(log n) balanced, O(n) worst
ALL BST OPS: O(height)
```
