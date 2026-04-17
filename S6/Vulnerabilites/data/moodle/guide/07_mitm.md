# Chapitre 7 -- Attaques Man-in-the-Middle

> Source : intro_mim-annotated.pdf
> Objectif : comprendre les attaques MitM, le protocole NSPK, l'attaque de Lowe, et la correction NSPKL

---

## 7.1 Concept du Man-in-the-Middle

### Definition

> **Attaque Man-in-the-Middle (MitM) :**
> Attaque ou l'adversaire intercepte et potentiellement modifie les communications entre deux parties qui pensent communiquer directement l'une avec l'autre.

### Analogie du cours : echecs par correspondance

```
Kasparov                    Trump (MitM)                 Karpov
    |                           |                           |
    |   e2-e4                   |                           |
    |-------------------------->|   e2-e4                   |
    |                           |-------------------------->|
    |                           |                           |
    |                           |   d7-d5                   |
    |   d7-d5                   |<--------------------------|
    |<--------------------------|                           |
    |                           |                           |
    |   e4xd5                   |                           |
    |-------------------------->|   e4xd5                   |
    |                           |-------------------------->|
```

Trump joue simultanement contre Kasparov et Karpov. Il relaie les coups de l'un a l'autre. Resultat : Trump fait "match nul" contre deux grands maitres sans savoir jouer aux echecs.

**Point cle :** Trump n'a aucune competence en echecs, il ne fait que relayer. De meme, un attaquant MitM n'a pas besoin de casser la cryptographie.

---

## 7.2 Modele d'attaquant Dolev-Yao (rappel)

Dans le contexte des protocoles de securite, on utilise le modele de Dolev-Yao :

```
Hypotheses :
    +-- La cryptographie est parfaite
    +-- Les messages sont des termes abstraits
    +-- Le reseau est entierement controle par l'adversaire

Capacites de l'attaquant :
    +-- Intercepter tout message sur le reseau
    +-- Bloquer des messages
    +-- Inserer des messages forges
    +-- Modifier des messages en transit
    +-- Participer au protocole en tant qu'agent (avec ses propres cles)
```

**Important :** L'attaquant Dolev-Yao est un attaquant **actif**. Il ne peut pas casser la cryptographie, mais il controle entierement le reseau.

---

## 7.3 Le protocole NSPK (Needham-Schroeder Public Key)

### Historique

- Propose en **1978** par Needham et Schroeder
- Prouve "correct" avec la logique BAN
- Utilise pendant **17 ans** dans des applications commerciales
- Attaque decouverte par **Gavin Lowe en 1995/1996**

### Description du protocole

```
     pk(r), sk(i)               pk(i), sk(r)
          i                          r
          |                          |
          | nonce n                  |
          |   {(n, i)}pk(r)          |   Message 1
          |------------------------->|
          |                          |
          |                          | nonce m
          |   {(n, m)}pk(i)          |   Message 2
          |<-------------------------|
          |                          |
          |   {m}pk(r)               |   Message 3
          |------------------------->|
```

### Fonctionnement prevu

1. **Message 1 :** `i` genere un nonce `n` et l'envoie a `r`, chiffre avec `pk(r)`
   - Seul `r` peut lire ce message (car il possede `sk(r)`)
   - `i` inclut son identite pour que `r` sache qui parle

