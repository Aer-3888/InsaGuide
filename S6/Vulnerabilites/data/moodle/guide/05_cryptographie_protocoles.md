# Chapitre 5 -- Cryptographie et protocoles de securite

> Sources : C1-annotated.pdf, intro.pdf (Barbara Fila)
> Objectif : maitriser les notations cryptographiques, comprendre les protocoles de securite et leurs proprietes

---

## 5.1 Terminologie

### Vocabulaire fondamental

| Francais | Anglais | Definition |
|----------|---------|-----------|
| Texte chiffre | Ciphertext | Message rendu illisible par chiffrement |
| Texte clair | Plaintext | Message original lisible |
| Chiffrer | To encrypt | Rendre illisible a l'aide d'une cle |
| Dechiffrer | To decrypt | Retrouver le clair a partir du chiffre + cle |

**Attention en francais :**
- On ne dit PAS "crypter" --> on dit **chiffrer**
- "Decrypter" en francais signifie retrouver le clair SANS la cle (= casser le chiffrement)
- "Dechiffrer" signifie retrouver le clair AVEC la cle

---

## 5.2 Notations du cours (rappel detaille)

### Chiffrement asymetrique (cle publique)

```
pk(i)           Cle publique de i (connue de tous)
sk(i)           Cle privee de i (connue de i seul)

{m}pk(i)        Chiffrement de m avec la cle publique de i
                = enc(m, pk(i))
                Seul i peut dechiffrer (avec sk(i))

{m}sk(i)        Signature de m avec la cle privee de i
                = sig(m, sk(i))
                Tout le monde peut verifier (avec pk(i))

Propriete :     dec(enc(m, pk(i)), sk(i)) = m
```

### Chiffrement symetrique

```
k(i,r)          Cle symetrique partagee entre i et r
                (ou simplement k)

{m}k            Chiffrement symetrique de m avec k
                = enc(m, k)

Propriete :     dec(enc(m, k), k) = m
```

### Hachage et nonce

```
h(m)            Hachage de m (fonction a sens unique)
nonce n         Nombre utilise une seule fois (aleatoire, frais)
```

---

## 5.3 Hypothese de cryptographie parfaite

Le cours travaille sous l'hypothese suivante :

> **Cryptographie parfaite** : sans connaitre la cle de dechiffrement, il est impossible (au sens calculatoire) de retrouver le message chiffre. Sans connaitre le message original, il est impossible de retrouver le message a partir de son hash.

### Proprietes d'une fonction de hachage cryptographique

| Propriete | Definition |
|-----------|-----------|
| **Resistance a la pre-image** | Etant donne h(m), il est difficile de trouver m |
| **Resistance a la seconde pre-image** | Etant donne m, il est difficile de trouver m' tel que h(m) = h(m') |
| **Resistance aux collisions** | Il est difficile de trouver m et m' distincts tels que h(m) = h(m') |
| **Oracle aleatoire** | h se comporte comme une fonction aleatoire |

---

## 5.4 Inference de messages

### Regles de deduction

Ce que l'adversaire peut deduire a partir de ce qu'il connait :

```
Ce qu'on sait               Ce qu'on peut deduire        Nom
-----------                 ----------------------        ---
m                           m                             identite
m1, m2                      (m1, m2)                      paire
m, k                        {m}k                          chiffrement
m1, ..., mk                 f(m1, ..., mk)                fonction
(m1, m2)                    m1  et  m2                    decomposition
{m}k, k^(-1)                m                             dechiffrement
```

**Exemples :**
- Si on connait `{m}pk(b)` et `sk(b)`, on peut deduire `m`
- Si on connait `pk(b)` et `m`, on peut creer `{m}pk(b)`
- Si on connait seulement `{m}pk(b)` et `pk(b)`, on ne peut PAS deduire `m`

### Exercice type : M = {h(k), sk(b), {m}h(k), {m}pk(b), {p}h(h(h(m)))}

A partir de M, l'adversaire peut-il deduire :
- `h(m)` ? Non directement (il faudrait connaitre m)
- `k` ? Non (h est a sens unique, connaitre h(k) ne donne pas k)
- `h(k)` ? **Oui**, c'est directement dans M

L'adversaire peut aussi deduire `m` a partir de `{m}pk(b)` et `sk(b)`.

---

## 5.5 Principe de Kerckhoffs

> **Pas de securite par l'obscurite !**
> Un systeme cryptographique doit etre securise meme si tout ce qui le concerne, sauf la cle, est connu publiquement.

La securite repose sur le **secret de la cle**, pas sur le secret de l'algorithme.

---

## 5.6 Protocoles de communication

### Definition

Un protocole de communication est une "recette" qui decrit comment la communication doit se derouler. Il consiste en une sequence d'etapes (evenements) qui doivent etre executees dans un ordre precis pour satisfaire une propriete de securite.

### Message Sequence Charts (MSC)

Les MSC sont la notation graphique utilisee dans le cours pour representer les protocoles :

```
Connaissance initiale      Connaissance initiale
de i                       de r
     |                          |
     i                          r
     |                          |
     |       message 1          |
     |------------------------->|
     |                          |
     |       message 2          |
     |<-------------------------|
     |                          |
   [claim]                   [claim]
```

