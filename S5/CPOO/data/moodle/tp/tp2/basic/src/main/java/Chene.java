/**
 * Represents an oak tree (chêne) in the forest.
 *
 * <p><strong>Specifications:</strong>
 * <ul>
 *   <li>Price: €1000/m³</li>
 *   <li>Minimum cutting age: 10 years</li>
 * </ul>
 *
 * @author INSA Rennes - CPOO TP2
 * @version 1.0
 */
public class Chene extends Arbre {
    /**
     * Creates a new oak tree with the specified age and volume.
     * Sets the price to €1000/m³ and minimum cutting age to 10 years.
     *
     * @param age the initial age of the oak tree in years
     * @param volume the volume of the oak tree in cubic meters
     */
    public Chene(double age, double volume) {
        super(age, volume);
        this.prix = 1000;  // €1000 per cubic meter
        this.age_coupe = 10;  // Must be at least 10 years old to cut
    }
}
