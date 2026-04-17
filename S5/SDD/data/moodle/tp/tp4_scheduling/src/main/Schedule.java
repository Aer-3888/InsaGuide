package main;

import java.time.DayOfWeek;

public class Schedule {
    private final DayOfWeek dow;
    private final int start_hour;

    public Schedule(DayOfWeek dow, int start_hour) {
        this.dow = dow;
        this.start_hour = start_hour;
    }

    public DayOfWeek getDow() {
        return dow;
    }

    public int getStart_hour() {
        return start_hour;
    }

    @Override
    public String toString() {
        return this.dow + "@" + this.start_hour + "h";
    }

    @Override
    public boolean equals(Object o) {
        // If we have the same object we're done
        if (this == o)
            return true;
        // If it's null it can't be us
        if (o == null)
            return false;
        // If it's not a Schedule it can't be us
        if (this.getClass() != o.getClass())
            return false;

        Schedule sch = (Schedule) o;

        // Check equality
        return this.dow.equals(sch.dow) && this.start_hour == sch.start_hour;
    }

    @Override
    public int hashCode() {
        return this.dow.hashCode() * 31 + this.start_hour;
    }
}
