import java.net.*;
import java.io.*;
import java.util.Random;

public class ServeurPlusMoins {
	ServerSocket sock = null;
	Integer port = null;

	public ServeurPlusMoins(int port) {
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
		Random rand = new Random();

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

			// Chose the random number for our person
			int to_be_guessed = rand.nextInt(65535);
			System.out.println("Guess " + to_be_guessed);

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

				// Convert to number
				int guess = 0;
				String response = new String();
				try {
					guess = Integer.parseInt(line);
					if (guess < to_be_guessed) {
						response = "+";
					} else if (guess > to_be_guessed) {
						response = "-";
					} else {
						response = "=";
					}
				} catch (NumberFormatException e) {
					System.out.println("Encoding error: " + e);
					response = "~";
				}

				// Write out
				out.println(response);
				if (response == "=")
					break;
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
		ServeurPlusMoins poss = new ServeurPlusMoins(8988);
		poss.runtime();
	}

}
