# Chapitre 1 -- Introduction a la securite informatique

> Sources : 2026-Vulnerabilities.pdf, intro.pdf, C1-annotated.pdf
> Objectif : comprendre les concepts fondamentaux de securite avant d'aborder les vulnerabilites specifiques

---

## 1.1 Qu'est-ce que la securite informatique ?

### Adages fondamentaux du cours

- **"Lorsque vous etes connecte a Internet... Internet est connecte a vous"** -- toute machine connectee est potentiellement exposee.
- **"We're Not a Target"** -- faux. Les vers et attaques automatisees ne ciblent pas specifiquement : elles balayent tout.
- **"Security is a process, not a product"** -- la securite n'est pas un logiciel qu'on installe, c'est une demarche continue.
- **"Trust, but verify"** -- ne jamais faire confiance aveuglment, toujours verifier.

### Definitions de base

| Terme | Definition |
|-------|-----------|
| **Vulnerabilite** | Point faible d'un systeme (logiciel, materiel, organisation, reseau...) |
| **Attaque** | Exploitation d'une vulnerabilite par un acteur malveillant pour obtenir des donnees, des privileges, etc. |
| **Surface d'attaque** | Ensemble de toutes les vulnerabilites exploitables d'un systeme |
| **Contre-mesure** | Mecanisme de defense pour prevenir ou attenuer une attaque |

---

## 1.2 La triade CIA

La triade CIA est le modele fondamental pour evaluer la securite d'un systeme.

```
            +-------------------+
            | CONFIDENTIALITE   |
            | (ne pas divulguer)|
            +--------+----------+
                     |
        +------------+------------+
        |                         |
+-------v--------+      +--------v-------+
| INTEGRITE      |      | DISPONIBILITE  |
| (ne pas alterer)|      | (rester access.)|
+----------------+      +----------------+
```

### Confidentialite (Confidentiality)

- **But** : empecher l'acces non autorise a l'information
- **Origine** : domaine militaire
- **Exemple** : chiffrer un message `send({m}K)` pour que seul le destinataire puisse le lire
- **Violation** : un attaquant lit des emails confidentiels, vole une base de donnees

### Integrite (Integrity)

- **But** : garantir que l'information n'est pas modifiee de maniere non autorisee
- **Origine** : domaine bancaire
- **Exemple** : signer un message `send("Payez 42M", {h("Payez 42M")}Kpriv)` pour empecher sa modification
- **Violation** : un attaquant modifie le montant d'un virement bancaire

### Disponibilite (Availability)

- **But** : garantir que le systeme et les informations sont accessibles quand necessaire
- **Origine** : domaine des telecoms
- **Exemple** : s'assurer qu'un service d'urgence reste joignable
- **Violation** : attaque DDoS qui rend un site web inaccessible

### Au-dela de CIA

Le cours mentionne d'autres proprietes de securite importantes :

| Propriete | Description |
|-----------|------------|
| **Secret (Secrecy)** | Garder une information secrete (mais secrete pour qui ?) |
| **Authentification** | S'assurer de l'identite d'un interlocuteur |
| **Anonymat** | Ne pas reveler qui a effectue une action |
| **Non-repudiation** | Ne pas pouvoir nier avoir effectue une action |
| **Non-chainabilite (Unlinkability)** | Un adversaire ne peut pas determiner si deux evenements sont lies |

---

## 1.3 Qu'est-ce qu'une vulnerabilite ?

Une vulnerabilite peut etre :

```
Vulnerabilite
    |
    +-- Bug logiciel ou materiel
    |       (avec consequences nefastes)
    |
    +-- Defaut de conception
    |       (pouvoir creer un user de niveau superieur,
    |        defauts dans les protocoles)
    |
    +-- Defaut de configuration
    |       (mot de passe par defaut, service inutile)
    |
    +-- Serie de negligences
    |
    +-- Mauvais apprentissage
    |
    +-- ...
```

### Exemples concrets du cours

**Exemple 1 : Supermicro IPMI**
```
Cible    : Supermicro IPMI sur a.b.c.d
Verifier : nmap -p 49152 a.b.c.d    -->  49152/tcp open unknown
Exploiter: wget http://a.b.c.d:49152/psblock
Analyser : strings psblock  -->  ...adminMaudePace...
Remedier : mettre a jour ! Considerer le mot de passe comme compromis.
```

**Exemple 2 : Heartbleed (CVE-2014-0160)**
- Vulnerabilite dans OpenSSL permettant de lire la memoire du serveur
- Impact : vol de cles privees, mots de passe, donnees confidentielles

