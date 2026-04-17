package point;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.util.Random;

import static org.junit.jupiter.api.Assertions.*;

public class TestMyPoint {
    // Testing the getter and setter of X
    MyPoint mp;
    @BeforeEach
    void buildPoint() {
        mp = new MyPoint();
    }

    @Test
    void testGetSetX() {
        mp.setX(4.0);
        assertEquals(4.0, mp.getX(),1e-4);
    }

    @Test
    void testGetSetY() {
        mp.setY(4.0);
        assertEquals(4.0, mp.getY(), 1e-4);
    }

    @Test
    void testConstructeurDefaut() {
        assertEquals(0, mp.getX());
        assertEquals(0, mp.getX());
    }

    @Test
    void testConstructeurSpecifique() {
        mp = new MyPoint(192.168, 42.1);
        assertEquals(192.168, mp.getX(), 1e-6);
        assertEquals(42.1, mp.getY(), 1e-6);
    }

    @Test
    void testConstructeurCopie() {
        mp = new MyPoint(new MyPoint(192.168, 42.1));
        assertEquals(192.168, mp.getX(), 1e-6);
        assertEquals(42.1, mp.getY(), 1e-6);
    }

    @Test
    void testScale() {
        mp = new MyPoint(192.168, 42.1);
        // Disgusting
        mp = mp.scale(1000.0);
        assertEquals(192168.0, mp.getX(), 1e-6);
        assertEquals(42100.0, mp.getY(), 1e-6);
    }

    @Test
    void testScaleByZero() {
        mp = new MyPoint(192.168, 42.1);
        mp = mp.scale(0);
        assertEquals(0.0, mp.getX(), 1e-6);
        assertEquals(0.0, mp.getY(), 1e-6);
    }

    @Test
    void testHorizontalSymmetry() {
        mp = new MyPoint(128.0, 17.0);
        mp = mp.horizontalSymmetry(new MyPoint(100.0,100.0));
        assertEquals(72.0, mp.getX(), 1e-6);
        assertEquals(17.0, mp.getY(), 1e-6);
    }

    @Test
    void testBrokenHorizontalSymmetry() {
        assertThrows(IllegalArgumentException.class, () -> mp.horizontalSymmetry(null));
    }

    @Test
    void testTranslation() {
        mp = new MyPoint(192.168, 42.1);
        mp.translate(100.2, -40.2);
        assertEquals(292.368, mp.getX(), 1e-6);
        assertEquals(1.9, mp.getY(), 1e-6);
    }

    @Test
    void testRandomPointSetHasInt() {
        // The coordinates are not integers
        mp = new MyPoint(192.168, 42.1);
        // But setPoint uses nextInt
        mp.setPoint(new Random(), new Random());
        // So if it went well, the coordinates are now integers as doubles
        assertEquals((int) mp.getX(), mp.getX(), 1e-6);
        assertEquals((int) mp.getY(), mp.getY(), 1e-6);
    }

    @Test
    void testSetPointRandom() {
        Random random = Mockito.mock(Random.class);

        Mockito.when(random.nextInt()).thenReturn(892, 190);

        mp.setPoint(random, random);
        assertEquals(892, mp.getX(), 1e-6);
        assertEquals(190, mp.getY(), 1e-6);
    }

    @Test
    void testITranslation() {
        ITranslation it = Mockito.mock(ITranslation.class);
        Mockito.when(it.getTx()).thenReturn(29);
        Mockito.when(it.getTy()).thenReturn(863);
        mp.translate(it);
        assertEquals(29, mp.getX(), 1e-6);
        assertEquals(863, mp.getY(), 1e-6);

    }

    @Test
    void testNullITranslation() {
        assertThrows(IllegalArgumentException.class, () -> mp.translate((ITranslation)null));
    }
}

