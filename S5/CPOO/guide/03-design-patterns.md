# Patrons de conception (Design Patterns)

## Theorie

Les patrons de conception sont des solutions reutilisables a des problemes recurrents en conception logicielle. Le cours CPOO se concentre sur les patrons qui apparaissent dans les hierarchies de classes POO et dans les questions d'examen.

---

## 1. Patron Strategy

**Intention** : Definir une famille d'algorithmes, encapsuler chacun d'entre eux, et les rendre interchangeables. Le code client depend de l'interface, pas de l'implementation concrete.

**Structure** :
```
  +-----------+          +------------------+
  |  Context  |--------->|  <<interface>>   |
  |-----------|          |    Strategy      |
  | - strategy|          +------------------+
  | + execute()|         | + algorithm()    |
  +-----------+          +------------------+
                              ^         ^
                              |         |
                  +-----------+    +----------+
                  | ConcreteA |    | ConcreteB|
                  +-----------+    +----------+
```

**Exemple du cours** : `Animal<F extends Fruit>` utilise les generiques comme strategie type-safe pour manger differents types de fruits.

```java
public abstract class Animal<F extends Fruit> {
    public abstract void manger(F fruit);   // strategy: what to eat
}

public class Cochon extends Animal<Gland> {
    @Override
    public void manger(Gland gland) { /* pig eats acorns */ }
}

public class Ecureuil extends Animal<Cone> {
    @Override
    public void manger(Cone cone) { /* squirrel eats pine cones */ }
}
```

**Quand l'utiliser** : quand vous avez plusieurs facons d'effectuer une operation et que vous voulez les echanger sans modifier le code client.

---

## 2. Patron Observer (Observateur)

**Intention** : Definir une dependance un-a-plusieurs de sorte que lorsqu'un objet (le sujet) change d'etat, tous ses dependants (observateurs) sont notifies automatiquement.

**Structure** :
```
  +-------------+          +------------------+
  |   Subject   |--------->|  <<interface>>   |
  |-------------|  0..*    |    Observer       |
  | + attach()  |          +------------------+
  | + notify()  |          | + update()       |
  +-------------+          +------------------+
                                   ^
                                   |
                           +-------+-------+
                           | ConcreteObs   |
                           +---------------+
```

**Exemple d'examen (2024-2025)** : La classe `Traitement` utilise une interface `Observateur` pour notifier les observateurs en fonction de l'entree.

```java
public interface Observateur {
    void a();
    void b(String str);
}

public class Traitement {
    private final Observateur obs;

    public Traitement(Observateur obs) {
        this.obs = obs;
    }

    public void analyser(String str) {
        switch(str) {
            case "a" -> obs.a();
            case "b" -> obs.b(str);
            default -> throw new IllegalArgumentException();
        }
    }
}
```

**Quand l'utiliser** : systemes d'evenements, mises a jour d'interface, scenarios editeur/abonne.

---

## 3. Patron Factory (Fabrique)

**Intention** : Fournir une interface pour creer des objets sans specifier leur classe exacte. Laisser les sous-classes ou une methode fabrique decider quelle classe instancier.

### Methode fabrique simple

```java
public class A {
    // Static factory method -- returns A or null
    public static A create(final B b) {
        try {
            return new A(b);
        } catch (final IllegalArgumentException ex) {
            return null;
        }
    }
}

// Usage
A obj = A.create(someB);   // cleaner than try/catch at call site
```

### Fabrique avec selection de sous-classe

```java
public abstract class Arbre<F extends Fruit> {
    public abstract F produireFruit();   // each subclass produces its own fruit type
}

// Each tree "factory-produces" its specific fruit
Chene oak = new Chene(15, 2.5);
Gland acorn = oak.produireFruit();       // factory method returns Gland

Pin pine = new Pin(8, 1.0);
Cone cone = pine.produireFruit();        // factory method returns Cone
```

**Quand l'utiliser** : quand la logique de creation d'objets est complexe, quand on veut decoupler le client des classes specifiques, ou quand la construction peut echouer.

---

## 4. Patron Singleton

**Intention** : Garantir qu'une classe n'a qu'une seule instance et fournir un point d'acces global a celle-ci.

```java
public class Registry {
    private static final Registry INSTANCE = new Registry();

    private Registry() { }                  // private constructor

    public static Registry getInstance() {
        return INSTANCE;
    }
}
```

**Attention** : Les singletons rendent les tests difficiles car ils introduisent un etat global. Preferer l'injection de dependances quand c'est possible.

---

## 5. MVC (Modele-Vue-Controleur)

**Intention** : Separer une application en trois composants interconnectes pour separer les responsabilites.

```
  +-------+     updates     +------+     renders     +------+
  | Model | <-------------- | Ctrl | --------------> | View |
  +-------+                 +------+                 +------+
      |                         ^                        |
      |      notifies           |       user input       |
      +-------------------------+------------------------+
```

