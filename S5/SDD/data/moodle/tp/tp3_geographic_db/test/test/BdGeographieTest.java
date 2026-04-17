package test;

import main.BdGeographique;
import main.Coordonnees;
import main.Enregistrement;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class BdGeographieTest {
    BdGeographique bd;

    @BeforeEach
    void setup() {
        this.bd = new BdGeographique();
    }

    // Ajouter
    @Test
    void addItems() {
        assertDoesNotThrow(() -> bd.ajouter(new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        )));
    }

    @Test
    void addTwiceDoesNotAdd() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        bd.ajouter(k);
        bd.ajouter(k);
        bd.retirer(k);
        // If all worked out, it must be absent now
        assertFalse(bd.estPresent(k));
    }

    // estPresent
    @Test
    void presenceOfNone() {
        assertFalse(bd.estPresent(null));
    }

    @Test
    void presenceOfItem() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        bd.ajouter(k);
        assertTrue(bd.estPresent(k));
    }

    // vider
    @Test
    void emptyNothing() {
        assertDoesNotThrow(() -> bd.vider());
    }
    @Test
    void emptyItems() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        Enregistrement u = new Enregistrement(
                "Compiègne",
                new Coordonnees((float)49.2454, (float)2.4923),
                40199
        );
        bd.ajouter(k);
        bd.ajouter(u);
        bd.vider();
        assertFalse(bd.estPresent(k));
        assertFalse(bd.estPresent(u));
    }

    // retirer
    @Test
    void retirerNone() {
        assertDoesNotThrow(() -> bd.retirer(null));
    }
    @Test
    void retirerPresentItem() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        bd.ajouter(k);
        bd.retirer(k);
        assertFalse(bd.estPresent(k));
    }
    @Test
    void retirerAbsentItem() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        assertDoesNotThrow(() -> bd.retirer(k));
    }

    // toString
    @Test
    void toStringEmpty() {
        assertEquals("DATABASE : empty", bd.toString());
    }
    @Test
    void toStringItem() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        bd.ajouter(k);
        assertEquals("DATABASE :\n\tRennes : 215366 @ (48.1173, -1.6778)", bd.toString());
    }
    @Test
    void toStringManyItem() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        Enregistrement u = new Enregistrement(
                "Compiègne",
                new Coordonnees((float)49.2454, (float)2.4923),
                40199
        );
        bd.ajouter(k);
        bd.ajouter(u);
        assertEquals("DATABASE :\n\tRennes : 215366 @ (48.1173, -1.6778)\n\tCompiègne : 40199 @ (49.2454, 2.4923)", bd.toString());
    }

    // ville
    @Test
    void findCity() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        bd.ajouter(k);
        assertEquals(k, bd.ville("Rennes"));
    }
    @Test
    void findNoneCity() {
        assertNull(bd.ville("Rennes"));
    }
    @Test
    void findMixedCity() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        bd.ajouter(null);
        bd.ajouter(k);
        assertEquals(k, bd.ville("Rennes"));
    }

    // coord
    @Test
    void findCoord() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        bd.ajouter(k);
        assertEquals(k, bd.coord(new Coordonnees((float)48.1173, (float)-1.6778)));
    }
    @Test
    void findNoneCoord() {
        assertNull(bd.coord(new Coordonnees((float)48.1173, (float)-1.6778)));
    }
    @Test
    void findMixedCoord() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        bd.ajouter(null);
        bd.ajouter(k);
        assertEquals(k, bd.coord(new Coordonnees((float)48.1173, (float)-1.6778)));
    }


    // retirerVille
    @Test
    void retirerNoneVille() {
        assertDoesNotThrow(() -> bd.retirerVille("Rennes"));
    }
    @Test
    void retirerManyVilles() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        Enregistrement u = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        bd.ajouter(k);
        bd.ajouter(u);
        bd.retirerVille("Rennes");
        assertFalse(bd.estPresent(u));
        assertFalse(bd.estPresent(k));
    }

    // retirerCoord
    @Test
    void retirerNoneCoords() {
        assertDoesNotThrow(() -> bd.retirerCoord(null));
    }
    @Test
    void retirerManyCoords() {
        Enregistrement k = new Enregistrement(
                "Compiègne",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215326
        );
        Enregistrement u = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        bd.ajouter(k);
        bd.ajouter(u);
        bd.retirerCoord(new Coordonnees((float)48.1173, (float)-1.6778));
        assertFalse(bd.estPresent(u));
        assertFalse(bd.estPresent(k));
    }

    // population
    @Test
    void populationEmpty() {
        assertEquals(0, bd.population());
    }
    @Test
    void populationExact() {
        Enregistrement u = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        bd.ajouter(u);
        assertEquals(u.getPopulation(), bd.population());
    }
    @Test
    void populationManyCities() {
        Enregistrement k = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        Enregistrement u = new Enregistrement(
                "Compiègne",
                new Coordonnees((float)49.2454, (float)2.4923),
                40199
        );
        bd.ajouter(k);
        bd.ajouter(u);
        assertEquals(u.getPopulation() + k.getPopulation(), bd.population());
    }
    @Test
    void populationMixedWithNull() {
        Enregistrement u = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
        bd.ajouter(null);
        bd.ajouter(u);
        bd.ajouter(null);
        assertEquals(u.getPopulation(), bd.population());
    }
}
