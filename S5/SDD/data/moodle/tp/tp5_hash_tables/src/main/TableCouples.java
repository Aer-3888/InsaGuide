package main;

import java.util.ArrayList;
import java.util.List;

public class TableCouples {
    private final List<Couple>[] lists;

    public TableCouples() {
        this.lists = new ArrayList[256*26+256];
    }

    public String toString() {
        StringBuilder res = new StringBuilder();
        for (List<Couple> lst : this.lists) {
            if (lst == null)
                continue;
            for (Couple cp : lst) {
                res.append(cp);
                res.append("\n");
            }
        }
        if (res.length() != 0)
            return res.substring(0, res.length()-1);
        else
            return "<Empty>";
    }

    public boolean ajouter(Word w, Word t) {
        if (w == null || t == null)
            throw new IllegalArgumentException("One or both of the words are null");
        // Check already existing index
        int hashcode = w.hashCode();
        if (this.lists[hashcode] == null)
            this.lists[hashcode] = new ArrayList<>();

        Couple new_couple = new Couple(w, t);
        for (int idx = 0; idx < this.lists[hashcode].size(); idx++) {
            Word old_translation = this.lists[hashcode].get(idx).compCoupleMot(w);
            if (old_translation != null) {
                this.lists[hashcode].set(idx, new_couple);
                return !old_translation.equals(t);
            }
        }
        return this.lists[hashcode].add(new_couple);
    }

    public Word traduire(Word w) {
        Word answer = null;
        for (List<Couple> lst : this.lists) {
            if (lst == null)
                continue;
            for (Couple attempt : lst) {
                answer = attempt.compCoupleMot(w);
                if (answer != null)
                    return answer;
            }
        }
        return answer;
    }
}
