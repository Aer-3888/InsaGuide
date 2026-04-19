# Chapitre 4 -- Circuits Logisim

## 4.1 Vue d'ensemble

Logisim est l'outil de simulation de circuits utilise tout au long du cours CLP. Toutes les conceptions de logique numerique (combinatoire et sequentielle) sont construites et testees dans Logisim avant l'analyse theorique.

Ce chapitre repertorie tous les fichiers de circuits du cours et des TD, explique ce que chacun demontre, et fournit des conseils sur les techniques de simulation.

---

## 4.2 Reference des circuits du cours

Les circuits sont numerotes dans l'ordre pedagogique, progressant du combinatoire au sequentiel puis a la conception au niveau processeur.

### Circuits combinatoires

| Fichier | Sujet | Description |
|---------|-------|-------------|
| `0-maximum-2.circ` | Comparateur | Trouve le maximum de deux valeurs en utilisant des comparateurs et des MUX |
| `binaire2bcd.circ` | Transcodeur | Convertit le binaire en BCD (Decimal Code Binaire) |
| `Riche-Pauvre-final.circ` | Logique de jeu | Circuit de jeu combinatoire utilisant des portes logiques |
| `decalage-GD-CH-8bits.circ` | Decaleur | Circuit de decalage 8 bits gauche/droite avec direction configurable |

### Circuits sequentiels

| Fichier | Sujet | Description |
|---------|-------|-------------|
| `1-Add-modulo4.circ` | Compteur | Additionneur modulo 4 utilisant des bascules |
| `2-diviseur6-7-9-v2.circ` | Diviseur | Diviseur de frequence d'horloge (division par 6, 7 ou 9) |
| `3-registre-decalage.circ` | Registre a decalage | Demontre le fonctionnement d'un registre a decalage avec entree serie |
| `4-compteur-decompteur.circ` | Compteur | Compteur/decompteur avec commande de direction |
| `5-arbitrage-ressource.circ` | Arbitre | Circuit d'arbitrage de ressource (base sur la priorite) |
| `6-arbitrage-machine-jeton.circ` | Arbitre | Circuit d'arbitrage par jeton (tourniquet) |

### Circuits d'unite de commande

| Fichier | Sujet | Description |
|---------|-------|-------------|
| `7-memory-horizontal.circ` | UC cablee | Microprogrammation horizontale avec codage direct des etats |
| `8-memory-vertical.circ` | UC microprogrammee | Microprogrammation verticale avec commande par ROM |

### Conception complete du PGCD

| Fichier | Sujet | Description |
|---------|-------|-------------|
| `9-pgcd-ut.circ` | UT (Chemin de donnees) | Unite de traitement pour le PGCD : registres A, B, soustracteur, comparateur |
| `10-pgcd-uc1.circ` | UC v1 | Unite de commande cablee pour l'algorithme du PGCD |
| `11-pgcd-uc2.circ` | UC v2 | Unite de commande microprogrammee pour le PGCD (utilise une ROM) |
| `11-pgcd-uc2.mem` | Microcode | Contenu de la ROM pour la commande microprogrammee du PGCD |
| `12-pgcd-integration.circ` | CPU complet | Machine PGCD complete : UC + UT integrees |

### Circuits processeur

| Fichier | Sujet | Description |
|---------|-------|-------------|
| `miniCPU.circ` | Mini CPU | Processeur simplifie avec cycle recherche-decodage-execution |

---

## 4.3 Reference des circuits de TD

### TD 1 -- Logique combinatoire

| Fichier | Exercice | Ce qu'il demontre |
|---------|----------|-------------------|
| `TD1EX3.circ` | Ex 3 : Analyse de portes | Circuit avec portes ET, NON-ET, NON-OU ; deduire S = abc + d |
| `TD1EX4C1.circ` | Ex 4 : Transistor C1 | Circuit de classification categorie C1 |
| `TD1EX4C2.circ` | Ex 4 : Transistor C2 | Circuit de classification categorie C2 |
| `TD1EX4C3.circ` | Ex 4 : Transistor C3 | Circuit de classification categorie C3 |

### TD 2 -- Arithmetique et codage

