# Réseau : TP1

Le TP a été réalisé sur ma machine.

## 1 - IP & Ethernet

Q1. Le hostname de ma machine est `awoobis`. Son ip pour l'interface `wlp3s0` (carte wifi) est 192.168.43.251 (v4), et son ip sur `tun1` (un tunnel VPN) est 10.8.1.135 et `fd11:1::135` en IPv6. Elle a aussi les ip de loopback `127.0.0.1` et `::1` sur l'interface loopback `lo`.

Q2.

|Interface|MTU|
|-|-|
|lo|65536|
|enp0s25|1500|
|wlp3s0|1500|
|tun1|1420|
|wwp0s20u4i6 (j'ai un port pour carte SIM sur mon laptop)|1500|

Q3.

Voilà ma table de routage par défaut en IPv4 :

	default via 192.168.43.1 dev wlp3s0 proto dhcp metric 600 
	10.8.1.0/24 dev tun1 proto kernel scope link src 10.8.1.135 
	192.168.43.0/24 dev wlp3s0 proto kernel scope link src 192.168.43.251 metric 600

Et ma table de routage par défaut en IPv6 :

	::1 dev lo proto kernel metric 256 pref medium
	fd11:1::/64 dev tun1 proto kernel metric 256 pref medium
	fe80::/64 dev wlp3s0 proto kernel metric 600 pref medium
	default dev tun1 metric 1024 pref medium

Q4. Je me connecte sur un de mes VPS (vulpinecitrus.info). Le hostname est `vulpinecitrus.info` (nécessaire pour certains services dessus).
Mes interfaces et leur MTU : `lo` (65536) avec les même IPs de loopback que précédemment, `eth0` (51.91.58.45 / 2001:41d0:305:2100::4547, MTU 1500),
`tun0` (le bout du tunnel VPN mentionné précédemment; ip 10.8.1.1 / fd11:1::1, MTU = 1420), `tun0-ifb`,
`docker0` (pour docker qui tourne sur le VPS; 172.17.0.1 et une IPv6 local link fe80::42:4bff:fe47:a294) et des interfaces pour
docker : `br-5aa5338f7baf` (bridge docker, 172.18.0.1), `vethfec39c6@if31`, `veth5986e70@if33`, `vethd8747d2@if35`.

Les routes par défaut sur le VPS sont :

	default via 51.91.56.1 dev eth0 
	10.8.1.0/24 dev tun0 proto kernel scope link src 10.8.1.1 
	51.91.56.1 dev eth0 scope link 
	172.17.0.0/16 dev docker0 proto kernel scope link src 172.17.0.1 
	172.18.0.0/16 dev br-5aa5338f7baf proto kernel scope link src 172.18.0.1 linkdown

et en IPv6 :

	::1 dev lo proto kernel metric 256 pref medium
	2001:41d0:305:2100::1 dev eth0 metric 1024 pref medium
	2001:41d0:305:2100::4547 dev eth0 proto kernel metric 256 pref medium
	fd11:1::/64 dev tun0 proto kernel metric 256 pref medium
	fe80::/64 dev tun0-ifb proto kernel metric 256 pref medium
	fe80::/64 dev docker0 proto kernel metric 256 pref medium
	fe80::/64 dev eth0 proto kernel metric 256 pref medium
	fe80::/64 dev vethfec39c6 proto kernel metric 256 pref medium
	fe80::/64 dev vethd8747d2 proto kernel metric 256 pref medium
	fe80::/64 dev veth5986e70 proto kernel metric 256 pref medium
	default via 2001:41d0:305:2100::1 dev eth0 metric 1024 pref medium

## Analyse ARP et ICMP

Q5. Voilà ma table ARP

	|Address|HWtype|HWaddress|Flags|Mask|Iface|
	216.239.38.21                    (incomplete)                              enp0s25
	192.168.43.1             ether   0c:70:4a:f8:8a:47   C                     wlp3s0
	216.239.36.21                    (incomplete)                              enp0s25
	216.239.34.21                    (incomplete)                              enp0s25
	216.239.32.21                    (incomplete)                              enp0s25

Q6. Pour avoir une capture du traffic plus claire, et au vu du reste des programmes (navigateurs, etc) qui tournent sur ma machine, j'utilise le tunnel VPN (interface `tun1`). J'ai programmé une routine sur mon laptop qui me permet d'obtenir le ping de ma machine avec `1.1.1.1` à travers toutes mes interfaces, j'ai donc juste à attendre pour récolter les paquets ICMP ECHO REQUEST/REPLY.

La spécification ICMP nous permet de comprendre un peu mieux le paquet ICMP. On fait ici abstraction de la couche ethernet, et on ne mentionne pas le numéro du type de paquet dans l'en-tête IP.

Le premier byte contient le type `8` qui correspond à ICMP ECHO REQUEST (0 pour la REPLY), suivi d'un code qui vaut 0 (ici avec REQUEST et REPLY c'est la seul valeur possible; 1 byte), du checksum du paquet (2 bytes), les identificateurs BE et LE (2 bytes chacun), puis le timestamp (8 bytes) et enfin 48 bytes de données qui sont renvoyées en reply.

