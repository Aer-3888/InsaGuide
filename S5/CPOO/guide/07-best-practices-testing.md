# Bonnes pratiques Java et Tests

## Principes SOLID

### S -- Responsabilite unique (Single Responsibility)

Chaque classe doit avoir une seule raison de changer. Exemple : `Foret` gere la collection d'arbres ; `Arbre` gere sa propre logique de prix et d'age.

### O -- Ouvert/Ferme (Open/Closed)

Les classes doivent etre ouvertes a l'extension mais fermees a la modification. La classe abstraite `Arbre` permet d'ajouter de nouveaux types d'arbres (ouverte a l'extension) sans modifier le code existant (fermee a la modification).

### L -- Substitution de Liskov

Les objets d'une superclasse doivent etre remplacables par des objets d'une sous-classe sans casser le programme. `List<Arbre>` peut contenir des objets `Chene` et `Pin`, et toutes les operations sur `Arbre` fonctionnent correctement quel que soit le type reel.

### I -- Segregation des interfaces (Interface Segregation)

Les clients ne doivent pas dependre d'interfaces qu'ils n'utilisent pas. Le cours utilise des interfaces ciblees : `Service` n'a que `getLatency()`, `Network` n'a que `ping()` et `sendGetHTTPQuery()`.

### D -- Inversion de dependances (Dependency Inversion)

Dependre d'abstractions, pas de classes concretes. `Exo2` depend de l'interface `Network`, pas d'une implementation concrete. Cela permet les tests avec des mocks.

```java
public class Exo2 {
    private final Network network;          // depends on interface

    public Exo2(Network network) {          // injected via constructor
        this.network = network;
    }
}
```

---

## Tests unitaires avec JUnit 5

### Structure de test (Patron AAA)

```java
@Test
void testVieillir() {
    // Arrange
    Arbre arbre = new Chene(5, 2.0);

    // Act
    arbre.vieillir();

    // Assert
    assertEquals(6, arbre.getAge());
}
```

### Assertions courantes

```java
assertEquals(expected, actual);                 // equality
assertEquals(expected, actual, 0.001);          // floating-point with delta
assertTrue(condition);
assertFalse(condition);
assertNull(object);
assertNotNull(object);
assertThrows(ExType.class, () -> code());       // exception expected
assertSame(obj1, obj2);                         // same reference (==)
```

### Annotations de cycle de vie

```java
@BeforeEach
void setUp() {
    // runs before each test method
    mp = new MyPoint();
}

@AfterEach
void tearDown() {
    // runs after each test method (cleanup)
}

@BeforeAll
static void initAll() { /* once before all tests */ }

@AfterAll
static void cleanAll() { /* once after all tests */ }
```

### Tests parametres

```java
@ParameterizedTest
@ValueSource(strings = {"abc", "999.999.999.999", "", "1.2.3"})
void testInvalidIP(String address) {
    assertFalse(exo2.connectServer(address));
}

@ParameterizedTest
@CsvSource({"0, true", "-1, true", "5, true", "4, false"})
void testIsOut(int value, boolean expected) {
    assertEquals(expected, plateau.isOut(value));
}
```

### Anti-patrons de test courants (du cours)

**Anti-pattern 1: assertTrue(a.equals(b))** -- use `assertEquals(a, b)` instead.

**Anti-pattern 2: assertFalse(!a.foo())** -- use `assertTrue(a.foo())`.

**Anti-pattern 3: assertTrue(a == b)** -- use `assertSame(a, b)` for reference equality.

**Anti-pattern 4: try/catch with fail()** -- use `assertThrows()`.

```java
// WRONG
@Test
void test1() {
    try {
        foobar.m(null);
        fail();
    } catch (MyException ex) {
        assertTrue(true);       // meaningless
    }
}

// CORRECT
@Test
void test1() {
    assertThrows(MyException.class, () -> foobar.m(null));
}
```

**Anti-pattern 5: if/fail instead of assertEquals**:
```java
// WRONG
if (i != 10) { fail(); }

// CORRECT
assertEquals(10, foo.getI());
```

**Anti-pattern 6: Duplicate setup in each test**:
```java
// WRONG
@Test void testC1() { C c = new C(); assertEquals(12.12, c.getC1()); }
@Test void testC2() { C c = new C(); assertEquals("foo", c.getC2()); }

// CORRECT: use @BeforeEach
C c;
@BeforeEach void setUp() { c = new C(); }
@Test void testC1() { assertEquals(12.12, c.getC1()); }
@Test void testC2() { assertEquals("foo", c.getC2()); }
```

