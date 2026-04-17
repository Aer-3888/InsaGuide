package cpoo1.exo5;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

interface Pion {
    int getX();
    int getY();
}

public class PlateauJeu {
    /**
     * Un plateau est carré et de cette dimension.
     **/
    public static final int SIZE = 5;

    private final List<Pion> pions;

    public PlateauJeu() {
        pions = new ArrayList<>();
    }

    /**
     * @return La liste des pions du plateau.
     * La liste retournée n'est pas modifiable : par exemple, un appel à clear() sur cette liste
     * levera une exception UnmodifiableListException.
     */
    public List<Pion> getPions() {
        return Collections.unmodifiableList(pions);
    }

    /**
     * Retourne vrai si aucun pion n'est placé aux coordonnées données.
     **/
    public boolean isFree(final int x, final int y) {
        if(isOut(x) || isOut(y)) {
            return false;
        }

        for (final Pion pion : pions) {
            if (pion.getX() == x && pion.getY() == y) {
                return false;
            }
        }

        return true;
    }

    /**
     * Ajoute un pion au plateau si non nul et si aucun autre pion n'est déjà placé
     * aux mêmes coordonnées.
     **/
    public boolean addPion(final Pion p) {
        if (p == null || !isFree(p.getX(), p.getY())) {
            return false;
        }
        pions.add(p);
        return true;
    }

    /**
     * La position d'un élément du plateau est forcement dans l'intervalle [0,SIZE[.
     **/
    private boolean isOut(final int value) {
        return value < 0 || value >= SIZE;
    }
}
