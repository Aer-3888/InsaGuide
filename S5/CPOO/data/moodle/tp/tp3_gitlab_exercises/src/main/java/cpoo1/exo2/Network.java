package cpoo1.exo2;

public interface Network {
    boolean ping(String address) throws NetworkException;

    void sendGetHTTPQuery(String address);
}

