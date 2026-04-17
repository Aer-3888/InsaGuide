package test;

import main.Schedule;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import java.time.DayOfWeek;

//import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;

public class ScheduleTest {
    Schedule sch;
    @BeforeEach
    void setup() {
        this.sch = new Schedule(DayOfWeek.MONDAY, 2);
    }

    @Test
    void initialize() {
        assertDoesNotThrow(() -> sch = new Schedule(DayOfWeek.MONDAY, 2));
    }

    @Test
    void getDow() {
        assertEquals(DayOfWeek.MONDAY, sch.getDow());
    }

    @Test
    void getStartHour() {
        assertEquals(2, sch.getStart_hour());
    }

    @Test
    void stringFormat() {
        assertEquals("MONDAY@2h", sch.toString());
    }

    @Test
    void equalsOnSame() {
        assertEquals(sch, sch);
    }

    @Test
    void equalsOnNull() {
        assertNotEquals(sch, null);
    }

    @Test
    void equalsOnWrongClass() {
        assertNotEquals(sch, "Moop");
    }

    @Test
    void equalsOnDifferentInstance() {
        assertEquals(sch, new Schedule(DayOfWeek.MONDAY, 2));
    }

    @Test
    void equalsOnDifferentInstanceButFalseDow() {
        assertNotEquals(sch, new Schedule(DayOfWeek.SUNDAY, 2));
    }

    @Test
    void equalsOnDifferentInstanceButFalseStartHour() {
        assertNotEquals(sch, new Schedule(DayOfWeek.MONDAY, 3));
    }

    @Test
    void equalsOnDifferentInstanceButFalseStartHourAndDow() {
        assertNotEquals(sch, new Schedule(DayOfWeek.TUESDAY, 8));
    }

    @Test
    void hashCodeEquality() {
        assertEquals(sch.hashCode(), new Schedule(DayOfWeek.MONDAY, 2).hashCode());
    }

    @Test
    void hashCodeNonEquality() {
        assertNotEquals(sch.hashCode(), new Schedule(DayOfWeek.TUESDAY, 6).hashCode());
    }
}
