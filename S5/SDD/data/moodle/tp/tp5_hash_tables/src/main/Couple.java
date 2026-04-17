package main;

public class Couple {
    private final Word mot;
    private final Word traduction;

    public Couple(Word m1, Word m2) {
        if (m1 == null || m2 == null)
            throw new IllegalArgumentException("One or both given words are null");
        this.mot = m1;
        this.traduction = m2;
    }

    public String toString() {
        return "(\"" + this.mot + "\", \"" + this.traduction + "\")";
    }

    public Word compCoupleMot(Word m) {
        // If the given word is equal to the first one return the second one
        if (m == null)
            return null;
        if (m.equals(this.mot))
            return this.traduction;
        return null;
    }
}
