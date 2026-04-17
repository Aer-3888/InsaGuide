package q5;

import java.util.ArrayList;
import java.util.List;

/**
 * Represents a bicycle with composition relationship to wheels.
 * This implementation maintains bidirectional referential integrity between
 * the bicycle and its wheels.
 *
 * <p>UML Association: Velo 0..1 <---velo---> 0..* Roue (composition with referential integrity)
 *
 * <p><strong>Key Concept:</strong> This is a composition relationship where:
 * <ul>
 *   <li>A Roue can belong to at most one Velo</li>
 *   <li>When a Roue is added to a Velo, it automatically references the Velo</li>
 *   <li>When a Roue is removed, its reference to the Velo is cleared</li>
 *   <li>Referential integrity is maintained at all times</li>
 * </ul>
 *
 * @author INSA Rennes - CPOO TP1
 * @version 1.0
 */
public class Velo {
    /**
     * The list of wheels attached to this bicycle.
     * Each wheel maintains a reference back to this bicycle.
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
     * @return the list of Roue objects
     */
    public List<Roue> getRoues() {
        return this.roues;
    }

    /**
     * Adds a wheel to this bicycle while maintaining referential integrity.
     *
     * <p>This method ensures bidirectional consistency:
     * <ol>
     *   <li>Validates the wheel is not null and not already attached</li>
     *   <li>Adds the wheel to this bicycle's collection</li>
     *   <li>Calls wheel.setVelo(this) to establish the back-reference</li>
     * </ol>
     *
     * <p>Note: This method is designed to work with Roue.setVelo() to avoid
     * infinite recursion. When called from Roue.setVelo(), the wheel is already
     * in the correct state.
     *
     * <p>Example:
     * <pre>
     * Velo bike = new Velo();
     * Roue wheel = new Roue();
     * bike.addRoue(wheel);      // wheel.getVelo() now returns bike
     * bike.addRoue(wheel);      // Returns false (already added)
     * </pre>
     *
     * @param r the wheel to add
     * @return true if the wheel was added, false if r is null or already attached
     */
    public Boolean addRoue(Roue r) {
        if (r == null || this.roues.contains(r)) {
            return false;
        }

        // Add wheel to collection
        this.roues.add(r);

        // Establish bidirectional link (if not already set)
        // The check in Roue.setVelo prevents infinite recursion
        if (r.getVelo() != this) {
            r.setVelo(this);
        }

        return true;
    }

    /**
     * Removes a wheel from this bicycle while maintaining referential integrity.
     *
     * <p>This method ensures bidirectional consistency:
     * <ol>
     *   <li>Validates the wheel is not null</li>
     *   <li>If the wheel is attached to this bicycle, removes it from the collection</li>
     *   <li>Calls wheel.setVelo(null) to clear the back-reference</li>
     * </ol>
     *
     * <p>Example:
     * <pre>
     * bike.removeRoues(wheel);  // wheel.getVelo() now returns null
     * </pre>
     *
     * @param r the wheel to remove
     * @return true if the wheel was removed, false if it wasn't attached or is null
     */
    public Boolean removeRoues(Roue r) {
        if (r == null) {
            return false;
        }

        // Check if wheel is actually attached to this bike
        if (this.roues.contains(r)) {
            // Clear bidirectional link (if still set to this bike)
            if (r.getVelo() == this) {
                r.setVelo(null);
            }

            // Remove wheel from collection
            this.roues.remove(r);
            return true;
        }

        return false;
    }
}
