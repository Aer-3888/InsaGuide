package q3;

/**
 * Represents a bicycle with a required handlebar (unidirectional association).
 * Unlike Q1 and Q2, the Guidon class no longer has access to its parent Velo.
 *
 * <p>UML Association: Velo 1 ---guidon---> Guidon (unidirectional only)
 *
 * <p><strong>Key Change:</strong> The association is now strictly unidirectional.
 * The Guidon class has no reference back to the Velo, simplifying the design
 * but removing the ability for a handlebar to know which bicycle it belongs to.
 *
 * @author INSA Rennes - CPOO TP1
 * @version 1.0
 */
public class Velo {
    /**
     * The handlebar attached to this bicycle.
     * Required - a bicycle must have a handlebar.
     */
    private Guidon guidon;

    /**
     * Default constructor creating a bicycle without a handlebar.
     * Note: setGuidon() must be called before the bicycle can be used.
     */
    public Velo() {
        // Empty constructor
    }

    /**
     * Creates a bicycle with the specified handlebar.
     *
     * @param gd the Guidon to attach to this bicycle
     * @throws IllegalArgumentException if the guidon is null
     */
    public Velo(Guidon gd) {
        if (gd == null) {
            throw new IllegalArgumentException("Guidon cannot be null");
        }
        this.guidon = gd;
    }

    /**
     * Gets the handlebar attached to this bicycle.
     *
     * @return the Guidon object
     */
    public Guidon getGuidon() {
        return this.guidon;
    }

    /**
     * Sets the handlebar for this bicycle.
     * Null values are rejected to enforce the multiplicity constraint (1).
     *
     * @param gd the Guidon to attach to this bicycle
     * @throws IllegalArgumentException implicitly rejected if null (no-op)
     */
    public void setGuidon(Guidon gd) {
        if (gd != null) {
            this.guidon = gd;
        }
    }
}