**Conventions :**
- Les axes verticaux representent les **roles** du protocole
- Les connaissances initiales sont au-dessus des noms de roles
- Les messages sont les fleches entre les roles
- Les **claims** (proprietes de securite) sont dans des boites losange
- Une boite barree = propriete violee (attaque trouvee)

---

## 5.7 Protocole Challenge-Response

### Version simple

```
        pk(p)                    pk(p), sk(p)
          r                          p
          |                          |
          |   nonce n                |
          |       n                  |
          |------------------------->|
          |                          |
          |     {n}sk(p)             |
          |<-------------------------|
          |                          |
        [auth p]                     |
```

**Fonctionnement :**
1. Le radar `r` genere un nonce `n` et l'envoie a l'avion `p`
2. L'avion `p` signe `n` avec sa cle privee et renvoie `{n}sk(p)`
3. Le radar verifie la signature avec `pk(p)`
4. Si la verification reussit, `r` est convaincu que `p` est bien l'avion attendu

**Probleme potentiel :** ce protocole peut etre vulnerable a une attaque Man-in-the-Middle (voir chapitre 7).

---

## 5.8 Secret (Secrecy)

### Definition formelle

> **Secret d'un message pour un role r :**
> Le secret d'un message est satisfait pour un role r si, chaque fois qu'un agent honnete executant le role r communique avec des agents honnetes, l'adversaire ne peut pas deduire le message.

### Secret valide

```
        pk(r)                    sk(r), pk(r)
          i                          r
          |                          |
          |  nonce n                 |
          |     {i, n}pk(r)          |
          |------------------------->|
          |                          |
        [secret n : VALIDE]          |
```

**Pourquoi c'est valide ?**
- Le message est chiffre avec `pk(r)` : seul `r` (qui possede `sk(r)`) peut dechiffrer
- Si `r` est honnete, il ne revelera pas `n`
- Donc `i` peut etre sur que l'attaquant ne connait pas `n`

### Secret invalide

```
        pk(r)                    sk(r), pk(r)
          i                          r
          |                          |
          |  nonce n                 |
          |     {i, n}pk(r)          |
          |------------------------->|
          |                          |
          |                     [secret n : INVALIDE]
```

**Pourquoi c'est invalide du point de vue de r ?**
- N'importe qui connait `pk(r)` et peut chiffrer avec
- Meme si `i` est honnete, `r` ne sait pas si le message vient vraiment de `i`
- L'attaquant a pu creer `{Eve, n_eve}pk(r)` et le `n` que `r` recoit pourrait etre connu de l'attaquant

### Correction avec chiffrement symetrique

```
        k(i,r)                   k(i,r)
          i                          r
          |                          |
          |  nonce n                 |
          |     {i, n}k(i,r)         |
          |------------------------->|
          |                          |
        [secret n : VALIDE]     [secret n : VALIDE]
```

Avec une cle symetrique partagee, seuls `i` et `r` peuvent chiffrer/dechiffrer. Si les deux sont honnetes, le secret est garanti pour les deux.

---

## 5.9 Lien avec les DS

### Type de question frequente

On vous montre un protocole et on vous demande :
1. Si une propriete de securite (secret, authentication) est satisfaite
2. De trouver une attaque qui viole cette propriete
3. De proposer une correction

### Methode de resolution

```
1. Identifier les connaissances de chaque role
2. Identifier les connaissances de l'attaquant (Dolev-Yao)
3. Pour chaque message :
   - Qui peut le creer ? (pas seulement l'emetteur prevu)
   - Qui peut le lire ? (pas seulement le destinataire prevu)
4. Verifier si la propriete de securite tient
5. Si non, decrire l'attaque avec un MSC
```

---

## 5.10 Pieges courants

1. **Confondre chiffrement et signature** : `{m}pk(i)` = chiffrement pour i ; `{m}sk(i)` = signature de i
2. **Penser que chiffrer assure l'integrite** : le chiffrement assure la confidentialite, pas l'integrite
3. **Oublier que pk(i) est publique** : n'importe qui peut chiffrer pour i, donc l'emetteur n'est pas authentifie
4. **Confondre "secret pour i" et "secret pour r"** : le secret peut etre valide pour un role mais pas l'autre
5. **Oublier que la cryptographie ne suffit pas** : un protocole peut utiliser une cryptographie parfaite et avoir des failles logiques (cf. NSPK)

---

## 5.11 Recapitulatif

```
CRYPTOGRAPHIE ET PROTOCOLES
    |
    +-- Notation : pk/sk (asym), k (sym), h (hash), nonce
    |
    +-- Hypothese : cryptographie parfaite
    |
    +-- Inference : ce qu'on peut deduire de ce qu'on sait
    |
    +-- Protocoles : MSC, roles, messages, claims
    |
    +-- Secret :
    |       +-- Valide si l'adversaire ne peut PAS deduire le message
    |       +-- Depend du ROLE considere
    |       +-- Chiffrement asym : secret valide pour l'emetteur, pas toujours pour le receveur
    |       +-- Chiffrement sym : secret valide pour les deux
    |
    +-- Principe de Kerckhoffs : pas de securite par l'obscurite
```
