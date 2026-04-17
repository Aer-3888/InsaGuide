/**
 * Represents a pine tree (pin) in the forest.
 *
 * <p><strong>Specifications:</strong>
 * <ul>
 *   <li>Price: €500/m³</li>
 *   <li>Minimum cutting age: 5 years</li>
 * </ul>
 *
 * @author INSA Rennes - CPOO TP2
 * @version 1.0
 */
public class Pin extends Arbre {
    /**
     * Creates a new pine tree with the specified age and volume.
     * Sets the price to €500/m³ and minimum cutting age to 5 years.
     *
     * @param age the initial age of the pine tree in years
     * @param volume the volume of the pine tree in cubic meters
     */
    public Pin(double age, double volume) {
        super(age, volume);
        this.prix = 500;  // €500 per cubic meter
        this.age_coupe = 5;  // Must be at least 5 years old to cut
    }
}
