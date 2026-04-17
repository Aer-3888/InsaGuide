package test;

import main.ListeDehorsException;
import main.ListeTabulee;
import main.ListeTabuleeIterateur;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class ListeTabuleeIterateurTest extends IterateurTest {
    @BeforeEach
    void setup() {
        this.l = new ListeTabulee<Integer>();
        this.it = (ListeTabuleeIterateur)l.iterateur();
    }
}
