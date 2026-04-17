package cpoo1.cours;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class LineTest {
    Line line;

    @BeforeEach
    void setup() {
        line = new Line(1, 2, 3, 4);
    }

    @AfterEach
    void tearDown() {
        // ...
    }

    @Test
    void testA() {
        assertEquals(1, line.getA(), 0.001);
    }

    @Test
    void testB() {
        assertEquals(1, line.getB(), 0.001);
    }
}
