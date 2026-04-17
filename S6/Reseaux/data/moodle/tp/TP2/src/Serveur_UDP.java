import java.net.*;
import java.io.*;

/**
 * UDP Echo Server
 *
 * Demonstrates UDP (User Datagram Protocol) socket programming.
 * UDP is connectionless - no handshake, each datagram is independent.
 *
 * Server behavior:
 * 1. Listen on UDP port
 * 2. Receive datagram from client
 * 3. Echo the same datagram back to sender
 * 4. Repeat indefinitely
 *
 * Key characteristics:
 * - Stateless: no connection state maintained
 * - Fast: no connection overhead
 * - Unreliable: no guarantee of delivery
 */
public class Serveur_UDP {
    private int port_number;
    private DatagramSocket sock;

    /**
     * Constructor - creates and binds UDP socket
     *
     * @param port_number Port to listen on
     * @param ip IP address to bind to (unused, binds to all interfaces)
     * @throws SocketException if port is already in use
     */
    Serveur_UDP(int port_number, InetAddress ip) throws SocketException {
        // Create UDP socket bound to specified port
        // DatagramSocket automatically binds to all local addresses (0.0.0.0)
        this.sock = new DatagramSocket(port_number);
        System.out.println("UDP Server listening on port " + port_number);
    }

    /**
     * Main server loop - receive and echo datagrams
     */
    void runtime() {
        // Prepare buffer for incoming data (256 bytes max)
        byte[] recvBuf = new byte[256];

        // DatagramPacket wraps buffer and will store sender info
        DatagramPacket message = new DatagramPacket(recvBuf, 256);

        // Loop forever handling requests
        while (true) {
            try {
                // Blocking receive - waits for datagram
                // On return, 'message' contains:
                // - data (in recvBuf)
                // - sender's IP and port
                // - actual data length
                this.sock.receive(message);

                // Log received message
                String data = new String(message.getData(), 0, message.getLength());
                System.out.println("Received from " +
                                 message.getAddress() + ":" +
                                 message.getPort() +
                                 " -> " + data);
            } catch (IOException e) {
                System.err.println("IOException when reading: " + e.getMessage());
                break;
            }

            try {
                // Echo datagram back to sender
                // 'message' already contains sender's address and port
                this.sock.send(message);
                System.out.println("Echoed back to client");
            } catch (IOException e) {
                System.err.println("IOException when sending back: " + e.getMessage());
                break;
            }
        }
    }

    /**
     * Entry point
     */
    public static void main(String[] argv) {
        final int DEFAULT_PORT = 5674;

        Serveur_UDP srv;
        try {
            // Create server on port 5674
            srv = new Serveur_UDP(DEFAULT_PORT, null);
        } catch (SocketException e) {
            System.err.println("Failed to create UDP server: " + e.getMessage());
            System.err.println("Port may already be in use.");
            return;
        }

        // Start server loop
        srv.runtime();
    }
}
