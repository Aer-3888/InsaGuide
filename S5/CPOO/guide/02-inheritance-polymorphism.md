# Heritage et Polymorphisme

## Theorie

### Heritage (`extends`)

L'heritage cree une relation "est-un". Une sous-classe herite de tous les membres non-prives de sa classe parente et peut specialiser ou etendre le comportement.

```java
public abstract class Arbre {
    protected double age;
    protected double volume;

    public Arbre(double age, double volume) {
        this.age = age;
        this.volume = volume;
    }

    public void vieillir() {
        this.age++;             // shared behavior
    }

    protected abstract double getPrixM3();    // must be implemented by subclasses
    public abstract double getAgeMinCoupe();
}

public class Chene extends Arbre {
    public Chene(double age, double volume) {
        super(age, volume);    // call parent constructor
    }

    @Override
    protected double getPrixM3() {
        return 1000;           // oak-specific price
    }

    @Override
    public double getAgeMinCoupe() {
        return 10;
    }
}

public class Pin extends Arbre {
    public Pin(double age, double volume) {
        super(age, volume);
    }

    @Override
    protected double getPrixM3() {
        return 500;            // pine-specific price
    }

    @Override
    public double getAgeMinCoupe() {
        return 5;
    }
}
```

### Classes abstraites

Une classe abstraite **ne peut pas etre instanciee** directement. Elle peut contenir :
- Des methodes concretes (avec implementation, ex. `vieillir()`, `getPrix()`)
- Des methodes abstraites (sans corps, devant etre redefinies par les sous-classes)
- Des constructeurs (appeles via `super()` depuis les sous-classes)
- Des champs (y compris des champs `protected` partages avec les sous-classes)

```java
public abstract class Arbre {
    // Concrete method -- shared by all tree types
    public double getPrix() {
        return this.volume * this.getPrixM3();
    }

    // Concrete method -- same logic for all
    public boolean peutEtreCoupe() {
        return this.age >= this.getAgeMinCoupe();
    }

    // Abstract methods -- subclass-specific
    protected abstract double getPrixM3();
    public abstract double getAgeMinCoupe();
}
```

**Quand utiliser les classes abstraites vs les interfaces** :

| Caracteristique | Classe abstraite | Interface |
|-----------------|-----------------|-----------|
| Champs | Oui (tout type) | Seulement des constantes `static final` |
| Constructeurs | Oui | Non |
| Methodes concretes | Oui | Oui (methodes default depuis Java 8) |
| Heritage multiple | Non (un seul extends) | Oui (implementation multiple) |
| Utiliser quand | Etat + comportement partages | Contrat / capacite |

### Interfaces

Une interface definit un contrat -- un ensemble de methodes que les classes implementantes doivent fournir.

```java
public interface Network {
    boolean ping(String address) throws NetworkException;
    void sendGetHTTPQuery(String address);
}

interface Service {
    int getLatency();
}

interface Pion {
    int getX();
    int getY();
}

public interface ITranslation {
    int getTx();
    int getTy();
}
```

Les interfaces sont centrales pour l'**inversion de dependances** : dependre d'abstractions, pas de classes concretes. C'est ce qui permet le mocking dans les tests.

### Polymorphisme

Le polymorphisme signifie "plusieurs formes." Le meme appel de methode produit un comportement different selon le type reel de l'objet a l'execution.

```java
// Reference type: Arbre     Actual type: Chene or Pin
List<Arbre> arbres = new ArrayList<>();
arbres.add(new Chene(15, 2.5));   // Chene is an Arbre
arbres.add(new Pin(8, 1.0));      // Pin is an Arbre

for (Arbre arbre : arbres) {
    // getPrix() calls the correct getPrixM3() depending on actual type
    System.out.println(arbre.getPrix());
    // Chene: 2.5 * 1000 = 2500
    // Pin:   1.0 * 500  = 500
}
```

### Liaison dynamique (Late Binding)

A la compilation, Java verifie que le **type de reference** possede la methode. A l'execution, Java dispatche vers l'implementation du **type reel**.

