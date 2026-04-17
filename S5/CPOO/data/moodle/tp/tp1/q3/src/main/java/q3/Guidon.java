package q3;

/**
 * Represents a simple bicycle handlebar with no reference to its parent bicycle.
 * This is a pure component in a unidirectional association.
 *
 * <p>UML Association: Velo ---guidon---> Guidon (no back reference)
 *
 * <p><strong>Design Note:</strong> Unlike Q1 and Q2, this Guidon has no knowledge
 * of which Velo it belongs to. This simplifies the design but loses bidirectional
 * navigation capability.
 *
 * @author INSA Rennes - CPOO TP1
 * @version 1.0
 */
public class Guidon {
    /**
     * Default constructor for a handlebar.
     */
    public Guidon() {
        // Empty constructor
    }
}