Pour l'ARP, je suis obligé de capture mon interface wifi. Je purge mes tables ARP pour cette interface en la déconnactant du wifi. Au retour, j'obtiens des paquets ARP (Adress Resolution Protocol). J'obtiens : 2 bytes pour le type (01 = Ethernet), 2 bytes pour le protocol (08 00 = IPv4), Hardware Size = 6, Protocol size = 4 (1 byte), le code d'opération (2 bytes, 00 01 = Request), l'adress MAC du sender (ici mon téléphone / AP wifi; 6 bytes, la hardware size), l'adresse IP du sender (toujours mon téléphone, 4 bytes, la protocol size), la target sur 6 bytes (ici la MAC vide donc tout le monde entend mon paquet), et enfin la target IP (le laptop ici).

Q7. Mon téléphone (MAC=0C:70:4A:F8:8A:47) demande qui a 192.168.43.251, de le dire à 192.168.53.1. Mon laptop (MAC=a4:4e:31:08:ac:84 sur sa carte wifi) répond que 192.168.42.251 se situe à MAC=a4:4e:31:08:ac:84.

Q8 et Q9 et Q10 à remettre en forme avec les questions d'avant.

## IP Fragmentation

Q14. Toujours dans le tunnel, j'envoie un ping dont la taille est plus grosse que le MTU de l'interface (1420). Le paquet est donc fragmenté.

Dans l'en-tête IP du paquet, on voit que le 3ème plus fort bit du 7e byte (Flags) est mis à 1, ce qui signifie "More Fragments" : d'autres fragments vont arriver.

Q15. Dans le deuxième fragment, ce même bit n'est pas mis à 1 (not set), ce qui indique que ce n'est pas le premier fragment, puisqu'il n'y a pas plus de fragments à venir. Cela signifie aussi que c'est le dernier fragment. Ces deux fragments ont aussi la même identification (bytes 5 et 6) dans l'en-tête ICMP.

Q16. La taille totale (1420 contre 628), le flags mentionné précédemment, l'offset de fragment (0 contre 1400), le checksum, changent entre les deux fragments.

## Services internet

Q17. C'est le fichier `/etc/services` qui contient la correspondance entre les noms de service et les numéros de port udp et tcp.  Quelques services connus sont `smtp` (`25/tcp`), `ftp` (tcp/udp 21 pour le contrôle, tcp/udp 20 pour les données), `ssh` (tcp/22), `telnet` (23/tcp), `domain` (le DNS) (53/udp), `www` (le web) (`80/tcp`), `pop3` (POP3 mail sans chiffrement) (`110/tcp`), `ntp` (network time protoco) (123/tcp), `https` (web chiffré) (443/tcp), `imap` (IMAP mail sans chiffrement) (143/tcp), `doom` (legacy serveur doom; `666/tcp`), `irc` (en pratique c'est 6667/tcp), etc…

