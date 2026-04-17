package main;

public class Coordonnees {
    private float latitude;
    private float longitude;

    public Coordonnees(float latitude, float longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public float getLatitude() {
        return this.latitude;
    }

    public float getLongitude() {
        return this.longitude;
    }

    public boolean equals(Coordonnees u) {
        return this.latitude == u.latitude && this.longitude == u.longitude;
    }

    public String toString() {
        return "(" + this.latitude + ", " + this.longitude + ")";
    }
}
