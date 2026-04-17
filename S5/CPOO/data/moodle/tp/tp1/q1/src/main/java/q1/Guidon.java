package q1;

/**
 * Represents a bicycle handlebar.
 * In this simple association, a Guidon can optionally reference the Velo it belongs to.
 *
 * <p>UML Association: Velo 0..1 <---velo--- 0..1 Guidon
 *
 * @author INSA Rennes - CPOO TP1
 * @version 1.0
 */
public class Guidon {
    /**
     * The bicycle this handlebar is attached to.
     * Can be null if not attached to any bicycle.
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
     *
     * @param vl the Velo to attach this handlebar to, or null to detach
     */
    public void setVelo(Velo vl) {
        this.velo = vl;
    }
}
