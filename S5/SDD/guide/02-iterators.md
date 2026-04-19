# Iterators & Design Patterns

## Theorie

### Le patron Iterateur

Le **patron Iterateur** separe la logique de parcours de la structure de donnees elle-meme. Cela permet :
- Des parcours simultanes multiples (plusieurs iterateurs sur une liste)
- Differentes strategies de parcours (avant, arriere, filtre)
- Interface propre : la liste cree les iterateurs, les iterateurs naviguent

```
  Liste<T>  ----------creates----------> Iterateur<T>
     |                                       |
     | implements                            | implements
     v                                       v
  ListeDoubleChainee<T>              ListeDoubleChaineeIterateur<T>
  ListeTabulee<T>                    ListeTabuleeIterateur<T>
```

### Pourquoi separer Liste et Iterateur ?

Avec l'approche du TP1 (`MyList` avec curseur integre) :
- Un seul curseur par liste
- Impossible d'iterer et modifier simultanement
- Impossible d'avoir deux parcours independants

Avec l'approche du TP2 (`Iterateur` separe) :
- Creer plusieurs iterateurs : `Iterateur&lt;T&gt; it1 = list.iterateur(); Iterateur&lt;T&gt; it2 = list.iterateur();`
- Chacun a son propre curseur
- La liste elle-meme n'a pas de curseur


## Interfaces Java (du TP2-3)

### Liste&lt;T&gt; -- L'interface Liste

```java
public interface Liste<T> {
    void vider();              // empty the list
    boolean estVide();         // is the list empty?
    Iterateur<T> iterateur();  // factory: create an iterator
}
```

### Iterateur&lt;T&gt; -- L'interface Iterateur

```java
public interface Iterateur<T> {
    void entete();          // cursor to first element
    void enqueue();         // cursor to last element
    void succ();            // move forward
    void pred();            // move backward
    void ajouterD(T o);     // insert right of cursor
    void ajouterG(T o);     // insert left of cursor
    void oterec();          // remove at cursor
    T valec();              // value at cursor
    void modifec(T o);      // modify value at cursor
    boolean estSorti();     // cursor out?
}
```


## Implementation : ListeDoubleChainee avec Iterateur separe (TP2)

### La classe Liste (sans curseur)

```java
public class ListeDoubleChainee<T> implements Liste<T> {
    protected static class Link<T> {
        T value = null;
        Link pred = null;
        Link succ = null;
    }
    protected Link head = null;
    protected Link tail = null;

    public ListeDoubleChainee() {
        this.head = new Link<T>();
        this.tail = new Link<T>();
        this.vider();
    }

    public void vider() {
        this.head.succ = this.tail;
        this.tail.pred = this.head;
    }

    public boolean estVide() {
        return this.head.succ == this.tail && this.tail.pred == this.head;
    }

    public Iterateur<T> iterateur() {
        return new ListeDoubleChaineeIterateur<T>(this);
    }
}
```

### La classe Iterateur (avec curseur)

```java
public class ListeDoubleChaineeIterateur<T> implements Iterateur<T> {
    private final ListeDoubleChainee<T> l;
    private ListeDoubleChainee.Link<T> cursor;

    public ListeDoubleChaineeIterateur(ListeDoubleChainee<T> lst) {
        this.l = lst;
        this.cursor = l.head;  // starts on sentinel
    }

    public boolean estSorti() {
        return this.cursor.pred == null || this.cursor.succ == null;
    }

    public void entete() { this.cursor = this.l.head.succ; }
    public void enqueue() { this.cursor = this.l.tail.pred; }

    public void succ() {
        if (this.estSorti()) throw new ListeDehorsException();
        this.cursor = this.cursor.succ;
    }

    public void ajouterD(T o) {
        if (!this.l.estVide() && this.estSorti())
            throw new ListeDehorsException();
        if (this.l.estVide()) this.cursor = this.l.head;

        ListeDoubleChainee.Link<T> nlink = new ListeDoubleChainee.Link<T>();
        nlink.value = o;
        nlink.pred = this.cursor;
        nlink.succ = this.cursor.succ;
        nlink.succ.pred = nlink;
        this.cursor.succ = nlink;
        this.cursor = nlink;
    }
    // ... (oterec, modifec, valec similar to TP1)
}
```


## Patron Adaptateur : Pont vers java.util (TP3)

### Probleme

Le cours utilise des interfaces personnalisees `Liste&lt;T&gt;` / `Iterateur&lt;T&gt;`, mais la bibliotheque standard Java utilise `java.util.List&lt;T&gt;` / `java.util.Iterator&lt;T&gt;`. Pour utiliser les boucles for-each et les API standard, il faut des adaptateurs.

