# Fondamentaux de la POO

## Theorie

### Qu'est-ce que la programmation orientee objet ?

La POO organise le logiciel autour d'**objets** -- des regroupements de donnees (attributs) et de comportements (methodes) -- plutot qu'autour de fonctions et de logique. Les quatre piliers sont : l'encapsulation, l'abstraction, l'heritage et le polymorphisme.

### Classes et objets

Une **classe** est un modele (blueprint) ; un **objet** (instance) est une realisation concrete de ce modele.

```java
// Class definition (blueprint)
public class Velo {
    private Guidon guidon = null;   // attribute (field)

    public Guidon getGuidon() {     // method (behavior)
        return this.guidon;
    }

    public void setGuidon(Guidon gd) {
        this.guidon = gd;
    }
}

// Creating an object (instance)
Velo monVelo = new Velo();
```

### Le mot-cle `this`

`this` fait reference a l'instance courante de l'objet. Il permet de distinguer les noms de champs des noms de parametres et de passer l'objet courant a d'autres methodes.

```java
public void setGuidon(Guidon guidon) {
    this.guidon = guidon;          // this.guidon = field, guidon = parameter
}
```

### Constructeurs

Les constructeurs initialisent les objets. Si vous n'ecrivez aucun constructeur, Java fournit un constructeur par defaut sans argument. Des que vous ecrivez un constructeur, le constructeur par defaut disparait.

```java
public class Arbre {
    protected double age;
    protected double volume;

    // Parameterized constructor
    public Arbre(double age, double volume) {
        this.age = age;
        this.volume = volume;
    }
}

// Subclass must call super()
public class Chene extends Arbre {
    public Chene(double age, double volume) {
        super(age, volume);       // MUST be first statement
        this.prix = 1000;
    }
}
```

**Chainage de constructeurs** avec `this()` :

```java
public class MyPoint {
    private double x;
    private double y;

    public MyPoint() {
        this(0, 0);               // calls the two-arg constructor
    }

    public MyPoint(double x, double y) {
        this.x = x;
        this.y = y;
    }

    public MyPoint(MyPoint pt) {
        this(pt.x, pt.y);        // copy constructor
    }
}
```

### Encapsulation

L'encapsulation regroupe les donnees avec les methodes qui les manipulent, et restreint l'acces direct a l'etat interne.

| Modificateur | Classe | Package | Sous-classe | Monde |
|--------------|--------|---------|-------------|-------|
| `private` | Oui | Non | Non | Non |
| (defaut) | Oui | Oui | Non | Non |
| `protected` | Oui | Oui | Oui | Non |
| `public` | Oui | Oui | Oui | Oui |

**Bonne pratique** : les champs sont `private`, accessibles via des getters/setters `public`. Les champs internes partages avec les sous-classes utilisent `protected`.

```java
public abstract class Arbre {
    protected int prix;              // accessible to Chene, Pin
    protected double age;
    protected double volume;
    protected double age_coupe;

    public double getAge() {         // public getter
        return age;
    }
}
```

### Associations (UML vers Java)

Les associations representent des relations "utilise" ou "possede" entre classes.

**Association unidirectionnelle 0..1** :
```java
// Velo --guidon--> Guidon (0..1)
public class Velo {
    private Guidon guidon = null;    // null means no guidon

    public Guidon getGuidon() { return this.guidon; }
    public void setGuidon(Guidon gd) { this.guidon = gd; }
}
```

**Association bidirectionnelle 0..1 avec integrite referentielle** :
```java
// In Velo.java
public void setGuidon(Guidon gd) {
    if (gd != this.guidon) {         // avoid infinite recursion
        Guidon oldGuidon = this.guidon;
        if (gd == null && oldGuidon != null) {
            oldGuidon.setVelo(null); // clean up old link
        }
        this.guidon = gd;
        if (gd != null) {
            gd.setVelo(this);        // establish bidirectional link
        }
    }
}
```

**Association un-a-plusieurs (0..\*)** :
```java
public class Velo {
    private List<Roue> roues;

    public Velo() {
        this.roues = new ArrayList<>();  // ALWAYS initialize in constructor
    }

    public Boolean addRoue(Roue r) {
        if (r == null || this.roues.contains(r)) {
            return false;                // reject null or duplicates
        }
        return this.roues.add(r);
    }

    public Boolean removeRoues(Roue r) {
        return this.roues.remove(r);
    }
}
```

**Composition avec navigation bidirectionnelle** :
```java
// In Velo.java -- the "whole"
public Boolean addRoue(Roue r) {
    if (r == null || this.roues.contains(r)) return false;
    this.roues.add(r);
    if (r.getVelo() != this) {
        r.setVelo(this);             // maintain referential integrity
    }
    return true;
}

// In Roue.java -- the "part"
public void setVelo(Velo vl) {
    if (this.velo == vl) return;     // avoid recursion
    if (this.velo != null) {
        Velo oldVelo = this.velo;
        this.velo = null;            // break old link first
        oldVelo.removeRoues(this);
    }
    this.velo = vl;
    if (vl != null && !vl.getRoues().contains(this)) {
        vl.addRoue(this);
    }
}
```

### Le mot-cle `final`

```java
public static final int SIZE = 5;       // constant: value cannot change

private final List<Pion> pions;          // reference cannot change, but
                                         // list contents CAN be modified
```

Distinction cle :
- `final` sur un **type primitif** : la valeur elle-meme ne peut pas changer
- `final` sur une **reference** : la reference ne peut pas pointer vers un autre objet, mais l'etat interne de l'objet peut toujours etre modifie

### Membres `static`

`static` appartient a la classe, pas aux instances.

```java
public class Chene extends Arbre<Gland> {
    private static final double AGE_MIN_COUPE = 10;  // shared across all Chene instances
}

// Static factory method
public static A create(final B b) {
    try {
        return new A(b);
    } catch (final IllegalArgumentException ex) {
        return null;
    }
}
```

## Pieges courants

1. **Oublier d'initialiser les collections** : `private List<Arbre> arbres;` sans `= new ArrayList<>()` dans le constructeur provoque une `NullPointerException`.
2. **Recursion infinie dans les setters bidirectionnels** : toujours verifier `if (gd != this.guidon)` avant d'appeler le setter de l'autre cote.
3. **Rompre l'integrite referentielle** : quand on modifie un cote d'une association bidirectionnelle, il faut toujours mettre a jour l'autre cote.
4. **Exposer l'etat interne mutable** : retourner `this.roues` directement permet aux appelants de modifier la liste. Utiliser plutot `Collections.unmodifiableList(roues)`.

---

## CHEAT SHEET

```
CLASS STRUCTURE
  public class ClassName {
      private Type field;                         // encapsulated field
      public ClassName() { ... }                  // constructor
      public Type getField() { return field; }    // getter
      public void setField(Type f) { field = f; } // setter
  }

CONSTRUCTOR RULES
  - Same name as class, no return type
  - super(...) must be first line in subclass constructor
  - this(...) chains to another constructor in same class
  - No explicit constructor => Java provides default no-arg

ASSOCIATION PATTERNS
  0..1   =>  private Type ref = null;
  1      =>  set in constructor, reject null
  0..*   =>  private List<Type> refs = new ArrayList<>();
  Bidirectional => update BOTH sides, guard against recursion

ACCESS MODIFIERS
  private < (default) < protected < public

FINAL
  final primitive  => constant value
  final reference  => fixed pointer, mutable contents
  final method     => cannot be overridden
  final class      => cannot be extended

STATIC
  static field     => shared across all instances (class-level)
  static method    => called via ClassName.method(), no 'this'
```
