package cpoo1.exo9;

import java.util.ArrayList;
import java.util.List;

public class Exo9 {
    private final List<String> maListe;

    public Exo9() {
        maListe = new ArrayList<>();
    }

    public void ajouterElement(String elt) {
        maListe.add(elt);
    }

    public boolean estVide() {
        return maListe.isEmpty();
    }

    public boolean contient(String str) {
        final int taille = maListe.size();

        for (int i = 0; i <= taille; i++) {
            if(maListe.get(i).equals(str)) {
                return true;
            }
        }
        return false;
    }
}