### IterateurEngine -- Adapte Iterateur vers java.util.Iterator

```java
public class IterateurEngine<T> implements java.util.Iterator<T> {
    private final Iterateur<T> it;

    public IterateurEngine(Liste<T> dt) {
        this.it = dt.iterateur();
        this.it.entete();  // start at first element
    }

    public boolean hasNext() {
        return !this.it.estSorti();
    }

    public T next() {
        T ret = this.it.valec();
        this.it.succ();
        return ret;
    }
}
```

### ListeEngine -- Adapte Liste vers java.util.List

```java
public class ListeEngine<T> implements java.util.List<T> {
    private final Liste<T> lst;

    public ListeEngine(Liste<T> ls) { this.lst = ls; }

    public java.util.Iterator<T> iterator() {
        return new IterateurEngine<>(this.lst);
    }

    public boolean add(T e) {
        Iterateur<T> it = this.lst.iterateur();
        it.enqueue();
        it.ajouterD(e);
        return true;
    }

    public int size() {
        int ret = 0;
        for (Object k : this) ret++;  // uses for-each via iterator()
        return ret;
    }
    // ... (get, set, remove, indexOf, etc.)
}
```

### Utilisation -- Base de donnees geographique (TP3)

```java
public class BdGeographique {
    private final List<Enregistrement> data;

    public BdGeographique() {
        // Custom list wrapped in adapter -- usable with for-each!
        this.data = new ListeEngine<>(new ListeDoubleChainee<>());
    }

    public boolean estPresent(Enregistrement e) {
        for (Enregistrement k : this.data) {  // for-each works!
            if (k.equals(e)) return true;
        }
        return false;
    }
}
```


## Comparaison : Iterateurs personnalises vs. Java standard

| Fonctionnalite | Iterateur&lt;T&gt; (personnalise) | java.util.Iterator&lt;T&gt; |
|----------------|-------------------------------|------------------------|
| Avant | succ() | next() (retourne aussi la valeur) |
| Arriere | pred() | Non supporte |
| Valeur | valec() | Integre dans next() |
| Insertion | ajouterD(), ajouterG() | Non supporte |
| Suppression | oterec() | remove() (optionnel) |
| Fin | estSorti() | hasNext() |
| Debut | entete() / enqueue() | Cree a neuf |
| Passes multiples | Oui (entete() reinitialise) | Non (une seule passe) |

### Protocole Java Iterable/Iterator

```java
// To use for-each, a class must implement Iterable<T>
public interface Iterable<T> {
    Iterator<T> iterator();
}

// Then you can write:
for (T item : myCollection) { ... }

// Which is syntactic sugar for:
Iterator<T> it = myCollection.iterator();
while (it.hasNext()) {
    T item = it.next();
    // ...
}
```


## Complexite

Toutes les operations d'iterateur sur une liste doublement chainee restent O(1) :

| Operation | ListeDoubleChaineeIterateur | ListeTabuleeIterateur |
|-----------|---------------------------|----------------------|
| entete() | O(1) | O(1) |
| enqueue() | O(1) | O(1) |
| succ() | O(1) | O(1) |
| pred() | O(1) | O(1) |
| ajouterD() | O(1) | **O(n)** -- shift |
| ajouterG() | O(1) | **O(n)** -- shift |
| oterec() | O(1) | **O(n)** -- shift |
| valec() | O(1) | O(1) |

Les methodes de l'adaptateur (ListeEngine) ajoutent un surcout pour l'acces par index : `get(i)` est O(i) sur une liste chainee.


## AIDE-MEMOIRE

```
ITERATOR PATTERN
=================
Liste<T>  --creates-->  Iterateur<T>   (factory method: iterateur())
  |                        |
  +-- no cursor            +-- has cursor
  +-- vider(), estVide()   +-- entete(), succ(), pred(), enqueue()
                           +-- ajouterD(), ajouterG(), oterec()
                           +-- valec(), modifec(), estSorti()

ADAPTER PATTERN
===============
Custom                Java Standard
------                -------------
Liste<T>        -->   java.util.List<T>      via ListeEngine<T>
Iterateur<T>    -->   java.util.Iterator<T>  via IterateurEngine<T>

IterateurEngine.hasNext()  =  !it.estSorti()
IterateurEngine.next()     =  val = it.valec(); it.succ(); return val;

FOR-EACH LOOP:
  for (T item : listeEngine) { ... }
  == Iterator<T> it = listeEngine.iterator();
     while (it.hasNext()) { T item = it.next(); ... }
```
