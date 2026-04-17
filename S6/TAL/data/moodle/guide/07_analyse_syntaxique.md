# Chapitre 7 -- Analyse syntaxique

## 7.1 La syntaxe : definition et enjeux

### Qu'est-ce que la syntaxe ?

La syntaxe etudie les **principes et contraintes qui gouvernent la combinaison des mots** en phrases grammaticalement correctes.

L'analyse syntaxique (parsing) consiste a **determiner la structure** d'une phrase.

### Trois aspects du cours

```
  Analyse syntaxique
  +-------------------------------------------+
  |                                           |
  |  1. POS Tagging (etiquetage morpho-       |
  |     syntaxique) --> voir chapitre 5       |
  |                                           |
  |  2. Parsing en constituants               |
  |     (arbres syntagmatiques)               |
  |                                           |
  |  3. Parsing en dependances                |
  |     (relations binaires)                  |
  |                                           |
  |  + Analyse partielle (chunking)           |
  |                                           |
  +-------------------------------------------+
```

## 7.2 POS Tagging : resume (voir chapitre 5 pour les details)

### Categories grammaticales (parties du discours)

**Classes ouvertes** (lexicales) : nom, verbe, adjectif, adverbe
**Classes fermees** (fonctionnelles) : determinant, pronom, preposition, conjonction

### Penn Treebank Tagset (45 etiquettes)

| Etiquette | Signification | Exemple |
|-----------|---------------|---------|
| NN | Nom singulier | "chat" |
| NNS | Nom pluriel | "chats" |
| VB | Verbe base | "manger" |
| VBD | Verbe passe | "mangea" |
| JJ | Adjectif | "noir" |
| DT | Determinant | "le" |
| IN | Preposition | "dans" |

### Difficulte principale : ambiguite lexicale

- "book" : nom ("a book") ou verbe ("book a flight")
- "ferme" : nom, verbe, ou adjectif
- "La belle ferme le voile" : 2 analyses possibles
- 85-86% des mots sont non ambigus, mais 55-67% des **tokens** sont ambigus

## 7.3 Analyse en constituants

### Constituants (syntagmes)

Les constituants sont des **groupes de mots** se comportant comme des unites.

| Type | Nom | Exemple |
|------|-----|---------|
| NP | Syntagme nominal | "le gros chat noir" |
| VP | Syntagme verbal | "mange la souris" |
| PP | Syntagme prepositionnel | "dans le jardin" |
| AP | Syntagme adjectival | "tres grand" |

### Arbre de constituants

```
              S
             / \
           NP    VP
          / \   / \
        Det  N  V   NP
         |   |  |   / \
        Le chat mange Det  N
                       |   |
                      la souris
```

### Grammaires formelles (Chomsky)

**Definition** : G = (V_N, V_T, R, S) ou :
- V_N = vocabulaire non-terminal {S, NP, VP, PP, Det, N, V, Prep...}
- V_T = vocabulaire terminal {le, chat, mange, la, souris...}
- R = regles de production
- S = symbole de depart

**Hierarchie de Chomsky** :

| Type | Nom | Contrainte | Expressivite |
|------|-----|-----------|-------------|
| 0 | Sans restriction | Aucune | Maximale |
| 1 | Context-sensitive | uXv --> uYv | Haute |
| **2** | **Context-free (CFG)** | **X --> Y (1 non-terminal a gauche)** | **Standard en TAL** |
| 3 | Reguliere | 1 non-terminal a droite max | Faible |

### Grammaires hors-contexte (CFG)

**Regles** + **lexique** :
```
S  --> NP VP
NP --> Det N | Det N PP | Pro
VP --> V | V NP | V NP PP
PP --> Prep NP
Det --> le | la | un | une
N  --> chat | souris | jardin
V  --> mange | dort | court
Prep --> dans | sur | avec
```

### Ambiguite syntaxique -- IMPORTANT POUR LE DS

La meme phrase peut avoir **plusieurs arbres d'analyse** valides.

**Exemple classique** : "block the door with stones"

**Arbre 1** : VP --> V NP PP (avec des pierres, on bloque la porte)
```
        S
        |
       VP
      / | \
     V  NP  PP
     |  /\  /\
  block Det N Prep N
        the door with stones
```

**Arbre 2** : VP --> V NP, NP --> NP PP (la porte avec des pierres)
```
        S
        |
       VP
      / \
     V   NP
     |   / \
  block NP  PP
        /\  /\
      Det N Prep N
      the door with stones
```

### Limites des CFG

- **Accord** : necessite de multiplier les categories (NP_sg, NP_pl...)
- **Dependances a distance** : "The man **who** the dog bit **ran** away"
- **Constituants discontinus**

**Solutions** : grammaires transformationnelles, grammaires a unification (LFG, GPSG, HPSG, TAG)

## 7.4 Algorithme CKY (Cocke-Kasami-Younger) -- IMPORTANT

### Principe

Algorithme de programmation dynamique pour les CFG en **forme normale de Chomsky**.

