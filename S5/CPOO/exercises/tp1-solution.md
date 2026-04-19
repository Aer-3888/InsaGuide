# TP CPOO1 - UML vers Java : Associations et Composition (Velo/Guidon/Roue)

> Instructions de l'enseignant : `S5/CPOO/data/moodle/tp/tp1/README.md`

Ce TP couvre la traduction de diagrammes de classes UML en code Java. Il progresse des associations unidirectionnelles simples a l'integrite referentielle bidirectionnelle puis a la composition avec des relations un-a-plusieurs.

---

## Q.1 - Association simple (0..1)

### Creer une association unidirectionnelle simple entre `Velo` et `Guidon`. Un `Velo` peut avoir 0 ou 1 `Guidon`. Un `Guidon` peut etre associe a 0 ou 1 `Velo`. Les deux classes ont des getters et setters.

**Reponse :**

Une multiplicite 0..1 en UML signifie que la reference est optionnelle (peut etre null). En Java, cela se traduit par un champ nullable. `Velo` et `Guidon` detiennent chacun une reference vers l'autre, mais il n'y a pas de synchronisation automatique -- modifier un cote ne met pas a jour l'autre.

**Diagramme UML :**

```
+-----------------+         guidon     +-----------------+
|      Velo       | -----------------> |     Guidon      |
+-----------------+       0..1         +-----------------+
| - guidon: Guidon|                    | - velo: Velo    |
+-----------------+                    +-----------------+
| + getGuidon()   |       velo         | + getVelo()     |
| + setGuidon()   | <----------------- | + setVelo()     |
+-----------------+       0..1         +-----------------+
```

**Velo.java:**

```java
package q1;

public class Velo {
    private Guidon guidon = null;

    public Guidon getGuidon() {
        return this.guidon;
    }

    public void setGuidon(Guidon gd) {
        this.guidon = gd;
    }
}
```

**Guidon.java:**

```java
package q1;

public class Guidon {
    private Velo velo = null;

    public Velo getVelo() {
        return this.velo;
    }

    public void setVelo(Velo vl) {
        this.velo = vl;
    }
}
```

**Tests :**

```java
package q1;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class VeloTest {

    @Test
    void testInitialGuidonIsNull() {
        Velo v = new Velo();
        assertNull(v.getGuidon());
    }

    @Test
    void testSetAndGetGuidon() {
        Velo v = new Velo();
        Guidon g = new Guidon();
        v.setGuidon(g);
        assertSame(g, v.getGuidon());
    }

    @Test
    void testSetGuidonToNull() {
        Velo v = new Velo();
        Guidon g = new Guidon();
        v.setGuidon(g);
        v.setGuidon(null);
        assertNull(v.getGuidon());
    }
}

class GuidonTest {

    @Test
    void testInitialVeloIsNull() {
        Guidon g = new Guidon();
        assertNull(g.getVelo());
    }

    @Test
    void testSetAndGetVelo() {
        Guidon g = new Guidon();
        Velo v = new Velo();
        g.setVelo(v);
        assertSame(v, g.getVelo());
    }
}
```

**Le probleme de Q.1 :** Il n'y a pas de synchronisation automatique entre les deux cotes. Apres `v.setGuidon(g)`, appeler `g.getVelo()` retourne toujours null. Le programmeur doit manuellement appeler les deux cotes, ce qui est source d'erreurs. Cela motive Q.2.

**Modifications de fichiers :**
- `q1/Velo.java`: Created with a `Guidon` field, getter, and setter
- `q1/Guidon.java`: Created with a `Velo` field, getter, and setter

---

## Q.2 - Association bidirectionnelle avec integrite referentielle

### Assurer l'integrite referentielle lors de l'ajout d'un `Guidon` a un `Velo`. Quand `velo.setGuidon(guidon)` est appele, `guidon.setVelo(velo)` doit etre appele automatiquement.

**Reponse :**

