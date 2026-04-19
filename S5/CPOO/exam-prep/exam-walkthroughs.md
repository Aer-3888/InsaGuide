# Corriges d'examen

## Exam 2024-2025 (cpoo1-2024-2025.pdf)

### Exercice 1 (~5 points) -- Test de Traitement

**Code donne** :
```java
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

public interface Observateur {
    void a();
    void b(String str);
}
```

**Consigne** : Ecrire `TestTraitement`. Un defaut est present dans le code, et vous devez ecrire un test qui l'expose.

**Le defaut** : le constructeur ne valide pas `obs`. Si `obs` est `null`, appeler `analyser()` lancera une `NullPointerException` au lieu d'une erreur correcte a la construction.

**Solution** :

```java
@ExtendWith(MockitoExtension.class)
public class TestTraitement {
    Traitement traitement;
    Observateur obs;

    @BeforeEach
    void setUp() {
        obs = Mockito.mock(Observateur.class);
        traitement = new Traitement(obs);
    }

    // Test case "a" -> calls obs.a()
    @Test
    void testAnalyserA() {
        traitement.analyser("a");
        Mockito.verify(obs).a();
    }

    // Test case "b" -> calls obs.b(str)
    @Test
    void testAnalyserB() {
        traitement.analyser("b");
        Mockito.verify(obs).b("b");
    }

    // Test default -> throws IllegalArgumentException
    @Test
    void testAnalyserDefault() {
        assertThrows(IllegalArgumentException.class,
            () -> traitement.analyser("xyz"));
    }

    // Test the DEFECT: constructor accepts null
    @Test
    void testConstructorWithNull() {
        Traitement t = new Traitement(null);
        // This should throw or be prevented, but the constructor allows it
        // Calling analyser will cause NullPointerException
        assertThrows(NullPointerException.class, () -> t.analyser("a"));
    }
}
```

### Exercice 2 (~5 points) -- QCM et questions

**Q.2**: Testing code is: **"apporter de la confiance vis-a-vis du code developpe"** (bring confidence about the developed code). Testing does NOT prove absence of bugs; it increases confidence.

**Q.3**: Executing tests to measure code coverage is a technique of: **"analyse dynamique"** (dynamic analysis). The code must actually run to measure coverage.

**Q.4**: A "mock" allows... the FALSE statement is: **"tester le fonctionnement de l'objet mocke"** (test the functioning of the mocked object). Mocks simulate dependencies; they test the code that USES the mock, not the mock itself.

**Q.5**: User stories and class diagrams are useful because: user stories capture requirements from the user's perspective and define acceptance criteria; class diagrams model the system's structure, relationships, and responsibilities. Together, they bridge the gap between what the system should do (stories) and how it is designed (diagrams).

**Q.6**: Acceptance tests in Agile and software testing: in Agile, a user story includes acceptance criteria that define "done." These criteria translate directly into acceptance tests. The term "test" has the same meaning in both contexts: a verifiable condition that, when met, confirms the feature works as specified.

**Q.7**: "A class abstract... possede que des methodes abstraites" is FALSE. An abstract class can have both abstract and concrete methods. (Interfaces in Java also had only abstract methods before Java 8, but abstract classes have always allowed concrete methods.)

### Exercice 3 (~5 points) -- Diagramme de classes UML (Devis)

**Resume du texte** : Un devis concerne un client et possede une date. Un client a un nom et une adresse. Un client peut etre une entreprise (avec un numero). Une tache a une designation, quantite, prix unitaire, et unite de mesure (ML, M2, U). Une tache fait reference a du materiel (au moins un). Un materiel a une designation et est fourni par un ou plusieurs fournisseurs. Un fournisseur a un nom.

**Diagramme solution** :

```
  +-------------------+     1    +-------------------+
  |      Devis        |--------->|     Client        |
  +-------------------+          +-------------------+
  | - date: String    |          | - nom: String     |
  +-------------------+          | - adresse: String |
         |                       +-------------------+
         | taches 1..*                    ^
         v                                | (extends)
  +-------------------+          +-------------------+
  |      Tache        |          |   Entreprise      |
  +-------------------+          +-------------------+
  | - designation: String   |    | - numero: String  |
  | - quantite: double      |   +-------------------+
  | - prixUnitaire: double  |
  | - unite: UniteDeMesure  |
  +-------------------+
         |
         | materiels 1..*
         v
  +-------------------+     *     +-------------------+
  |     Materiel      |<--------->|   Fournisseur     |
  +-------------------+   1..*   +-------------------+
  | - designation: String|       | - nom: String     |
  +-------------------+          +-------------------+

  +-------------------+
  | <<enumeration>>   |
  |  UniteDeMesure    |
  +-------------------+
  | ML                |
  | M2                |
  | U                 |
  +-------------------+
```

