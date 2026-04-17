package main;

public class ListeTabuleeIterateur<T> implements Iterateur<T> {
    private final ListeTabulee<T> l;
    private int index = -1;

    public ListeTabuleeIterateur(ListeTabulee<T> lst) {
        this.l = lst;
    }

    public void entete() {
        this.index = 0;
    }

    public void enqueue() {
        this.index = this.l.occupation-1;
    }
    public void succ() {
        // Check that we're not out of bounds
        if (this.estSorti())
            throw new ListeDehorsException("Suivant depuis la fin");
        this.index++;
    }

    public void pred() {
        // Check that we're not out of bounds
        if (this.estSorti())
            throw new ListeDehorsException("Précédent de la tête");
        this.index--;
    }
    public void ajouterD(Object o) {
        if (!this.l.estVide() && this.estSorti())
            throw new ListeDehorsException();
        // Check if we're not already at the max level
        if (this.l.occupation >= ListeTabulee.TMAX)
            throw new DebordementException("Impossible d'ajouter");

        // Move everything up
        for (int tmpcursor = this.l.occupation;
            tmpcursor-1 > this.index; tmpcursor--)
            this.l.internal_tab[tmpcursor] = this.l.internal_tab[tmpcursor-1];

        // Insert and stay on it
        this.index++;
        this.l.internal_tab[this.index] = o;
        this.l.occupation++;
    }

    public void ajouterG(T o) {
        if (!this.l.estVide() && this.estSorti())
            throw new ListeDehorsException();
        // Check if we're not already at the max level
        if (this.l.occupation >= ListeTabulee.TMAX)
            throw new DebordementException("Impossible d'ajouter");
        // Move everything including the current item up
        if (this.index < 0)
            this.index = 0;
        for (int tmpcursor = this.l.occupation;
            tmpcursor > this.index; tmpcursor--)
            this.l.internal_tab[tmpcursor] = this.l.internal_tab[tmpcursor-1];

            // Insert on current element since it's been copied on the right
        this.l.internal_tab[this.index] = o;
        this.l.occupation++;
    }

    public void oterec() {
        if (this.estSorti())
            throw new ListeDehorsException("Oter sur sortie??");
        for (int tmpcursor = this.index;
            tmpcursor < this.l.occupation-1; tmpcursor++)
            this.l.internal_tab[tmpcursor] = this.l.internal_tab[tmpcursor+1];
        this.l.occupation--;
    }

    public T valec() {
        if (this.estSorti())
            throw new ListeDehorsException("Courant sur sortie");
        return (T)this.l.internal_tab[this.index];
    }

    public void modifec(T o) {
        if (this.estSorti())
            throw new ListeDehorsException("Remplacement sur sortie");
        this.l.internal_tab[this.index] = o;
    }

    public boolean estSorti() {
        return this.index < 0 || this.index >= this.l.occupation;
    }
}