**Forme Normale de Chomsky (CNF)** :
- Toute regle est soit A --> B C (deux non-terminaux)
- Soit A --> a (un terminal)

### Transformations vers CNF

1. Eliminer les regles epsilon
2. Gerer les symboles mixtes (terminal dans une regle non-terminale)
3. Eliminer les productions unitaires (A --> B)
4. Binariser les regles longues (A --> B C D --> A --> B X, X --> C D)

### Algorithme

```
Pour chaque position j (de 1 a n) :
    Pour chaque regle A --> w_j :
        table[j][j] += {A}

Pour chaque longueur l (de 2 a n) :
    Pour chaque debut i (de 1 a n-l+1) :
        Pour chaque point de coupure k (de i a i+l-1) :
            Pour chaque regle A --> B C :
                Si B in table[i][k] et C in table[k+1][i+l-1] :
                    table[i][i+l-1] += {A}
```

**Complexite** : O(n^3 * |R|^2) pour une phrase de n mots et |R| regles.

### Strategie

- **Bottom-up** : on part des mots et on remonte vers S
- Stocke tous les constituants possibles dans une table triangulaire

## 7.5 Grammaires probabilistes (PCFG)

### Motivation

Quand plusieurs arbres sont possibles, comment choisir le **meilleur** ?

### Definition

G = (V_N, V_T, R, S, **P**) ou P est une fonction de probabilite :
- Pour chaque non-terminal X : SUM P(X --> gamma) = 1

**Probabilite d'un arbre** = produit des probabilites des regles utilisees :
```
P(arbre) = PRODUIT P(regle_i)
```

### Exercice type DS (exam 2022)

PCFG donnee :
```
S  --> VP         [1.0]
VP --> V NP       [0.7]
VP --> V NP PP    [0.3]
NP --> NP PP      [0.3]
NP --> Det N      [0.7]
PP --> Prep N     [1.0]
```
Terminaux : Det, V, Prep, N tous avec probabilite 0.1.

Phrase : "block the door with stones"

**Arbre 1** (VP --> V NP PP) :
```
P = 1.0 * 0.3 * 0.1 * 0.7 * 0.1 * 0.1 * 1.0 * 0.1 * 0.1
  = 1.0 * 0.3 * 0.1 * (0.7 * 0.1 * 0.1) * (1.0 * 0.1 * 0.1)
```

**Arbre 2** (VP --> V NP, NP --> NP PP) :
```
P = 1.0 * 0.7 * 0.1 * 0.3 * (0.7 * 0.1 * 0.1) * (1.0 * 0.1 * 0.1)
```

On compare les deux et on choisit le plus probable.

### Interet des PCFG (question DS)

> "Quel est l'interet des PCFG par rapport aux CFG ?"

Les probabilites permettent de **desambiguiser** les phrases ayant plusieurs analyses syntaxiques valides en choisissant l'arbre le plus probable. Elles permettent aussi de **classer** les analyses.

### Apprentissage des PCFG

A partir de corpus annotes (treebanks) :
- **Penn Treebank** : 1M mots du Wall Street Journal
- **French Treebank** : 1M mots du journal Le Monde

### Limites des PCFG

- Invariance positionnelle (les pronoms sont plus frequents en sujet)
- Seules les POS sont considerees, pas les mots eux-memes
- **Solution** : lexicalisation des grammaires

### CKY neuronal (Kitaev et al., 2019)

- Embeddings BERT pour representer les mots
- Classifieur MLP pour scorer chaque span possible
- Decodage par programmation dynamique (pas de grammaire explicite)

## 7.6 Analyse en dependances

### Principe

Relations **binaires dirigees** entre mots : d'une **tete** (gouverneur) vers un **dependant**.

```
  Phrase : "Paul regarde le chien noir"

           regarde
          /   |    \
       Paul  chien  noir
               |
              le

  Relations :
  regarde --nsubj--> Paul
  regarde --obj----> chien
  chien   --det----> le
  chien   --amod---> noir
```

### Types de relations

| Categorie | Exemples |
|-----------|----------|
| Clausales | nsubj (sujet), obj (objet), iobj (objet indirect) |
| Modification | amod (modifieur adjectival), advmod (adverbial) |
| Fonctionnelles | det (determinant), case (preposition), cc (conjonction) |

### Universal Dependencies

Projet international de standardisation des relations de dependance cross-linguistiques. Treebanks UD disponibles pour de nombreuses langues.

### Contraintes structurelles

- Un seul mot dependant de ROOT
- Chaque mot (sauf ROOT) a exactement un arc entrant
- Pas de cycles
- Chemin unique de ROOT vers chaque mot
- **Projectif** : pas d'arcs croises (la plupart des phrases)
- **Non-projectif** : arcs croises possibles (langues a ordre libre)

## 7.7 Algorithmes de parsing en dependances

### Parsing transition-based (Nivre, 2005)