- **Modele** : donnees et logique metier (ex. classes `Arbre`, `Foret`)
- **Vue** : couche de presentation (affiche les donnees a l'utilisateur)
- **Controleur** : gere les entrees utilisateur, met a jour le modele, selectionne la vue

Dans le contexte du cours CPOO, le code des TPs suit un MVC simplifie ou les classes du domaine (Modele) sont testees independamment de toute interface graphique.

---

## 6. Patron Decorator (Decorateur)

**Intention** : Attacher dynamiquement des responsabilites supplementaires a un objet. Les decorateurs offrent une alternative flexible a la sous-classification.

```
  +------------------+
  |  <<interface>>   |
  |    Component     |
  +------------------+
  | + operation()    |
  +------------------+
        ^         ^
        |         |
  +----------+  +-----------+
  | Concrete |  | Decorator |-----> Component
  +----------+  +-----------+
                | + operation()|
                +-----------+
```

```java
// Conceptual example
interface Boisson {
    double prix();
    String description();
}

class Cafe implements Boisson {
    public double prix() { return 1.50; }
    public String description() { return "Cafe"; }
}

class AvecLait implements Boisson {
    private final Boisson boisson;
    public AvecLait(Boisson b) { this.boisson = b; }
    public double prix() { return boisson.prix() + 0.30; }
    public String description() { return boisson.description() + " + Lait"; }
}

// Usage: new AvecLait(new Cafe()).prix() => 1.80
```

---

## 7. Patron Composite

**Intention** : Composer des objets en structures arborescentes pour representer des hierarchies partie-tout. Les clients traitent les objets individuels et les compositions de maniere uniforme.

```
  +------------------+
  |  <<interface>>   |
  |    Component     |
  +------------------+
  | + operation()    |
  +------------------+
        ^         ^
        |         |
  +----------+  +-------------+
  |   Leaf   |  |  Composite  |----> 0..* Component
  +----------+  +-------------+
                | + add()      |
                | + remove()   |
                +-------------+
```

**Exemple d'examen (2020-2021)** : Arbre de formule arithmetique ou un noeud est soit une valeur litterale, une reference a une constante, ou un operateur (addition/soustraction) avec deux operandes (gauche et droite). La formule et tous les noeuds sont "calculables" -- ils implementent une methode `calculer(): double`.

```
  +------------------+
  |  <<interface>>   |
  |   Calculable     |
  +------------------+
  | + calculer(): double |
  +------------------+
        ^    ^    ^
        |    |    |
  +-------+ +--------+ +-----------+
  | Valeur| |  Ref   | | Operateur |
  +-------+ +--------+ +-----------+
                            ^    ^
                            |    |
                     +--------+ +--------+
                     |Addition| |Soustraction|
                     +--------+ +--------+
```

---

## Patrons dans le materiel de cours

| Patron | Ou il apparait |
|--------|---------------|
| Template Method | `Arbre.getPrix()` appelle l'abstrait `getPrixM3()` |
| Strategy (via generiques) | `Animal<F>` / `Arbre<F>` avec comportement specifique au type |
| Factory Method | `A.create(B b)` fabrique statique |
| Observer | Examen 2024-2025 `Traitement`/`Observateur` |
| Composite | Examen 2020-2021 arbre de formule arithmetique |

## Pieges courants

1. **Sur-ingenierie** : ne pas appliquer de patrons la ou une solution simple suffit.
2. **Confondre Strategy et Template Method** : Strategy utilise la composition (l'objet detient une reference vers une strategie) ; Template Method utilise l'heritage (la sous-classe redefinit des etapes).
3. **Abus de Singleton** : dans les tests, les singletons rendent le mocking tres difficile. Le cours enseigne `mockConstruction` et `mockStatic` pour contourner ce probleme.
4. **Ne pas reconnaitre le patron dans les questions d'examen** : lire attentivement le texte UML pour reperer les mots-cles comme "compose de", "est un", "differents types de" pour identifier le patron adapte.

---

## CHEAT SHEET

```
STRATEGY        = interface + multiple implementations, context holds reference
OBSERVER        = subject notifies observers on state change (1-to-many)
FACTORY         = static method or separate class creates objects
SINGLETON       = private constructor + static getInstance()
MVC             = Model (data) + View (display) + Controller (logic)
DECORATOR       = wraps an object, adds behavior, same interface
COMPOSITE       = tree structure, leaf and composite share interface
TEMPLATE METHOD = base class algorithm, subclasses override steps

EXAM KEYWORDS TO PATTERN MAPPING:
  "different types of X"        -> Inheritance / Strategy
  "composed of / contains"      -> Composite / Aggregation
  "notify / update"             -> Observer
  "create / factory"            -> Factory Method
  "tree structure / recursive"  -> Composite
  "wraps / adds behavior"       -> Decorator
```
