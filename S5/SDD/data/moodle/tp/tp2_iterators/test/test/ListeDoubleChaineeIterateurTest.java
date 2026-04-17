package test;

import main.ListeDehorsException;
import main.ListeDoubleChainee;
import main.ListeDoubleChaineeIterateur;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ListeDoubleChaineeIterateurTest extends IterateurTest {
    @BeforeEach
    void setup() {
        this.l = new ListeDoubleChainee<Integer>();
        this.it = l.iterateur();
    }

}
