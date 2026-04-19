# Banque de questions par type

Toutes les questions extraites des examens CPOO 2019-2025, organisees par sujet.

---

## Type 1 : Ecrire une classe de test

Ces questions donnent une classe Java + interface et demandent d'ecrire une classe de test complete avec couverture maximale.

### Schema de question

On recoit :
- Une classe a tester (avec constructeur, methodes, eventuellement une fabrique statique)
- Une interface dont la classe depend (doit etre mockee)
- Parfois une classe d'exception personnalisee

Il faut ecrire :
- `@BeforeEach` avec configuration du mock
- Tests pour le constructeur (y compris entree null)
- Tests pour chaque methode (cas normal, cas limites, chemins d'exception)
- Appels `verify()` quand c'est pertinent

### Exemples des annales

**2024-2025**: Test `Traitement` (Observateur interface, switch/case, defect to find)
**2021-2022**: Test `A` (B interface, AnException, private doSomething, static createA)
**2020-2021**: Test `Client` (Service interface, addService with validation, getTotalLatency)

### Reponse type

```java
@ExtendWith(MockitoExtension.class)
public class TestClassName {
    ClassName obj;
    InterfaceName mock;

    @BeforeEach
    void setUp() throws SomeException {
        mock = Mockito.mock(InterfaceName.class);
        Mockito.when(mock.someMethod()).thenReturn(someValue);
        obj = new ClassName(mock);
    }

    @Test void testConstructorNull() {
        assertThrows(IllegalArgumentException.class, () -> new ClassName(null));
    }

    @Test void testNormalCase() throws SomeException {
        assertEquals(expected, obj.method(args));
    }

    @Test void testExceptionCase() throws SomeException {
        InterfaceName badMock = Mockito.mock(InterfaceName.class);
        Mockito.when(badMock.someMethod()).thenThrow(new SomeException());
        ClassName badObj = new ClassName(badMock);
        assertThrows(SomeException.class, () -> badObj.method(args));
    }

    @Test void testVerifyCall() throws SomeException {
        obj.method(args);
        Mockito.verify(mock).someMethod();
    }
}
```

---

## Type 2 : Corriger des assertions / Reecrire des tests

### Corrections courantes (reviennent chaque annee)

| Faux | Correct | Pourquoi |
|------|---------|----------|
| `assertTrue(a.equals(b))` | `assertEquals(a, b)` | Meilleur message d'erreur en cas d'echec |
| `assertFalse(!a.foo())` | `assertTrue(a.foo())` | La double negation est confuse |
| `assertTrue(a == b)` | `assertSame(a, b)` | Clarte semantique pour l'egalite de reference |
| `assertFalse(a.equals(b))` | `assertNotEquals(a, b)` | Intention plus claire |
| `assertTrue(!o.myMethod())` | `assertFalse(o.myMethod())` | Supprimer la negation |

### Anti-patron try/catch

```java
// WRONG
@Test void test1() {
    try {
        foobar.m(null);
        fail();
    } catch (MyException ex) {
        assertTrue(true);
    }
}

// CORRECT
@Test void test1() {
    assertThrows(MyException.class, () -> foobar.m(null));
}
```

### Anti-patron if/fail

```java
// WRONG
@Test void testI() {
    final int i = foo.getI();
    if (i != 10) { fail(); }
}

// CORRECT
@Test void testI() {
    assertEquals(10, foo.getI());
}
```

### Anti-patron setup duplique

```java
// WRONG
@Test void testC1() { C c = new C(); assertEquals(12.12, c.getC1()); }
@Test void testC2() { C c = new C(); assertEquals("foo", c.getC2()); }

// CORRECT
C c;
@BeforeEach void setUp() { c = new C(); }
@Test void testC1() { assertEquals(12.12, c.getC1()); }
@Test void testC2() { assertEquals("foo", c.getC2()); }
```

---

## Type 3 : Diagrammes de classes UML a partir de texte

### Exemples des annales

**2024-2025 (Devis)**: Devis, Client, Entreprise, Tache, UniteDeMesure (enum), Materiel, Fournisseur

**2021-2022 (Football)**: Championnat, Equipe, Joueur, Entraineur, Arbitre (3 types), Rencontre, events (Penalty, But, Carton, Remplacement, Expulsion)

**2020-2021 (Arithmetic)**: FormuleArithmetique, Constante, Noeud (interface/abstract), Valeur, RefConstante, Operateur (abstract), Addition, Soustraction -- Composite pattern

### Methode systematique

1. **Lister tous les noms** : ce sont des classes ou attributs candidats
2. **Classer les noms** : entite autonome = classe ; descripteur = attribut ; ensemble fixe de valeurs = enum
3. **Identifier l'heritage** : "X est un type de Y" ou "X peut etre Y" = Y est le parent
4. **Identifier les associations** : "X possede Y" ou "X contient Y"
5. **Determiner la multiplicite** : "un" = 1 ; "zero ou plusieurs" = 0..* ; "au moins un" = 1..* ; "optionnel" = 0..1
6. **Agregation vs Composition** : "appartient a exactement un" ou dependance de cycle de vie = composition ; "peut exister independamment" = agregation
7. **Ajouter les methodes** : la ou un comportement est decrit
8. **Marquer abstrait** : classes qui ne doivent pas etre instanciees directement

### Erreurs courantes

- Oublier la multiplicite aux extremites des associations
- Tout mettre en classe (certaines choses sont juste des attributs)
- Manquer la relation d'heritage quand le texte dit "X peut etre Y" ou "X est un type particulier de Y"
- Ne pas reconnaitre les enumerations ("est soit A, B, ou C")

---

## Type 4 : Graphes de flot de controle

### Quoi dessiner

- **Noeuds** : instructions, conditions, en-tetes de boucle
- **Aretes** : flot de controle entre les noeuds
- **Noeuds de branchement** : `if`, `switch`, conditions de boucle

### Operateurs court-circuit

For `if (a || b)`:
```
  [a?] --true--> [then-body]
  |
  false
  v
  [b?] --true--> [then-body]
  |
  false
  v
  [else-body or next]
```

For `if (a && b)`:
```
  [a?] --false--> [else-body or next]
  |
  true
  v
  [b?] --false--> [else-body or next]
  |
  true
  v
  [then-body]
```

### Exemples des annales

- **2024-2025** : `deplacerPoints` avec deux boucles for et condition `||`
- **2021-2022** : `addService` avec condition `||`, `getTotalLatency` avec boucle for-each
- **2020-2021** : `foo` avec condition `||`

---

## Type 5 : Tables de verite

### Methode

For `if (a || b)` with short-circuit:

| a | b | b evaluated? | Result |
|---|---|-------------|--------|
| T | - | No | T |
| F | T | Yes | T |
| F | F | Yes | F |

For `if (a && b)` with short-circuit:

| a | b | b evaluated? | Result |
|---|---|-------------|--------|
| F | - | No | F |
| T | F | Yes | F |
| T | T | Yes | T |

---

## Type 6 : Classes d'equivalence

### Methode

1. Identifier le parametre d'entree
2. Identifier les conditions qui partitionnent l'espace des entrees
3. Nommer chaque partition
4. Identifier les valeurs aux limites

### Exemple (positions dans deplacerPoints, polygone avec 3 points)

| Classe | Intervalle | Comportement |
|--------|-----------|-------------|
| Invalide bas | position &lt; 0 | return (quitte la methode) |
| Valide | 0 &lt;= position &lt; 3 | translate |
| Invalide haut | position >= 3 | return (quitte la methode) |

Valeurs aux limites : -1, 0, 2, 3

---

## Type 7 : QCM / Reponses courtes

### Sujets recurrents

**Definitions de test** :
- Tester apporte de la confiance, ne prouve pas la correction
- La couverture de code est de l'analyse dynamique (le code doit s'executer)
- Les mocks testent le code qui UTILISE le mock, pas le mock lui-meme
- Les tests de mutation evaluent la qualite des tests en introduisant des changements de code

