# Chapitre 6 -- Authentification et mots de passe

> Sources : secrecy_auth-annotated.pdf, password_cracking.pdf
> Objectif : comprendre les differents niveaux d'authentification et les enjeux du cracking de mots de passe

---

## 6.1 Hierarchie des proprietes d'authentification

Le cours de Barbara Fila presente une hierarchie precise de proprietes d'authentification, du plus faible au plus fort.

### Vue d'ensemble

```
Non-injective synchronization (la plus forte)
          |
          v
Non-injective agreement
          |
          v
Weak aliveness in the correct role
          |
          v
Weak aliveness (la plus faible)
```

---

## 6.2 Weak Aliveness (vivacite faible)

### Definition

> **Weak aliveness :**
> Un protocole garantit a A la weak aliveness de l'agent B si, chaque fois que A complete l'execution du protocole apparemment avec B, et que B est honnete, alors B a precedemment execute le protocole.

En clair : "mon interlocuteur B est bien vivant et a participe au protocole."

### Exemple : protocole "Hello"

```
          i                          r
          |                          |
          |       "Hello"            |
          |------------------------->|
          |                          |
          |       "Hello"            |
          |<-------------------------|
          |                          |
        [weak-alive r ?]             |
```

**Probleme : attaque par miroir (mirror attack)**

```
          Bob                    Eve (se fait passer pour Alice)
          |                          |
          |       "Hello"            |
          |------------------------->|
          |                          |
          |       "Hello"            |  Eve renvoie simplement
          |<-------------------------|  le message a Bob
          |                          |
        [weak-alive Alice ?]         |
        INVALIDE : Alice n'a         |
        jamais participe !           |
```

Eve intercepte le "Hello" de Bob et le renvoie. Bob pense parler a Alice, mais Alice n'a jamais participe.

### Correction : signatures

```
     sk(i), pk(r)               sk(r), pk(i)
          i                          r
          |                          |
          |    {"Hello"}sk(i)        |
          |------------------------->|
          |                          |
          |    {"Hello"}sk(r)        |
          |<-------------------------|
          |                          |
        [weak-alive r : VALIDE]      |
```

Seul `r` possede `sk(r)`, donc seul `r` peut produire `{"Hello"}sk(r)`.

---

## 6.3 Weak Aliveness in the Correct Role

### Le probleme du role

Meme avec des signatures, un probleme subsiste :

```
     sk(Bob), pk(Alice)         sk(Alice), pk(Bob)       sk(Bob), pk(Alice)
     Bob (role i)               Alice (role i)           Bob (role r)
          |                          |                        |
          |    {"Hello"}sk(Bob)      |                        |
          |------------------------->|                        |
          |                          |                        |
          |                          |   {"Hello"}sk(Alice)   |
          |                          |----------------------->|
          |                          |                        |
          |                          |   {"Hello"}sk(Bob)     |
          |                          |<-----------------------|
          |   {"Hello"}sk(Alice)     |                        |
          |<-------------------------|                        |
          |                          |                        |
     [weak-alive Alice               |                        |
      in role r ?]                   |                        |
     INVALIDE : Alice                |                        |
     jouait le role i,               |                        |
     pas r !                         |                        |
```

Bob recoit une reponse d'Alice, mais Alice jouait le role d'initiateur dans une autre session, pas le role de repondeur. C'est un faux sentiment de securite.

### Correction

