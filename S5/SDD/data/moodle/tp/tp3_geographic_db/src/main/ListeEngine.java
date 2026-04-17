package main;

import java.util.Collection;
import java.util.List;
import java.util.Iterator;
import java.util.ListIterator;
import java.util.ArrayList;

public class ListeEngine<T> implements List<T> {
    private final Liste<T> lst;

    public ListeEngine(Liste<T> ls) {
        this.lst = ls;
    }

    public Iterator<T> iterator() {
        return new IterateurEngine<>(this.lst);
    }

    public int size() {
        int ret = 0;
        for (Object k : this) {
            ret++;
        }
        return ret;
    }

    public boolean isEmpty() {
        return this.lst.estVide();
    }

    public boolean contains(Object o) {
        for (Object u : this) {
            if (o == u)
                return true;
        }
        return false;
    }

    public Object[] toArray() {
        int size = this.size();
        int prog = 0;
        Object[] rs = new Object[size];
        for (Object u : this) {
            rs[prog] = u;
            prog++;
        }

        return rs;
    }

    public<T1> T1[] toArray(T1[] a) {
        throw new java.lang.UnsupportedOperationException();
    }

    @Override
    public boolean add(T e) {
        Iterateur<T> it = this.lst.iterateur();
        it.enqueue();
        it.ajouterD(e);
        return true;
    }

    @Override
    public boolean remove(Object o) {
        Iterateur<T> it = this.lst.iterateur();
        it.entete();
        while(!it.estSorti()) {
            if (it.valec() == o) {
                it.oterec();
                return true;
            } else {
                it.succ();
            }
        }
        return false;
    }

    @Override
    public boolean containsAll(Collection<?> collection) {
        for (Object u : collection) {
            if (!this.contains(u))
                return false;
        }
        return true;
    }

    @Override
    public boolean addAll(Collection<? extends T> collection) {
        Iterateur<T> it = this.lst.iterateur();
        it.enqueue();
        for (T u : collection)
            it.ajouterD(u);
        return true;
    }

    @Override
    public boolean addAll(int i, Collection<? extends T> collection) {
        throw new java.lang.UnsupportedOperationException();
    }

    @Override
    public boolean removeAll(Collection<?> collection) {
        boolean dada = false;
        for (Object u : collection)
            dada = this.remove(u) || dada;
        return dada;
    }

    @Override
    public boolean retainAll(Collection<?> collection) {
        throw new java.lang.UnsupportedOperationException();
    }

    @Override
    public void clear() {
        this.lst.vider();
    }

    @Override
    public T get(int i) {
        Iterateur<T> it = this.lst.iterateur();
        for ( ; i > 0; i--) {
            try {
                it.succ();
            } catch (ListeDehorsException e) {
                throw new java.lang.ArrayIndexOutOfBoundsException();
            }
        }
        return it.valec();
    }

    @Override
    public T set(int i, T t) {
        Iterateur<T> it = this.lst.iterateur();
        for ( ; i > 0; i--) {
            try {
                it.succ();
            } catch (ListeDehorsException e) {
                throw new java.lang.ArrayIndexOutOfBoundsException();
            }
        }
        T u = it.valec();
        it.modifec(t);
        return u;
    }

    @Override
    public void add(int i, T t) {
        Iterateur<T> it = this.lst.iterateur();
        for ( ; i > 0; i--) {
            try {
                it.succ();
            } catch (ListeDehorsException e) {
                throw new java.lang.ArrayIndexOutOfBoundsException();
            }
        }
        it.ajouterG(t);
    }

    @Override
    public T remove(int i) {
        Iterateur<T> it = this.lst.iterateur();
        for ( ; i > 0; i--) {
            try {
                it.succ();
            } catch (ListeDehorsException e) {
                throw new java.lang.ArrayIndexOutOfBoundsException();
            }
        }
        T u = it.valec();
        it.oterec();
        return u;
    }

    @Override
    public int indexOf(Object o) {
        Iterateur<T> it = this.lst.iterateur();
        it.entete();
        int index = 0;
        while (!it.estSorti()) {
            if (it.valec() == o)
                return index;
            index++;
            it.succ();
        }
        return -1;
    }

    @Override
    public int lastIndexOf(Object o) {
        Iterateur<T> it = this.lst.iterateur();
        it.enqueue();
        int index = this.size()-1;
        while (!it.estSorti()) {
            if (it.valec() == o)
                return index;
            index--;
            it.pred();
        }
        return -1;
    }

    @Override
    public ListIterator<T> listIterator() {
        throw new java.lang.UnsupportedOperationException();
    }

    @Override
    public ListIterator<T> listIterator(int i) {
        throw new java.lang.UnsupportedOperationException();
    }

    @Override
    public List<T> subList(int ibeg, int iend) {
        int i = 0;
        Iterateur<T> it = this.lst.iterateur();
        for ( ; i < ibeg; i++) {
            try {
                it.succ();
            } catch (ListeDehorsException e) {
                throw new java.lang.ArrayIndexOutOfBoundsException();
            }
        }
        ArrayList<T> k = new ArrayList<>();
        for ( ; i < iend; i++) {
            try {
                k.add(it.valec());
                it.succ();
            } catch (ListeDehorsException e) {
                throw new java.lang.ArrayIndexOutOfBoundsException();
            }
        }
        return k;
    }
}