Decisions cles :
- `UniteDeMesure` est une enumeration (trois valeurs fixes)
- `Entreprise extends Client` (heritage : "un client peut etre une entreprise")
- `Materiel <-> Fournisseur` est plusieurs-a-plusieurs (1..* des deux cotes)
- `Devis -> Tache` est 1..* (au moins une tache)

### Exercice 4 (~5 points) -- Flot de controle Polygone

**Code donne** :
```java
public void deplacerPoints(List<Integer> positions, double vecteurTranslation) {
    for(int position : positions) {                    // A
        if(position < 0 || position >= points.size()) { // B, a: position<0, b: position>=size
            return;                                     // C
        }
    }
    for(int position: positions) {                     // D
        points.get(position).translation(vecteurTranslation); // E
    }
    System.out.println("deplacement fait");            // F
}
```

**Q.9 -- Table de verite pour la ligne B** :

| a: `position < 0` | b: `position >= points.size()` | Evaluated? | Result |
|---|---|---|---|
| true | non evalue (court-circuit) | Seulement a | true (return) |
| false | true | Les deux | true (return) |
| false | false | Les deux | false (continue) |

**Q.10 -- Graphe de flot de controle** :

```
  A (for loop: has next position?) ---no---> D
  |
  yes
  v
  a (position < 0?) ---true---> C (return)
  |
  false
  v
  b (position >= points.size()?) ---true---> C (return)
  |
  false
  v
  A (loop back)

  D (for loop: has next position?) ---no---> F (println)
  |
  yes
  v
  E (translation)
  |
  v
  D (loop back)

  F -> [end]
```

**Q.11 -- Classes d'equivalence pour `position`** :

Avec un polygone de 3 points (indices 0, 1, 2) :
- Classe 1 : `position < 0` (ex. -1) -- invalide, provoque return
- Classe 2 : `0 <= position < 3` (ex. 0, 1, 2) -- valide
- Classe 3 : `position >= 3` (ex. 3, 4) -- invalide, provoque return

Valeurs aux limites : -1, 0, 2, 3

**Q.12 -- Valeurs pour 100% de couverture de lignes** (polygone avec 3 points) :

Test 1 : `positions = [-1]` -- couvre A, B (a=true), C (return)
Test 2 : `positions = [0, 1, 2]` -- couvre A, B (a=false, b=false), D, E, F

**Q.13 -- Valeurs pour 100% de couverture de conditions** :

Chaque sous-condition doit etre vraie et fausse :
- `a` vrai : position = -1
- `a` faux, `b` vrai : position = 3
- `a` faux, `b` faux : position = 0

Tests : `[-1]`, `[3]`, `[0, 1, 2]`

### Exercice 5 (Bonus ~1 point) -- Tests de mutation

Les tests de mutation modifient le code source (creent des "mutants") et relancent la suite de tests. Si les tests passent toujours apres une mutation, les tests sont trop faibles pour detecter ce changement. Une bonne suite de tests doit "tuer" tous les mutants (chaque mutation provoque l'echec d'au moins un test). Le score de mutation = (mutants tues / total de mutants) * 100%. Un score eleve indique des tests robustes.

---

## Exam 2021-2022 (DS-CPOO1-2021-2022.pdf)

### Exercice 1 -- Test de la classe A

**Code donne** : Classe `A` avec validation du constructeur, `getB()`, `getStr()`, `al(boolean value)`, `doSomething()` (privee), et `create(B b)` (fabrique statique).

**Q.1 -- Analyse de couverture maximale** :

1. **Couverture de lignes 100% ?** Analyse : `doSomething()` fixe `str = "yolo"`. Apres l'appel de `al()`, `str` est toujours `"yolo"` (jamais null). Toutes les lignes de `al()` sont atteignables : `return 0` est declenche quand `!value` est vrai ; `return str.length() * b.getB1()` est declenche quand `value` est vrai. Les `throws SecurityException, NumberFormatException` sont seulement declares dans la signature -- ils n'ajoutent pas de lignes couvrables. **100% de couverture de lignes EST atteignable**.

