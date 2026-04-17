package main;

public interface Liste<T> {
    // Empty the list
    public void vider();
    // Is the list empty?
    public boolean estVide();
    // Get an iterator
    Iterateur<T> iterateur();
}
