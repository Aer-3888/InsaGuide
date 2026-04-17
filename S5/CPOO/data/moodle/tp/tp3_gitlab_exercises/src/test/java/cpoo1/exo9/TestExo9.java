package cpoo1.exo9;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class TestExo9 {
    Exo9 exo9;

    @BeforeEach
    void setUp() {
        exo9 = new Exo9();
    }

    @Test
    void testIsEmpty() {
        assertTrue(exo9.estVide());
    }

    @Test
    void testAjouterElement() {
        exo9.ajouterElement("foo");
    }

    @Test
    void testContient() {
        exo9.ajouterElement("bar");
        assertTrue(exo9.contient("bar"));
    }
}
