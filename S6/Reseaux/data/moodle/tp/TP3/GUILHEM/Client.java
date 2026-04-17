import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;

public class Client {
    int port;
    InetAddress host;
    Socket socket;
    BufferedWriter os = null;
    BufferedReader is = null;
    Thread receiveThread;

    public Client(String h, int p) {
        try {
            host = InetAddress.getByName(h);
        } catch (UnknownHostException e1) {
            e1.printStackTrace();
        }
        port = p;
        try {
            socket = new Socket(host, port);
            os = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
            is = new BufferedReader(new InputStreamReader(socket.getInputStream()));
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public void run(String[] args) {
        try {

            // Thread pour recevoir le messages du serveur en continu
            receiveThread = new Thread() {
                public void run() {
                    while (true) {
                        String responseLine;
                        try {
                            while ((responseLine = is.readLine()) != null) {
                                System.out.println("Server: " + responseLine);
                                if (responseLine.equals(">> BYE")) {
                                    System.exit(0);
                                }                                
                            }
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
            };
            receiveThread.start();

            // si args
            for (int i = 0; i < args.length; i++) {
                os.write(args[i]);
                os.newLine();
                os.flush();
            }

            // Recuperer les input depuis la console
            BufferedReader reader = new BufferedReader(new InputStreamReader(System.in));
            while (true) {
                os.write(reader.readLine());
                os.newLine();
                os.flush();
            }

        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            receiveThread.interrupt();
            try {
                socket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        Client c = new Client("0.0.0.0", 5555);
        c.run(args);
    }
}
