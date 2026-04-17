package test;

import main.Word;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class WordTest {
    private Word w;

    @Test
    public void initWithNull() {
        assertThrows(IllegalArgumentException.class, () -> w = new Word(null));
    }

    @Test
    public void initWithEmpty() {
        assertThrows(IllegalArgumentException.class, () -> w = new Word(""));
    }

    @Test
    public void initWithLowercaseValue() {
        assertDoesNotThrow(() -> w = new Word("mustard"));
    }

    @Test
    public void initWithUppercaseValue() {
        assertDoesNotThrow(() -> w = new Word("Mustard"));
    }

    @Test
    public void equalsWorksOnBothLowercase() {
        assertEquals(new Word("mustard"), new Word("mustard"));
    }

    @Test
    public void equalsWorksOnLowerAndUpperCase() {
        assertEquals(new Word("mustard"), new Word("MuStArD"));
        assertEquals(new Word("MuStArD"), new Word("mUsTaRd"));
    }

    @Test
    public void equalsOnNull() {
        assertNotEquals(new Word("mustard"), null);
    }

    @Test
    public void equalsOnRandomBullshit() {
        assertNotEquals(new Word("mustard"),"");
    }

    @Test
    public void hashCodeOnLong() {
        w = new Word("mustard");
        assertEquals('m' * 26 + 'u', w.hashCode());
    }

    @Test
    public void hashCodeSimpleChar() {
        w = new Word("m");
        assertEquals('m' * 26, w.hashCode());
    }

    @Test
    public void toStringWorks() {
        assertEquals("mustard", (new Word("Mustard")).toString());
    }
}