Q18. 

	Proto Recv-Q Send-Q Local Address           Foreign Address         State      
	tcp        0      0 awoobis:35918           lb-140-82-114-25-:https ESTABLISHED
	tcp        0      0 awoobis:38460           162.159.138.232:https   ESTABLISHED
	tcp        0      0 awoobis:45032           fra02s18-in-f4.1e:https TIME_WAIT  
	tcp        0      0 awoobis:57082           ec2-54-149-175-5.:https ESTABLISHED
	tcp        0      0 awoobis:51540           stackoverflow.com:https ESTABLISHED
	tcp        0      0 awoobis:36828           162.159.136.234:https   ESTABLISHED
	tcp        0      0 awoobis:55598           151.101.122.167:https   ESTABLISHED
	tcp        0      0 awoobis:38458           162.159.138.232:https   ESTABLISHED
	tcp        0      0 awoobis:37322           arctic.vulpine.ow:https ESTABLISHED
	tcp        0      0 awoobis:37720           arctic.vulpine.ow:https ESTABLISHED
	tcp        0      0 awoobis:49170           104.244.42.66:https     ESTABLISHED
	tcp        0      0 awoobis:43616           45.ip-51-91-58.eu:https TIME_WAIT  
	tcp        0      0 awoobis:34266           104.26.5.21:https       ESTABLISHED
	tcp        0      0 awoobis:59870           aur.archlinux.org:https ESTABLISHED
	tcp        0      0 awoobis:59676           193.52.94.55:https      ESTABLISHED
	tcp        0      0 awoobis:42186           mirrors.stuart:www-http ESTABLISHED
	tcp        0      0 awoobis:60716           193.52.94.55:https      ESTABLISHED
	tcp        0      0 awoobis:52702           ec2-52-25-93-75.u:https ESTABLISHED
	tcp        0      0 awoobis:50566           archlinux.org:www-http  TIME_WAIT  
	tcp        0      0 awoobis:37718           arctic.vulpine.ow:https ESTABLISHED
	tcp        0      0 awoobis:37718           arctic.vulpine.ow:https ESTABLISHED
	tcp        0      0 awoobis:43630           45.ip-51-91-58.eu:https TIME_WAIT  
	tcp6       0      0 awoobis:49548           2600:1901:1:e52:::https ESTABLISHED
	tcp6       0    357 awoobis:42790           2001:41d0:305:210:https ESTABLISHED
	udp        0      0 awoobis:bootpc          _gateway:bootps         ESTABLISHED

## Nommage

Q19. On lance les pings. C'est assez rapide et fiable avec google (142ms en moyenne, ~0.8% packet loss), c'est très long et assez fiable en Namibie (283ms mais 0% loss), et un peu plus rapide mais moins fiable (135ms en moyenne, ~1.2% packet loss).

Q20.

Traceroute vers google.com (11 hops)

	traceroute to 172.217.22.132 (172.217.22.132), 30 hops max, 60 byte packets
	 1  _gateway (192.168.43.1)  9.517 ms  10.672 ms  11.193 ms
	 2  10.88.0.1 (10.88.0.1)  91.052 ms  129.119 ms  157.071 ms
	 3  192.168.253.30 (192.168.253.30)  178.868 ms  264.752 ms  306.373 ms
	 4  192.168.255.38 (192.168.255.38)  377.966 ms  389.628 ms  448.775 ms
	 5  194.149.164.92 (194.149.164.92)  458.687 ms  528.517 ms  551.250 ms
	 6  194.149.166.117 (194.149.166.117)  569.238 ms  586.962 ms  600.208 ms
	 7  194.149.166.54 (194.149.166.54)  624.482 ms  437.722 ms  418.355 ms
	 8  72.14.220.92 (72.14.220.92)  439.385 ms  440.800 ms  440.986 ms
	 9  108.170.231.111 (108.170.231.111)  441.912 ms  274.932 ms  173.638 ms
	10  66.249.95.247 (66.249.95.247)  189.124 ms  190.405 ms  137.513 ms
	11  par21s12-in-f4.1e100.net (172.217.22.132)  154.082 ms  178.191 ms  194.057 ms

Vers la Namibie (22 hops)

	traceroute to 196.216.167.71 (196.216.167.71), 30 hops max, 60 byte packets
	 1  _gateway (192.168.43.1)  8.797 ms  9.603 ms  9.985 ms
	 2  10.88.0.1 (10.88.0.1)  62.092 ms  100.021 ms  100.237 ms
	 3  192.168.253.30 (192.168.253.30)  101.123 ms  102.747 ms  119.587 ms
	 4  192.168.255.38 (192.168.255.38)  140.270 ms  142.792 ms  143.563 ms
	 5  194.149.164.92 (194.149.164.92)  139.117 ms  142.525 ms  144.074 ms
	 6  194.149.166.117 (194.149.166.117)  158.768 ms  150.428 ms  154.083 ms
	 7  * * *
	 8  * * *
	 9  be2102.ccr41.par01.atlas.cogentco.com (154.54.61.17)  88.595 ms  80.099 ms  74.733 ms
	10  be12497.ccr41.lon13.atlas.cogentco.com (154.54.56.129)  73.700 ms  74.763 ms  79.733 ms
	11  be2053.rcr21.b015591-1.lon13.atlas.cogentco.com (130.117.2.66)  109.787 ms  94.775 ms  95.603 ms
	12  204.68.252.78 (204.68.252.78)  97.220 ms  55.502 ms  52.860 ms
	13  41.181.189.69 (41.181.189.69)  79.387 ms  76.443 ms  75.850 ms
	14  41.181.190.150 (41.181.190.150)  72.622 ms  79.998 ms  88.222 ms
	15  41.181.189.93 (41.181.189.93)  88.636 ms  105.839 ms  115.690 ms
	16  196.44.0.29 (196.44.0.29)  307.374 ms  302.013 ms  305.104 ms
	17  196.44.30.241 (196.44.30.241)  289.720 ms  317.263 ms  280.019 ms
	18  cr2.wdh1.na--cr1.wdh5.na.mtnns.net (196.20.9.0)  296.804 ms  327.490 ms  311.574 ms
	19  gw3.wdh1.na--cr2.wdh1.na.mtnns.net (196.20.9.7)  307.757 ms  264.050 ms  277.917 ms
	20  196.31.245.27 (196.31.245.27)  272.674 ms  309.196 ms  296.065 ms
	21  196.12.10.249 (196.12.10.249)  283.975 ms  272.605 ms  261.687 ms
	22  196.216.167.71 (196.216.167.71)  274.054 ms  292.105 ms  255.844 ms

