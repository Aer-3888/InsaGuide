package main;

public interface Iterateur<T> {
    // Set cursor on head
    public void entete();
    // Set cursor on tail
    public void enqueue();
    // Go to next
    public void succ();
    // Go to previous
    public void pred();
    // Add item right
    public void ajouterD(T o);
    // Add item left
    public void ajouterG(T o);
    // Remove current item
    public void oterec();
    // Current item value
    public T valec();
    // Modify current item
    public void modifec(T o);
    // Is the cursour out?
    public boolean estSorti();
}
// Note that any time there's an exception, it inherits from RuntimeException so no need to say the method throws
