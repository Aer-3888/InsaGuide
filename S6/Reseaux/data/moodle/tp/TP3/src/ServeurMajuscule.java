import java.net.*;
import java.io.*;

public class ServeurMajuscule {
	ServerSocket sock = null;
	Integer port = null;

	public ServeurMajuscule(int port) {
		this.port = port;
		try {
			this.sock = new ServerSocket(this.port);
		} catch (IOException e) {
			System.out.println("Error opening service socket.");
		}
	}

	public void runtime() {
		// Those are useful tools that will help us later
		PrintWriter out = null;
		BufferedReader in = null;
		Socket cs = null;

		while (true) {
			// Accepting
			try {
				cs = this.sock.accept();
			} catch (IOException e) {
				System.out.println("Error opening client communication.");
				continue;
			}

			// Define the "out" stream
			try {
				out = new PrintWriter(cs.getOutputStream(), true);
			} catch (IOException e) {
				System.out.println("Error opening output stream.");
				continue;
			}
			// Define the "in" stream
			try {
				in = new BufferedReader(new InputStreamReader(cs.getInputStream()));
			} catch (IOException e) {
				System.out.println("Error opening input stream");
				continue;
			}

			// Send modality line
			out.println("Hello. Please behave.");

			// Repeater
			String line = null;
			while (true) {
				// Read one (1) line
				try {
					line = in.readLine();
				} catch (IOException e) {
					System.out.println("Hmm, error.");
					break;
				}
				System.out.println("'" + line + "'");
				// Is the line the point '.'
				if (line == null || line.equals("."))
					break;

				// Write out
				out.println(line.toUpperCase());
			}

			// Close
			try {
				cs.close();
			} catch (IOException e) {
				System.out.println("Error closing socket service.");
				continue;
			}
		}

		/*try {
			this.sock.close();
		} catch (IOException e) {
			System.out.println("Error closing service socket.");
			return -1;
		}

		return 0;*/
	}
	public static void main(String[] args) {
		ServeurMajuscule poss = new ServeurMajuscule(8987);
		poss.runtime();
	}
}
