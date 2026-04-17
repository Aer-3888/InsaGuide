# Reseaux - Travaux Pratiques

Network programming labs covering TCP/IP, socket programming, and network protocols.

## Lab Overview

| TP | Topic | Technologies | Key Concepts |
|----|-------|--------------|--------------|
| [TP1](./TP1/) | Network Discovery | Linux networking tools | IP, Ethernet, ARP, ICMP, routing, TCP/IP stack |
| [TP2](./TP2/) | UDP/TCP with Java | Java Sockets | UDP datagrams, TCP connections, HTTP server |
| [TP3](./TP3/) | TCP Services (Java) | Java ServerSocket | TCP client/server, uppercase service, guessing game |
| [TP4](./TP4/) | Socket Programming in C | C sockets API | TCP/UDP in C, cross-platform sockets |
| [TP5](./TP5/) | Multicast Chat | C + pthreads | IP multicast, multithreading, real-time chat |

## Core Technologies

- **Languages**: C, Java
- **Protocols**: TCP, UDP, HTTP, ICMP, ARP
- **Tools**: Wireshark, ping, traceroute, netstat, arp
- **Libraries**: POSIX sockets, pthreads

## Learning Progression

1. **TP1** - Understand network fundamentals through packet analysis
2. **TP2** - Implement basic UDP/TCP communication in Java
3. **TP3** - Build interactive TCP services with client/server architecture
4. **TP4** - Master low-level socket programming in C
5. **TP5** - Advanced multicast communication with threading

## Quick Start

Each TP directory contains:
- `README.md` - Detailed walkthrough and explanations
- `src/` - Cleaned, commented source code
- Original assignment PDFs for reference

## Compilation Examples

### Java (TP2, TP3)
```bash
javac *.java
java ClientClassName [args]
```

### C (TP4, TP5)
```bash
gcc -o client client.c
gcc -o server server.c
./server [port]
./client [host] [port]
```

### TP5 Multicast (with threading)
```bash
gcc -pthread -o chat main.c
./chat 224.0.0.10 10000 YourName
```

## Key Concepts Covered

### Network Layer Analysis
- IP addressing (IPv4/IPv6)
- Routing tables and packet forwarding
- Fragmentation and MTU
- ICMP echo request/reply

### Transport Layer
- TCP three-way handshake
- Sequence numbers and acknowledgments
- UDP connectionless communication
- Port numbers and service mapping

### Application Layer
- HTTP protocol implementation
- Custom application protocols
- Message formatting and parsing

### Socket Programming
- Stream sockets (TCP) vs datagram sockets (UDP)
- bind(), listen(), accept(), connect()
- send()/recv() vs sendto()/recvfrom()
- Multicast group membership

## Network Tools Reference

| Command | Purpose | Example |
|---------|---------|---------|
| `hostname` | Get machine name | `hostname` |
| `ifconfig` / `ip addr` | Network interfaces | `ip addr show` |
| `ip route` | Routing table | `ip route show` |
| `arp -a` | ARP cache | `arp -a` |
| `ping` | Test connectivity | `ping google.com` |
| `traceroute` | Trace packet path | `traceroute google.com` |
| `netstat` | Active connections | `netstat -tuln` |
| `nslookup` / `dig` | DNS queries | `nslookup google.com` |
| `wireshark` | Packet analyzer | `wireshark` (GUI) |
| `tcpdump` | Packet capture | `tcpdump -i eth0` |

## Common Socket Functions

### C Socket API
```c
// Create socket
int sock = socket(AF_INET, SOCK_STREAM, 0);  // TCP
int sock = socket(AF_INET, SOCK_DGRAM, 0);   // UDP

// Bind to port
struct sockaddr_in addr;
addr.sin_family = AF_INET;
addr.sin_port = htons(port);
addr.sin_addr.s_addr = INADDR_ANY;
bind(sock, (struct sockaddr*)&addr, sizeof(addr));

// TCP Server
listen(sock, 5);
int client = accept(sock, NULL, NULL);
recv(client, buffer, size, 0);
send(client, data, len, 0);

// TCP Client
connect(sock, (struct sockaddr*)&server, sizeof(server));

// UDP
sendto(sock, data, len, 0, (struct sockaddr*)&dest, sizeof(dest));
recvfrom(sock, buffer, size, 0, (struct sockaddr*)&src, &srclen);
```

### Java Socket API
```java
// TCP Server
ServerSocket server = new ServerSocket(port);
Socket client = server.accept();
BufferedReader in = new BufferedReader(
    new InputStreamReader(client.getInputStream()));
PrintWriter out = new PrintWriter(client.getOutputStream(), true);

// TCP Client
Socket sock = new Socket(host, port);

// UDP
DatagramSocket socket = new DatagramSocket();
DatagramPacket packet = new DatagramPacket(buf, len, addr, port);
socket.send(packet);
socket.receive(packet);
```

## Protocol Stack Reminder

```
┌─────────────────────────────────┐
│   Application Layer             │  HTTP, DNS, custom protocols
├─────────────────────────────────┤
│   Transport Layer               │  TCP (stream), UDP (datagram)
├─────────────────────────────────┤
│   Network Layer                 │  IP (routing, addressing)
├─────────────────────────────────┤
│   Link Layer                    │  Ethernet, ARP
├─────────────────────────────────┤
│   Physical Layer                │  Cables, signals
└─────────────────────────────────┘
```

## Additional Resources

- `/etc/services` - Port number to service name mapping
- Wireshark filters: `tcp.port == 80`, `udp`, `icmp`, `arp`
- RFC 793 (TCP), RFC 768 (UDP), RFC 791 (IP)
- POSIX socket man pages: `man socket`, `man bind`, `man listen`

## Author

INSA Rennes - 3rd Year Computer Science  
Course: Reseaux (Networks)
