package test;

import main.ListeDehorsException;
import main.Liste;
import main.Iterateur;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public abstract class IterateurTest {
    Liste l = null;
    Iterateur it = null;

    @Test
    void isNewOutOfBounds() {
        assertTrue(it.estSorti());
    }

    // Entete
    @Test
    void ElementTete() {
        it.ajouterD(4);
        it.ajouterD(5);
        it.entete();
        assertEquals(4, it.valec());
    }

    @Test
    void EnTeteEmptyOutOfBounds() {
        // An entete leaves us out when empty
        it.entete();
        assertTrue(it.estSorti());
    }

    // Enqueue
    @Test
    void ElementQueue() {
        it.ajouterD(39);
        it.ajouterD(38);
        it.ajouterD(27);
        it.enqueue();
        assertEquals(27, it.valec());
    }

    @Test
    void EnQueueEmptyOutOfBounds() {
        it.enqueue();
        assertTrue(it.estSorti());
    }

    // Succ
    @Test
    void succOnEmptyThrows() {
        assertThrows(ListeDehorsException.class,
                () -> it.succ());
    }
    @Test
    void succAfterElementSucceeds() {
        it.ajouterD(8392);
        assertDoesNotThrow(() -> it.succ());
    }
    @Test
    void succTwiceAfterElementThrows() {
        it.ajouterD(329);
        it.succ();
        assertThrows(ListeDehorsException.class,
                () -> it.succ());
    }

    // Pred
    @Test
    void predOnEmptyThrows() {
        assertThrows(ListeDehorsException.class,
                () -> it.pred());
    }
    @Test
    void predAfterElementSucceeds() {
        it.ajouterD(3829);
        assertDoesNotThrow(() -> it.pred());
    }
    @Test
    void predTwiceAfterElementThrows() {
        it.ajouterG(3289);
        it.pred();
        assertThrows(ListeDehorsException.class,
                () -> it.pred());
    }

    // Ajouter D
    @Test
    void ajouterDNotEmpty() {
        it.ajouterD(37289);
        assertFalse(l.estVide());
    }
    @Test
    void ajouterDNotOutOfBounds() {
        it.ajouterD(37289);
        assertFalse(it.estSorti());
    }
    @Test
    void ajouterDCurrentElement() {
        it.ajouterD(37289);
        assertEquals(37289, it.valec());
    }
    @Test
    void ajouterDInsertion() {
        it.ajouterD(3829);
        it.ajouterD(3822);
        it.pred();
        it.ajouterD(20);
        it.pred();
        assertEquals(3829, it.valec());
    }
    @Test
    void ajouterDAtSameTimeKeepsIndex() {
        Iterateur itd = (Iterateur)l.iterateur();
        it.ajouterD(2910);
        itd.entete();
        itd.ajouterD(83290);
        assertEquals(83290, itd.valec());
        assertEquals(2910, it.valec());
    }
    @Test
    void ajouterDAtSameTimeMakesNonEmpty() {
        Iterateur itd = (Iterateur)l.iterateur();
        it.ajouterD(38);
        // Itd is still out at -1 but list it not empty
        assertThrows(ListeDehorsException.class,
                () -> itd.ajouterD(38));
    }

    // Ajouter G
    @Test
    void ajouterGNotEmpty() {
        it.ajouterG(37289);
        assertFalse(l.estVide());
    }
    @Test
    void ajouterGNotOutOfBounds() {
        it.ajouterG(37289);
        assertFalse(it.estSorti());
    }
    @Test
    void ajouterGCurrentElement() {
        it.ajouterG(37289);
        assertEquals(37289, it.valec());
    }
    @Test
    void ajouterGInsertion() {
        it.ajouterG(3829);
        it.ajouterG(3822);
        it.succ();
        it.ajouterG(20);
        it.succ();
        assertEquals(3829, it.valec());
    }
    /*@Test
    void ajouterGAtSameTimeKeepsIndex() {
        Iterateur itd = (Iterateur)l.iterateur();
        it.ajouterG(2910);
        itd.entete();
        itd.ajouterG(83290);
        // Both are equal because both point to the same item
        // 'it' was never updated
        assertEquals(83290, itd.valec());
        assertEquals(itd.valec(), it.valec());
    }*/
    @Test
    void ajouterGAtSameTimeMakesNonEmpty() {
        Iterateur itd = (Iterateur)l.iterateur();
        it.ajouterG(38);
        // Itd is still out at -1 but list it not empty
        assertThrows(ListeDehorsException.class,
                () -> itd.ajouterG(38));
    }

    // oterec
    @Test
    void oterecOnEmptyThrows() {
        assertThrows(ListeDehorsException.class,
                () -> it.oterec());
    }
    @Test
    void oterecCanMakeEmpty() {
        it.ajouterD(3892);
        assertFalse(l.estVide());
        it.oterec();
        assertTrue(l.estVide());
    }
    @Test
    void oterecMovesCorrectly() {
        it.ajouterD(329);
        it.ajouterD(3892);
        it.ajouterD(3);
        it.entete();
        it.oterec();
        assertEquals(3892, it.valec());
    }
    /*@Test
    void oterecCanLeaveOutOfBounds() {
        Iterateur itd = (Iterateur)l.iterateur();
        it.ajouterD(38920);
        it.ajouterG(3892);
        itd.enqueue();
        it.oterec();
        assertTrue(itd.estSorti());
    }*/
    //Valec
    @Test
    void valecOutOfBoundsThrows() {
        assertThrows(ListeDehorsException.class,
                () -> it.valec());
    }
    //Modifec
    @Test
    void modifecOutOfBoundsThrows() {
        assertThrows(ListeDehorsException.class,
                () -> it.modifec(89));
    }
    @Test
    void modifecWorks() {
        it.ajouterD(3829);
        it.modifec(-3);
        assertEquals(-3, it.valec());
    }
    @Test
    void modifecInOrer() {
        Iterateur itd = (Iterateur)l.iterateur();
        it.ajouterD(902);
        itd.entete();
        itd.modifec(728);
        it.modifec(91);
        itd.modifec(-267);
        it.modifec(90);
        assertEquals(it.valec(), itd.valec());
        assertEquals(90, it.valec());
    }
    // estSorti has been extensively tested
}
