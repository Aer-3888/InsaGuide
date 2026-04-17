/**
 * Abstract base class representing an animal that eats a specific type of fruit.
 * Uses generics to ensure type-safe feeding: each animal species can only eat
 * its preferred fruit type.
 *
 * <p><strong>Generic Type Parameter:</strong>
 * <ul>
 *   <li>{@code <F extends Fruit>} - The type of fruit this animal eats</li>
 *   <li>Ensures compile-time type safety for feeding</li>
 *   <li>Example: {@code Cochon extends Animal<Gland>} means pigs eat only acorns</li>
 * </ul>
 *
 * <p><strong>Design Pattern:</strong> Strategy Pattern with Generics
 * <ul>
 *   <li>Each animal has a specific eating strategy</li>
 *   <li>Type parameter prevents feeding wrong fruit types</li>
 *   <li>Compile-time safety instead of runtime checks</li>
 * </ul>
 *
 * @param <F> the type of fruit this animal eats, must extend Fruit
 * @author INSA Rennes - CPOO TP2
 * @version 1.0
 */
public abstract class Animal<F extends Fruit> {
    /**
     * Feeds this animal with a fruit of the appropriate type.
     *
     * <p><strong>Type Safety:</strong> The generic parameter ensures that:
     * <ul>
     *   <li>Pigs (Cochon) can only be fed Gland (acorns)</li>
     *   <li>Squirrels (Ecureuil) can only be fed Cone (pine cones)</li>
     *   <li>Attempting to feed the wrong fruit type causes a compile error</li>
     * </ul>
     *
     * <p>Example:
     * <pre>
     * Cochon pig = new Cochon();
     * Gland acorn = new Gland();
     * pig.manger(acorn);      // OK - type-safe
     *
     * Cone cone = new Cone();
     * pig.manger(cone);       // Compile error - type mismatch!
     * </pre>
     *
     * @param fruit the fruit to feed to this animal
     */
    public abstract void manger(F fruit);
}