**Composants** :
- **Pile** (sigma) : commence avec ROOT
- **Buffer** (beta) : commence avec la phrase
- **Arcs** (A) : commence vide

**Actions possibles** :

| Action | Effet |
|--------|-------|
| **Shift** | Deplacer le premier element du buffer vers la pile |
| **Left-Arc** | Creer un arc du sommet de la pile vers le second element + retirer le second |
| **Right-Arc** | Creer un arc du second element vers le sommet + retirer le sommet |

**Apprentissage de l'oracle** : un classifieur predit l'action a effectuer a chaque etape.

### Parsing graph-based (McDonald et al., 2005)

- Assigne un score a chaque arc possible
- Trouve l'arbre de score maximum (algorithme de Eisner, MST)

### Classifieurs neuronaux

- Embeddings des mots + POS + labels d'arcs
- Concatenation + reseau feed-forward + softmax
- Beaucoup plus performant que les features manuelles

## 7.8 Evaluation des analyseurs

### Metriques pour les constituants

| Metrique | Formule |
|----------|---------|
| Precision etiquetee | Constituants corrects / constituants produits |
| Rappel etiquete | Constituants corrects / constituants de reference |
| F-mesure | 2*P*R / (P+R) |

### Metriques pour les dependances

| Metrique | Signification |
|----------|---------------|
| **UAS** (Unlabeled Attachment Score) | Tete correcte (sans label) |
| **LAS** (Labeled Attachment Score) | Tete + relation correctes |

**Performances** :
- MaltParser : UAS=89.8%, LAS=87.2%, 469 phrases/s
- Etat de l'art 2017 (Dozat & Manning) : UAS=95.74%, LAS=94.08%

### Code Python : analyse en dependances avec spaCy

```python
import spacy
nlp = spacy.load("fr_core_news_sm")

doc = nlp("Paul regarde le chien noir")
for token in doc:
    print(f"{token.text:10} --{token.dep_:8}--> {token.head.text}")
# Paul       --nsubj  --> regarde
# regarde    --ROOT   --> regarde
# le         --det    --> chien
# chien      --obj    --> regarde
# noir       --amod   --> chien
```

## 7.9 Analyse partielle / Chunking

### Motivation

- L'analyse syntaxique complete n'est pas toujours necessaire
- Le chunking identifie des **constituants non-recursifs**

### Definition

Un **chunk** est un segment non-recursif correspondant a une POS majeure (NP, VP, PP).

```
  [NP Le vol AF210] [PP de] [NP Paris] [PP a] [NP New-York]
```

### Chunking comme etiquetage de sequence

On utilise le systeme **IOB** (identique a BIO) :
```
  The    AF210   flight   from    Paris
  B_NP   I_NP    I_NP     O      B_NP
```

**Techniques utilisables** : HMM, CRF, methodes neuronales (memes principes que le POS tagging).

### Evaluation du chunking

- Precision = chunks corrects produits / total chunks produits
- Rappel = chunks corrects produits / total chunks reference
- "Correct" = memes frontieres ET memes etiquettes

## 7.10 Pieges classiques

- **Confondre constituants et dependances** : constituants = groupes hierarchiques, dependances = relations binaires tete-dependant
- **Oublier la forme normale de Chomsky** : CKY necessite que les regles soient en CNF (A --> B C ou A --> a)
- **PCFG : produit des probabilites** : P(arbre) = PRODUIT des P(regle), pas la somme
- **PCFG vs CFG** : les probabilites servent a desambiguiser, pas a generer
- **UAS vs LAS** : UAS = juste la tete correcte, LAS = tete + label corrects. LAS est plus strict
- **Transition-based** : 3 actions (Shift, Left-Arc, Right-Arc), pas plus
- **Chunking != parsing complet** : le chunking ne produit pas d'arbres recursifs
- **Ambiguite d'attachement PP** : c'est LE sujet classique en DS ("I saw the man with the telescope")

## 7.11 Recapitulatif

| Concept | A retenir |
|---------|-----------|
| Syntaxe | Etude de la structure des phrases |
| Constituants | Groupes hierarchiques (NP, VP, PP) |
| Dependances | Relations binaires tete --> dependant |
| CFG | G = (V_N, V_T, R, S), regles X --> Y |
| CNF | A --> B C ou A --> a (pour CKY) |
| CKY | Programmation dynamique, O(n^3), bottom-up |
| PCFG | CFG + probabilites, P(arbre) = PROD P(regles) |
| Interet PCFG | Desambiguation par probabilite maximale |
| Transition-based | Pile + buffer + {Shift, Left-Arc, Right-Arc} |
| UAS | Tete correcte (sans label) |
| LAS | Tete + label corrects |
| Chunking | Constituants non-recursifs, encodage IOB |
| Universal Dependencies | Standard cross-linguistique pour dependances |

### Formules essentielles

```
P(arbre PCFG) = PRODUIT P(regle_i)
CKY : O(n^3 * |R|^2)
UAS = arcs corrects / total arcs
LAS = arcs avec label correct / total arcs
```
