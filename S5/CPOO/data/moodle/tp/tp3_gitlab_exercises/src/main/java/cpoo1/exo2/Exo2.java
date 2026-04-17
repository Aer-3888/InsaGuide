package cpoo1.exo2;

import java.util.regex.Pattern;

public class Exo2 {
    private final Network network;
    private final Pattern regex;

    public Exo2(Network network) {
        this.network = network;
        // Do not try to understand this regex.
        // Comes from: https://stackoverflow.com/questions/5284147/validating-ipv4-addresses-with-regexp
        regex = Pattern.compile("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$");
    }

    public boolean connectServer(final String address) {
        // Checks the format of the IP address:
        // good ones: 122.154.198.1
        if(!regex.matcher(address).matches()) {
            return false;
        }

        try {
            boolean pingOK = network.ping(address);

            network.sendGetHTTPQuery(address);

            return pingOK;
        }catch (NetworkException ex) {
            return false;
        }
    }
}
