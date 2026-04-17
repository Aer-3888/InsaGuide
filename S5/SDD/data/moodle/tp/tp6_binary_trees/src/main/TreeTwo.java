package main;

import java.util.ArrayList;

public class TreeTwo implements Arbre {
    private static class Noeud {
        private Object value;
        private Noeud droit;
        private Noeud gauche;
        public Noeud(Object value) {
            this.value = value;
        }

        public Object getValue() {
            return value;
        }

        public void setValue(String value) {
            this.value = value;
        }

        public Noeud getDroit() {
            return droit;
        }

        public void setDroit(Noeud droit) {
            this.droit = droit;
        }
    }

    private Noeud root;

    public TreeTwo(Object root) {
        this.root = new Noeud(root);
    };

    public Object racine() {
        // This cannot fail since we must have had a root node
        // Initialized
        return this.root.getValue();
    }

    public Arbre arbreG() {
        // We actually need to build something here
        // If there is nothing on the left tree...
        if (this.root.gauche == null) {
            return new TreeTwo(null);
        }
        TreeTwo res = new TreeTwo(this.root.gauche.getValue());
        res.root = this.root.gauche;
        return res;
    }

    public Arbre arbreD() {
        // Same as left tree
        if (this.root.droit == null) {
            return new TreeTwo(null);
        }
        TreeTwo res = new TreeTwo(this.root.droit.getValue());
        res.root = this.root.droit;
        return res;
    }

    public boolean estVide() {
        return this.root.getValue() == null
                && this.root.gauche == null
                && this.root.droit == null;
    }

    public void vider() {
        this.root.droit = null;
        this.root.gauche = null;
        this.root.value = null;
    }

    public void modifRacine(Object r) {
        this.root.value = r;
    }

    public void modifArbreG(Arbre a) {
        if (a == null)
            this.root.gauche = null;
        else if (a.getClass() == TreeTwo.class)
            this.root.gauche = ((TreeTwo) a).root;
        else
            throw new UnsupportedOperationException("Cannot modify with non TreeTwo");
    }

    public void modifArbreD(Arbre a) {
        if (a == null)
            this.root.droit = null;
        else if (a.getClass() == TreeTwo.class)
            this.root.droit = ((TreeTwo) a).root;
        else
            throw new UnsupportedOperationException("Cannot modify with non TreeTwo");
    }

    private String postfixTraversal(Noeud r) {
        StringBuilder res = new StringBuilder();
        if (r.gauche != null)
            res.append(postfixTraversal(r.gauche));
        if (r.droit != null)
            res.append(postfixTraversal(r.droit));
        if (r.value != null) {
            res.append(r.value.toString());
            res.append(" ");
        }
        return res.toString();
    }

    public String toString() {
        // Postfix path
        String res = postfixTraversal(this.root);
        // It could happen that the string is empty (root = null)
        return res.substring(0, Math.max(res.length()-1, 0));
    }

    public void dessiner() {
        Trees.draw(this);
    }

    private int recursiveHeight(Noeud r) {
        if (r == null)
            return 0;

        // Not too great on the stack
        return 1+Math.max(recursiveHeight(r.gauche), recursiveHeight(r.droit));
    }

    public int hauteur() {
        if (this.estVide()) {
            throw new RuntimeException("Attempt to find depth of empty tree");
        }

        // Heck it, recursion time
        return Math.max(this.recursiveHeight(this.root.gauche),
                this.recursiveHeight(this.root.droit));
    }

    public int denombrer(String n) {
        if (n == null)
            throw new IllegalArgumentException("Attempt to count null string");
        ArrayList<Noeud> lr = new ArrayList<>();
        int count = 0;
        // Push the top
        lr.add(this.root);

        while (lr.size() > 0) {
            // Pop the end
            Noeud e = lr.remove(lr.size()-1);
            if (e.gauche != null)
                lr.add(e.gauche);
            if (e.droit != null)
                lr.add(e.droit);
            if (e.value != null && e.value.toString().equals(n))
                count++;
        }
        return count;
    }

    public void remplacer(String n1, String n2) {
        if (n1 == null)
            throw new IllegalArgumentException("Attempt to find null string");
        if (n2 == null)
            throw new IllegalArgumentException("Attempt to replace with null string");
        ArrayList<Noeud> lr = new ArrayList<>();
        // Push the top
        lr.add(this.root);

        while (lr.size() > 0) {
            // Pop the end
            Noeud e = lr.remove(lr.size()-1);
            if (e.gauche != null)
                lr.add(e.gauche);
            if (e.droit != null)
                lr.add(e.droit);
            if (e.value != null && e.value.toString().equals(n1))
                e.value = n2;
        }
    }

}
