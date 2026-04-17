package main;

public class ListeTabulee<T> implements Liste<T> {
    // it's a list but it's ugly because it has a table
    static final int TMAX = 1000;
    protected Object internal_tab[];
    protected int occupation = 0;

    public ListeTabulee() {
        internal_tab = new Object[ListeTabulee.TMAX];
    }
    public void vider() {
        // Security
        while (this.occupation > 0) {
            this.internal_tab[this.occupation-1] = null;
            this.occupation--;
        }
    }

    public boolean estVide() {
        return this.occupation == 0;
    }

    public Iterateur<T> iterateur() {
        return new ListeTabuleeIterateur<T>(this);
    }
}