**Exemple 3 : ShellShock (CVE-2014-6271)**
- Injection de commandes via les variables d'environnement Bash
- Impact : execution de code arbitraire a distance

**Exemple 4 : PwnKit (CVE-2021-4034)**
- Elevation de privileges via polkit
- Impact : un utilisateur standard devient root

---

## 1.4 Divulgation des vulnerabilites

Quand une vulnerabilite est decouverte, trois approches existent :

```
Decouverte d'une vulnerabilite
            |
    +-------+--------+------------+
    |                |             |
    v                v             v
Full Disclosure  Non-Disclosure  Responsible Disclosure
(publication     (non publiee,   (cooperation
 directe)         patch           inventeur/editeur,
                  silencieux)     delai ~3 mois,
                                  role des CERTs)
```

**Tendance recente : Bug Bounty** -- les entreprises recompensent financierement les chercheurs qui signalent des vulnerabilites de maniere responsable (exemples : programmes Google, Meta, Microsoft).

---

## 1.5 CVE : nommer les vulnerabilites

**CVE = Common Vulnerabilities and Exposures**

- Base de donnees qui recense et nomme les vulnerabilites
- Geree par MITRE : [https://cve.mitre.org/](https://cve.mitre.org/)
- Format : `CVE-ANNEE-NUMERO`

| Vulnerabilite | CVE | Description |
|--------------|-----|-------------|
| ShellShock | CVE-2014-6271 | Injection via variables d'env Bash |
| Heartbleed | CVE-2014-0160 | Fuite memoire OpenSSL |
| PwnKit | CVE-2021-4034 | Elevation de privileges polkit |

---

## 1.6 CVSS : mesurer la gravite

**CVSS = Common Vulnerability Scoring System**

### Echelle de gravite

| Score | Niveau |
|-------|--------|
| 0 -- 3.9 | LOW (faible) |
| 4.0 -- 6.9 | MEDIUM (moyen) |
| 7.0 -- 8.9 | HIGH (eleve) |
| 9.0 -- 10.0 | CRITICAL (critique) |

### Exemples de scores

| Vulnerabilite | CVSSv3.1 | Niveau |
|--------------|----------|--------|
| ShellShock (CVE-2014-6271) | 9.8 | CRITICAL |
| Heartbleed (CVE-2014-0160) | 7.5 | HIGH |
| PwnKit (CVE-2021-4034) | 7.8 | HIGH |

### Metriques CVSS v3.1

Le score CVSS est calcule a partir de plusieurs metriques :

```
CVSS v3.1
    |
    +-- Attack Vector (AV) : N(etwork), A(djacent), L(ocal), P(hysical)
    |
    +-- Attack Complexity (AC) : L(ow), H(igh)
    |
    +-- Privileges Required (PR) : N(one), L(ow), H(igh)
    |
    +-- User Interaction (UI) : N(one), R(equired)
    |
    +-- Scope (S) : U(nchanged), C(hanged)
    |
    +-- Impact :
         +-- Confidentiality (C) : N(one), L(ow), H(igh)
         +-- Integrity (I) : N(one), L(ow), H(igh)
         +-- Availability (A) : N(one), L(ow), H(igh)
```

### Exemple de notation CVSS

Pour Heartbleed :
```
CVSSv3.1: 7.5  AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:N/A:N
```
Lecture : vecteur reseau, complexite basse, aucun privilege requis, aucune interaction utilisateur, scope inchange, impact confidentialite haute, pas d'impact integrite ni disponibilite.

### CVSS v4 (depuis 2023)

La version 4 ajoute des metriques supplementaires (AT: Attack Requirements, VC/VI/VA pour les impacts sur le composant vulnerable, SC/SI/SA pour les impacts sur les composants subsequents). Le cours montre que les scores evoluent d'une version a l'autre.

---

## 1.7 Modeles d'attaquant

### Attaquant passif vs actif

| Type | Capacites |
|------|-----------|
| **Passif** | Observe le systeme, ecoute les communications reseau, mais ne peut pas interagir |
| **Actif** | Observe ET interagit : peut envoyer, bloquer, modifier des messages |

### Types d'attaques cryptographiques

| Attaque | Description | Type |
|---------|------------|------|
| Ciphertext-only | L'adversaire n'a que le chiffre | Passif |
| Known-plaintext | L'adversaire a le chiffre et le clair correspondant | Passif |
| Chosen-plaintext | L'adversaire choisit des clairs a chiffrer | Actif |
| Chosen-ciphertext | L'adversaire choisit des chiffres a dechiffrer | Actif |

### Modele de Dolev-Yao

C'est le modele d'attaquant standard pour les protocoles de securite :

```
Hypotheses :
- Cryptographie parfaite (on ne casse pas le chiffrement sans la cle)
- Messages = termes abstraits
- Le reseau est ENTIEREMENT controle par l'adversaire

Capacites de l'attaquant Dolev-Yao :
- Intercepter tout message envoye sur le reseau
- Bloquer des messages
- Inserer des messages forges
- Modifier des messages en transit
```

**Question piege** : Dolev-Yao est-il un attaquant passif ou actif ? **Reponse** : actif (il peut modifier et inserer des messages).

---

## 1.8 Eviter les vulnerabilites : principes generaux

### Secure Coding

Les principes de base pour eviter les vulnerabilites :

1. **Faire moins confiance** : minimiser la base de confiance (trusted base)
2. **Verifier les parametres** : en entree ET en sortie, au moment de l'usage
3. **Changer les configs par defaut** : notamment les mots de passe par defaut, a l'installation ET apres les mises a jour

### Principe de Kerckhoffs

> Un systeme cryptographique doit etre securise meme si tout, sauf la cle, est connu publiquement.

Autrement dit : **pas de securite par l'obscurite** (security by obscurity). La securite ne doit pas reposer sur le secret du mecanisme mais sur le secret de la cle.

---

## 1.9 Inference de messages (notation du cours)

Ce tableau recapitule les operations que chaque partie peut effectuer sur les messages :

| Ce qu'on connait | Ce qu'on peut en deduire |
|-----------------|------------------------|
| `m` | `m` (identite) |
| `m1, m2` | `(m1, m2)` (paire) |
| `m, k` | `{m}k` (chiffrement) |
| `m1,...,mk` | `f(m1,...,mk)` (application de fonction) |
| `(m1, m2)` | `m1, m2` (decomposition) |
| `{m}k, k^(-1)` | `m` (dechiffrement) |

Avec :
- Chiffrement symetrique : `k^(-1) = k`
- Chiffrement asymetrique : `pk(i)^(-1) = sk(i)` et `sk(i)^(-1) = pk(i)`

---

## 1.10 Notations du cours

| Notation | Signification |
|----------|--------------|
| `pk(i)` | Cle publique de i |
| `sk(i)` | Cle privee de i |
| `{m}pk(i)` ou `enc(m, pk(i))` | Chiffrement de m avec la cle publique de i |
| `{m}sk(i)` ou `sig(m, sk(i))` | Signature de m avec la cle privee de i |
| `k(i,r)` ou `k` | Cle symetrique partagee entre i et r |
| `{m}k` ou `enc(m, k)` | Chiffrement symetrique de m avec k |
| `nonce n` | Nombre utilise une seule fois (aleatoire) |
| `h(m)` | Hachage de m |

---

## 1.11 Pieges courants en DS

1. **Confondre integrite et confidentialite** : chiffrer assure la confidentialite, signer assure l'integrite
2. **Oublier la disponibilite** : c'est la troisieme composante de CIA, souvent negligee
3. **Penser que la cryptographie suffit** : une cryptographie parfaite n'empeche pas les attaques sur les protocoles (cf. NSPK)
4. **Ignorer le modele d'attaquant** : une attaque n'existe que dans un modele donne (Dolev-Yao =/= attaquant passif)
5. **Confondre CVE et CVSS** : CVE = identifiant unique, CVSS = score de gravite
6. **Mal lire un vecteur CVSS** : AV:N signifie "attaque via le reseau" (plus grave que AV:P "physique")
7. **Oublier que Dolev-Yao est actif** : il controle tout le reseau

---

## 1.12 Recapitulatif

```
SECURITE INFORMATIQUE
    |
    +-- Triade CIA : Confidentialite, Integrite, Disponibilite
    |
    +-- Vulnerabilite : bug, defaut conception, defaut config, negligence
    |
    +-- CVE : identifiant unique (CVE-YYYY-NNNNN)
    |
    +-- CVSS : score de gravite (0-10), metriques (AV, AC, PR, UI, S, C, I, A)
    |
    +-- Modeles d'attaquant : passif, actif, Dolev-Yao
    |
    +-- Principes : least privilege, defense in depth, Kerckhoffs
    |
    +-- Divulgation : full/non/responsible disclosure, bug bounty
```
