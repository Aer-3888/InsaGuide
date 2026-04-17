# Exercises -- Reseaux (S6)

Solutions detaillees et annotees des TPs de programmation reseau.
Chaque fichier contient le code source complet, les commandes de compilation, les sessions terminal et l'analyse reseau.

## Table des matieres

| Fichier | Description | Langages |
|---------|-------------|----------|
| [tp1_network_discovery.md](tp1_network_discovery.md) | TP1 : Decouverte reseau, Wireshark, ARP, ICMP, fragmentation, TCP handshake | Outils Linux |
| [tp2_udp_tcp_java.md](tp2_udp_tcp_java.md) | TP2 : Serveur echo UDP, serveur/client HTTP en Java | Java |
| [tp3_tcp_services.md](tp3_tcp_services.md) | TP3 : Services TCP interactifs (Majuscule, Plus ou Moins) en Java | Java |
| [tp4_sockets_c.md](tp4_sockets_c.md) | TP4 : Programmation socket en C (TCP, UDP, Plus ou Moins) | C |
| [tp5_multicast_chat.md](tp5_multicast_chat.md) | TP5 : Chat multicast en C (pthreads, termios, mutex) | C |

## Progression pedagogique

```
TP1 (Observation)     TP2 (Java basique)     TP3 (Java avance)     TP4 (C sockets)     TP5 (C avance)
    Wireshark     -->   UDP/TCP Java     -->   Protocoles TCP  -->   POSIX sockets  -->  Multicast
    ping/arp            DatagramSocket          ServerSocket         socket/bind          IP_ADD_MEMBERSHIP
    traceroute          ServerSocket            Protocole texte      send/recv            pthreads
    fragmentation       HTTP 1.0                Jeu interactif       sendto/recvfrom      termios raw mode
```
