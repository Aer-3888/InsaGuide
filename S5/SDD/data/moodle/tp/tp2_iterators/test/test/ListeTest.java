package test;

import main.Liste;
import main.Iterateur;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;

import static org.junit.jupiter.api.Assertions.*;

public abstract class ListeTest {
    Liste l = null;
    Iterateur it = null;

    // Constructor
    @Test
    public void isNewEmpty() {
        assertTrue(l.estVide());
    }

    @Test
    public void isEmptiedEmpty() {
        it.ajouterD(54);
        it.ajouterD(2738);
        l.vider();
        assertTrue(l.estVide());
    }

    @Test
    public void emptyingEmpty() {
        assertDoesNotThrow(() -> l.vider());
    }

    @Test
    abstract void returnsIterateur();
}
