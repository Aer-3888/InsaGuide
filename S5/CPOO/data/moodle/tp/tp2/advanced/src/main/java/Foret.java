import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

/**
 * Represents a forest containing multiple trees.
 * Manages both standing trees and trees that have been cut.
 *
 * <p>This class demonstrates the use of collections, polymorphism,
 * and proper iteration techniques to avoid ConcurrentModificationException.
 *
 * @author INSA Rennes - CPOO TP2
 * @version 1.0
 */
public class Foret {
    /**
     * List of trees currently standing in the forest.
     */
    private List<Arbre> arbres;

    /**
     * List of trees that have been cut from the forest.
     */
    private List<Arbre> arbres_coupes;

    /**
     * Creates a new empty forest.
     * Initializes both the standing trees and cut trees lists.
     */
    public Foret() {
        this.arbres = new ArrayList<>();
        this.arbres_coupes = new ArrayList<>();
    }

    /**
     * Gets the list of standing trees in the forest.
     *
     * @return the list of Arbre objects currently in the forest
     */
    public List<Arbre> getArbres() {
        return arbres;
    }

    /**
     * Gets the list of trees that have been cut.
     *
     * @return the list of cut Arbre objects
     */
    public List<Arbre> getArbres_coupes() {
        return arbres_coupes;
    }

    /**
     * Plants a new tree in the forest.
     *
     * @param arbre the tree to add to the forest
     */
    public void planterArbre(Arbre arbre) {
        this.arbres.add(arbre);
    }

    /**
     * Attempts to cut a tree from the forest.
     * Finds the first tree that is old enough to be cut, moves it to the
     * cut trees list, and removes it from the standing trees.
     *
     * <p><strong>Implementation Note:</strong> Uses Iterator to safely remove
     * elements while iterating, avoiding ConcurrentModificationException.
     *
     * <p>Example of the problem:
     * <pre>
     * // WRONG: ConcurrentModificationException
     * for (Arbre arbre : arbres) {
     *     if (arbre.peutEtreCoupe()) {
     *         arbres.remove(arbre);  // Modifying list during iteration!
     *     }
     * }
     * </pre>
     *
     * @return true if a tree was cut, false if no tree is ready to be cut
     */
    public boolean couperArbre() {
        // Use Iterator for safe removal during iteration
        Iterator<Arbre> iterator = arbres.iterator();
        while (iterator.hasNext()) {
            Arbre arbre = iterator.next();
            if (arbre.peutEtreCoupe()) {
                // Move to cut trees list
                this.arbres_coupes.add(arbre);
                // Safe removal using iterator
                iterator.remove();
                return true;
            }
        }
        return false;
    }

    /**
     * Counts the number of oak trees (Chene) in the forest.
     * Demonstrates the use of the instanceof operator for runtime type checking.
     *
     * @return the number of oak trees currently standing in the forest
     */
    public int getNombreChenes() {
        int nombreChenes = 0;
        for (Arbre arbre : arbres) {
            if (arbre instanceof Chene) {
                nombreChenes++;
            }
        }
        return nombreChenes;
    }

    /**
     * Calculates the total value of all standing trees in the forest.
     * This is the sum of the individual prices of each tree.
     *
     * @return the total price of all standing trees in euros
     */
    public double getPrixTotal() {
        double prix = 0;
        for (Arbre arbre : arbres) {
            prix += arbre.getPrix();
        }
        return prix;
    }
}
