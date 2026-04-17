package main;

public class ListeDoubleChaineeIterateur<T> implements Iterateur<T> {
    private final ListeDoubleChainee<T> l;
    private ListeDoubleChainee.Link<T> cursor;

    public ListeDoubleChaineeIterateur(ListeDoubleChainee<T> lst) {
        this.l = lst;
        this.cursor = l.head;
    }

    public boolean estSorti() {
        return this.cursor.pred == null || this.cursor.succ == null;
    }

    public void entete() {
        this.cursor = this.l.head.succ;
    }

    public void enqueue() {
        this.cursor = this.l.tail.pred;
    }

    public void pred() {
        if (this.estSorti())
            throw new ListeDehorsException("Précédent sur sortie");
        this.cursor = this.cursor.pred;
    }

    public void succ() {
        if (this.estSorti())
            throw new ListeDehorsException("Successeur sur sortie");
        this.cursor = this.cursor.succ;
    }

    public void ajouterD(T o) {
        if (!this.l.estVide() && this.estSorti())
            throw new ListeDehorsException("Ajout droit sorti");

        // If empty, be on head
        if (this.l.estVide())
            this.cursor = this.l.head;
        // Create link
        ListeDoubleChainee.Link<T> nlink = new ListeDoubleChainee.Link<T>();
        nlink.value = o;
        nlink.pred = this.cursor;
        nlink.succ = this.cursor.succ;
        nlink.succ.pred = nlink;
        this.cursor.succ = nlink;
        this.cursor = nlink;
    }

    public void ajouterG(T o) {
        if (!this.l.estVide() && this.estSorti())
            throw new ListeDehorsException("Ajout gauche sorti");

        // If empty, be on tail
        if (this.l.estVide())
            this.cursor = this.l.tail;
        // Create link
        ListeDoubleChainee.Link<T> nlink = new ListeDoubleChainee.Link<T>();
        nlink.value = o;
        nlink.pred = this.cursor.pred;
        nlink.succ = this.cursor;
        nlink.succ.pred = nlink;
        this.cursor.succ = nlink;
        this.cursor = nlink;
    }

    public void oterec() {
        if (this.estSorti())
            throw new ListeDehorsException("Oter sur sortie");

        this.cursor.pred.succ = this.cursor.succ;
        this.cursor.succ.pred = this.cursor.pred;
        this.cursor = this.cursor.succ;
    }

    public void modifec(T o) {
        if (this.estSorti())
            throw new ListeDehorsException("Modification sur sortie");

        this.cursor.value = o;
    }

    public T valec() {
        if (this.estSorti())
            throw new ListeDehorsException("Valeur actuelle sur sortie");
        return this.cursor.value;
    }
}
