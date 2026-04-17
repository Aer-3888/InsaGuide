/**
 * Abstract base class representing a tree in a forest management system.
 * This class provides common attributes and behaviors for all types of trees.
 *
 * <p>A tree has an age, volume, price per cubic meter, and minimum cutting age.
 * Concrete subclasses must define specific values for price and cutting age.
 *
 * <p><strong>Design Pattern:</strong> Template Method - defines the skeleton
 * of operations while letting subclasses provide specific values.
 *
 * @author INSA Rennes - CPOO TP2
 * @version 1.0
 */
public abstract class Arbre {
    /**
     * Price per cubic meter (€/m³).
     * Set by concrete subclasses (Oak: 1000, Pine: 500).
     */
    protected int prix;

    /**
     * Age of the tree in years.
     */
    protected double age;

    /**
     * Volume of the tree in cubic meters (m³).
     */
    protected double volume;

    /**
     * Minimum age at which the tree can be cut.
     * Set by concrete subclasses (Oak: 10, Pine: 5).
     */
    protected double age_coupe;

    /**
     * Creates a new tree with the specified age and volume.
     *
     * @param age the initial age of the tree in years
     * @param volume the volume of the tree in cubic meters
     */
    public Arbre(double age, double volume) {
        this.age = age;
        this.volume = volume;
        this.prix = 0;  // Default value, overridden by subclasses
    }

    /**
     * Ages the tree by one year.
     * This method simulates the passage of time in the forest.
     */
    public void vieillir() {
        this.age++;
    }

    /**
     * Gets the age of the tree.
     *
     * @return the age in years
     */
    public double getAge() {
        return age;
    }

    /**
     * Gets the volume of the tree.
     *
     * @return the volume in cubic meters
     */
    public double getVolume() {
        return volume;
    }

    /**
     * Calculates the total price of the tree.
     * The price is calculated as: price_per_m³ × volume
     *
     * @return the total price in euros
     */
    public double getPrix() {
        return prix * volume;
    }

    /**
     * Checks if the tree is old enough to be cut.
     *
     * @return true if the tree's age is greater than or equal to the minimum cutting age
     */
    public boolean peutEtreCoupe() {
        return age >= age_coupe;
    }
}
