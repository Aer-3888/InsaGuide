# Chapitre 2 -- Logique sequentielle

## 2.1 Fondements

Un **circuit sequentiel** a des sorties qui dependent a la fois des entrees courantes ET de l'etat interne (memoire). Contrairement aux circuits combinatoires, les circuits sequentiels possedent un signal d'horloge et des chemins de retroaction.

**Difference cle avec le combinatoire** : Les circuits sequentiels ont de la memoire. Ils "se souviennent" des entrees passees.

### Deux modeles de machines sequentielles

| Propriete | Machine de Moore | Machine de Mealy |
|-----------|-----------------|------------------|
| La sortie depend de | L'etat uniquement | L'etat + l'entree |
| La sortie change | Uniquement au front d'horloge | Des que l'entree change |
| Necessite generalement | Plus d'etats | Moins d'etats |
| Synchronisation de la sortie | Synchronisee sur l'horloge | Peut presenter des glitchs |

---

## 2.2 Bascules

Les bascules sont les elements de memoire fondamentaux des circuits sequentiels. Chacune stocke exactement **un bit** d'information.

### Bascule D (Donnee)

La bascule la plus couramment utilisee. A chaque front montant d'horloge, la sortie Q prend la valeur de l'entree D.

```
Table de verite :
  D | Q(t+1)
  --|-------
  0 |   0
  1 |   1
```

Equation caracteristique : Q(t+1) = D

**Propriete cle** : La bascule D est la plus simple -- la sortie suit l'entree avec un delai d'un coup d'horloge.

### Bascule T (Toggle / Basculement)

Bascule sa sortie quand T=1, maintient quand T=0.

```
Table de verite :
  T | Q(t+1)
  --|-------
  0 |  Q(t)     (maintien)
  1 | /Q(t)     (basculement)
```

Equation caracteristique : Q(t+1) = T XOR Q(t)

