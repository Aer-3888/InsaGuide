import java.net.*;
import java.io.*;

public class ClientMajuscule {
	Socket sock = null;
	boolean ready = false;
	BufferedReader in = null;
	PrintWriter out = null;

	public ClientMajuscule(String addr, int port) {
		// Open socket
		try {
			this.sock = new Socket(addr, port);
		} catch (IOException e) {
			System.out.println("Error opening socket to " + addr + ":" + port);
			return;
		}

		// Initialize bufferedreader
		try {
			this.in = new BufferedReader(new InputStreamReader(this.sock.getInputStream()));
		} catch (IOException e) {
			System.out.println("Error opening input stream.");
			return;
		}
		// Initialize printwriter
		try {
			this.out = new PrintWriter(this.sock.getOutputStream(), true);
		} catch (IOException e) {
			System.out.println("Error opening output stream.");
			return;
		}
		// Read first line
		try {
			this.in.readLine();
		} catch (IOException e) {
			System.out.println("Error reading modality line");
			return;
		}
		this.ready = true;
	}

	public boolean isReader() {
		return this.ready;
	}

	public String toUpp(String s) {
		// Write
		this.out.println(s);
		// Read
		String line = null;
		try {
			line = this.in.readLine();
		} catch (IOException e) {
			return "";
		}
		return line;
	}

	public void terminate() {
		this.out.println(".");
	}

	public static void main(String[] argv) {
		int port = 8988;
		if (argv.length > 1) {
			try {
				port = Integer.parseInt(argv[1]);
			} catch (NumberFormatException e) {
				System.out.println("Encoding error: " + e);
				System.out.println("Invalid port number.");
				return;
			}
		}

		ClientMajuscule cl = new ClientMajuscule("127.0.0.1", port);
		for (int scan = 0; scan < argv.length; scan++)
			System.out.println(cl.toUpp(argv[scan]));
		cl.terminate();
	}
}
