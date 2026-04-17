# Cheat Sheet -- Reseaux (S6)

> Ce document est une synthese pour reviser avant un DS. Il regroupe les formules, protocoles cles, questions recurrentes et pieges a eviter.

---

## 1. Architecture en couches

### Modele TCP/IP (4 couches)

| Couche | Protocoles | Unite de donnees | Adressage |
|--------|-----------|------------------|-----------|
| Application | HTTP, DNS, FTP, SMTP, SSH, DHCP | Message | URL, nom de domaine |
| Transport | TCP, UDP | Segment / Datagramme | Port (16 bits, 0-65535) |
| Internet | IP, ICMP, ARP | Paquet | Adresse IP (32 bits) |
| Acces reseau | Ethernet, WiFi | Trame | Adresse MAC (48 bits) |

### Encapsulation

```
[En-tete Ethernet][En-tete IP][En-tete TCP][Donnees applicatives][FCS]
|--- Trame ----------------------------------------------------------|
                   |--- Paquet --------------------------------|
                                  |--- Segment ----------|
```

**Regle d'or** : l'adresse IP ne change jamais de bout en bout (sauf NAT). L'adresse MAC change a chaque saut (routeur).

---

## 2. Ethernet et couche liaison

### Trame Ethernet II

```
| Dest MAC (6) | Src MAC (6) | EtherType (2) | Payload (46-1500) | FCS (4) |
```

- **Taille min** : 64 octets | **Taille max** : 1518 octets | **MTU** : 1500 octets
- Si payload < 46 octets -> padding ajoute

### EtherType courants

| Valeur | Protocole |
|--------|-----------|
| 0x0800 | IPv4 |
| 0x0806 | ARP |
| 0x86DD | IPv6 |
| 0x8100 | 802.1Q (VLAN) |

### Adresses MAC speciales

| Adresse | Signification |
|---------|---------------|
| FF:FF:FF:FF:FF:FF | Broadcast (tout le monde) |
| 01:00:5E:xx:xx:xx | Multicast IPv4 |

### Hub vs Switch

| | Hub | Switch |
|---|-----|--------|
| Couche | 1 (physique) | 2 (liaison) |
| Envoi | Tous les ports | Port cible uniquement |
| Collisions | Oui (domaine partage) | Non (par port) |
| Table MAC | Non | Oui (auto-apprentissage) |

### ARP

- **Request** = broadcast Ethernet -> "Qui a cette IP ?"
- **Reply** = unicast Ethernet -> "C'est moi, voici ma MAC"
- Cache ARP avec expiration (quelques minutes)

---

## 3. Adressage IP -- Formules et calculs

### Formules essentielles

| Formule | Description |
|---------|-------------|
| **Nombre d'adresses = 2^(32-n)** | Pour un masque /n |
| **Nombre d'hotes = 2^(32-n) - 2** | On retire reseau + broadcast |
| **Pas = 256 - dernier octet du masque** | Block size dans le dernier octet significatif |
| **Bits supplementaires = log2(nb sous-reseaux)** | Pour decouper en sous-reseaux |

### Tableau des masques (a connaitre par coeur)

| CIDR | Masque | Pas | Hotes |
|------|--------|-----|-------|
| /24 | 255.255.255.0 | 256 | 254 |
| /25 | 255.255.255.128 | 128 | 126 |
| /26 | 255.255.255.192 | 64 | 62 |
| /27 | 255.255.255.224 | 32 | 30 |
| /28 | 255.255.255.240 | 16 | 14 |
| /29 | 255.255.255.248 | 8 | 6 |
| /30 | 255.255.255.252 | 4 | 2 |
| /31 | 255.255.255.254 | 2 | 2* |
| /32 | 255.255.255.255 | 1 | 1* |

*: /31 et /32 sont des cas speciaux (point a point et loopback).

### Puissances de 2 (a connaitre)

| 2^1 | 2^2 | 2^3 | 2^4 | 2^5 | 2^6 | 2^7 | 2^8 | 2^9 | 2^10 |
|-----|-----|-----|-----|-----|-----|-----|-----|-----|------|
| 2 | 4 | 8 | 16 | 32 | 64 | 128 | 256 | 512 | 1024 |