2. **Message 2 :** `r` repond avec `n` (preuve qu'il a lu le message 1) et un nouveau nonce `m`
   - Chiffre avec `pk(i)` : seul `i` peut lire
   - `n` prouve a `i` que `r` a bien recu le message 1

3. **Message 3 :** `i` renvoie `m` chiffre avec `pk(r)`
   - Prouve a `r` que `i` a bien recu le message 2

### Le raisonnement (apparemment correct)

```
"Seul r peut lire le message 1" --> OK (chiffre avec pk(r))
"Apres reception du message 2 contenant n, i est sur de parler a r" --> FAUX !
"Seul i peut lire le message 2" --> OK (chiffre avec pk(i))
"Apres reception du message 3 contenant m, r est sur de parler a i" --> FAUX !
```

---

## 7.4 L'attaque de Lowe sur NSPK

### Description complete

```
     Bob                    Eve                      Alice
     (pense parler         (Man-in-the-Middle)      (pense parler
      a Eve)                                         a Bob)

     pk(Eve), sk(Bob)      pk(Bob), pk(Alice)       pk(Bob), sk(Alice)
                            sk(Eve)
          |                     |                        |
          | nonce n             |                        |
          | {(n, Bob)}pk(Eve)   |                        |
    (1)   |-------------------->|                        |
          |                     |                        |
          |                     | {(n, Bob)}pk(Alice)    |
          |                (1') |----------------------->|
          |                     |                        |
          |                     |                        | nonce m
          |                     | {(n, m)}pk(Bob)        |
          |                (2') |<-----------------------|
          |                     |                        |
          | {(n, m)}pk(Bob)     |                        |
    (2)   |<--------------------|                        |
          |                     |                        |
          | {m}pk(Eve)          |                        |
    (3)   |-------------------->|                        |
          |                     |                        |
          |                     | {m}pk(Alice)           |
          |                (3') |----------------------->|
          |                     |                        |
                                               Alice pense :
                                               "Je parle a Bob"
                                               FAUX !
```

### Deroulement pas a pas

1. **Bob initie une session avec Eve** (scenario normal : Bob veut parler a Eve)
   - Bob envoie `{(n, Bob)}pk(Eve)` a Eve

2. **Eve ouvre une session parallele avec Alice** en se faisant passer pour Bob
   - Eve dechiffre le message de Bob (elle a `sk(Eve)`) et obtient `n`
   - Eve rechiffre `{(n, Bob)}pk(Alice)` et l'envoie a Alice

3. **Alice repond a "Bob"**
   - Alice croit parler a Bob
   - Alice genere `m` et repond `{(n, m)}pk(Bob)`
   - Eve ne peut PAS lire ce message (chiffre avec `pk(Bob)`)

4. **Eve relaie la reponse a Bob**
   - Eve transmet `{(n, m)}pk(Bob)` a Bob dans la session originale
   - Bob dechiffre, trouve `n` (son propre nonce) et `m`
   - Bob repond `{m}pk(Eve)` (car il pense parler a Eve)

5. **Eve obtient m et le transmet a Alice**
   - Eve dechiffre `{m}pk(Eve)` et obtient `m`
   - Eve rechiffre `{m}pk(Alice)` et l'envoie a Alice

6. **Alice est convaincue de parler a Bob**
   - Alice recoit `m` correctement, mais c'est Eve qui l'a relaie

### Consequence grave

```
     Consequence bancaire :

     Client i (victime)     Site frauduleux (Eve)     Banque r (Alice)
          |                        |                       |
          |  S'authentifie         |                       |
          |  aupres d'"Eve"        |   Relaie vers la      |
          |----------------------->|   banque en se         |
          |                        |   faisant passer       |
          |                        |   pour le client       |
          |                        |----------------------->|
          |                        |                        |
          |                        |   La banque pense      |
          |                        |   parler au client     |
          |                        |<-----------------------|
          |                        |                        |
          |                        | "Transferer 5000 EUR   |
          |                        |  du compte de i..."    |
          |                        |----------------------->|
```

---

## 7.5 La correction de Lowe : NSPKL

### Le probleme dans NSPK

Dans le message 2 original `{(n, m)}pk(i)`, rien n'indique **qui** a genere `m`. Alice genere le message 2 et Eve le relaie a Bob, qui pense que c'est Eve qui l'a genere.

### La correction

Ajouter l'identite du repondeur `r` dans le message 2 :

```
     pk(r), sk(i)               pk(i), sk(r)
          i                          r
          |                          |
          | nonce n                  |
          |   {(n, i)}pk(r)          |   Message 1
          |------------------------->|
          |                          |
          |                          | nonce m
          |   {(n, m, r)}pk(i)       |   Message 2 (CORRIGE)
          |<-------------------------|
          |                          |
          |   {m}pk(r)               |   Message 3
          |------------------------->|
          |                          |
        [ni-synch]              [ni-synch]
        [secret n]              [secret n]
        [secret m]              [secret m]
```

### Pourquoi ca corrige l'attaque

Dans l'attaque de Lowe :
- Eve relaie le message 2 d'Alice : `{(n, m, Alice)}pk(Bob)`
- Bob dechiffre et trouve `r = Alice` au lieu de `r = Eve`
- Bob detecte l'incoherence : il pense parler a Eve mais le message contient l'identite d'Alice
- L'attaque echoue

### Verification

Le protocole corrige (NSPKL) satisfait :
- Non-injective synchronization
- Secret de `n` et `m`
- Verifie par l'outil **Scyther** (verification automatique de protocoles)

---

## 7.6 Lecons importantes

### Ce que NSPK nous apprend

```
1. "Notre application est securisee car nous utilisons
    les algorithmes cryptographiques les plus recents."
    --> FAUX : la crypto parfaite n'empeche pas les attaques sur les protocoles

2. "Nos ingenieurs ont examine le protocole un moment
    et n'ont pas trouve d'erreurs."
    --> INSUFFISANT : NSPK a ete utilise 17 ans avant la decouverte de l'attaque

3. "Nous avons trouve ce protocole dans la litterature,
    donc on peut l'utiliser en toute securite."
    --> FAUX : en 2008, Google a deploye un protocole avec une vulnerabilite
               similaire a NSPK, 12 ans apres la publication de l'attaque de Lowe
```

### Outils de verification automatique

- **Scyther** : [https://people.cispa.io/cas.cremers/scyther/](https://people.cispa.io/cas.cremers/scyther/)
- Permet de verifier automatiquement si un protocole satisfait des proprietes de securite
- A trouve l'attaque sur NSPK en quelques secondes
- Utilise dans le cours avec des fichiers `.spdl`

---

## 7.7 Exemple en langage Scyther

```
protocol auth-mim(r, p) {
    role r {
        fresh n: Nonce;
        send_1(r, p, n);
        recv_2(p, r, {n}sk(p));
        claim_3(r, Weakagree);
    }
    role p {
        var v: Nonce;
        recv_1(r, p, v);
        send_2(p, r, {v}sk(p));
    }
}
```

---

## 7.8 Exercice type : corriger un protocole MitM

### Protocole challenge-response vulnerable

```
        pk(p)                    pk(p), sk(p)
          r                          p
          |                          |
          | nonce n                  |
          |       n                  |
          |------------------------->|
          |                          |
          |     {n}sk(p)             |
          |<-------------------------|
          |                          |
        [auth p]                     |
```

**Exercice du cours :** Proposer une correction pour empecher un MitM.

**Piste de solution :** Inclure l'identite du destinataire dans le message signe, ou utiliser un protocole bidirectionnel ou les deux parties prouvent leur identite.

---

## 7.9 Pieges courants

1. **Penser que le chiffrement empeche le MitM** : non, Eve peut relayer des messages chiffres meme sans les lire (comme dans NSPK)
2. **Oublier que l'attaquant peut initier des sessions** : dans Dolev-Yao, Eve peut contacter n'importe qui
3. **Ne pas voir les sessions paralleles** : l'attaque de Lowe utilise DEUX sessions simultanees
4. **Croire que la correction est triviale** : il a fallu ajouter UNE seule information (l'identite de `r` dans le message 2) pour corriger NSPK
5. **Confondre NSPK et NSPKL** : NSPK est vulnerable, NSPKL est corrige (ajout de `r` dans le message 2)

---

## 7.10 Recapitulatif

```
MAN-IN-THE-MIDDLE
    |
    +-- Concept : intercepter et relayer les communications
    |
    +-- Modele Dolev-Yao : controle total du reseau
    |
    +-- NSPK :
    |       +-- Protocole de 1978 (Needham-Schroeder)
    |       +-- 3 messages avec nonces et chiffrement asymetrique
    |       +-- Utilise 17 ans avant decouverte de l'attaque
    |
    +-- Attaque de Lowe (1996) :
    |       +-- Eve ouvre une session parallele
    |       +-- Relaie les nonces entre Bob et Alice
    |       +-- Alice croit parler a Bob
    |
    +-- Correction NSPKL :
    |       +-- Ajouter l'identite de r dans le message 2
    |       +-- {(n, m, r)}pk(i) au lieu de {(n, m)}pk(i)
    |
    +-- Lecons :
            +-- La cryptographie seule ne suffit pas
            +-- Les protocoles doivent etre verifies formellement
            +-- Utiliser des outils comme Scyther
```
