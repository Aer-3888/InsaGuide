import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.ServerSocket;
import java.net.Socket;

public class ServerPM {
    int port;
    ServerSocket ssocket;
    BufferedReader is;
    BufferedWriter os;

    public ServerPM(int p) {
        port = p;
        try {
            ssocket = new ServerSocket(port);
        } catch (IOException e) {
            e.printStackTrace();
        }
        // Affichage caracteristiques du serveur
        displayInfo();
    }

    public void displayInfo() {
        System.out.println("Adresse : " + ssocket.getInetAddress() + " Port : " + ssocket.getLocalPort());
    }

    public void sendMessage(String m) throws IOException {
        os.write(m);
        os.newLine();
        os.flush();
    }

    public void run() {
        while (true) {
            try {
                // On accepte les connexions entrantes
                Socket s = ssocket.accept();
                System.out.println("A client has connected !");

                // Nb random a trouver
                final int guess = (int) (Math.random() * 100);

                is = new BufferedReader(new InputStreamReader(s.getInputStream()));
                os = new BufferedWriter(new OutputStreamWriter(s.getOutputStream()));

                String message = ">> Vous venez de vous connecter au server. \n" +
                        ">> Envoyez un int et le serveur vous dira si vous êtes trop haut ou bas.\n" +
                        ">> Envoyer ';' termine la connection. ";
                sendMessage(message);

                while (true) {
                    message = is.readLine();
                    if (message == null || message.equals(";")) {
                        break;
                    } else {
                        int input;
                        try {
                            input = Integer.parseInt(message);
                        } catch (NumberFormatException e) {
                            sendMessage("Veuillez rentrer un entier !");
                            continue;
                        }
                        if (input == guess) {
                            sendMessage("Bien joué, vous avez trouvé la solution !");
                            break;
                        } else if (input < guess) {
                            sendMessage("Vous êtes en dessous.");
                        } else if (input > guess) {
                            sendMessage("Vous êtes au dessus.");
                        }
                    }
                }
                sendMessage(">> BYE");
                s.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        ServerPM s1 = new ServerPM(5555);
        s1.run();
    }
}
