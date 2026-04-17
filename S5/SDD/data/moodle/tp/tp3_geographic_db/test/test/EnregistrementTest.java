package test;

import main.Coordonnees;
import main.Enregistrement;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

public class EnregistrementTest {
    Enregistrement rn;
    @BeforeEach
    void setup() {
        this.rn = new Enregistrement(
                "Rennes",
                new Coordonnees((float)48.1173, (float)-1.6778),
                215366
        );
    }

    @Test
    void getCityName() {
        assertEquals("Rennes", this.rn.getCityName());
    }

    @Test
    void getPopulation() {
        assertEquals(215366, this.rn.getPopulation());
    }

}