| Fichier | Exercice | Ce qu'il demontre |
|---------|----------|-------------------|
| `TD2EX3.circ` | Ex 3 : UAL | Circuit calculant X+Y, 2X+Y ou X+2Y |
| `TD2EX4C1-C5.circ` | Ex 4 : Variantes d'additionneur | Differentes configurations d'additionneurs |
| `TD2EX5C2-C18.circ` | Ex 5 : Operations binaires | Divers circuits d'operations binaires |
| `TD2EX6.circ` | Ex 6 : Fonction MUX | Implementation de S avec un multiplexeur |
| `TD2EX7C1-C4.circ` | Ex 7 : VU-metre | Controleur de barre de LED utilisant decodeur + portes OU |

### TD 3 -- Circuits sequentiels et machines a etats

| Fichier | Exercice | Ce qu'il demontre |
|---------|----------|-------------------|
| `ex_3_1.circ` | Ex 1 : Conversions de bascules | Construction de RS, JK a partir de bascule D et inversement |
| `ex_3_2.circ` | Ex 2 : Machine de Moore | Deux bascules D avec retroaction par porte ET |
| `ex_3_3.circ` | Ex 3 : Detecteur de front | Detecteur de transition positive/negative |
| `ex_3_4.circ` | Ex 4 : Div-par-5 | Verificateur serie de divisibilite par 5 |

### TD 4 -- Machines a etats complexes

| Fichier | Exercice | Ce qu'il demontre |
|---------|----------|-------------------|
| `ex_4_1.circ` | Ex 1 : Basculement LED | LED commandee par bouton avec machine a etats |
| `ex_4_2.circ` | Ex 2 : Detecteur de sequence | Detecte la sequence d'entree 00,01,00,10 |
| `ex_4_4.circ` | Ex 4 : UC a compteur chargeable | Unite de commande utilisant un compteur chargeable pour le sequencement des etats |

### TD 5 -- Machine Fibonacci

| Fichier | Exercice | Ce qu'il demontre |
|---------|----------|-------------------|
| `ex_5.circ` | Fibonacci | Machine complete de calcul de Fibonacci avec UC + UT |
| `ex_5.mem` | Microcode | Contenu de la ROM pour le sequenceur de la machine Fibonacci |

---

## 4.4 Techniques de simulation

### Lancer une simulation

1. **Ouvrir** le fichier `.circ` dans Logisim
2. **Definir les valeurs d'entree** en cliquant sur les broches d'entree (elles basculent entre 0 et 1)
3. **Observer les sorties** -- elles se mettent a jour immediatement pour les circuits combinatoires
4. **Pour les circuits sequentiels** : Utiliser l'horloge (Ctrl+T pour un tick, ou utiliser le controle de vitesse d'horloge)

### Debugger les circuits sequentiels

1. **Ralentir l'horloge** pour observer les changements d'etat pas a pas
2. **Observer les etats des bascules** -- cliquer sur une bascule pour voir sa valeur courante
3. **Tracer les signaux** -- utiliser des sondes pour surveiller des fils specifiques
4. **Verifier le timing** : S'assurer de comprendre quand les sorties changent par rapport aux fronts d'horloge

### Examiner le contenu de la ROM

Pour les circuits utilisant la commande microprogrammee (comme `11-pgcd-uc2.circ`), le contenu de la ROM est dans les fichiers `.mem`.

**Format des fichiers `.mem`** :
```
v2.0 raw
c110 10001 a112 1227 1236 52f3 2cf3 10007
70
```

Chaque valeur hexadecimale est un mot de micro-instruction. L'adresse correspond au numero de l'etat.

### Problemes courants avec Logisim

- **Fils rouges** : Desaccord de largeur de bus entre les composants
- **Fils bleus** : Valeurs inconnues/non initialisees
- **Points orange** : Jonctions de fils (connexions intentionnelles) vs croisements
- **L'horloge ne tourne pas** : S'assurer que la simulation est activee (Simulate > Simulation Enabled)

---

## 4.5 Methodologie de conception de circuits

### Etape par etape pour les circuits combinatoires

