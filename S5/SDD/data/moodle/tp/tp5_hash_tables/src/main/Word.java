package main;

public class Word {
    private final String word;

    public Word(String s) {
        if (s == null || s.equals(""))
            throw new IllegalArgumentException("Word with null or empty string");
        this.word = s.toLowerCase();
    }

    @Override
    public String toString() {
        return this.word;
    }

    @Override
    public boolean equals(Object o) {
        if (o == null)
            return false;
        if (o.getClass() != this.getClass())
            return false;
        Word wo = (Word)o;
        return wo.word.equals(this.word);
    }

    public int hashCode() {
        if (this.word.length() > 2)
            return this.word.charAt(0) * 26 + this.word.charAt(1);
        else
            return this.word.charAt(0) * 26;
    }
}
