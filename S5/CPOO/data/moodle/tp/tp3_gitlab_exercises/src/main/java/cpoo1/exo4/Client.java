package cpoo1.exo4;

import java.util.ArrayList;
import java.util.List;

interface Service {
    int getLatency();
}

public class Client {
    private final List<Service> services;

    /** Creates the objet with an empty list of services. **/
    public Client() {
        services = new ArrayList<>();
    }

    /**
     * Adds a service.
     * @throws IllegalArgumentException if 'service' is null
     **/
    public void addService(Service s) {
        if(s==null || services.contains(s)) throw new IllegalArgumentException();
        services.add(s);
    }

    /** Returns the list of services **/
    public List<Service> getServices() {
        return services;
    }

    /** Returns the total of all the latencies of the services. **/
    public double getTotalLatency() { // A
        // Calls the method getLatency from Service on each element
        // of 'services' to sum all the latencies.
//        return services.stream().mapToDouble(s -> s.getLatency()).sum();
        double sum = 0.0; // B
        for(Service s : services) { // C
            sum += s.getLatency(); // D
        }
        return sum; // E
    }
}