1. **Ecrire la table de verite** a partir de la specification
2. **Simplifier** avec les tableaux de Karnaugh
3. **Dessiner le circuit** dans Logisim en utilisant les portes correspondant a l'expression simplifiee
4. **Verifier** en testant toutes les combinaisons d'entrees par rapport a la table de verite

### Etape par etape pour les circuits sequentiels

1. **Dessiner le diagramme d'etats** a partir de la specification
2. **Encoder les etats** en binaire
3. **Construire la table de transition** (entrees + etat courant → etat suivant)
4. **Simplifier** les fonctions de transition et de sortie avec les tableaux de Karnaugh
5. **Placer les bascules D** (une par bit d'etat)
6. **Cabler la logique combinatoire** pour les fonctions de transition et de sortie
7. **Ajouter l'horloge** et verifier avec une simulation temporelle

### Etape par etape pour l'integration UC+UT

1. **Concevoir l'UT d'abord** : identifier les registres, les operations de l'UAL, les bus
2. **Definir l'interface** : lister toutes les commandes (UC->UT) et conditions (UT->UC)
3. **Concevoir l'UC** : machine a etats implementant l'algorithme
4. **Implementer l'UC** en cable ou en microprogramme
5. **Connecter** les sorties de l'UC aux entrees de commande de l'UT, les sorties de condition de l'UT aux entrees de l'UC
6. **Tester** le systeme complet avec des paires entree/sortie connues

---

## 4.6 Pieges courants

1. **Desaccords de largeur de bus** : S'assurer que tous les fils connectes ont la meme largeur en bits. Un bus 4 bits ne peut pas se connecter directement a une entree 8 bits.

2. **Connexions d'horloge manquantes** : Chaque bascule et registre doit etre connecte au signal d'horloge. Une horloge deconnectee signifie que la bascule ne se met jamais a jour.

3. **Boucles de retroaction sans bascule** : Une retroaction directe (sortie → entree) sans bascule cree une condition de course. Toujours utiliser des elements synchrones pour la retroaction.

4. **Adressage de la ROM** : Les entrees d'adresse de la ROM doivent correspondre a la largeur de sortie du compteur. Si votre compteur produit 3 bits, la ROM doit avoir 8 entrees (2^3).

5. **Oubli du controle trois-etats** : Si plusieurs composants partagent un bus, chacun doit avoir un tampon trois-etats. Sans cela, les conflits de bus causent des valeurs indefinies.

---

## AIDE-MEMOIRE -- Circuits Logisim

```
CARTE DES FICHIERS DE CIRCUITS (progression du cours) :
  0  -> Combinatoire : maximum de deux valeurs
  1  -> Sequentiel : additionneur modulo 4
  2  -> Diviseur de frequence (6, 7, 9)
  3  -> Registre a decalage
  4  -> Compteur/decompteur
  5  -> Arbitrage de ressource (priorite)
  6  -> Arbitrage par jeton
  7  -> Microprogrammation horizontale (UC cablee)
  8  -> Microprogrammation verticale (UC par ROM)
  9  -> PGCD : Unite de Traitement (UT)
  10 -> PGCD : Unite de Commande v1 (cablee)
  11 -> PGCD : Unite de Commande v2 (microprogrammee)
  12 -> PGCD : Integration complete (UC + UT)

RACCOURCIS LOGISIM CLES :
  Ctrl+T    Un tick d'horloge
  Ctrl+K    Demarrer/arreter le tick auto
  Ctrl+R    Reinitialiser la simulation
  Ctrl+E    Basculer mode edition/simulation

FORMAT DES FICHIERS .MEM :
  v2.0 raw
  (valeurs hexadecimales separees par des espaces, une par adresse ROM)

LISTE DE VERIFICATION POUR LE DEBOGAGE :
  [ ] Tous les fils connectes (pas de bouts pendants)
  [ ] Largeurs de bus correspondantes a chaque connexion
  [ ] Horloge connectee a toutes les bascules/registres
  [ ] Tampons trois-etats sur les bus partages
  [ ] Contenu ROM charge depuis le fichier .mem
  [ ] Broches d'entree aux bonnes valeurs initiales
```
