package main;

public class ListeDoubleChainee<T> implements Liste<T> {
    protected static class Link<T> {
        T value = null;
        Link pred = null;
        Link succ = null;
        public String toString() {
            return "<" + (this.pred == null) + " | " + value + "|" + (this.succ == null) + ">";
        }
    }

    protected Link head = null;
    protected Link tail = null;

    public ListeDoubleChainee() {
        this.head = new Link<T>();
        this.tail = new Link<T>();
        this.vider();
    }

    public void vider() {
        // Empty list by linking the ends
        this.head.succ = this.tail;
        this.tail.pred = this.head;
    }

    public boolean estVide() {
        return this.head.succ == this.tail && this.tail.pred == this.head;
    }

    public Iterateur<T> iterateur() {
        return new ListeDoubleChaineeIterateur<T>(this);
    }
}
