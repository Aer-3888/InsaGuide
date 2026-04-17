/**
 * Represents a squirrel (écureuil) that lives in the forest and eats pine cones.
 *
 * <p><strong>Diet:</strong> Squirrels eat pine cones (Cone) produced by pine trees.
 *
 * <p><strong>Generic Type:</strong> {@code Animal<Cone>} ensures this animal
 * can only be fed pine cones, providing compile-time type safety.
 *
 * <p>Example usage:
 * <pre>
 * Ecureuil squirrel = new Ecureuil();
 * Pin pine = new Pin(8, 1.5);
 * Cone pineCone = pine.produireFruit();
 * squirrel.manger(pineCone);  // Type-safe feeding
 * </pre>
 *
 * @author INSA Rennes - CPOO TP2
 * @version 1.0
 */
public class Ecureuil extends Animal<Cone> {
    /**
     * Feeds this squirrel with a pine cone.
     *
     * @param cone the pine cone to eat
     */
    @Override
    public void manger(Cone cone) {
        // Squirrel eats the pine cone
        // Implementation could track consumption, energy gained, etc.
    }
}