---

## Mocking avec Mockito

### Pourquoi mocker ?

Quand une classe depend d'une interface (ex. `Network`, `Service`, `B`), on ne peut pas la tester sans implementation. Les mocks simulent le comportement de l'interface.

### Mocking de base

```java
// Create a mock
Network network = Mockito.mock(Network.class);

// Define behavior
Mockito.when(network.ping("192.168.1.1")).thenReturn(true);

// Use in tests
Exo2 exo2 = new Exo2(network);
assertTrue(exo2.connectServer("192.168.1.1"));
```

### Mocker des exceptions

```java
B beh = Mockito.mock(B.class);
Mockito.when(beh.getB1()).thenThrow(new AnException("test"));

A a = new A(beh);
assertThrows(AnException.class, () -> a.al(true));
```

### Verification des appels de methode

```java
// Verify that sendGetHTTPQuery was called with the correct argument
Mockito.verify(network).sendGetHTTPQuery("192.168.1.1");

// Verify a method was never called
Mockito.verify(network, Mockito.never()).sendGetHTTPQuery("bad");
```

### Mocker des retours consecutifs

```java
Random random = Mockito.mock(Random.class);
Mockito.when(random.nextInt()).thenReturn(892, 190);

mp.setPoint(random, random);
assertEquals(892, mp.getX(), 1e-6);    // first call returns 892
assertEquals(190, mp.getY(), 1e-6);    // second call returns 190
```

### Mock de construction (Avance -- Exo8)

Quand une classe instancie un objet en interne, on ne peut pas injecter un mock normalement. Utiliser `mockConstruction()` :

```java
@Test
void testUneFonctionInutile() {
    try (var mocked = Mockito.mockConstruction(Random.class,
            (mock, context) -> {
                Mockito.when(mock.nextRandom()).thenReturn(42);
            })) {
        Exo8 exo8 = new Exo8();           // constructor creates Random, gets mock
        assertEquals(42 * 5, exo8.uneFonctionInutile(5));
    }
}
```

### Mock de methodes statiques (Avance -- Exo8)

Quand une classe appelle directement une methode statique :

```java
@Test
void testUneAutreFonctionInutile() {
    try (var mocked = Mockito.mockStatic(RandomGenerator.class)) {
        RandomGenerator mockGen = Mockito.mock(RandomGenerator.class);
        Mockito.when(mockGen.nextInt()).thenReturn(10);
        mocked.when(RandomGenerator::getDefault).thenReturn(mockGen);

        Exo8 exo8 = new Exo8();
        assertEquals(10 * 3, exo8.uneAutreFonctionInutile(3));
    }
}
```

---

## Couverture de code

### Types de couverture

| Type | Description | Pertinence a l'examen |
|------|-------------|----------------------|
| **Couverture de lignes** | % de lignes source executees | Frequemment demande |
| **Couverture de branches** | % de branches de decision prises (vrai + faux) | Frequemment demande |
| **Couverture de conditions** | Chaque sous-expression booleenne evaluee vrai ET faux | Frequemment demande |

### Operateurs court-circuit et couverture

```java
if (s == null || services.contains(s))     // || short-circuits
```

Table de verite pour la couverture :

| `s == null` | `services.contains(s)` | Evalue ? | Resultat |
|-------------|----------------------|----------|----------|
| vrai | non evalue | Seulement le premier | vrai |
| faux | vrai | Les deux | vrai |
| faux | faux | Les deux | faux |

Pour atteindre la **couverture de conditions**, il faut des tests ou chaque sous-condition est vraie et fausse independamment.

### Graphes de flot de controle

Pour la methode `getTotalLatency` :
```java
public double getTotalLatency() {    // A
    double sum = 0.0;                // B
    for (Service s : services) {     // C  (loop condition)
        sum += s.getLatency();       // D
    }
    return sum;                      // E
}
```

```
  A -> B -> C --(has next)--> D -> C
             |
             +--(no more)--> E
```

### Classes d'equivalence

Regrouper les entrees qui produisent le meme comportement :
```java
// For addService(Service s):
// Class 1: s == null            -> IllegalArgumentException
// Class 2: s already in list    -> IllegalArgumentException
// Class 3: s valid, not in list -> added successfully
```

