package test;

import main.Schedule;
import main.TimeTable;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.time.DayOfWeek;

public class TimeTableTest {
    TimeTable tt;
    @BeforeEach
    void setup() {
        ArrayList<String> teachers = new ArrayList<>();
        teachers.add("M. Patard");
        this.tt = new TimeTable(teachers);
    }

    @Test
    void constructorThrowsInvalidTeachers() {
        assertThrows(IllegalArgumentException.class,
                () -> tt = new TimeTable(null));
        assertThrows(IllegalArgumentException.class,
                () -> tt = new TimeTable(new ArrayList<>()));
    }

    @Test
    void addCourseThrowsInvalidTeachers() {
        assertThrows(IllegalArgumentException.class,
                () -> tt.addCourse(null, DayOfWeek.MONDAY, 8, "SDD"));
        assertThrows(IllegalArgumentException.class,
                () -> tt.addCourse("", DayOfWeek.MONDAY, 8, "SDD"));
    }

    @Test
    void addCourseValidatesExistingTeacher() {
        assertDoesNotThrow(() -> tt.addCourse("M. Patard", DayOfWeek.MONDAY, 8, "SDD"));
    }

    @Test
    void addCourseValidatesNewTeacher() {
        assertDoesNotThrow(() -> tt.addCourse("M. Laurent", DayOfWeek.MONDAY, 8, "SDD"));
    }

    @Test
    void addCourseThrowsInvalidDow() {
        // DOW is null
        assertThrows(IllegalArgumentException.class,
                () -> tt.addCourse("M. Patard", null, 8, "SDD"));
    }

    @Test
    void addCourseThrowsInvalidStartHour() {
        // StartHour is not odd
        assertThrows(IllegalArgumentException.class,
                () -> tt.addCourse("M. Patard", DayOfWeek.MONDAY,
                        7, "SDD"));
        // StartHour is below 0
        assertThrows(IllegalArgumentException.class,
                () -> tt.addCourse("M. Patard", DayOfWeek.MONDAY,
                        -8, "SDD"));
        // StartHour is above 22
        assertThrows(IllegalArgumentException.class,
                () -> tt.addCourse("M. Patard", DayOfWeek.MONDAY,
                        24, "SDD"));
    }

    @Test
    void addCourseThrowsInvalidCourseName() {
        // Course name is null
        assertThrows(IllegalArgumentException.class,
                () -> tt.addCourse("M. Patard", DayOfWeek.MONDAY,
                        8, null));
    }

    @Test
    void teacherNotBusyAtFirst() {
        assertTrue(tt.addCourse("M. Patard", DayOfWeek.WEDNESDAY, 10, "SDD"));
    }

    @Test
    void addCourseReturnsFalseIfBusy() {
        // Add one course, the teacher isn't busy
        tt.addCourse("M. Patard", DayOfWeek.THURSDAY, 10, "SDD");
        // Add another one, this time he is
        assertFalse(tt.addCourse("M. Patard", DayOfWeek.THURSDAY, 10, "CPOO"));
    }

    @Test
    void getTimeTableThrowsInvalidTeacher() {
        // Teacher is null
        assertThrows(IllegalArgumentException.class,
                () -> tt.getTimeTable(null));
        // Teacher is empty
        assertThrows(IllegalArgumentException.class,
                () -> tt.getTimeTable(""));
    }

    @Test
    void getTimeTableIsNullForUnknownTeacher() {
        assertNull(tt.getTimeTable("M. Laurent"));
    }

    @Test
    void getTimeTableIsMap() {
        assertEquals(HashMap.class,
                tt.getTimeTable("M. Patard").getClass());
    }

    @Test
    void getTimeTableIsEmptyAtLaunch() {
        assertTrue(tt.getTimeTable("M. Patard").isEmpty());
    }

    @Test
    void thereIsNoClassAtTenAMOnMonday() {
        assertEquals(0, tt.classesAtTenAMOnMonday());
    }

    @Test
    void thereAreTwoClassesAtTenOnMonday() {
        tt.addCourse("M. Patard", DayOfWeek.MONDAY, 10, "SDD");
        tt.addCourse("M. Patard", DayOfWeek.MONDAY, 10, "SDD");
        tt.addCourse("M. Patard", DayOfWeek.FRIDAY, 10, "SDD");
        tt.addCourse("M. Laurent", DayOfWeek.MONDAY, 10, "SDD");
        assertEquals(2, tt.classesAtTenAMOnMonday());
    }

    @Test
    void thereAreNoClassesOnMonday() {
        tt.addCourse("M. Patard", DayOfWeek.SATURDAY, 16, "SVT");
        assertEquals(0, tt.classesOnMonday());
    }

