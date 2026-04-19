# Chapitre 3 -- Architecture des processeurs

## 3.1 Vue d'ensemble

Un processeur se decompose en deux unites principales :

- **UT (Unite de Traitement / Chemin de donnees)** : Contient les registres, l'UAL, les bus et effectue les calculs
- **UC (Unite de Commande)** : Genere les signaux de commande pour orchestrer l'UT en fonction de l'instruction courante et des conditions

```
                +------------------+
   Entrees ---->|                  |----> Sorties
                |   UT (Donnees)   |
                |                  |
                +--------+---------+
                         |
              conditions |  commandes
                         |
                +--------+---------+
                |                  |
                |  UC (Commande)   |
                |                  |
                +------------------+
```

L'UC envoie des **commandes** (signaux de controle) a l'UT. L'UT envoie des **conditions** (drapeaux d'etat) a l'UC. Cette separation est le fondement de toute conception de processeur.

---

## 3.2 Unite de Traitement (UT / Chemin de donnees)

### Composants

| Composant | Role | Exemple |
|-----------|------|---------|
| Registres | Stocker les valeurs de donnees | N0, N1, Q, N dans la machine Fibonacci |
| UAL | Arithmetique et logique | Additionneur, comparateur |
| Bus | Transferer les donnees entre composants | Bus de donnees interne |
| Tampons trois-etats | Controler l'acces au bus | Activer/desactiver les sorties sur un bus partage |
| Multiplexeurs | Selectionner les sources de donnees | Choisir quel registre alimente l'entree de l'UAL |

### Operations sur les registres

Chaque registre possede des signaux de commande :
- **Chargement (LD)** : Quand actif, le registre capture la valeur du bus au prochain front d'horloge
- **Activation de sortie (OE)** : Quand actif, le registre place sa valeur sur le bus

### Operations de l'UAL

L'UAL effectue les operations selectionnees par les signaux de commande :
- Addition, soustraction
- ET, OU, XOR, NON
- Decalage a gauche, decalage a droite
- Comparaison (genere les drapeaux de condition)

### Drapeaux de condition

L'UT genere des drapeaux envoyes a l'UC :

| Drapeau | Nom | Signification |
|---------|-----|---------------|
| Z | Zero | Le resultat est zero |
| N | Negatif | Le resultat est negatif (MSB = 1) |
| C | Retenue (Carry) | Debordement non-signe |
| V | Debordement (oVerflow) | Debordement signe |

---

## 3.3 Unite de Commande (UC)

L'UC est elle-meme une machine a etats finis. Elle peut etre implementee de deux facons :

### 1. Commande cablee (Microprogrammation horizontale)

L'UC est construite directement a partir de logique combinatoire et sequentielle. Du circuit Logisim 7-memory-horizontal :

- Chaque etat est code avec des bascules
- La logique de transition est implementee avec des portes
- Rapide mais inflexible -- les modifications necessitent un recablage

### 2. Commande microprogrammee (Microprogrammation verticale)

L'UC utilise une ROM (memoire morte) pour stocker les micro-instructions. Du circuit Logisim 8-memory-vertical :

- Chaque adresse en ROM correspond a un etat
- Le contenu de la ROM definit les signaux de commande et l'information d'etat suivant
- Flexible -- changer le comportement en reprogrammant la ROM
- Legerement plus lent a cause du temps d'acces a la ROM

### Sequenceur

Le sequenceur controle le flux des etats dans l'UC. Du TD5 :

Composants :
- **Compteur** : Contient l'etat courant (adresse)
- **ROM** : Stocke le microcode (commandes + cibles de saut)
- **Multiplexeur** : Selectionne la condition a evaluer
- **Logique de saut** : Decide s'il faut incrementer le compteur ou charger une nouvelle adresse

**Fonctionnement a chaque cycle d'horloge** :
1. Le compteur fournit l'adresse courante a la ROM
2. La ROM produit : bits de commande + code de saut + adresse de saut
3. Le code de saut selectionne la condition a verifier via le MUX
4. Si la condition est vraie : charger l'adresse de saut dans le compteur
5. Si la condition est fausse : incrementer le compteur

