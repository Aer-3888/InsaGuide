package main;

public interface Arbre {
    public Object racine();
    public Arbre arbreG();
    public Arbre arbreD();
    public boolean estVide();
    public void vider();
    public int hauteur();
    public void modifRacine(Object r);
    public void modifArbreD(Arbre a);
    public void modifArbreG(Arbre a);
    public String toString();
    public void dessiner();
}