Vers la Nouvelle-Zélande (12 hops)

	traceroute to www.victoria.ac.nz (151.101.66.49), 30 hops max, 60 byte packets
	 1  _gateway (192.168.43.1)  9.515 ms  10.807 ms  11.054 ms
	 2  10.88.0.1 (10.88.0.1)  34.250 ms  56.092 ms  57.466 ms
	 3  192.168.253.30 (192.168.253.30)  57.663 ms  59.501 ms  60.338 ms
	 4  192.168.255.38 (192.168.255.38)  67.033 ms  68.321 ms  68.423 ms
	 5  194.149.164.92 (194.149.164.92)  62.287 ms  63.331 ms  73.068 ms
	 6  194.149.166.117 (194.149.166.117)  74.416 ms  65.257 ms  64.971 ms
	 7  * * *
	 8  * * *
	 9  be2103.ccr42.par01.atlas.cogentco.com (154.54.61.21)  49.533 ms  50.177 ms  50.217 ms
	10  be2922.rcr21.b032899-0.par01.atlas.cogentco.com (130.117.1.162)  41.495 ms  38.177 ms  48.934 ms
	11  netdna-gw.cdg.ip4.cogentco.com (149.6.114.82)  48.959 ms  46.021 ms  46.051 ms
	12  151.101.66.49 (151.101.66.49)  46.732 ms  79.161 ms  79.745 ms

Q21.

|Site|IP|
|-|-|
|www.free.fr|212.27.48.10, 2a01:e0c:1::1|
|www.insa-rennes.fr|193.52.94.51 (pas d'IPv6)|

## TCP et HTTP

Q22. Le port utilisé est TCP 443 qui correspond bien au service HTTPS.
Q23. L'en-tête TCP fait 32 bytes.
Q24. La segment length est mise à 0 pour les trois paquets du handshake (aucune donnée propre n'est échangée).
Q25. Wireshark affiche un numéro de séquence initial à "0" (c'est une simplification qui aide à la lecture). En réalité le numéro aléatoirement choisi par le noyau pour initialiser la séquence TCP est 238730258. La window length (taille du nombre de bytes qui peuvent être envoyées sans recevoir immédiatement d'acknowledgement, et nombre maximal de bytes qui peuvent être acknowledged d'un coup) est 64860. 
Q26. On regarde le deuxième paquet (SYN-ACK), où je n'ai malheureusement pas de trame ethernet (vu que je suis dans un tunnel vpn), mais si je n'y avais pas été, j'aurais eu une addresse source à 'a4:4e:31:08:ac:84', et une adresse destination à '0c:70:4A:F8:8A:47', et un type `0x0800` (IPv4). Pour le paquet IP, la source *dans le tunnel* est `10.8.1.135`, la destination est `51.91.58.45`. Le numéro d'ACK du deuxième paquet est 1 en relatif, mais 238730259 en absolu. Sa séquence initiale en absolu est initialisée à 1347695507. Il annonce une fenêtre de taille 64296.
Q27. Le MSS est donc de 64296 (le minimum entre les deux fenêtres).
Q28. L'ACK du dernier fragment est 1347695508, et sa séquence est 238730259. Sa winlen = 64896.
Q29. Je sais comment ça marche bon
Q30. 
