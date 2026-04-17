package main;

import java.util.*;
import java.time.DayOfWeek;

public class TimeTable {
    // Map a teacher's name with the mapping of their classes
    private final Map<String, Map<Schedule, String>> data;

    public TimeTable(List<String> teachers) throws IllegalArgumentException {
        // Don't try and mess with us
        if (teachers == null || teachers.isEmpty())
            throw new IllegalArgumentException();

        this.data = new HashMap<>();
        for (String teacher : teachers)
            this.data.put(teacher, new HashMap<>());
    }

    public boolean addCourse(String teacher, DayOfWeek dow, int start_hour, String courseName) throws IllegalArgumentException {
        // Assert teacher
        if (teacher == null || teacher.equals(""))
            throw new IllegalArgumentException("Invalid empty or null teacher name");
        // Assert dow, we won't check that it's an actual day of the week because fuck it
        if (dow == null)
            throw new IllegalArgumentException("Invalid null day of the week");
        // Assert starting hour
        if (start_hour % 2 != 0 || start_hour < 0 || start_hour > 22)
            throw new IllegalArgumentException("Invalid out of bounds or non-even starting hour");
        // Assert course name
        if (courseName == null) // A course can be empty if you want
            throw new IllegalArgumentException("Invalid null course name");

        // Do we know the teacher?
        if (!this.data.containsKey(teacher))
            // If we don't, well, we'll always be adding new stuff
            this.data.put(teacher, new HashMap<>());
            // For the sake of brevity I'll let the following line add though

        // Is the teacher free?
        return this.data.get(teacher).putIfAbsent(new Schedule(dow, start_hour), courseName) == null;
    }

    public Map<Schedule, String> getTimeTable(String teacher) throws IllegalArgumentException {
        // Assert teacher
        if (teacher == null || teacher.equals(""))
            throw new IllegalArgumentException("Invalid null teacher");
        return this.data.get(teacher);
    }

    public int classesAtTenAMOnMonday() {
        int res = 0;
        for (Map<Schedule, String> sch : this.data.values()) {
            res += sch.containsKey(new Schedule(DayOfWeek.MONDAY, 10)) ? 1 : 0;
        }
        return res;
    }

    public int classesOnMonday() {
        int res = 0;
        for (Map<Schedule, String> sch : this.data.values()) {
            for (Schedule key : sch.keySet()) {
                res += key.getDow() == DayOfWeek.MONDAY ? 1 : 0;
            }
        }
        return res;
    }

    public String earlyBirdTeacher() {
        HashMap<String, Integer> teachers = new HashMap<>();
        // Count early classes
        for (String teacher : this.data.keySet()) {
            for (Schedule key : this.data.get(teacher).keySet()) {
                if (key.getStart_hour() < 12) {
                    teachers.putIfAbsent(teacher, teachers.getOrDefault(teacher, 0)+1);
                }
            }
        }

        // Find the earliest of birds
        String tch = "";
        int max_early_class = 0;
        for (Map.Entry<String,Integer> e : teachers.entrySet()){
            if (e.getValue() > max_early_class) {
                tch = e.getKey();
                max_early_class = e.getValue();
            }
        }

        return tch;
    }

    public String versatileTeacher() {
        HashMap<String, Integer> teachers = new HashMap<>();
        // Count early classes
        for (String teacher : this.data.keySet()) {
            Set<String> classes = new HashSet<>(this.data.get(teacher).values());
            teachers.put(teacher, classes.size());
        }

        // Find the most versatile teacher
        String tch = "";
        int max_early_class = 0;
        for (Map.Entry<String,Integer> e : teachers.entrySet()){
            if (e.getValue() > max_early_class) {
                tch = e.getKey();
                max_early_class = e.getValue();
            }
        }

        return tch;
    }

    public Map<Schedule, Map<String, String>> buildReverseTable() {
        Map<Schedule, Map<String, String>> result = new HashMap<>();
        for (String teacher : this.data.keySet()) {
            // Get their classes and reshape
            for (Map.Entry<Schedule, String> entry : this.data.get(teacher).entrySet()) {
                // If the hashmap for a given schedule does not already exist
                // Add it
                result.putIfAbsent(entry.getKey(), new HashMap<>());

                // Then add to it the combo (teacher, class_name)
                result.get(entry.getKey()).put(teacher, entry.getValue());
            }
        }
        return result;
    }

    public int minimalNumberOfClassRooms() {
        Map<Schedule, Map<String, String>> res = this.buildReverseTable();
        // The maximum amount of classrooms needed is the maximum
        // In size for all schedule entries
        int maxrooms = 0;
        for (Map<String, String> classes : res.values())
            maxrooms = Math.max(maxrooms, classes.size());
        return maxrooms;
    }
}