Il faut inclure des informations sur le role dans le protocole (par exemple, inclure l'identite du destinataire dans le message signe).

---

## 6.4 Agreement (accord)

### Non-injective agreement

> **Non-injective agreement :**
> Les agents s'accordent sur les partenaires de communication ET les messages recus correspondent aux messages envoyes comme specifie par le protocole.

C'est plus fort que weak aliveness car on verifie aussi le **contenu** des messages.

### Non-injective synchronization

> **Non-injective synchronization :**
> En plus de l'accord, l'ordre du protocole est respecte : les messages ne peuvent pas etre recus avant d'avoir ete envoyes.

C'est la propriete la plus forte.

---

## 6.5 Protocole NSPK et ses proprietes

Le protocole Needham-Schroeder (NSPK) est un cas d'etude central :

```
     pk(r), sk(i)               pk(i), sk(r)
          i                          r
          |                          |
          | nonce n                  |
          |   {(n, i)}pk(r)          |
          |------------------------->|
          |                          | nonce m
          |   {(n, m)}pk(i)          |
          |<-------------------------|
          |                          |
          |   {m}pk(r)               |
          |------------------------->|
```

**Propriete d'accord (ni-agree)** : ce protocole ne satisfait PAS la non-injective agreement a cause de l'attaque de Lowe (voir chapitre 7).

---

## 6.6 Exercice type : weak aliveness avec cle symetrique

```
          k                          k
          i                          r
          |                          |
          | nonce n                  |
          |      n, i                |
          |------------------------->|
          |                          |
          |      h(n, k)             |
          |<-------------------------|
          |                          |
        [weak-alive r ?]             |
```

**Analyse :**
- L'initiateur envoie un nonce `n` et son identite `i`
- Le repondeur repond avec `h(n, k)`
- Pour forger `h(n, k)`, il faut connaitre `k`
- MAIS : l'attaquant peut faire une **attaque par rejeu** (replay attack)

**Attaque par rejeu :**
1. L'attaquant observe une session precedente ou `i` envoie `n1, i` et `r` repond `h(n1, k)`
2. Dans une nouvelle session, l'attaquant bloque le vrai `r` et renvoie `h(n1, k)` quand `i` envoie `n1, i`
3. Si `i` reutilise le meme nonce, l'attaque fonctionne

---

## 6.7 Mots de passe : stockage et cracking

### Le probleme du stockage

Les mots de passe ne doivent JAMAIS etre stockes en clair. On stocke un **hash sale** :

```
Stockage correct :
    mot_de_passe --> salt + hash(salt + mot_de_passe)

Verification :
    entree_utilisateur --> hash(salt_stocke + entree_utilisateur)
    Comparer avec le hash stocke
```

### Attaques par cracking de mots de passe

Le cours reference l'article sur l'entrainement automatise d'outils de cracking.

#### Types d'attaques

| Attaque | Description | Efficacite |
|---------|-------------|-----------|
| **Brute force** | Essayer toutes les combinaisons possibles | Lent mais complet |
| **Masques** | Limiter la recherche aux mots de passe d'une structure donnee (ex: 5 lettres + 3 chiffres) | Plus rapide |
| **Dictionnaire** | Utiliser une liste de mots connus | Rapide, efficace sur les mots de passe faibles |
| **Dictionnaire + regles** | Appliquer des transformations aux mots du dictionnaire | Tres efficace |

#### Regles de mangling (transformation)

Les outils comme **hashcat** et **John the Ripper** appliquent des regles pour generer des variantes :
- Mettre la premiere lettre en majuscule
- Ajouter des chiffres a la fin
- Remplacer des caracteres (`s` --> `$`, `a` --> `@`, `e` --> `3`)
- Inverser le mot
- Combiner des mots

#### Statistiques importantes (du cours)

- Les 10 mots de passe les plus frequents representent des millions d'occurrences
- Le mot de passe le plus courant : `123456` (37 millions d'occurrences)
- Avec un entrainement adequat, on peut craquer **72.67%** des mots de passe en 10^12 essais
- Les mots de passe reels les plus frequents sont de meilleurs dictionnaires que les dictionnaires de langue naturelle

#### Mots de passe les plus courants

```
1. 123456        (37 359 195 occurrences)
2. 123456789     (16 629 796)
3. qwerty        (10 556 095)
4. password      ( 9 545 824)
5. 12345678      ( 5 119 355)
6. 111111        ( 4 833 228)
7. qwerty123     ( 4 759 446)
8. 1q2w3e        ( 4 456 640)
9. 1234567       ( 4 043 126)
10. abc123       ( 3 891 152)
```

### Outils de cracking

| Outil | Description |
|-------|-------------|
| **hashcat** | Cracking GPU, supporte de nombreux formats de hash |
| **John the Ripper** | Cracking CPU/GPU, detection automatique du format |
| **haveibeenpwned.com** | Verification si un mot de passe a ete compromis |

---

## 6.8 Exemple de DS : systeme de Barbara (Sujet 2025)

### Le probleme

Barbara genere les mots de passe avec : `5^dn(E) mod 11`
ou `dn(E)` est la date de naissance au format yyyymmdd.

### Analyse de securite

1. **Deux etudiants peuvent-ils avoir le meme mot de passe ?**
   Oui ! Car `5^x mod 11` ne prend que 10 valeurs possibles (0 a 10), et il y a bien plus de 10 etudiants.

2. **Confidentialite du mot de passe :**
   - Le systeme de calcul est connu (Kerckhoffs)
   - Si quelqu'un connait la date de naissance, il peut calculer le mot de passe
   - Les dates de naissance sont souvent publiques (reseaux sociaux)
   - Seulement 10 valeurs possibles --> brute force trivial

3. **Protection des donnees personnelles :**
   - Si la base est compromise, les mots de passe en clair sont exposes
   - A partir du mot de passe (5^dn mod 11), retrouver la date exacte n'est pas immediat (plusieurs dates donnent le meme resultat)
   - Mais l'espace des dates est petit (~40000 dates possibles), donc une attaque par enumeration est triviale

---

## 6.9 Pieges courants

1. **Confondre weak aliveness et agreement** : aliveness = "il participe", agreement = "on est d'accord sur le contenu"
2. **Oublier l'attaque par miroir** : un protocole sans signature est vulnerable a la reflexion
3. **Oublier l'attaque par rejeu** : meme avec un MAC, si le nonce est reutilise, c'est vulnerable
4. **Penser que hacher suffit** : sans sel, les rainbow tables cassent les hash rapidement
5. **Sous-estimer l'espace de recherche des mots de passe** : les humains choisissent des patterns previsibles
6. **Confondre aliveness "dans le bon role" et aliveness simple** : un agent peut etre vivant mais dans le mauvais role

---

## 6.10 Recapitulatif

```
AUTHENTIFICATION ET MOTS DE PASSE
    |
    +-- Hierarchie d'authentification :
    |       +-- Weak aliveness (le plus faible)
    |       +-- Weak aliveness in correct role
    |       +-- Non-injective agreement
    |       +-- Non-injective synchronization (le plus fort)
    |
    +-- Attaques typiques :
    |       +-- Miroir (reflexion)
    |       +-- Rejeu (replay)
    |       +-- Man-in-the-Middle (voir chapitre 7)
    |
    +-- Mots de passe :
    |       +-- Stockage : hash sale (JAMAIS en clair)
    |       +-- Cracking : brute force, dictionnaire, masques, regles
    |       +-- Outils : hashcat, john the ripper
    |       +-- Realite : 72% crackables en 10^12 essais
    |
    +-- En DS : calculer des proprietes de securite sur un protocole donne
```