L'integrite referentielle signifie que les deux cotes d'une association bidirectionnelle sont toujours coherents. La solution est de designer une classe comme "maitre" (Velo) qui gere la relation. L'autre classe (Guidon) a un setter simple. Le defi principal est d'eviter la recursion infinie : si `setGuidon` appelle `setVelo` et `setVelo` appelle `setGuidon`, on obtient un debordement de pile. La clause de garde `if (gd != this.guidon)` empeche cela.

**Diagramme UML :**

```
+-----------------+        guidon      +-----------------+
|      Velo       | =================> |     Guidon      |
+-----------------+       0..1         +-----------------+
| - guidon: Guidon|   referential      | - velo: Velo    |
+-----------------+   integrity        +-----------------+
| + getGuidon()   |                    | + getVelo()     |
| + setGuidon()   | <================= | + setVelo()     |
+-----------------+       0..1         +-----------------+
```

**Velo.java** (master side -- manages the relationship):

```java
package q2;

public class Velo {
    private Guidon guidon = null;

    public Guidon getGuidon() {
        return this.guidon;
    }

    public void setGuidon(Guidon gd) {
        // Guard: if same object, do nothing (prevents infinite recursion)
        if (gd != this.guidon) {
            Guidon oldGuidon = this.guidon;

            // If removing the handlebar, notify the old one
            if (gd == null && oldGuidon != null) {
                oldGuidon.setVelo(null);
            }

            // Set the new handlebar
            this.guidon = gd;

            // Establish back-reference on the new handlebar
            if (gd != null) {
                gd.setVelo(this);
            }
        }
    }
}
```

**Guidon.java** (passive side -- simple setter):

```java
package q2;

public class Guidon {
    private Velo velo = null;

    public Velo getVelo() {
        return this.velo;
    }

    // Simple setter. The Velo side manages referential integrity.
    // This method does NOT call back to Velo.setGuidon() to avoid infinite recursion.
    public void setVelo(Velo vl) {
        this.velo = vl;
    }
}
```

**Comment la recursion infinie est empechee :**

```
v.setGuidon(g)
  |-- gd != this.guidon? YES (guidon was null, gd is g)
  |-- this.guidon = g
  |-- g.setVelo(v)              // Guidon.setVelo is a simple setter
  |     |-- this.velo = v       // Done. No callback.
  |-- Done.
```

If `Guidon.setVelo` called back `v.setGuidon(g)`, the guard `gd != this.guidon` would evaluate to FALSE (because `this.guidon` is already `g`), and the method would return immediately.

**Tests :**

```java
package q2;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class VeloGuidonTest {

    @Test
    void testReferentialIntegrityOnSet() {
        Velo v = new Velo();
        Guidon g = new Guidon();
        v.setGuidon(g);
        assertSame(g, v.getGuidon());
        assertSame(v, g.getVelo());     // automatic back-reference
    }

    @Test
    void testReplaceGuidonUpdatesOldAndNew() {
        Velo v = new Velo();
        Guidon g1 = new Guidon();
        Guidon g2 = new Guidon();
        v.setGuidon(g1);
        v.setGuidon(g2);
        assertSame(g2, v.getGuidon());
        assertSame(v, g2.getVelo());    // new guidon linked
    }

    @Test
    void testRemoveGuidonCleansUp() {
        Velo v = new Velo();
        Guidon g = new Guidon();
        v.setGuidon(g);
        v.setGuidon(null);
        assertNull(v.getGuidon());
        assertNull(g.getVelo());        // old back-reference cleared
    }

    @Test
    void testSetSameGuidonTwice() {
        Velo v = new Velo();
        Guidon g = new Guidon();
        v.setGuidon(g);
        v.setGuidon(g);                 // no change
        assertSame(g, v.getGuidon());
        assertSame(v, g.getVelo());
    }

    @Test
    void testInitialStateIsNull() {
        Velo v = new Velo();
        assertNull(v.getGuidon());
    }
}
```

**Modifications de fichiers :**
- `q2/Velo.java`: Copied from q1, modified `setGuidon()` to maintain referential integrity with a guard clause and back-reference update
- `q2/Guidon.java`: Copied from q1, unchanged (passive side)

---

## Q.3 - Suppression de l'acces bidirectionnel

