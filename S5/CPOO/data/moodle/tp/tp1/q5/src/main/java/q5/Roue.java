package q5;

/**
 * Represents a bicycle wheel in a composition relationship with Velo.
 * This implementation maintains bidirectional referential integrity,
 * ensuring a wheel always knows which bicycle it belongs to.
 *
 * <p>UML Association: Velo 0..1 <---velo---> 0..* Roue (composition)
 *
 * <p><strong>Key Concept:</strong> When setVelo() is called:
 * <ul>
 *   <li>If the wheel belonged to another bike, it is removed from that bike first</li>
 *   <li>The wheel is then associated with the new bike</li>
 *   <li>The new bike is notified to add this wheel to its collection</li>
 * </ul>
 *
 * @author INSA Rennes - CPOO TP1
 * @version 1.0
 */
public class Roue {
    /**
     * The bicycle this wheel is attached to.
     * Can be null if the wheel is not attached to any bicycle.
     */
    private Velo velo = null;

    /**
     * Gets the bicycle this wheel is attached to.
     *
     * @return the Velo object, or null if not attached to any bicycle
     */
    public Velo getVelo() {
        return this.velo;
    }

    /**
     * Sets the bicycle this wheel is attached to while maintaining referential integrity.
     *
     * <p>This method ensures bidirectional consistency:
     * <ol>
     *   <li>If already attached to this bike, do nothing (avoid infinite recursion)</li>
     *   <li>If attached to a different bike, remove from that bike first</li>
     *   <li>Set the new bicycle reference</li>
     *   <li>If the new bike is not null, add this wheel to the bike's collection</li>
     * </ol>
     *
     * <p><strong>Referential Integrity:</strong> This method works in conjunction with
     * Velo.addRoue() and Velo.removeRoues() to maintain consistency. The checks prevent
     * infinite recursion when both sides try to update each other.
     *
     * <p>Example:
     * <pre>
     * Roue wheel = new Roue();
     * Velo bike1 = new Velo();
     * Velo bike2 = new Velo();
     *
     * wheel.setVelo(bike1);  // wheel added to bike1
     * wheel.setVelo(bike2);  // wheel removed from bike1, added to bike2
     * wheel.setVelo(null);   // wheel removed from bike2
     * </pre>
     *
     * @param vl the Velo to attach this wheel to, or null to detach from current bicycle
     */
    public void setVelo(Velo vl) {
        // Avoid infinite recursion - if already set to this bike, do nothing
        if (this.velo == vl) {
            return;
        }

        // If currently attached to a different bike, remove from that bike first
        if (this.velo != null) {
            Velo oldVelo = this.velo;
            this.velo = null;  // Clear reference before calling remove to avoid recursion
            oldVelo.removeRoues(this);
        }

        // Set new bicycle reference
        this.velo = vl;

        // If attaching to a new bike, add to that bike's collection
        if (vl != null && !vl.getRoues().contains(this)) {
            vl.addRoue(this);
        }
    }
}
