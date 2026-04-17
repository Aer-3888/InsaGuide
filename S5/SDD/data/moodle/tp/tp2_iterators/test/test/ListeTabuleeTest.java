package test;

import main.ListeTabulee;
import main.ListeTabuleeIterateur;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;

import static org.junit.jupiter.api.Assertions.*;

public class ListeTabuleeTest extends ListeTest {
    @BeforeEach
    void setup() {
        this.l = new ListeTabulee<Integer>();
        this.it = l.iterateur();
    }

    @Test
    public void returnsIterateur() {
        assertEquals(ListeTabuleeIterateur.class, it.getClass());
    }
}
