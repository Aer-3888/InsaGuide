package test;

import main.ListeDoubleChainee;
import main.ListeDoubleChaineeIterateur;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;

import static org.junit.jupiter.api.Assertions.*;

public class ListeDoubleChaineeTest extends ListeTest {
    @BeforeEach
    void setup() {
        this.l = new ListeDoubleChainee<Integer>();
        this.it = l.iterateur();
    }

    @Test
    public void returnsIterateur() {
        assertEquals(ListeDoubleChaineeIterateur.class, it.getClass());
    }
}
