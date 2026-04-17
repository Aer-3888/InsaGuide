package test;

import main.ListeDoubleChainage;
//import main.MyListOutOfBoundsException;
import main.MyListOutOfBoundsException;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ListeDoubleChainageTest {
    ListeDoubleChainage ml;
    @BeforeEach
    void setup() {
        ml = new ListeDoubleChainage();
    }

    @Test
    void isNewEmpty() {
        assertTrue(ml.estVide());
    }

    @Test
    void isAddedNonEmpty() {
        ml.ajouterD(4);
        assertFalse(ml.estVide());
    }

    @Test
    void oterecMovesToNext() {
        ml.ajouterD(4);
        ml.ajouterD(5);
        ml.entete();
        ml.oterec();
        assertEquals(5, ml.valec());
    }

    @Test
    void removedActuallyGone() {
        ml.ajouterD(4);
        ml.ajouterD(5);
        ml.ajouterD(6);
        // Move in the middle
        ml.entete();
        ml.succ();
        // Remove 5
        ml.oterec();
        // Go backwards
        ml.pred();

        assertEquals(4, ml.valec());
    }

    @Test
    void successorOfPredecessorIsSame() {
        ml.ajouterD(4);
        ml.ajouterD(78);
        ml.entete();
        // Pred and succ
        ml.succ();
        ml.pred();
        assertEquals(4, ml.valec());
    }

    @Test
    void predecessorOfSuccessorIsSame() {
        ml.ajouterD(3);
        ml.ajouterD(4);
        ml.ajouterD(78);
        ml.entete();
        ml.succ();
        // Succ and pred
        ml.pred();
        ml.succ();
        assertEquals(4, ml.valec());
    }

    @Test
    void succFromEnqueueOutOfBounds() {
        ml.ajouterD(4);
        ml.enqueue();
        ml.succ();
        assertTrue(ml.estSorti());
    }

    @Test
    void predFromEnteteOutOfBounds() {
        ml.ajouterD(4);
        ml.entete();
        ml.pred();
        assertTrue(ml.estSorti());
    }

    @Test
    void NewListOutofBounds() {
        assertTrue(ml.estSorti());
    }

    @Test
    void entetePutsOnItem() {
        ml.ajouterD(4);
        ml.entete();
        assertFalse(ml.estSorti());
    }

    @Test
    void enqueuePutsOnItem() {
        ml.ajouterD(4);
        ml.enqueue();
        assertFalse(ml.estSorti());
    }

    @Test
    void addingDoesPutOutofBounds() {
        ml.ajouterD(4);
        assertFalse(ml.estSorti());
    }

    @Test
    void cursorMovesToNew() {
        ml.ajouterD(78);
        assertEquals(78, ml.valec());
    }

    @Test
    void cursorPredMovesToNewPred() {
        ml.ajouterD(8);
        ml.ajouterD(78);
        ml.pred();
        assertEquals(8, ml.valec());
    }

    @Test
    void valecThrowsOnOut() {
        assertTrue(ml.estSorti());
        assertThrows(MyListOutOfBoundsException.class, () -> ml.valec());
    }

    @Test
    void predOnOutOfBounds() {
        assertTrue(ml.estSorti());
        assertThrows(MyListOutOfBoundsException.class, () -> ml.pred());
    }

    @Test
    void succOnOutOfBounds() {
        assertTrue(ml.estSorti());
        assertThrows(MyListOutOfBoundsException.class, () -> ml.succ());
    }

    @Test
    void preOnOterRecOutOfBounds() {
        assertTrue(ml.estSorti());
        assertThrows(MyListOutOfBoundsException.class, () -> ml.oterec());
    }

    @Test
    void preAjoutD() {
        // Trying to add to nonempty out of bounds
        ml.ajouterD(4);
        assertFalse(ml.estVide());
        ml.enqueue();
        ml.succ(); // We're now out of bounds
        assertTrue(ml.estSorti());
        assertThrows(MyListOutOfBoundsException.class, () -> ml.ajouterD(78));
    }
}
