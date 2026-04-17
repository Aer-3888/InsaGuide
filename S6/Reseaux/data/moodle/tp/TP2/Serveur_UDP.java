import java.net.*;
import java.io.*;

public class Serveur_UDP {
	private int port_number;
	private DatagramSocket sock;

	Serveur_UDP(int port_number, InetAddress ip) throws SocketException{
		this.sock = new DatagramSocket(port_number);
	}

	void runtime() {
		// Loop eternally
		byte[] recvBuf = new byte[256];
		DatagramPacket message = new DatagramPacket(recvBuf, 256);
		while (true) {
			try {
				this.sock.receive(message);
			} catch (IOException e) {
				System.out.println("IOException when reading");
				break;
			}
			try {
				this.sock.send(message);
			} catch (IOException e) {
				System.out.println("IOException when sending back");
				break;
			}
		}
	}

	public static void main(String[] argv) {
		Serveur_UDP srv;
		try {
			srv = new Serveur_UDP(5674, null);
		} catch (SocketException e) {
			return;
		}
		srv.runtime();
	}
}