```java
Arbre tree = new Chene(15, 2.0);
tree.getPrix();          // Calls Chene's getPrixM3() at runtime
// Compiler checks: Arbre has getPrix()? Yes.
// Runtime dispatches: actual type is Chene, so Chene.getPrixM3() is called.
```

### L'operateur `instanceof`

Verification de type a l'execution -- a utiliser avec parcimonie (c'est souvent le signe d'un probleme de conception, mais le cours l'enseigne explicitement).

```java
public int getNombreChenes() {
    int nombreChenes = 0;
    for (Arbre arbre : arbres) {
        if (arbre instanceof Chene) {   // runtime type check
            nombreChenes++;
        }
    }
    return nombreChenes;
}
```

### Redefinition vs Surcharge

**Redefinition (Overriding)** (polymorphisme a l'execution) : une sous-classe redefinit une methode parente avec la meme signature.
```java
@Override
public Gland produireFruit() {   // same name, covariant return type
    return new Gland();
}
```

**Surcharge (Overloading)** (a la compilation) : la meme classe definit plusieurs methodes avec le meme nom mais des listes de parametres differentes.
```java
public void translate(double tx, double ty) { ... }
public void translate(ITranslation translation) { ... }
```

### L'annotation `@Override`

Toujours utiliser `@Override` lors de la redefinition d'une methode. Cela donne une verification a la compilation que vous redefinissez bien quelque chose (detecte les fautes de frappe et les erreurs de signature).

```java
@Override
public void manger(Gland gland) {
    // correct override of Animal<Gland>.manger(Gland)
}
```

## Patron : Methode Template (Template Method)

La hierarchie `Arbre` utilise le patron Template Method : la classe de base definit le squelette de l'algorithme (`getPrix()` appelle `getPrixM3()`) et les sous-classes remplissent les etapes variables.

```
Arbre.getPrix()  -->  calls this.getPrixM3()  -->  dispatched to Chene.getPrixM3() or Pin.getPrixM3()
     ^                                                              ^
     |                                                              |
 Algorithm skeleton                                        Variable step
```

## Pieges courants

1. **Oublier `super()` dans les constructeurs de sous-classes** : si le parent n'a pas de constructeur sans argument, il FAUT appeler explicitement `super(args)`.
2. **Cast sans verification** : toujours utiliser `instanceof` avant un cast : `if (arbre instanceof Chene c) { ... }`.
3. **Confondre type de reference et type reel** : `Arbre a = new Chene(...)` -- `a` est type comme `Arbre` mais se comporte comme `Chene` pour les methodes redefinies.
4. **Methode abstraite non implementee** : oublier `@Override` et mal ecrire le nom de la methode cree une nouvelle methode au lieu de la redefinir.

---

## CHEAT SHEET

```
INHERITANCE
  class Child extends Parent { ... }
  - Single inheritance only (one extends)
  - Can implement multiple interfaces
  - super() calls parent constructor (must be first line)
  - super.method() calls parent's version of an overridden method

ABSTRACT CLASSES
  abstract class X {
      abstract void doSomething();    // no body
      void concreteMethod() { ... }  // has body
  }
  - Cannot instantiate: new X() is illegal
  - Subclasses MUST implement all abstract methods (or also be abstract)

INTERFACES
  interface Y {
      void doSomething();            // implicitly public abstract
      default void helper() { ... }  // Java 8+ default method
  }
  - class Z implements Y, W { ... }  // multiple interfaces OK

POLYMORPHISM
  Parent ref = new Child();
  ref.method();  // dispatched to Child.method() at runtime

instanceof
  if (obj instanceof Type t) {
      // t is already cast to Type (Java 16+ pattern matching)
  }

@Override
  - Always use when overriding
  - Compile error if method does not actually override anything

OVERRIDING RULES
  - Same method name and parameter types
  - Return type can be covariant (more specific)
  - Access cannot be more restrictive
  - Cannot override private or static methods
```
