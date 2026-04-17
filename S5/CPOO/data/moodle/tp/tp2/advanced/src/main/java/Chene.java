/**
 * Represents an oak tree (chêne) that produces acorns.
 *
 * <p><strong>Specifications:</strong>
 * <ul>
 *   <li>Price: €1000/m³</li>
 *   <li>Minimum cutting age: 10 years</li>
 *   <li>Produces: Gland (acorns)</li>
 * </ul>
 *
 * <p><strong>Generic Type:</strong> {@code Arbre<Gland>} ensures this tree
 * can only produce acorns, providing compile-time type safety.
 *
 * @author INSA Rennes - CPOO TP2
 * @version 2.0 (with generics)
 */
public class Chene extends Arbre<Gland> {
    /**
     * Minimum age at which an oak tree can be cut (10 years).
     * Declared as static final constant to avoid magic numbers.
     */
    private static final double AGE_MIN_COUPE = 10;

    /**
     * Creates a new oak tree with the specified age and volume.
     *
     * @param age the initial age of the oak tree in years
     * @param volume the volume of the oak tree in cubic meters
     */
    public Chene(double age, double volume) {
        super(age, volume);
    }

    /**
     * Gets the price per cubic meter for oak wood.
     *
     * @return €1000 per cubic meter
     */
    @Override
    protected double getPrixM3() {
        return 1000;
    }

    /**
     * Gets the minimum age at which an oak tree can be cut.
     *
     * @return 10 years
     */
    @Override
    public double getAgeMinCoupe() {
        return AGE_MIN_COUPE;
    }

    /**
     * Produces an acorn from this oak tree.
     *
     * <p><strong>Type Safety:</strong> The return type is Gland (not Fruit),
     * ensuring compile-time type safety. No casting is needed when calling
     * this method on a Chene object.
     *
     * @return a new Gland (acorn)
     */
    @Override
    public Gland produireFruit() {
        return new Gland();
    }
}
