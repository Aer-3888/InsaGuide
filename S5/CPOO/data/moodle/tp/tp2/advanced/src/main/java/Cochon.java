/**
 * Represents a pig (cochon) that lives in the forest and eats acorns.
 *
 * <p><strong>Diet:</strong> Pigs eat acorns (Gland) produced by oak trees.
 *
 * <p><strong>Generic Type:</strong> {@code Animal<Gland>} ensures this animal
 * can only be fed acorns, providing compile-time type safety.
 *
 * <p>Example usage:
 * <pre>
 * Cochon pig = new Cochon();
 * Chene oak = new Chene(15, 2.5);
 * Gland acorn = oak.produireFruit();
 * pig.manger(acorn);  // Type-safe feeding
 * </pre>
 *
 * @author INSA Rennes - CPOO TP2
 * @version 1.0
 */
public class Cochon extends Animal<Gland> {
    /**
     * Feeds this pig with an acorn.
     *
     * @param gland the acorn to eat
     */
    @Override
    public void manger(Gland gland) {
        // Pig eats the acorn
        // Implementation could track consumption, energy gained, etc.
    }
}