---

## 3.4 Conception du microcode (du TD5 -- Machine Fibonacci)

### Probleme

Concevoir un circuit qui calcule les nombres de Fibonacci F(n).

**Algorithme** :
```
tant que init:
    N0 = 0; N1 = 1; N = entree; Q = 0; Res = 0
tant que N > Q:
    N1 = N0 + N1; N0 = N1; Q = Q + 1   (simultane)
tant que init:
    Res = 1; afficher N0
Res = 0
```

### Conception de l'UT

Registres et commandes :
- R_N0 (registre 8 bits pour N0)
- R_N1 (registre 8 bits pour N1)
- R_N (registre 8 bits pour N, l'indice cible)
- Compteur Q (compteur 8 bits avec increment)
- Verrou Res (bascule JK pour le drapeau de resultat)

Commandes envoyees par l'UC :
- RESET : Initialiser tous les registres (N0=0, N1=1, N=entree, Q=0)
- N1_2_N0 : Charger la valeur de N1 dans N0
- SUM_N1 : Charger N0+N1 dans N1
- INC_Q : Incrementer le compteur Q
- RES_0 : Remettre Res a 0
- RES_1 : Mettre Res a 1
- OUT_N0 : Placer N0 sur le bus de sortie

Conditions envoyees a l'UC :
- init : Signal d'initialisation utilisateur
- N_GT_Q : Sortie du comparateur (N > Q)

### Conception de l'UC (Machine a etats)

| Etat | Nom | Action | Etat suivant |
|------|-----|--------|-------------|
| 0 (A) | Attente init | RESET, RES_0 | Si init : rester. Sinon : aller en 1 |
| 1 (B) | Verification boucle | (aucune) | Si N &lt;= Q : aller en 3. Sinon : aller en 2 |
| 2 (C) | Iteration | N1_2_N0, SUM_N1, INC_Q | Aller en 1 |
| 3 (D) | Affichage | RES_1, OUT_N0 | Si init : rester. Sinon : aller en 4 |
| 4 (E) | Remise a zero resultat | RES_0 | Aller en 0 |

### Codage du microcode

Chaque mot de micro-instruction (13 bits) :

```
[Code de saut (3 bits)] [Adresse de saut (3 bits)] [Commandes (7 bits)]

Commandes : N1_2_N0 | SUM_N1 | INC_Q | RES_0 | RES_1 | OUT_N0 | RESET

Etat A : 001 000 0001001    -- code saut 1 (test init), adr 0, RESET+RES_0
Etat B : 010 011 0000000    -- code saut 2 (test /N_GT_Q), adr 3, pas de commande
Etat C : 111 001 1110000    -- code saut 7 (inconditionnel), adr 1, N1_2_N0+SUM_N1+INC_Q
Etat D : 001 011 0000110    -- code saut 1 (test init), adr 3, RES_1+OUT_N0
Etat E : 111 000 0001000    -- code saut 7 (inconditionnel), adr 0, RES_0
```

### Entrees du MUX du sequenceur

| Code de saut | Condition selectionnee |
|--------------|----------------------|
| 0 | Toujours 0 (increment inconditionnel) |
| 1 | init |
| 2 | /N_GT_Q |
| 7 | Toujours 1 (saut inconditionnel) |

---

## 3.5 Architecture de la machine PGCD

La machine PGCD est un exemple cle du cours qui integre UC et UT. Voir le chapitre dedie [pgcd-arithmetic.md](pgcd-arithmetic.md) pour le traitement complet.

**Resume rapide de l'architecture** :
- L'UT contient les registres A et B, un soustracteur et un comparateur
- L'UC implemente l'algorithme d'Euclide comme machine a etats
- L'integration utilise les conditions A>B, A=B, A&lt;B pour controler la soustraction

---

## 3.6 Hierarchie memoire

### Banc de registres

Stockage le plus rapide. Directement a l'interieur du processeur. En ARM : 16 registres (r0-r15).

### Cache

Memoire petite et rapide entre le processeur et la memoire principale. Exploite :
- **Localite temporelle** : Les donnees recemment accedees seront probablement accedees a nouveau
- **Localite spatiale** : Les donnees proches de celles recemment accedees seront probablement accedees

### Memoire principale (RAM)

Plus grande, plus lente. Stocke le programme et les donnees pendant l'execution.

### ROM (memoire morte)

Non volatile. Utilisee pour :
- Le stockage du microcode dans l'UC
- Le firmware de demarrage
- Les tables de correspondance dans les circuits combinatoires

---

## 3.7 Pieges courants

1. **Confondre UC et UT** : L'UC commande, l'UT calcule. L'UC n'effectue jamais d'arithmetique sur les donnees -- elle ne fait que sequencer les operations.

2. **Conditions manquantes** : L'UC a besoin des conditions de l'UT pour prendre des decisions. Si vous oubliez de caler un resultat de comparaison vers l'UC, la machine ne peut pas brancher.

3. **Operations simultanees** : En materiel, les operations connectees a des registres differents peuvent se produire dans le meme cycle d'horloge (contrairement au code sequentiel). La machine Fibonacci exploite ceci : N0=N1 et N1=N0+N1 se produisent simultanement.

4. **Largeur du mot de microcode** : Chaque bit du mot de microcode a une signification precise. Se tromper dans l'ordre des bits signifie envoyer de mauvaises commandes a l'UT.

5. **Conflits de bus** : Ne jamais activer deux sorties sur le meme bus simultanement. Utiliser des tampons trois-etats avec des signaux d'activation mutuellement exclusifs.

6. **Nombre d'etats** : Le nombre d'etats du microcode n'est PAS egal au nombre d'etapes de l'algorithme de haut niveau. Vous pouvez avoir besoin d'etats supplementaires pour l'initialisation, la verification des conditions et le nettoyage.

---

## AIDE-MEMOIRE -- Architecture des processeurs

```
DECOMPOSITION EN DEUX UNITES :
  UT (Donnees) :  registres + UAL + bus + MUX
  UC (Commande) : MEF qui genere les signaux de commande

UC -> UT :  commandes (charger registre, activer sortie, selectionner op UAL)
UT -> UC :  conditions (zero, retenue, debordement, resultats de comparaison)

STYLES D'IMPLEMENTATION DE L'UC :
  Cablee :           Portes + bascules, rapide, inflexible
  Microprogrammee :  ROM + compteur + MUX, flexible, legerement plus lente

FONCTIONNEMENT DU SEQUENCEUR (a chaque cycle d'horloge) :
  1. Compteur -> adresse ROM
  2. ROM produit : commandes + code_saut + adresse_saut
  3. code_saut -> MUX selectionne la condition
  4. Si condition vraie : compteur <- adresse_saut (chargement)
  5. Si condition fausse : compteur <- compteur + 1 (increment)

FORMAT DU MOT DE MICROCODE :
  [Code de saut] [Adresse de saut] [Bits de commande]
  Code de saut : selectionne quelle condition (via MUX)
  Adresse de saut : ou sauter si condition verifiee
  Bits de commande : un bit par signal de commande vers l'UT

ETATS DE LA MACHINE FIBONACCI :
  A : Initialiser    B : Verifier N>Q    C : Iterer
  D : Afficher       E : Remise a zero resultat

DRAPEAUX DE CONDITION (sortie UAL) :
  Z (Zero)      N (Negatif)    C (Retenue)    V (Debordement)

METHODOLOGIE DE CONCEPTION :
  1. Ecrire l'algorithme en pseudo-code
  2. Identifier registres, operations, conditions
  3. Concevoir l'UT (registres + UAL + bus)
  4. Concevoir la machine a etats de l'UC
  5. Definir les signaux de commande et conditions
  6. Encoder le microcode en ROM
  7. Construire le sequenceur (compteur + MUX + ROM)
  8. Integrer UC + UT
```
