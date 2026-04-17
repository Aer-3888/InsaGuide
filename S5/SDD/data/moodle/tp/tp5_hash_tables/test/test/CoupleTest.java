package test;

import main.Word;
import main.Couple;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class CoupleTest {
    Couple cp;

    @Test
    public void initWithNullWords() {
        assertThrows(IllegalArgumentException.class, () -> cp = new Couple(null, null));
        assertThrows(IllegalArgumentException.class, () -> cp = new Couple(new Word("mustard"), null));
        assertThrows(IllegalArgumentException.class, () -> cp = new Couple(null, new Word("mustard")));
    }

    @Test
    public void initWithValueOK() {
        assertDoesNotThrow(() -> cp = new Couple(new Word("m"), new Word("ustard")));
    }

    @Test
    public void toStringOK() {
        cp = new Couple(new Word("ordinateur"), new Word("computer"));
        assertEquals("(\"ordinateur\", \"computer\")", cp.toString());
    }

    @Test
    public void translationOverNull() {
        cp = new Couple(new Word("ordinateur"), new Word("computer"));
        assertNull(cp.compCoupleMot(null));
    }

    @Test
    public void translationWrong() {
        cp = new Couple(new Word("ordinateur"), new Word("computer"));
        assertNull(cp.compCoupleMot(new Word("moutarde")));
    }

    @Test
    public void translationOK() {
        cp = new Couple(new Word("ordinateur"), new Word("computer"));
        assertEquals(new Word("computer"), cp.compCoupleMot(new Word("ordinateur")));
    }
}