### Methode rapide pour trouver l'adresse reseau

1. Convertir le masque : /26 -> dernier octet = 192
2. Calculer le pas : 256 - 192 = 64
3. Diviser l'octet hote par le pas : 130 / 64 = 2.03 -> 2 * 64 = 128
4. Adresse reseau = 128 dans cet octet

**Exemple express** : 172.16.45.130/26
- Pas = 64
- 130 / 64 = 2.03 -> sous-reseau 128
- Reseau : 172.16.45.128
- Broadcast : 172.16.45.191 (128 + 64 - 1)
- Hotes : 172.16.45.129 a 172.16.45.190
- Nombre d'hotes : 62

### Adresses privees (RFC 1918)

| Plage | CIDR | Classe |
|-------|------|--------|
| 10.0.0.0 -- 10.255.255.255 | 10.0.0.0/8 | A |
| 172.16.0.0 -- 172.31.255.255 | 172.16.0.0/12 | B |
| 192.168.0.0 -- 192.168.255.255 | 192.168.0.0/16 | C |

### VLSM : methode

1. Trier les besoins du plus grand au plus petit
2. Pour chaque besoin : trouver le plus petit masque qui contient (besoin + 2) adresses
3. Allouer a la suite, en s'assurant que l'adresse de debut est alignee sur le pas

---

## 4. En-tete IP -- Champs importants

| Champ | Role en DS |
|-------|-----------|
| TTL | Decremente a chaque routeur. A 0 = paquet detruit + ICMP Time Exceeded |
| Protocol | 1=ICMP, 6=TCP, 17=UDP |
| Flags + Offset | Fragmentation : MF=1 si d'autres fragments suivent. Offset en unites de 8 octets |
| Total Length | Taille totale du paquet (en-tete + donnees) |

### Fragmentation IP

```
Nombre de fragments = ceil(taille_donnees / (MTU - taille_entete_IP))
Taille donnees par fragment = (MTU - 20) arrondi au multiple de 8 inferieur
Dernier fragment = taille_donnees - (nb_fragments - 1) * taille_par_fragment
```

**Exemple** : 4000 octets, MTU = 1500
- Par fragment : 1500 - 20 = 1480 (deja multiple de 8)
- Fragment 1 : 1480 octets, offset 0, MF=1
- Fragment 2 : 1480 octets, offset 185 (1480/8), MF=1
- Fragment 3 : 1040 octets, offset 370 (2960/8), MF=0

---

## 5. Routage

### Table de routage : lecture

```
Destination      Masque           Passerelle      Interface
192.168.1.0      /24              Directement     eth0
10.0.0.0         /8               192.168.1.1     eth0
0.0.0.0          /0               192.168.1.254   eth0  (route par defaut)
```

### Longest prefix match

**Regle** : la route avec le masque le plus long qui correspond gagne.

Si destination = 10.1.2.42 :
- 10.0.0.0/8 correspond (8 bits)
- 10.1.0.0/16 correspond (16 bits)
- 10.1.2.0/24 correspond (24 bits) -> **gagnante**

### Processus de routage a chaque saut

1. Recevoir la trame -> retirer en-tete Ethernet
2. Lire IP destination -> consulter table de routage (longest prefix match)
3. Decrementer TTL (si TTL=0 -> detruire + ICMP)
4. ARP pour trouver MAC du prochain saut
5. Construire nouvelle trame Ethernet -> transmettre

**Ce qui change** : MAC src, MAC dest, TTL, checksum IP
**Ce qui NE change PAS** : IP src, IP dest, donnees

### Protocoles de routage

| Protocole | Type | Metrique | Particularite |
|-----------|------|----------|---------------|
| RIP | Vecteur de distance | Sauts (max 15) | Simple, lent a converger |
| OSPF | Etat de liens | Cout (bande passante) | Dijkstra, rapide |
| BGP | Vecteur de chemin | Politiques | Inter-AS, Internet |

---

## 6. TCP

### Three-way handshake

```
Client            Serveur
  |--- SYN, Seq=x -------->|
  |<-- SYN+ACK, Seq=y, Ack=x+1 --|
  |--- ACK, Seq=x+1, Ack=y+1 --->|
```