**Definitions POO** :
- Les classes abstraites peuvent avoir des constructeurs, des methodes concretes et des champs
- Une interface definit un contrat ; l'implementation multiple est possible
- `final` sur une reference : la reference ne peut pas changer, mais l'objet peut etre modifie
- Polymorphisme : meme appel de methode, comportement different selon le type reel

**Definitions UML/Conception** :
- Les user stories capturent les besoins ; les diagrammes de classes capturent la conception
- Les criteres/tests d'acceptation font le pont entre besoins et verification

---

## Type 8 : Analyse de couverture

### "Peut-on atteindre 100% de couverture de lignes/branches/conditions ?"

Verifier :
1. **Code mort** : code apres `return` ou `throw`
2. **Branches inatteignables** : court-circuit empechant l'evaluation
3. **Methodes privees qui changent l'etat** : ex. `doSomething()` fixe `str = "yolo"`, rendant la branche subsequente `str == null` morte
4. **Exceptions declarees mais non lancables** : `throws SecurityException` mais aucun chemin de code ne la lance

### Analyse 2021-2022 de la classe A

- `doSomething()` fixe toujours `str = "yolo"` avant la verification `if`
- Donc `str == null` est toujours `false` dans `al()` -- cette sous-condition ne peut pas etre `true`
- `SecurityException` et `NumberFormatException` sont declarees mais jamais lancees par `al()` elle-meme
- Resultat : 100% de couverture de **lignes** EST atteignable (toutes les lignes sont accessibles : `return 0` via `!value`, `return str.length() * b.getB1()` via `value == true`). Mais 100% de couverture de **branches** et de **conditions** NE SONT PAS atteignables (la branche vrai de `str == null` est morte)

---

## Type 9 : Questions bonus

### Tests de mutation (2024-2025)

Expliquer en quelques phrases comment fonctionnent les tests de mutation et leur interet :

"Mutation testing automatically modifies the source code to create 'mutants' (e.g., changing `>` to `>=`, removing a method call, negating a condition). The test suite is then run against each mutant. If a test fails, the mutant is 'killed' (detected). If all tests pass, the mutant 'survives,' indicating a gap in the test suite. The mutation score (killed/total) measures the quality of tests -- a high score means the tests are effective at detecting code changes."