### Empecher `Guidon` d'acceder a son parent `Velo`. L'association est strictement unidirectionnelle avec multiplicite 1 (un Velo DOIT avoir un Guidon).

**Reponse :**

Quand la navigation n'est necessaire que dans un sens, la conception est plus simple. Le `Guidon` devient un composant pur sans connaissance de qui le possede. La multiplicite change de 0..1 a 1, ce qui signifie que null est rejete.

**Diagramme UML :**

```
+-----------------+        guidon      +-----------------+
|      Velo       | -----------------> |     Guidon      |
+-----------------+          1         +-----------------+
| - guidon: Guidon|                    |                 |
+-----------------+                    +-----------------+
| + Velo()        |   NO back-reference.
| + Velo(Guidon)  |   Multiplicity is 1 (not 0..1).
| + getGuidon()   |
| + setGuidon()   |
+-----------------+
```

**Velo.java:**

```java
package q3;

public class Velo {
    private Guidon guidon;

    public Velo() {
        // guidon is null by default
    }

    // Constructor enforcing multiplicity-1 constraint
    public Velo(Guidon gd) {
        if (gd == null) {
            throw new IllegalArgumentException("Guidon cannot be null");
        }
        this.guidon = gd;
    }

    public Guidon getGuidon() {
        return this.guidon;
    }

    // Rejects null to enforce multiplicity 1. If null is passed, no-op.
    public void setGuidon(Guidon gd) {
        if (gd != null) {
            this.guidon = gd;
        }
    }
}
```

**Guidon.java:**

```java
package q3;

// Simple handlebar with no reference to any bicycle.
public class Guidon {
    public Guidon() {
        // Empty constructor
    }
}
```

**Tests :**

```java
package q3;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class VeloTest {

    @Test
    void testConstructorWithValidGuidon() {
        Guidon g = new Guidon();
        Velo v = new Velo(g);
        assertSame(g, v.getGuidon());
    }

    @Test
    void testConstructorWithNullThrows() {
        assertThrows(IllegalArgumentException.class, () -> new Velo(null));
    }

    @Test
    void testDefaultConstructorHasNullGuidon() {
        Velo v = new Velo();
        assertNull(v.getGuidon());
    }

    @Test
    void testSetGuidonWithValidGuidon() {
        Velo v = new Velo();
        Guidon g = new Guidon();
        v.setGuidon(g);
        assertSame(g, v.getGuidon());
    }

    @Test
    void testSetGuidonWithNullDoesNothing() {
        Guidon g = new Guidon();
        Velo v = new Velo(g);
        v.setGuidon(null);
        assertSame(g, v.getGuidon()); // unchanged
    }

    @Test
    void testReplaceGuidon() {
        Guidon g1 = new Guidon();
        Guidon g2 = new Guidon();
        Velo v = new Velo(g1);
        v.setGuidon(g2);
        assertSame(g2, v.getGuidon());
    }
}
```

**Modifications de fichiers :**
- `q3/Velo.java`: Copied from q2, removed referential integrity logic, added constructor with null validation, setGuidon rejects null
- `q3/Guidon.java`: Removed `velo` field, `getVelo()`, and `setVelo()` entirely

---

## Q.4 - Association un-a-plusieurs (0..*)

### Implementer une association un-a-plusieurs ou un `Velo` a plusieurs `Roue`. L'association est unidirectionnelle.

**Reponse :**

Une multiplicite 0..* signifie "zero ou plusieurs", ce qui correspond a une `List<Roue>` en Java. La collection doit etre initialisee dans le constructeur (sinon `NullPointerException`). Les roues null et dupliquees sont rejetees.

**Diagramme UML :**

```
+---------------------+       roues      +-------------+
|       Velo          | ---------------> |    Roue     |
+---------------------+      0..*        +-------------+
| - roues: List<Roue> |                  |             |
+---------------------+                  +-------------+
| + Velo()            |                  | + Roue()    |
| + getRoues()        |                  +-------------+
| + addRoue(Roue)     |
| + removeRoues(Roue) |
+---------------------+
```

**Velo.java:**

