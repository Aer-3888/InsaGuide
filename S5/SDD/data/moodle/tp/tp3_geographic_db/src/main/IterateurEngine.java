package main;

import java.util.Iterator;

public class IterateurEngine<T> implements Iterator<T> {
    private Liste<T> data;
    private final Iterateur<T> it;

    public IterateurEngine(Liste<T> dt) {
        this.data = dt;
        this.it = dt.iterateur();
        this.it.entete();
    }

    public boolean hasNext() {
        return !this.it.estSorti();
    }
    public T next() {
        T ret = this.it.valec();
        this.it.succ();
        return ret;
    }
}
