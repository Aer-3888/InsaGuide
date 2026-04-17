/**
 * Abstract base class representing a tree that produces fruits.
 * This generic version uses type parameters to ensure type-safe fruit production.
 *
 * <p><strong>Generic Type Parameter:</strong>
 * <ul>
 *   <li>{@code <F extends Fruit>} - The type of fruit this tree produces</li>
 *   <li>Ensures compile-time type safety for fruit production</li>
 *   <li>Example: {@code Chene extends Arbre<Gland>} means oak trees produce acorns</li>
 * </ul>
 *
 * <p><strong>Design Pattern:</strong> Template Method with Generics
 * <ul>
 *   <li>Abstract methods define what subclasses must implement</li>
 *   <li>Concrete methods provide common behavior</li>
 *   <li>Generics ensure type safety across the hierarchy</li>
 * </ul>
 *
 * @param <F> the type of fruit produced by this tree, must extend Fruit
 * @author INSA Rennes - CPOO TP2
 * @version 2.0 (with generics)
 */
public abstract class Arbre<F extends Fruit> {
    /**
     * Age of the tree in years.
     */
    protected double age;

    /**
     * Volume of the tree in cubic meters (m³).
     */
    protected double volume;

    /**
     * Creates a new tree with the specified age and volume.
     *
     * @param age the initial age of the tree in years
     * @param volume the volume of the tree in cubic meters
     */
    public Arbre(double age, double volume) {
        this.age = age;
        this.volume = volume;
    }

    /**
     * Gets the age of the tree.
     *
     * @return the age in years
     */
    public double getAge() {
        return this.age;
    }

    /**
     * Gets the volume of the tree.
     *
     * @return the volume in cubic meters
     */
    public double getVolume() {
        return this.volume;
    }

    /**
     * Gets the price per cubic meter for this tree species.
     * Must be implemented by concrete subclasses.
     *
     * @return the price per m³ in euros
     */
    protected abstract double getPrixM3();

    /**
     * Ages the tree by one year.
     * This method simulates the passage of time in the forest.
     */
    public void vieillir() {
        this.age++;
    }

    /**
     * Calculates the total price of the tree.
     * The price is calculated as: price_per_m³ × volume
     *
     * @return the total price in euros
     */
    public double getPrix() {
        return this.volume * this.getPrixM3();
    }

    /**
     * Gets the minimum age at which this tree species can be cut.
     * Must be implemented by concrete subclasses.
     *
     * @return the minimum cutting age in years
     */
    public abstract double getAgeMinCoupe();

    /**
     * Checks if the tree is old enough to be cut.
     *
     * @return true if the tree's age is greater than or equal to the minimum cutting age
     */
    public boolean peutEtreCoupe() {
        return this.age >= this.getAgeMinCoupe();
    }

    /**
     * Produces a fruit from this tree.
     * The type of fruit is determined by the generic type parameter F.
     *
     * <p><strong>Type Safety:</strong> The compiler ensures that:
     * <ul>
     *   <li>Oak trees (Chene) can only produce Gland (acorns)</li>
     *   <li>Pine trees (Pin) can only produce Cone (pine cones)</li>
     *   <li>No runtime type casting is needed</li>
     * </ul>
     *
     * <p>Example:
     * <pre>
     * Chene oak = new Chene(15, 2.5);
     * Gland acorn = oak.produireFruit();  // Type-safe, no casting needed
     * </pre>
     *
     * @return a fruit of type F
     */
    public abstract F produireFruit();
}