**Construire T a partir de D** : D = T XOR Q (injecter le XOR de T et du Q courant dans l'entree D)

### Bascule JK

La bascule la plus polyvalente. J=mise a 1, K=mise a 0, J=K=1 bascule.

```
Table de verite :
  J | K | Q(t+1)
  --|---|-------
  0 | 0 | Q(t)      (maintien)
  0 | 1 |  0         (remise a zero)
  1 | 0 |  1         (mise a un)
  1 | 1 | /Q(t)      (basculement)
```

Equation caracteristique : Q(t+1) = J./Q(t) + /K.Q(t)

### Bascule RS (Set-Reset / Mise a un - Remise a zero)

Verrou de base. S=1 met la sortie a 1, R=1 remet a 0. S=R=1 est INTERDIT.

```
Table de verite :
  R | S | Q(t+1)
  --|---|-------
  0 | 0 | Q(t)      (maintien)
  0 | 1 |  1         (mise a un)
  1 | 0 |  0         (remise a zero)
  1 | 1 | INTERDIT
```

### Conversions entre bascules (du TD3)

| Construire | A partir de | Methode |
|------------|-------------|---------|
| RS depuis D | Bascule D + portes | D = S + /R.Q |
| JK depuis D | Bascule D + portes | D = J./Q + /K.Q |
| D depuis T | Bascule T + XOR | T = D XOR Q |
| D depuis JK | Bascule JK | J = D, K = /D |
| T depuis JK | Bascule JK | J = T, K = T |

---

## 2.3 Registres

Un **registre** est un groupe de bascules qui stocke une valeur multi-bits.

### Registre parallele

Tous les bits sont charges simultanement au front d'horloge. Utilise pour stocker des valeurs de donnees (adresses, operandes, resultats).

### Registre a decalage (du circuit Logisim 3-registre-decalage)

Les bits se decalent a gauche ou a droite a chaque front d'horloge. La position liberee recoit un nouveau bit d'entree.

**Applications** :
- Conversion serie vers parallele
- Conversion parallele vers serie
- Multiplication/division par des puissances de 2
- Lignes a retard

### Operations du registre a decalage

- **Decalage a gauche** : Multiplier par 2 (pour non-signe). Le MSB est perdu, 0 entre par la droite.
- **Decalage a droite** : Diviser par 2 (pour non-signe). Le LSB est perdu, 0 entre par la gauche.
- **Decalage arithmetique a droite** : Pour les nombres signes. Le MSB (bit de signe) est replique.

---

## 2.4 Compteurs

Un **compteur** est un registre qui incremente (ou decremente) sa valeur a chaque front d'horloge.

### Compteur binaire (du circuit Logisim 4-compteur-decompteur)

Compte en sequence binaire naturelle : 0, 1, 2, ..., 2^n-1, 0, 1, ...

**Compteur modulo-N** : Compte de 0 a N-1, puis revient a 0.

### Compteur/decompteur

Peut compter vers le haut ou vers le bas selon un signal de commande. Dans le circuit du cours 4-compteur-decompteur, un seul bit de commande selectionne la direction de comptage.

### Compteur chargeable

Peut etre charge avec une valeur arbitraire (utilise dans les unites de commande comme sequenceur). Essentiel pour implementer les sauts dans le microcode.

### Diviseurs de frequence (du circuit Logisim 2-diviseur6-7-9-v2)

Un compteur qui divise la frequence d'horloge par N. La sortie bascule tous les N cycles d'horloge.

**Exemple** : Diviseur par 6 -- le compteur compte 0,1,2,3,4,5 puis se remet a zero. La sortie passe a 1 pendant un cycle tous les 6 cycles.

---

## 2.5 Machines a etats finis (MEF)

Une MEF est l'abstraction fondamentale pour la conception de circuits sequentiels. Elle se compose de :
- **Etats** : Un ensemble fini de configurations internes
- **Entrees** : Signaux externes
- **Sorties** : Resultats calcules par la machine
- **Fonction de transition** : Associe (etat courant, entree) a l'etat suivant
- **Fonction de sortie** : Associe l'etat (Moore) ou (etat, entree) (Mealy) a la sortie

### Methodologie de conception

1. **Comprendre le probleme** -- quel comportement est necessaire ?
2. **Identifier les etats** -- que doit "retenir" la machine ?
3. **Dessiner le diagramme d'etats** -- des bulles pour les etats, des fleches pour les transitions
4. **Assigner les codes d'etats** -- codage binaire pour chaque etat
5. **Construire la table de transition** -- entrees + etat courant → etat suivant
6. **Construire la table de sortie** -- etat (+ entree pour Mealy) → sortie
7. **Simplifier** avec les tableaux de Karnaugh
8. **Implementer** avec des bascules et de la logique combinatoire

### Exemple detaille : Detecteur de front montant (du TD3 Exercice 3)

**Probleme** : L'entree e vaut 0 ou 1 pendant des cycles complets. La sortie s1=1 pendant un cycle apres une transition 0->1. La sortie s2=1 pendant un cycle apres une transition 1->0.

**Etats** : Deux etats bases sur la valeur precedente de l'entree :
- Etat 0 : L'entree precedente etait 0
- Etat 1 : L'entree precedente etait 1

**C'est une machine de Mealy** car la sortie depend a la fois de l'etat (valeur precedente) et de l'entree courante.

**Table de transition/sortie** :

| Etat | Entree e | Etat suivant | s1 | s2 |
|------|----------|-------------|----|----|
| 0 | 0 | 0 | 0 | 0 |
| 0 | 1 | 1 | 1 | 0 |
| 1 | 0 | 0 | 0 | 1 |
| 1 | 1 | 1 | 0 | 0 |

**Implementation** : Une bascule D stocke l'entree precedente. s1 = e ET /Q. s2 = /e ET Q.

### Exemple detaille : Bouton poussoir pour LED (du TD4 Exercice 1)

**Probleme** : Un appui sur le bouton bascule la LED. La LED maintient son etat quand le bouton est relache.

**Etats** (4 etats, 2 bits m1,m2) :
- (0,0) : LED eteinte, bouton relache
- (0,1) : LED eteinte, bouton appuye
- (1,0) : LED allumee, bouton relache
- (1,1) : LED allumee, bouton appuye

**Sortie** : LED = m1 (premier bit de memoire directement)

**Fonction de transition** (apres simplification par Karnaugh) :
```
m1(t+1) = /BP . m1 + BP . (m1.m2 + /m1./m2)
m2(t+1) = BP
```

### Exemple detaille : Detecteur de sequence (du TD4 Exercice 2)

**Probleme** : Detecter la sequence 00, 01, 00, 10 sur deux entrees (e1, e2). La sortie S=1 pendant un cycle quand la sequence est detectee.

**Etats** (4 etats, 2 bits d2,d1) :
- (0,0) : En attente de 00
- (0,1) : 00 recu, en attente de 01
- (1,0) : 00+01 recus, en attente de 00
- (1,1) : 00+01+00 recus, en attente de 10

**Equations de transition** (apres simplification par Karnaugh) :
```
d1(t+1) = /e1 . /e2
d2(t+1) = /e1 . (/e2.d2./d1 + d1.e2)
Sortie S = d2.d1.e1./e2
```

### Exemple detaille : Detecteur de divisibilite par 5 (du TD3 Exercice 4)

**Probleme** : Les bits arrivent MSB en premier. Apres chaque bit, indiquer si le nombre forme jusqu'ici est divisible par 5.

**Idee cle** : Recevoir un bit 0 signifie N → 2N. Recevoir un bit 1 signifie N → 2N+1. Suivre le reste modulo 5.

**Etats** : 5 etats (restes 0 a 4), codes sur 3 bits.

**Table de transition** :

| R(N) | R(2N) (entree 0) | R(2N+1) (entree 1) |
|------|-------------------|---------------------|
| 0 | 0 | 1 |
| 1 | 2 | 3 |
| 2 | 4 | 0 |
| 3 | 1 | 2 |
| 4 | 3 | 4 |

**Sortie** : Est_div = 1 quand etat = 0 (le reste est 0).

---

## 2.6 Chronogrammes

Un chronogramme montre l'evolution des signaux dans le temps. Pour les circuits sequentiels :

1. Tracer le signal d'horloge (signal carre)
2. A chaque front montant, calculer l'etat suivant avec la fonction de transition
3. Calculer les sorties a partir de l'etat (Moore) ou etat+entree (Mealy)
4. Tracer tous les signaux alignes sur l'horloge

**Exemple** (du TD3 Exercice 2, deux bascules D avec portes ET) :

```
Sequence d'entree R = 0, 1, 1, 0, 1

Horloge : _|--|__|--|__|--|__|--|__|--|__
R:        0     1     1     0     1
S1:       0     0     1     1     0
S2:       0     0     0     1     1
```

Ou S1 et S2 sont les sorties des bascules D, retrocouplees a travers des portes ET avec R.

---

## 2.7 Pieges courants

1. **Oublier l'horloge** : Tous les changements d'etat se produisent aux fronts d'horloge. Les sorties d'une machine de Moore ne changent PAS entre les fronts d'horloge.

2. **Codage des etats** : Le nombre de bits necessaires = ceil(log2(nombre d'etats)). Avec 5 etats il faut 3 bits (pas 2).

3. **Transitions manquantes** : Chaque etat doit avoir une transition definie pour chaque entree possible. Les transitions manquantes menent a un comportement indefini.

4. **Confusion Mealy / Moore** : Si l'examen dit "machine de Moore", la sortie doit dependre uniquement de l'etat, pas de l'entree.

5. **Decalage d'un dans les detecteurs de sequence** : Attention a savoir si la sortie se produit au meme cycle que la derniere entree ou un cycle plus tard. Utiliser une bascule supplementaire si necessaire pour retarder la sortie d'un coup d'horloge.

6. **Boucles sur soi-meme** : Ne pas oublier les boucles sur soi-meme (etat restant dans le meme etat) lors du dessin des diagrammes d'etats. Ce sont aussi des transitions.

---

## AIDE-MEMOIRE -- Logique sequentielle

```
EQUATIONS DES BASCULES :
  D :  Q(t+1) = D
  T :  Q(t+1) = T XOR Q(t)
  JK : Q(t+1) = J./Q(t) + /K.Q(t)
  RS : Q(t+1) = S + /R.Q(t)  [S.R = 0 requis]

CONVERSIONS :
  D depuis JK :  J=D, K=/D
  T depuis JK :  J=T, K=T
  D depuis T :   T = D XOR Q
  JK depuis D :  D = J./Q + /K.Q

ETAPES DE CONCEPTION D'UNE MEF :
  1. Identifier les etats
  2. Dessiner le diagramme d'etats
  3. Assigner les codes binaires aux etats
  4. Construire la table de transition
  5. Construire la table de sortie
  6. Simplification par Karnaugh
  7. Implementer avec bascules + portes

MOORE vs MEALY :
  Moore : sortie = f(etat)          -- synchronisee, plus d'etats
  Mealy : sortie = f(etat, entree)  -- moins d'etats, sortie asynchrone

CODAGE DES ETATS :
  n etats -> ceil(log2(n)) bascules
  2 etats -> 1 bit
  3-4 etats -> 2 bits
  5-8 etats -> 3 bits

TYPES DE COMPTEURS :
  Binaire :    0,1,2,...,2^n-1,0,1,...
  Modulo-N :   0,1,...,N-1,0,1,...
  Compteur/decompteur : direction commandee par entree
  Chargeable : peut sauter a n'importe quelle valeur (pour sequenceur)

REGLES DES CHRONOGRAMMES :
  - Les changements d'etat se font au FRONT MONTANT
  - Sorties Moore : changent UNIQUEMENT au front d'horloge
  - Sorties Mealy : peuvent changer entre les fronts (quand l'entree change)
  - Bascule D : la sortie est l'entree precedente (1 delai d'horloge)
```
