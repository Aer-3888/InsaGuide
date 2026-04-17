package main;

import java.util.List;
// Change this line to change list
import java.util.LinkedList;

public class BdGeographique {
    private final List<Enregistrement> data;

    public BdGeographique() {
        // Change this line to change list
        this.data = new ListeEngine<>(new ListeDoubleChainee<>());
    }

    public boolean estPresent(Enregistrement e) {
        for (Enregistrement k : this.data) {
            System.out.println("1");
            if (k.equals(e))
                return true;
        }
        return false;
    }

    public void vider() {
        this.data.clear();
    }

    public void ajouter(Enregistrement e) {
        if (!this.data.contains(e))
            this.data.add(e);
    }

    public void retirer(Enregistrement e) {
        this.data.remove(e);
    }

    public String toString() {
        StringBuilder ret = new StringBuilder();
        ret.append("DATABASE :");
        // If empty, proper formatting
        if (this.data.size() == 0)
            ret.append(" empty");

        for (Enregistrement k : this.data) {
            ret.append("\n\t");
            ret.append(k);
        }

        return ret.toString();
    }

    public Enregistrement ville(String v) {
        // Find it
        for (Enregistrement k : this.data) {
            if (k == null)
                continue;

            if (k.getCityName().equals(v))
                return k;
        }
        return null;
    }

    public Enregistrement coord(Coordonnees c) {
        // Find it
        for (Enregistrement k : this.data) {
            if (k == null)
                continue;

            if (c.equals(k.getCoordinates()))
                return k;
        }
        return null;
    }

    public void retirerVille(String v) {
        Enregistrement k = this.ville(v);
        while (k != null) {
            this.retirer(k);
            k = this.ville(v);
        }
    }

    public void retirerCoord(Coordonnees c) {
        Enregistrement k = this.coord(c);
        while (k != null) {
            this.retirer(k);
            k = this.coord(c);
        }
    }

    public int population() {
        int res = 0;
        for (Enregistrement k : this.data) {
            if (k == null)
                continue;

            res += k.getPopulation();
        }
        return res;
    }
}