```java
package q4;

import java.util.ArrayList;
import java.util.List;

public class Velo {
    private List<Roue> roues;

    public Velo() {
        this.roues = new ArrayList<>();
    }

    public List<Roue> getRoues() {
        return this.roues;
    }

    // Adds a wheel. Rejects null and duplicate wheels.
    public Boolean addRoue(Roue r) {
        if (r == null || this.roues.contains(r)) {
            return false;
        }
        return this.roues.add(r);
    }

    // Removes a wheel from this bicycle.
    public Boolean removeRoues(Roue r) {
        return this.roues.remove(r);
    }
}
```

**Roue.java:**

```java
package q4;

// Simple wheel with no knowledge of which bicycle it belongs to.
public class Roue {
    public Roue() {
        // Empty constructor
    }
}
```

**Tests :**

```java
package q4;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class VeloRoueTest {
    private Velo velo;

    @BeforeEach
    void setUp() {
        velo = new Velo();
    }

    @Test
    void testInitiallyNoWheels() {
        assertTrue(velo.getRoues().isEmpty());
    }

    @Test
    void testAddOneWheel() {
        Roue r = new Roue();
        assertTrue(velo.addRoue(r));
        assertEquals(1, velo.getRoues().size());
        assertSame(r, velo.getRoues().get(0));
    }

    @Test
    void testAddMultipleWheels() {
        Roue r1 = new Roue();
        Roue r2 = new Roue();
        assertTrue(velo.addRoue(r1));
        assertTrue(velo.addRoue(r2));
        assertEquals(2, velo.getRoues().size());
    }

    @Test
    void testAddNullRejected() {
        assertFalse(velo.addRoue(null));
        assertEquals(0, velo.getRoues().size());
    }

    @Test
    void testAddDuplicateRejected() {
        Roue r = new Roue();
        velo.addRoue(r);
        assertFalse(velo.addRoue(r));
        assertEquals(1, velo.getRoues().size());
    }

    @Test
    void testRemoveWheel() {
        Roue r = new Roue();
        velo.addRoue(r);
        assertTrue(velo.removeRoues(r));
        assertEquals(0, velo.getRoues().size());
    }

    @Test
    void testRemoveNonexistentWheel() {
        Roue r = new Roue();
        assertFalse(velo.removeRoues(r));
    }
}
```

**Modifications de fichiers :**
- `q4/Velo.java`: Created with `List<Roue>` field, `addRoue()` with null/duplicate guards, `removeRoues()`
- `q4/Roue.java`: Created as a simple empty class

---

## Q.5 - Composition avec navigation bidirectionnelle

### Implementer la composition ou `Roue` appartient a exactement un `Velo`, et `Velo` peut acceder a ses roues. Respecter l'integrite referentielle du role `roues` dans la composition.

**Reponse :**

La composition est une forme forte d'association ou la "partie" (Roue) appartient a exactement un "tout" (Velo) a la fois. Ajouter une Roue a un Velo fixe `roue.getVelo()` automatiquement. Supprimer une Roue l'efface. Deplacer une Roue d'un Velo a un autre la supprime du premier. La prevention de la recursion infinie est plus complexe ici car `addRoue` et `setVelo` s'appellent mutuellement.

**Diagramme UML :**

```
+---------------------+       roues      +------------------+
|       Velo          |<>=============>  |      Roue        |
+---------------------+      0..*        +------------------+
| - roues: List<Roue> |                  | - velo: Velo     |
+---------------------+      velo        +------------------+
| + Velo()            | <=============== | + getVelo()      |
| + getRoues()        |      0..1        | + setVelo(Velo)  |
| + addRoue(Roue)     |                  +------------------+
| + removeRoues(Roue) |
+---------------------+
```

**Velo.java:**

