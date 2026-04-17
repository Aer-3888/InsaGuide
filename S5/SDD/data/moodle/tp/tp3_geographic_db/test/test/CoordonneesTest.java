package test;

import main.Coordonnees;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class CoordonneesTest {
    Coordonnees cd;

    @BeforeEach
    void setup() {
        this.cd = new Coordonnees((float)-36.9, (float)2.10);
    }

    @Test
    void getLatitude() {
        assertEquals(-36.9, this.cd.getLatitude(), 1e-4);
    }

    @Test
    void getLongitude() {
        assertEquals(2.10, this.cd.getLongitude(), 1e-4);
    }
}
