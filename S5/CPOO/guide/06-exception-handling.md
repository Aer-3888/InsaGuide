# Gestion des exceptions

## Theorie

### Hierarchie des exceptions

```
             Throwable
            /         \
       Error         Exception
    (do not catch)    /        \
                RuntimeException  Checked Exceptions
                (unchecked)       (must be declared)
                  |                    |
          NullPointerException    IOException
          IllegalArgumentException NetworkException (custom)
          IndexOutOfBoundsException AnException (custom)
          SecurityException
          NumberFormatException
          ConcurrentModificationException
```

### Exceptions verifiees vs non verifiees

| Type | Doit declarer (`throws`) | Doit capturer | Exemples |
|------|--------------------------|---------------|----------|
| **Verifiee (Checked)** | Oui | Oui (ou declarer) | `IOException`, `NetworkException`, `AnException` |
| **Non verifiee (Unchecked)** (RuntimeException) | Non | Non (optionnel) | `NullPointerException`, `IllegalArgumentException` |

### try/catch/finally

```java
public boolean connectServer(final String address) {
    if (!regex.matcher(address).matches()) {
        return false;                    // validation before try
    }

    try {
        boolean pingOK = network.ping(address);      // may throw NetworkException
        network.sendGetHTTPQuery(address);
        return pingOK;
    } catch (NetworkException ex) {
        return false;                    // handle checked exception
    }
}
```

### Lancer des exceptions

```java
public A(final B b) {
    if (b == null) {
        throw new IllegalArgumentException();    // input validation
    }
    this.b = b;
}
```

### Classes d'exceptions personnalisees

```java
// Checked exception (extends Exception)
public class NetworkException extends Exception {
}

// Checked exception with message
public class AnException extends Exception {
    public AnException(String e) {
        super(e);
    }
}
```

### Declarer les exceptions avec `throws`

Quand une methode peut lancer une exception verifiee, elle doit la declarer :

```java
public interface B {
    int getB1() throws AnException;        // declares checked exception
}

public int al(final boolean value) throws SecurityException, NumberFormatException, AnException {
    doSomething();
    if (str == null || !value) {
        return 0;
    }
    return str.length() * b.getB1();       // b.getB1() may throw AnException
}
```

### Methodes fabrique statiques et gestion des exceptions

Un patron courant est d'envelopper les exceptions du constructeur dans une methode fabrique :

```java
public static A create(final B b) {
    try {
        return new A(b);                   // constructor throws if b is null
    } catch (final IllegalArgumentException ex) {
        return null;                       // return null instead of propagating
    }
}
```

### Gestion des exceptions dans les tests

**Tester qu'une exception est lancee** :
```java
@Test
void testConstructWithNull() {
    assertThrows(IllegalArgumentException.class, () -> {
        new A(null);
    });
}
```

**Tester qu'une exception n'est PAS lancee (flux normal)** :
```java
@Test
void testNormalFlow() throws AnException {
    // If al() throws, the test fails automatically
    assertEquals(0, at.al(false));
}
```

**Erreur courante a l'examen -- envelopper dans un try/catch au lieu d'utiliser assertThrows** :
```java
// WRONG (verbose, error-prone)
@Test
void testBad() {
    try {
        foobar.m(null);
        fail();                            // easy to forget
    } catch (MyException ex) {
        assertTrue(true);                  // meaningless assertion
    }
}

// CORRECT
@Test
void testGood() {
    assertThrows(MyException.class, () -> foobar.m(null));
}
```

### Le bug dans Exo9 : IndexOutOfBoundsException

Le cours inclut un bug delibere pour enseigner les limites des exceptions :

```java
public boolean contient(String str) {
    final int taille = maListe.size();
    for (int i = 0; i <= taille; i++) {    // BUG: should be i < taille
        if (maListe.get(i).equals(str)) {
            return true;
        }
    }
    return false;
}
```

Quand `i == taille`, `maListe.get(i)` lance une `IndexOutOfBoundsException`. La correction : changer `<=` en `<`.

---

## Patrons d'exceptions des examens

### Patron 1 : Evaluation en court-circuit et exceptions

```java
// In A.al():
if (str == null || !value) {
    return 0;
}
return str.length() * b.getB1();    // b.getB1() may throw AnException
```

L'operateur `||` court-circuite : si `str == null` est vrai, `!value` n'est pas evalue. De meme, si `str != null` et `value == true`, alors `str.length()` est sur (pas de NPE) et `b.getB1()` est appele (peut lancer `AnException`).

### Patron 2 : Types d'exceptions multiples

```java
public int al(final boolean value) throws SecurityException, NumberFormatException, AnException {
    ...
}
```

Une methode peut declarer plusieurs types d'exceptions. Dans les tests, il faut verifier quelles exceptions sont effectivement atteignables.

### Patron 3 : Exception depuis des objets mockes

```java
B beh = Mockito.mock(B.class);
Mockito.when(beh.getB1()).thenThrow(new AnException("test"));

// Test that the exception propagates
assertThrows(AnException.class, () -> {
    A a = new A(beh);
    a.al(true);
});
```

---

## Pieges courants

1. **Capturer trop large** : `catch (Exception e)` masque les erreurs specifiques. Capturer le type d'exception le plus specifique.
2. **Avaler silencieusement les exceptions** : un bloc `catch` vide masque les echecs. Au minimum, journaliser l'erreur.
3. **Erreur de borne dans les boucles** : `i <= size` au lieu de `i < size` provoque une `IndexOutOfBoundsException` (comme dans Exo9).
4. **Ne pas tester les chemins d'exception** : atteindre 100% de couverture necessite de tester les chemins normaux et les chemins d'exception.
5. **Utiliser `fail()` au lieu de `assertThrows()`** : la facon moderne avec JUnit 5 est `assertThrows()`, qui est plus propre et moins sujette aux erreurs.

---

## CHEAT SHEET

```
EXCEPTION HIERARCHY
  Throwable > Exception > RuntimeException (unchecked)
  Throwable > Exception > [custom] (checked if extends Exception directly)
  Throwable > Error (do not catch: OutOfMemoryError, StackOverflowError)

CHECKED EXCEPTIONS
  Must declare: throws ExType in method signature
  Must handle: try/catch or propagate with throws
  Examples: IOException, custom exceptions extending Exception

UNCHECKED EXCEPTIONS (RuntimeException)
  No declaration required
  Examples: NullPointerException, IllegalArgumentException,
            IndexOutOfBoundsException, ClassCastException

SYNTAX
  throw new ExceptionType("message");     // throw an exception
  throws ExType1, ExType2                 // declare in signature

  try {
      riskyCode();
  } catch (SpecificException e) {
      handleIt();
  } finally {
      alwaysRuns();                        // cleanup code
  }

TESTING EXCEPTIONS (JUnit 5)
  assertThrows(ExType.class, () -> code());
  assertDoesNotThrow(() -> code());

CUSTOM EXCEPTION
  public class MyException extends Exception {      // checked
      public MyException(String msg) { super(msg); }
  }
  public class MyRTException extends RuntimeException { // unchecked
      ...
  }
```