```java
package q5;

import java.util.ArrayList;
import java.util.List;

public class Velo {
    private List<Roue> roues;

    public Velo() {
        this.roues = new ArrayList<>();
    }

    public List<Roue> getRoues() {
        return this.roues;
    }

    // Adds a wheel with referential integrity.
    // 1. Reject null and duplicates
    // 2. Add to collection
    // 3. If wheel does not already reference us, set it (prevents recursion)
    public Boolean addRoue(Roue r) {
        if (r == null || this.roues.contains(r)) {
            return false;
        }

        this.roues.add(r);

        // Establish back-reference (guard prevents recursion)
        if (r.getVelo() != this) {
            r.setVelo(this);
        }

        return true;
    }

    // Removes a wheel with referential integrity.
    // 1. Reject null
    // 2. If wheel is in collection, clear its back-reference, then remove
    public Boolean removeRoues(Roue r) {
        if (r == null) {
            return false;
        }

        if (this.roues.contains(r)) {
            if (r.getVelo() == this) {
                r.setVelo(null);
            }
            this.roues.remove(r);
            return true;
        }

        return false;
    }
}
```

**Roue.java:**

```java
package q5;

public class Roue {
    private Velo velo = null;

    public Velo getVelo() {
        return this.velo;
    }

    // Sets the bicycle this wheel belongs to with referential integrity.
    // 1. If already set to this bike, do nothing (recursion guard)
    // 2. If currently on another bike, remove from that bike first
    //    (clear reference BEFORE calling removeRoues to prevent recursion)
    // 3. Set the new bike reference
    // 4. If new bike does not already contain us, add us
    public void setVelo(Velo vl) {
        if (this.velo == vl) {
            return;
        }

        // Remove from old bike (if any)
        if (this.velo != null) {
            Velo oldVelo = this.velo;
            this.velo = null;          // clear BEFORE calling remove
            oldVelo.removeRoues(this);
        }

        // Set new bike
        this.velo = vl;

        // Add to new bike's collection (if not already there)
        if (vl != null && !vl.getRoues().contains(this)) {
            vl.addRoue(this);
        }
    }
}
```

**How infinite recursion is prevented for a normal add:**

```
bike.addRoue(wheel)
  |-- wheel not null, not in list --> add to list
  |-- wheel.getVelo() != bike --> call wheel.setVelo(bike)
  |     |-- this.velo != bike? YES (was null)
  |     |-- this.velo is null, so skip "remove from old bike"
  |     |-- this.velo = bike
  |     |-- bike.getRoues().contains(this)? YES (just added above)
  |     |-- skip addRoue (already in collection)
  |-- DONE
```

**How moving a wheel between bikes works:**

```
wheel.setVelo(bike2)
  |-- this.velo != bike2? YES (was bike1)
  |-- oldVelo = bike1
  |-- this.velo = null          <-- break link BEFORE callback
  |-- bike1.removeRoues(wheel)
  |     |-- wheel is in bike1's list
  |     |-- wheel.getVelo() == bike1? NO (we set it to null)
  |     |-- skip setVelo(null) call
  |     |-- remove from list
  |-- this.velo = bike2
  |-- bike2 does not contain wheel --> bike2.addRoue(wheel)
  |     |-- wheel not null, not in list --> add to list
  |     |-- wheel.getVelo() == bike2? YES (just set above)
  |     |-- skip setVelo call
  |-- DONE
```

**Tests :**

