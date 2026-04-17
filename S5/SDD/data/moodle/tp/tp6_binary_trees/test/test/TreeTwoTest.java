package test;

import main.TreeTwo;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class TreeTwoTest {
    TreeTwo tr;
    @BeforeEach
    public void setup() {
        tr = new TreeTwo("+");

        TreeTwo droit = new TreeTwo("/");
        droit.modifArbreD(new TreeTwo(2));
        droit.modifArbreG(new TreeTwo(5));
        tr.modifArbreD(droit);

        TreeTwo gauche = new TreeTwo("*");
        gauche.modifArbreD(new TreeTwo("pi"));
        gauche.modifArbreG(new TreeTwo(4));
        tr.modifArbreG(gauche);
    }

    @Test
    public void testToString() {
        assertEquals("4 pi * 5 2 / +", tr.toString());
    }
    @Test
    public void toStringOnNull() {
        tr.modifRacine("");
        tr.modifArbreD(null);
        tr.modifArbreG(null);
        assertEquals("", tr.toString());
        tr.modifRacine(null);
        assertEquals("", tr.toString());
    }

    // Hauteur
    @Test
    public void hauteurCorrect() {
        assertEquals(2, tr.hauteur());
    }
    @Test
    public void hauteurShallow() {
        tr.modifArbreD(null);
        tr.modifArbreG(null);
        assertEquals(0, tr.hauteur());
    }
    @Test
    public void hauteurOnNull() {
        tr = new TreeTwo(null);
        assertThrows(RuntimeException.class,
                () -> tr.hauteur());
    }

    // Dénombrer
    @Test
    public void denombrerThrows() {
        assertThrows(IllegalArgumentException.class,
                () -> tr.denombrer(null));
    }
    @Test
    public void denombrerCorrect() {
        assertEquals(1, tr.denombrer("/"));
        assertEquals(0, tr.denombrer("e"));
    }
    @Test
    public void denombrerOnNull() {
        tr.modifRacine(null);
        tr.modifArbreD((TreeTwo)null);
        tr.modifArbreG((TreeTwo)null);
        assertEquals(0, tr.denombrer("5"));
    }

    // Remplacer
    @Test
    public void remplacerCorrect() {
        tr.remplacer("4", "2");
        assertEquals(2, tr.denombrer("2"));
    }
    @Test
    public void remplacerThrows() {
        assertThrows(IllegalArgumentException.class,
                () -> tr.remplacer(null, "2"));
        assertThrows(IllegalArgumentException.class,
                () -> tr.remplacer("8", null));
        assertThrows(IllegalArgumentException.class,
                () -> tr.remplacer(null, null));
    }
}