SYN et FIN consomment chacun 1 numero de sequence.

### Four-way teardown

```
Client            Serveur
  |--- FIN, Seq=u -------->|
  |<-- ACK, Ack=u+1 ------|
  |<-- FIN, Seq=v ---------|
  |--- ACK, Ack=v+1 ----->|
  [TIME_WAIT: 2*MSL]
```

### En-tete TCP : champs cles

| Champ | Taille | Role en DS |
|-------|--------|-----------|
| Port src/dest | 16 bits chacun | Identifier l'application |
| Seq Number | 32 bits | Position dans le flux (en octets) |
| Ack Number | 32 bits | Prochain octet attendu |
| Flags | SYN, ACK, FIN, RST, PSH | Gestion de connexion |
| Window | 16 bits | Controle de flux (taille fenetre recepteur) |

### Controle de flux vs controle de congestion

| | Controle de flux | Controle de congestion |
|---|-----------------|----------------------|
| Protege | Le recepteur | Le reseau |
| Mecanisme | Window Size dans ACK | Slow Start + Congestion Avoidance |
| Fenetre | rwnd (recepteur) | cwnd (emetteur) |
| Fenetre effective | min(rwnd, cwnd) | |

---

## 7. UDP

### En-tete UDP (8 octets)

```
| Port src (2) | Port dest (2) | Longueur (2) | Checksum (2) |
```

### TCP vs UDP en un coup d'oeil

| | TCP | UDP |
|---|-----|-----|
| Connexion | Oui | Non |
| Fiabilite | Oui | Non |
| Ordre | Oui | Non |
| En-tete | 20+ octets | 8 octets |
| Multicast | Non | Oui |
| Usage | HTTP, FTP, SSH | DNS, streaming, jeux |

---

## 8. Couche application

### Ports a connaitre

| Port | Service | Transport |
|------|---------|-----------|
| 20/21 | FTP | TCP |
| 22 | SSH | TCP |
| 25 | SMTP | TCP |
| 53 | DNS | UDP (+ TCP) |
| 67/68 | DHCP | UDP |
| 80 | HTTP | TCP |
| 110 | POP3 | TCP |
| 143 | IMAP | TCP |
| 443 | HTTPS | TCP |

### DNS

- Hierarchique : . -> fr -> insa-rennes.fr -> www
- Resolution iterative depuis les serveurs racine
- Enregistrements : A (IPv4), AAAA (IPv6), CNAME (alias), MX (mail), NS (DNS), PTR (inverse)
- UDP port 53 (TCP pour transferts de zone ou reponses > 512 octets)

### HTTP

- Requete : `METHODE /chemin HTTP/version` + headers + corps
- Reponse : `HTTP/version code message` + headers + corps
- Codes : 200 OK, 301 Moved, 400 Bad Request, 404 Not Found, 500 Internal Error
- HTTP/1.1 : connexion persistante, header Host obligatoire

### DHCP (DORA)

1. **D**iscover (client broadcast)
2. **O**ffer (serveur propose IP)
3. **R**equest (client accepte)
4. **A**ck (serveur confirme)

---

## 9. Questions recurrentes en DS

### Type 1 : calcul de sous-reseaux

> "Donnez l'adresse reseau, le broadcast et la plage d'hotes pour 172.16.45.130/26"

Methode : pas = 256 - 192 = 64. 130/64 = 2 -> reseau = 128. Broadcast = 191. Hotes = 129-190.

### Type 2 : decoupe en sous-reseaux

> "Decoupez 192.168.1.0/24 en sous-reseaux de 50 hotes"

Methode : 50 + 2 = 52. 2^6 = 64 >= 52 -> /26. Pas = 64. 4 sous-reseaux.

### Type 3 : VLSM

> "Allouez des sous-reseaux pour 100, 50, 25 et 2 hotes"

Methode : du plus grand au plus petit. /25 (126), /26 (62), /27 (30), /30 (2).

### Type 4 : routage pas a pas

> "Detaillez le parcours d'un paquet de A vers B en indiquant MAC src/dest et IP src/dest a chaque saut"

Methode : IP reste constante, MAC change a chaque routeur. ARP pour chaque saut. TTL decremente.

### Type 5 : TCP handshake

