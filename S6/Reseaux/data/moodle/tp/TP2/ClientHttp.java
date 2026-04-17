import java.net.*;
import java.io.*;

public class ClientHttp {
	static String userAgent = "Simple ClientHttp";

	ClientHttp() {
		// No resource to allocate ?
	}

	static String makeRequest(String target) {
		String request = "GET /" + target + " HTTP/1.1\r\n";
		//request += "User-Agent: " + ClientHttp.userAgent + "\r\n";
		request += "\r\n";
		return request;
	}

	String get(String addr, int port, String target) {
		// Connect
		Socket sock = null;
		try {
			sock = new Socket(addr, port);
		} catch (IOException e) {
			System.out.println("Error connecting to " + addr + ":" + port);
			return "";
		}
		//
		String request = ClientHttp.makeRequest(target);
		PrintWriter out = null;
		try {
			out = new PrintWriter(sock.getOutputStream());
		} catch (IOException e) {
			System.out.println("Error opening output stream towards " + sock.getInetAddress().getHostName() + ":" + sock.getPort());
		}
		System.out.println(request);
		out.println(request);
		out.flush();

		// Input
		BufferedReader in = null;
		try {
			in = new BufferedReader(new InputStreamReader(sock.getInputStream()));
		} catch (IOException e) {
			System.out.println("IOException when opening input for response");
			return "";
		}
		String response = null;
		try {
			String buff = in.readLine();
			while (buff != null) {
				response += buff + "\n";
				buff = in.readLine();	
			}
		} catch (IOException e) {
			System.out.println("IOException whean reading");
			return response;
		}
		return response;
	}

	public static void main(String[] args) {
		String[] possible_targets = {
			"index.html",
			"Client_UDP.java",
			"ziuoaueyaizezuae"/*,
			"big_secret_file.zip",
			"ClientHttp.java"*/
		};
		ClientHttp clt = new ClientHttp();
		for (String target : possible_targets) {
			System.out.println(clt.get("127.0.0.1", 8888, target));
		}
	}
}
