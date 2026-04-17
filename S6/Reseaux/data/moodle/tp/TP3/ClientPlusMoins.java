import java.net.*;
import java.io.*;

public class ClientPlusMoins {
	Socket sock = null;
	boolean ready = false;
	BufferedReader in = null;
	PrintWriter out = null;

	public ClientPlusMoins(String addr, int port) {
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

	public void runtime() {
		// We are connected, now we enter a loop
		BufferedReader keyboard = new BufferedReader(new InputStreamReader(System.in));
		while (true) {
			// Where we ask the player what they wish to send
			String line = null;
			try {
				line = keyboard.readLine();
			} catch (IOException e) {
				System.out.println("Error reading from keyboard");
				break;
			}
			if (line == null) {
				System.out.println("There was a reading error.");
				break;
			}
			// Send it
			this.out.println(line);
			// Try and receive
			String response = null;
			try {
				response = this.in.readLine();
			} catch (IOException e) {
				System.out.println("An error occurred while reading from the server.");
				break;
			}
			if (response == null) {
				System.out.println("Error during reading from server");
				break;
			}
			switch (response) {
				case "+": { System.out.println("It's higher"); break; }
				case "-": { System.out.println("It's lower"); break; }
				case "~": { System.out.println("…what?"); break; }
				case "=": { System.out.println("It's the answer!"); return; }
			}
		}
	}

	public static void main(String[] argv) {
		// Port is hardcoded, fuck it
		int port = 8988;
		if (argv.length >= 1) {
			try {
				port = Integer.parseInt(argv[0]);
			} catch (NumberFormatException e) {
				System.out.println("Formatting error " + e);
				System.out.println("Invalid port number");
				return;
			}
		}

		ClientPlusMoins cl = new ClientPlusMoins("127.0.0.1", port);
		cl.runtime();
		cl.terminate();
	}
}
