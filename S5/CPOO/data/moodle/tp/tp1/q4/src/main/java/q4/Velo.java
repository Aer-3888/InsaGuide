package q4;

import java.util.ArrayList;
import java.util.List;

/**
 * Represents a bicycle with multiple wheels (one-to-many association).
 * A bicycle can have zero or more wheels, and wheels can be added or removed.
 *
 * <p>UML Association: Velo 0..* ---roues---> Roue (unidirectional)
 *
 * <p><strong>Key Concept:</strong> This implements a one-to-many association using
 * a List collection. Duplicate wheels are prevented using contains() check.
 *
 * @author INSA Rennes - CPOO TP1
 * @version 1.0
 */
public class Velo {
    /**
     * The list of wheels attached to this bicycle.
     * Uses ArrayList to maintain insertion order and allow duplicates checking.
     */
    private List<Roue> roues;

    /**
     * Creates a new bicycle with no wheels.
     */
    public Velo() {
        this.roues = new ArrayList<>();
    }

    /**
     * Gets the list of wheels attached to this bicycle.
     *
     * @return an unmodifiable view would be better, but returning the list directly
     *         for compatibility with tests
     */
    public List<Roue> getRoues() {
        return this.roues;
    }

    /**
     * Adds a wheel to this bicycle.
     * Prevents adding null wheels or duplicate wheels.
     *
     * <p>Example:
     * <pre>
     * Velo bike = new Velo();
     * Roue wheel = new Roue();
     * bike.addRoue(wheel);  // Returns true
     * bike.addRoue(wheel);  // Returns false (duplicate)
     * bike.addRoue(null);   // Returns false (null)
     * </pre>
     *
     * @param r the wheel to add
     * @return true if the wheel was added, false if r is null or already exists
     */
    public Boolean addRoue(Roue r) {
        if (r == null || this.roues.contains(r)) {
            return false;
        }
        return this.roues.add(r);
    }

    /**
     * Removes a wheel from this bicycle.
     *
     * @param r the wheel to remove
     * @return true if the wheel was removed, false if it wasn't in the list
     */
    public Boolean removeRoues(Roue r) {
        return this.roues.remove(r);
    }
}
