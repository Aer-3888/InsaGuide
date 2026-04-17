package main;

public class Enregistrement {
    private String cityName;
    private Coordonnees coordinates;
    private int population = 0;

    public Enregistrement(String cn, Coordonnees coord, int pop) {
        this.cityName = cn;
        this.coordinates = coord;
        this.population = pop;
    }

    public String getCityName() {
        return this.cityName;
    }

    public Coordonnees getCoordinates() {
        return this.coordinates;
    }

    public int getPopulation() {
        return this.population;
    }

    public String toString() {
        return this.cityName + " : " + this.population + " @ " + this.coordinates;
    }

    public boolean equals(Enregistrement k) {
        return this.cityName == k.cityName && this.population == k.population && this.coordinates.equals(k.coordinates);
    }
}
