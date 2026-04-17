import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.ServerSocket;
import java.net.Socket;

public class ServerMaj {
    int port;
    ServerSocket ssocket;

    public ServerMaj(int p) {
        port = p;
        try {
            ssocket = new ServerSocket(port);
        } catch (IOException e) {
            e.printStackTrace();
        }
        // Affichage caracteristiques du serveur
        displayInfo();
    }

    public void run() {
        try {
            while (true) {
                // On accepte les connexions entrantes
                Socket s = ssocket.accept();
                System.out.println("A client has connected !");
                // On créer un Thread par client pour les gérer
                ThreadClient c = new ThreadClient(s);
                c.setDaemon(true);
                c.start();
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            // Si pb on ferme le ServerSocket
            try {
                ssocket.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public void displayInfo() {
        System.out.println("Adresse : " + ssocket.getInetAddress() + " Port : " + ssocket.getLocalPort());
    }

    static private class ThreadClient extends Thread {
        Socket socket;
        BufferedReader is;
        BufferedWriter os;

        public ThreadClient(Socket s) {
            super();
            socket = s;
            try {
                // Ouverture Input et Output
                is = new BufferedReader(new InputStreamReader(socket.getInputStream()));
                os = new BufferedWriter(new OutputStreamWriter(socket.getOutputStream()));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        @Override
        public void run() {
            try {
                String message = ">> Vous venez de vous connecter au server.\n" + 
                 ">> Vous pouvez envoyer n'importe quelle chaine et elle vous sera renvoyée en majuscule.\n" + 
                 ">> Envoyer '.' termine la connection. ";
                os.write(message);
                os.newLine();
                os.flush();

                while (true) {
                    message = is.readLine();
                    if (message.equals(".")) {
                        os.write(">> BYE");
                        os.newLine();
                        os.flush();
                        break;
                    }
                    message = message.toUpperCase();
                    os.write(message);
                    os.newLine();
                    os.flush();
                }
            } catch (IOException e) {
                e.printStackTrace();
            } finally {
                System.out.println("A client has disconnected !");
                // Si pb on ferme le Socket
                try {
                    socket.close();
                } catch (IOException e1) {
                    e1.printStackTrace();
                }
            }
        }
    }

    public static void main(String[] args) {
        ServerMaj s1 = new ServerMaj(5555);
        s1.run();
    }
}
