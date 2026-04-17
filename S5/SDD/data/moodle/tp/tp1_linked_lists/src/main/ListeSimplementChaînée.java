package main;

public class ListeSimplementChaînée extends MyList {
    private Maillon tete;

    private static class Maillon {
        Object val;
        Maillon s;
    }

    public void entete() {
        //...
    }
    // Go to next
    public void succ() {
        //...
    }
    // Go to previous
    public void pred() {
        //...
    }
    // Add item right
    public void ajouterD(T o) {
        //...
    }
    // Remove current item
    public void oterec() {
        //...
    }
    // Current item value
    public T valec() {
        //...
    }
    // Is the cursour out?
    public boolean estSorti() {
        //...
    }
    // Is the list empty?
    public boolean estVide() {
        //...
    }
}
