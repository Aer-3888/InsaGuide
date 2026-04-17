/**
 * Represents a pine tree (pin) that produces pine cones.
 *
 * <p><strong>Specifications:</strong>
 * <ul>
 *   <li>Price: €500/m³</li>
 *   <li>Minimum cutting age: 5 years</li>
 *   <li>Produces: Cone (pine cones)</li>
 * </ul>
 *
 * <p><strong>Generic Type:</strong> {@code Arbre<Cone>} ensures this tree
 * can only produce pine cones, providing compile-time type safety.
 *
 * @author INSA Rennes - CPOO TP2
 * @version 2.0 (with generics)
 */
public class Pin extends Arbre<Cone> {
    /**
     * Minimum age at which a pine tree can be cut (5 years).
     * Declared as static final constant to avoid magic numbers.
     */
    private static final double AGE_MIN_COUPE = 5;

    /**
     * Creates a new pine tree with the specified age and volume.
     *
     * @param age the initial age of the pine tree in years
     * @param volume the volume of the pine tree in cubic meters
     */
    public Pin(double age, double volume) {
        super(age, volume);
    }

    /**
     * Gets the price per cubic meter for pine wood.
     *
     * @return €500 per cubic meter
     */
    @Override
    protected double getPrixM3() {
        return 500;
    }

    /**
     * Gets the minimum age at which a pine tree can be cut.
     *
     * @return 5 years
     */
    @Override
    public double getAgeMinCoupe() {
        return AGE_MIN_COUPE;
    }

    /**
     * Produces a pine cone from this pine tree.
     *
     * <p><strong>Type Safety:</strong> The return type is Cone (not Fruit),
     * ensuring compile-time type safety. No casting is needed when calling
     * this method on a Pin object.
     *
     * @return a new Cone (pine cone)
     */
    @Override
    public Cone produireFruit() {
        return new Cone();
    }
}