Pour les coordonnees dans `PlateauJeu` (SIZE = 5) :
```
// Class 1: x < 0            -> isOut = true
// Class 2: 0 <= x < SIZE    -> isOut = false (valid)
// Class 3: x >= SIZE         -> isOut = true
// Boundary values: -1, 0, 4, 5
```

---

## Tests de mutation (Pitest)

### Concept

Les tests de mutation modifient votre code (creent des "mutants") et verifient si vos tests detectent les changements. Si un test passe toujours apres une mutation, le test est faible.

**Les mutations incluent** :
- Changer `>` en `>=` ou `<`
- Remplacer `+` par `-`
- Supprimer des appels de methode
- Changer les valeurs de retour
- Nier les conditions

### Executer Pitest

```bash
mvn clean install test org.pitest:pitest-maven:mutationCoverage
# Report: target/pit-reports/index.html
```

### Les trois problemes de TestExo9

Le `TestExo9` original a trois problemes :

1. **Aucune assertion sur `ajouterElement`** : le test appelle `ajouterElement("foo")` mais ne verifie jamais que l'element a ete ajoute (pas de `assertFalse(exo9.estVide())` ni de `assertTrue(exo9.contient("foo"))`).

2. **Pas de test pour `estVide` retournant false** : ne teste que le cas vide (`assertTrue(exo9.estVide())`), jamais le cas non vide.

3. **Ne detecte pas le bug off-by-one dans `contient()`** : le test appelle seulement `contient("bar")` qui trouve l'element avant d'atteindre la limite. Il ne teste jamais `contient("notPresent")` qui declencherait l'`IndexOutOfBoundsException`.

### Tests corriges (score de mutation 100%)

```java
@Test
void testIsEmpty() {
    assertTrue(exo9.estVide());
}

@Test
void testIsNotEmpty() {
    exo9.ajouterElement("foo");
    assertFalse(exo9.estVide());
}

@Test
void testAjouterElement() {
    exo9.ajouterElement("foo");
    assertFalse(exo9.estVide());
    assertTrue(exo9.contient("foo"));
}

@Test
void testContientPresent() {
    exo9.ajouterElement("bar");
    assertTrue(exo9.contient("bar"));
}

@Test
void testContientAbsent() {
    exo9.ajouterElement("bar");
    // After fixing the bug (i <= taille -> i < taille):
    assertFalse(exo9.contient("notHere"));
}
```

---

## Pieges courants

1. **Tester le mock au lieu du systeme sous test** : `assertEquals(vb, b.getB1())` teste la configuration du mock, pas la classe reelle.
2. **Atteindre 100% de couverture de lignes mais avec des assertions faibles** : la couverture mesure l'execution, pas la correction. Les tests de mutation detectent cela.
3. **Oublier `@ExtendWith(MockitoExtension.class)`** : necessaire pour que les annotations `@Mock` fonctionnent.
4. **Ne pas utiliser `try-with-resources` pour les mock static/construction** : la portee du mock doit etre fermee correctement.

---

## CHEAT SHEET

```
JUNIT 5 ANNOTATIONS
  @Test                              single test method
  @BeforeEach / @AfterEach          before/after each test
  @BeforeAll / @AfterAll            before/after all tests (static)
  @ParameterizedTest                 data-driven test
  @ValueSource / @CsvSource          data providers

ASSERTIONS
  assertEquals(expected, actual)
  assertEquals(expected, actual, delta)   // for doubles
  assertTrue / assertFalse
  assertNull / assertNotNull
  assertThrows(Exception.class, () -> ...)
  assertSame / assertNotSame             // reference equality

MOCKITO
  mock(Class.class)                      create mock
  when(mock.method()).thenReturn(val)     stub return value
  when(mock.method()).thenThrow(ex)       stub exception
  verify(mock).method()                  verify call
  verify(mock, never()).method()         verify no call
  verify(mock, times(n)).method()        verify call count
  mockConstruction(Class.class, ...)     mock new instances
  mockStatic(Class.class)               mock static methods

COVERAGE TYPES
  Line:      each source line executed
  Branch:    each if/else path taken
  Condition: each boolean sub-expression true AND false

MUTATION TESTING
  mvn clean install test org.pitest:pitest-maven:mutationCoverage
  Goal: 100% mutation score = all mutants killed by tests
```