```java
package q5;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class CompositionTest {
    private Velo velo;

    @BeforeEach
    void setUp() {
        velo = new Velo();
    }

    @Test
    void testAddRoueSetsBackReference() {
        Roue r = new Roue();
        velo.addRoue(r);
        assertSame(velo, r.getVelo());
    }

    @Test
    void testAddRoueAppearsInList() {
        Roue r = new Roue();
        velo.addRoue(r);
        assertEquals(1, velo.getRoues().size());
        assertSame(r, velo.getRoues().get(0));
    }

    @Test
    void testAddNullRejected() {
        assertFalse(velo.addRoue(null));
    }

    @Test
    void testAddDuplicateRejected() {
        Roue r = new Roue();
        velo.addRoue(r);
        assertFalse(velo.addRoue(r));
        assertEquals(1, velo.getRoues().size());
    }

    @Test
    void testRemoveRoueClearsBackReference() {
        Roue r = new Roue();
        velo.addRoue(r);
        velo.removeRoues(r);
        assertNull(r.getVelo());
    }

    @Test
    void testRemoveRoueRemovesFromList() {
        Roue r = new Roue();
        velo.addRoue(r);
        velo.removeRoues(r);
        assertTrue(velo.getRoues().isEmpty());
    }

    @Test
    void testRemoveNullReturnsFalse() {
        assertFalse(velo.removeRoues(null));
    }

    @Test
    void testRemoveNonexistentReturnsFalse() {
        assertFalse(velo.removeRoues(new Roue()));
    }

    @Test
    void testMoveWheelViaSetVelo() {
        Velo v1 = new Velo();
        Velo v2 = new Velo();
        Roue r = new Roue();

        v1.addRoue(r);
        assertSame(v1, r.getVelo());
        assertEquals(1, v1.getRoues().size());

        r.setVelo(v2);     // move wheel to v2

        assertFalse(v1.getRoues().contains(r));   // removed from v1
        assertTrue(v2.getRoues().contains(r));     // added to v2
        assertSame(v2, r.getVelo());               // back-reference updated
    }

    @Test
    void testDetachWheel() {
        Roue r = new Roue();
        velo.addRoue(r);
        r.setVelo(null);
        assertNull(r.getVelo());
        assertFalse(velo.getRoues().contains(r));
    }

    @Test
    void testSetVeloDirectlyAddsToList() {
        Roue r = new Roue();
        r.setVelo(velo);    // set from the Roue side
        assertTrue(velo.getRoues().contains(r));
        assertSame(velo, r.getVelo());
    }

    @Test
    void testSetVeloSameBikeNoOp() {
        Roue r = new Roue();
        velo.addRoue(r);
        r.setVelo(velo);    // already set
        assertEquals(1, velo.getRoues().size());
        assertSame(velo, r.getVelo());
    }
}
```

**Modifications de fichiers :**
- `q5/Velo.java`: Copied from q4, added referential integrity in `addRoue()` and `removeRoues()` with back-reference management
- `q5/Roue.java`: Added `velo` field with `getVelo()` and `setVelo()` that handles moving between bikes with break-before-callback recursion prevention

---

## Q.6 - Tests avec la suite de tests Moodle

### Executer les tests fournis par Moodle et corriger les eventuels problemes.

**Reponse :**

Cette etape valide l'implementation par rapport a la suite de tests officielle de l'enseignant.

**Etapes :**

1. Telecharger l'archive de tests depuis Moodle
2. L'extraire dans le repertoire `test/java2` de votre projet
3. Dans IntelliJ : clic droit sur le dossier `java2`, selectionner "Mark directory as" puis "Test Sources Root"
4. Executer tous les tests via clic droit sur la classe de test, puis "Run"
5. Corriger les tests echoues en modifiant votre implementation de q1 a q5

**Problemes courants detectes par la suite Moodle :**

- Oublier de verifier null dans `addRoue()`
- Ne pas gerer le cas ou `removeRoues()` est appele avec une roue absente de la liste
- Recursion infinie dans les associations bidirectionnelles due a l'absence de clauses de garde
- Ne pas nettoyer les anciennes references arriere lors du remplacement d'un Guidon en Q.2

Si un test echoue, lire attentivement le message d'assertion. Il indique quelle valeur attendue ne correspond pas a la valeur reelle. Tracer le code avec les entrees du test pour trouver la divergence.

---

## Tableau recapitulatif

| Question | Classes | Relation | Concept cle |
|----------|---------|----------|-------------|
| Q.1 | Velo, Guidon | 0..1 bidirectionnelle, sans synchronisation | Association simple |
| Q.2 | Velo, Guidon | 0..1 bidirectionnelle, avec integrite | Integrite referentielle, clauses de garde |
| Q.3 | Velo, Guidon | 1 unidirectionnelle | Suppression de la reference arriere, rejet de null |
| Q.4 | Velo, Roue | 0..* unidirectionnelle | Un-a-plusieurs avec List |
| Q.5 | Velo, Roue | 0..* composition avec integrite | Composition, rupture-avant-rappel |
| Q.6 | Toutes | Toutes | Validation avec les tests Moodle |