> "Dessinez l'echange TCP avec les numeros de sequence"

Methode : SYN(Seq=x) -> SYN-ACK(Seq=y, Ack=x+1) -> ACK(Seq=x+1, Ack=y+1).

### Type 6 : analyse Wireshark

> "Identifiez le protocole, les adresses, les ports dans cette capture"

Methode : lire de bas en haut. Ethernet (MAC), IP (adresses), TCP/UDP (ports), Application (HTTP, DNS...).

### Type 7 : fragmentation

> "Un paquet de 3000 octets traverse un lien MTU=1500. Decrivez les fragments."

Methode : donnees par fragment = 1480 (multiple de 8). Fragment 1: 1480, offset 0, MF=1. Fragment 2: 1520, offset 185, MF=0. Note: Total Length du dernier fragment = 1520 + 20 = 1540.

---

## 10. Pieges les plus frequents

| # | Piege | Bonne reponse |
|---|-------|---------------|
| 1 | Oublier -2 dans le nombre d'hotes | 2^n - 2 (reseau + broadcast) |
| 2 | Adresse MAC constante de bout en bout | NON, elle change a chaque saut |
| 3 | Adresse IP change a chaque routeur | NON, elle reste constante (sauf NAT) |
| 4 | ARP Reply en broadcast | NON, ARP Reply est en unicast |
| 5 | Hub = Switch | NON, hub = couche 1, switch = couche 2 |
| 6 | DNS toujours en UDP | NON, TCP pour reponses > 512 octets |
| 7 | HTTP garde un etat | NON, HTTP est sans etat (stateless) |
| 8 | SYN ne consomme pas de Seq | SI, SYN et FIN consomment 1 numero de sequence |
| 9 | TCP envoie des messages | NON, TCP est un flux d'octets |
| 10 | Controle de flux = controle de congestion | NON, flux protege recepteur, congestion protege reseau |
| 11 | /31 = 0 hote | NON, /31 = 2 hotes (liens point a point, RFC 3021) |
| 12 | Masque non contigu possible | NON, toujours une suite de 1 puis de 0 |
| 13 | TIME_WAIT est un bug | NON, c'est voulu (2*MSL pour securite) |
| 14 | UDP garantit l'ordre | NON, aucune garantie |
| 15 | TTL ne change pas | SI, decremente a chaque routeur |

---

## 11. Commandes reseau essentielles

```bash
# Configuration reseau
ip addr show                    # Interfaces et adresses
ip route show                   # Table de routage
arp -a                          # Cache ARP

# Diagnostic
ping <ip>                       # Test connectivite (ICMP)
traceroute <ip>                 # Chemin parcouru (ICMP TTL)
nslookup <domaine>              # Resolution DNS
dig <domaine>                   # Resolution DNS detaillee
netstat -tuln                   # Ports en ecoute
netstat -tun                    # Connexions etablies

# Capture
tcpdump -i eth0                 # Capture en ligne de commande
wireshark                       # Capture graphique (GUI)
```

### Filtres Wireshark utiles

```
arp                             # Paquets ARP
icmp                            # Paquets ICMP
tcp.port == 80                  # HTTP
tcp.flags.syn == 1              # SYN TCP
udp.port == 53                  # DNS
ip.addr == 192.168.1.1          # IP specifique
http.request.method == "GET"    # Requetes HTTP GET
```

---

## 12. Aide-memoire final

```
OSI :    Application > Presentation > Session > Transport > Reseau > Liaison > Physique
TCP/IP : Application > Transport > Internet > Acces reseau

Encapsulation : Donnees -> Segment -> Paquet -> Trame -> Bits
                (haut)                                  (bas)

TCP :  connecte, fiable, ordonne, flux d'octets
UDP :  non connecte, non fiable, datagrammes

Adresse IP   : identifie une machine (bout en bout)
Adresse MAC  : identifie une interface (saut par saut)
Port         : identifie une application

DNS  : nom -> IP (UDP 53)
HTTP : web (TCP 80/443)
DHCP : config auto (UDP 67/68, DORA)
ARP  : IP -> MAC (broadcast request, unicast reply)
ICMP : diagnostic (ping=8/0, traceroute=TTL+11/0)
```
