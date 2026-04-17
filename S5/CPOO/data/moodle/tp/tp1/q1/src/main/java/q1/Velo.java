package q1;

/**
 * Represents a bicycle with an optional handlebar.
 * This is a simple unidirectional association where a Velo can reference a Guidon.
 *
 * <p>UML Association: Velo 0..1 ---guidon---> 0..1 Guidon
 *
 * @author INSA Rennes - CPOO TP1
 * @version 1.0
 */
public class Velo {
    /**
     * The handlebar attached to this bicycle.
     * Can be null if no handlebar is attached.
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
     * Sets the handlebar for this bicycle.
     *
     * @param gd the Guidon to attach to this bicycle, or null to remove the handlebar
     */
    public void setGuidon(Guidon gd) {
        this.guidon = gd;
    }
}
