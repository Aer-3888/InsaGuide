package q2;

/**
 * Represents a bicycle handlebar with referential integrity support.
 * This implementation ensures consistency in the bidirectional association with Velo.
 *
 * <p>UML Association: Velo 0..1 <---velo---> 0..1 Guidon (with referential integrity)
 *
 * @author INSA Rennes - CPOO TP1
 * @version 1.0
 */
public class Guidon {
    /**
     * The bicycle this handlebar is attached to.
     */
    private Velo velo = null;

    /**
     * Gets the bicycle this handlebar is attached to.
     *
     * @return the Velo object, or null if not attached to any bicycle
     */
    public Velo getVelo() {
        return this.velo;
    }

    /**
     * Sets the bicycle this handlebar is attached to.
     * Called by Velo.setGuidon() to maintain referential integrity.
     *
     * @param vl the Velo to attach this handlebar to, or null to detach
     */
    public void setVelo(Velo vl) {
        this.velo = vl;
    }
}
