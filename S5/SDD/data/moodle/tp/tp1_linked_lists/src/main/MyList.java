package main;

public interface MyList<T> {
    // Set cursor on head
    public void entete();
    // Go to next
    public void succ();
    // Go to previous
    public void pred();
    // Add item right
    public void ajouterD(T o);
    // Remove current item
    public void oterec();
    // Current item value
    public T valec();
    // Is the cursour out?
    public boolean estSorti();
    // Is the list empty?
    public boolean estVide();
}
// Note that any time there's an exception, it inherits from RuntimeException so no need to say the method throws