2. **Couverture de branches 100% ?** La condition `str == null || !value` apres l'execution de `doSomething()` : `str` est toujours `"yolo"`, donc `str == null` est toujours `false`. Le court-circuit signifie qu'on entre dans la branche seulement quand `!value` est vrai. On ne peut jamais couvrir la branche ou `str == null` est vrai (puisque `doSomething()` s'execute toujours avant).

3. **Couverture de conditions 100% ?** `str == null` est toujours `false` apres `doSomething()`, donc on ne peut pas le rendre `true`.

**Classe de test solution** :

```java
public class TestA {
    A a;
    B b;

    @BeforeEach
    void setUp() throws AnException {
        b = Mockito.mock(B.class);
        Mockito.when(b.getB1()).thenReturn(1);
        a = new A(b);
    }

    @Test void testConstructorNull() {
        assertThrows(IllegalArgumentException.class, () -> new A(null));
    }

    @Test void testGetB() {
        assertSame(b, a.getB());
    }

    @Test void testGetStrInitiallyNull() {
        assertNull(a.getStr());
    }

    @Test void testAlFalse() throws Exception {
        assertEquals(0, a.al(false));
        // After al(), str is "yolo" (doSomething was called)
    }

    @Test void testAlTrue() throws Exception {
        // "yolo".length() = 4, b.getB1() = 1
        assertEquals(4, a.al(true));
    }

    @Test void testAlThrowsAnException() throws AnException {
        B badB = Mockito.mock(B.class);
        Mockito.when(badB.getB1()).thenThrow(new AnException("test"));
        A badA = new A(badB);
        assertThrows(AnException.class, () -> badA.al(true));
    }

    @Test void testCreateWithNull() {
        assertNull(A.create(null));
    }

    @Test void testCreateWithValid() {
        A created = A.create(b);
        assertNotNull(created);
        assertSame(b, created.getB());
    }
}
```

**Q.2 -- Test supplementaire pour create** : verifier que `create` retourne une NOUVELLE instance a chaque fois (pas un singleton) :

```java
@Test void testCreateReturnsNewInstance() {
    A a1 = A.create(b);
    A a2 = A.create(b);
    assertNotSame(a1, a2);
}
```

**Q.3 -- Tests qui n'augmentent pas la couverture mais sont necessaires** : tester que `getStr()` retourne `"yolo"` apres l'appel de `al()` (verification de l'effet de bord de `doSomething()`) :

```java
@Test void testStrAfterAl() throws Exception {
    a.al(false);
    assertEquals("yolo", a.getStr());
}
```

### Exercice 2 -- Diagramme UML Championnat de football

C'est un exercice de diagramme de classes complexe. Classes cles :
- `Championnat`, `Equipe`, `Joueur`, `Entraineur`, `Arbitre`, `Rencontre`
- Types d'evenements : `Penalty`, `Carton`, `But`, `Remplacement`, `Expulsion`
- Specialisations d'Arbitre : `ArbitreCentral`, `ArbitreTouche`, `ArbitreVideo`

Relations cles :
- `Rencontre` appartient a exactement 1 `Championnat`
- `Equipe` peut etre dans plusieurs `Championnat`s
- `Rencontre` implique 2 `Equipe` (local + visiteur)
- `Carton` a une couleur (enum : JAUNE, ROUGE) et cible un `Joueur` ou `Entraineur`
- `ArbitreCentral` peut faire tout ce que `ArbitreTouche` et `ArbitreVideo` peuvent, plus d'autres choses

---

## Exam 2020-2021 (DS-CPOO1-2020-2021.pdf)

### Exercice 1 -- Flot de controle de Foo

```java
public int foo(int i, int j) {
    if (i < 0 || j > 0) {
        return i + j;
    }
    return i * j;
}
```

**Q.1** : Nombre minimum de tests pour 100% de couverture de flot de controle : **2 tests** (un pour la branche `true`, un pour la branche `false`).

**Q.2** : Valeurs de test :
- Test 1 (branche true) : `i < 0` (ex. i=-1, j=0) OU `j > 0` (ex. i=0, j=1)
- Test 2 (branche false) : `i >= 0 ET j <= 0` (ex. i=1, j=0 ou i=0, j=-1)

Pour la couverture de conditions (chaque sous-condition vraie et fausse) : 3 tests necessaires.

**Q.3** : Graphe de flot de controle :
```
  [entry: line 2]
  |
  v
  [i<0?] --true--> [return i+j: line 4]
  |
  false
  v
  [j>0?] --true--> [return i+j: line 4]
  |
  false
  v
  [return i*j: line 6]
```

### Exercice 2 -- Correction d'assertions

| Faux | Correct |
|------|---------|
| `assertTrue(a.equals(b))` | `assertEquals(a, b)` |
| `assertFalse(!a.foo())` | `assertTrue(a.foo())` |
| try/catch with `fail()` | `assertThrows(VeryBadException.class, () -> foobar.m())` followed by `assertEquals(1, foobar.m())` for the normal case |

### Exercice 3 -- Formule arithmetique UML

Voir l'exemple detaille dans [04-uml-diagrams.md](../guide/04-uml-diagrams.md). Cle : identifier le patron Composite ou `Noeud` est soit une `Valeur`, une `RefConstante`, ou un `Operateur` (avec `Addition` et `Soustraction` comme sous-types).
