package q2;

/**
 * Represents a bicycle with referential integrity for handlebar association.
 * This implementation ensures that when a handlebar is set on a bicycle,
 * the handlebar automatically references the bicycle (bidirectional consistency).
 *
 * <p>UML Association: Velo 0..1 <---velo---> 0..1 Guidon (with referential integrity)
 *
 * <p><strong>Key Concept:</strong> When setGuidon() is called, it automatically calls
 * setVelo() on the Guidon to maintain referential integrity. This also handles
 * removing the old handlebar's reference if one existed.
 *
 * @author INSA Rennes - CPOO TP1
 * @version 1.0
 */
public class Velo {
    /**
     * The handlebar attached to this bicycle.
     */
    private Guidon guidon = null;

    /**
     * Gets the handlebar attached to this bicycle.
     *
     * @return the Guidon object, or null if no handlebar is attached
     */
    public Guidon getGuidon() {
        return this.guidon;
    }

    /**
     * Sets the handlebar for this bicycle while maintaining referential integrity.
     *
     * <p>This method ensures bidirectional consistency:
     * <ol>
     *   <li>If the old handlebar exists, it is notified that it no longer belongs to this bicycle</li>
     *   <li>The new handlebar is attached</li>
     *   <li>The new handlebar is notified that it now belongs to this bicycle</li>
     * </ol>
     *
     * <p>Example:
     * <pre>
     * Velo bike = new Velo();
     * Guidon handlebar = new Guidon();
     * bike.setGuidon(handlebar); // handlebar.getVelo() now returns bike
     * </pre>
     *
     * @param gd the Guidon to attach to this bicycle, or null to remove the handlebar
     */
    public void setGuidon(Guidon gd) {
        // Avoid infinite recursion and unnecessary work
        if (gd != this.guidon) {
            // Store old guidon for cleanup
            Guidon oldGuidon = this.guidon;

            // If removing the handlebar, notify the old one
            if (gd == null && oldGuidon != null) {
                oldGuidon.setVelo(null);
            }

            // Set the new handlebar
            this.guidon = gd;

            // If adding a new handlebar, establish bidirectional link
            if (gd != null) {
                gd.setVelo(this);
            }
        }
    }
}