    @Test
    void thereAreTwoClassesOnMonday() {
        tt.addCourse("M. Patard", DayOfWeek.MONDAY, 10, "SDD");
        tt.addCourse("M. Patard", DayOfWeek.MONDAY, 10, "SDD");
        tt.addCourse("M. Patard", DayOfWeek.FRIDAY, 10, "SDD");
        tt.addCourse("M. Laurent", DayOfWeek.MONDAY, 10, "SDD");
        assertEquals(2, tt.classesOnMonday());
    }

    @Test
    void theEarliestBirdWithTie() {
        tt.addCourse("M. Patard", DayOfWeek.THURSDAY, 16, "SDD");
        tt.addCourse("M. Laurent", DayOfWeek.FRIDAY, 8, "Prolog");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 8, "CLP");
        assertEquals("M. Laurent", tt.earlyBirdTeacher());
    }

    @Test
    void theMostVersatileWithTie() {
        tt.addCourse("M. Patard", DayOfWeek.THURSDAY, 16, "SDD");
        tt.addCourse("M. Laurent", DayOfWeek.FRIDAY, 8, "Prolog");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 8, "CLP");
        tt.addCourse("M. Patard", DayOfWeek.WEDNESDAY, 12, "SDD");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 14, "FUS");
        assertEquals("Mme. Martin", tt.versatileTeacher());
    }

    @Test
    void reshapingTimeTableNotNull() {
        tt.addCourse("M. Patard", DayOfWeek.THURSDAY, 16, "SDD");
        tt.addCourse("M. Laurent", DayOfWeek.FRIDAY, 8, "Prolog");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 10, "CLP");
        tt.addCourse("M. Patard", DayOfWeek.FRIDAY, 8, "SDD");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 14, "FUS");
        // Get the table
        Map<Schedule, Map<String, String>> res = tt.buildReverseTable();
        // It is not null
        assertNotNull(res);
    }

    @Test
    void reshapingTimeTableHashRightEntryCount() {
        tt.addCourse("M. Patard", DayOfWeek.THURSDAY, 16, "SDD");
        tt.addCourse("M. Laurent", DayOfWeek.FRIDAY, 8, "Prolog");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 10, "CLP");
        tt.addCourse("M. Patard", DayOfWeek.FRIDAY, 8, "SDD");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 14, "FUS");
        // Get the table
        Map<Schedule, Map<String, String>> res = tt.buildReverseTable();
        // It is not null
        assertEquals(4, res.keySet().size());
    }

    @Test
    void reshapingTimeTableHashRightValues() {
        tt.addCourse("M. Patard", DayOfWeek.THURSDAY, 16, "SDD");
        tt.addCourse("M. Laurent", DayOfWeek.FRIDAY, 8, "Prolog");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 10, "CLP");
        tt.addCourse("M. Patard", DayOfWeek.FRIDAY, 8, "SDD");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 14, "FUS");
        // Get the table
        Map<Schedule, Map<String, String>> res = tt.buildReverseTable();
        Map<String,String> compar = new HashMap<>();
        // Assert all four entries
        compar.put("M. Patard", "SDD");
        assertEquals(compar, res.get(new Schedule(DayOfWeek.THURSDAY, 16)));
        compar.put("M. Laurent", "Prolog");
        assertEquals(compar, res.get(new Schedule(DayOfWeek.FRIDAY, 8)));
        compar.clear();
        compar.put("Mme. Martin", "CLP");
        assertEquals(compar, res.get(new Schedule(DayOfWeek.TUESDAY, 10)));
        compar.clear();
        compar.put("Mme. Martin", "FUS");
        assertEquals(compar, res.get(new Schedule(DayOfWeek.TUESDAY, 14)));
    }

    @Test
    void minimalClassRoomsCanReturnZero() {
        assertEquals(0, tt.minimalNumberOfClassRooms());
    }

    @Test
    void minimalClassRoomsWithOverlap() {
        tt.addCourse("M. Patard", DayOfWeek.THURSDAY, 16, "SDD");
        tt.addCourse("M. Laurent", DayOfWeek.FRIDAY, 8, "Prolog");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 10, "CLP");
        tt.addCourse("M. Patard", DayOfWeek.FRIDAY, 8, "SDD");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 14, "FUS");
        assertEquals(2, tt.minimalNumberOfClassRooms());
    }

    @Test
    void minimalClassRoomsWithNoOverlap() {
        tt.addCourse("M. Patard", DayOfWeek.THURSDAY, 16, "SDD");
        tt.addCourse("M. Laurent", DayOfWeek.FRIDAY, 10, "Prolog");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 10, "CLP");
        tt.addCourse("M. Patard", DayOfWeek.FRIDAY, 8, "SDD");
        tt.addCourse("Mme. Martin", DayOfWeek.TUESDAY, 14, "FUS");
        assertEquals(1, tt.minimalNumberOfClassRooms());
    }
}
