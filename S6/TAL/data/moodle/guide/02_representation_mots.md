# Chapitre 2 -- Representation des mots

## 2.1 Le probleme central

### Pourquoi representer les mots ?

Le texte brut n'est pas directement exploitable par les algorithmes d'apprentissage. Il faut transformer les mots en **representations numeriques** que les machines peuvent manipuler.

```
  "Le chat mange la souris"
         |
         v
  Comment un algorithme peut-il
  comprendre cette phrase ?
         |
         v
  Il faut convertir chaque mot
  en un VECTEUR NUMERIQUE
         |
         v
  [0.23, -0.45, 0.78, ...]
```

### Les grands types de representations

```
  Representations des mots
  +-------------------------------------------------+
  |                                                 |
  |  1. Symboliques (chaines de caracteres)         |
  |     --> Simple mais aucune semantique            |
  |                                                 |
  |  2. Lexiques semantiques (WordNet, FrameNet)    |
  |     --> Relations entre mots, mais manuels       |
  |                                                 |
  |  3. Distribuees / Embeddings (Word2Vec, GloVe)  |
  |     --> Vecteurs denses, captent la semantique   |
  |                                                 |
  |  4. Sous-mots (FastText, BPE, WordPiece)        |
  |     --> Gerent les mots inconnus                 |
  |                                                 |
  +-------------------------------------------------+
```

## 2.2 Rappel : tokens et concepts linguistiques

| Terme | Definition | Exemple |
|-------|-----------|---------|
| **Token** | Chaine graphique normalisee, sans signification propre | "mangeait" |
| **Forme (wordform)** | Signe linguistique autonome | "mangeait" |
| **Lexeme** | Ensemble de formes differenciees par flexion | {mange, manges, mangeait, mangeons...} = meme lexeme |
| **Lemme** | Forme canonique d'un lexeme | "manger" |
| **Radical (stem)** | Support morphologique portant le sens | "mang-" |

**Attention a l'ambiguite du mot "mot"** :
- Au niveau surface : "His answer was only two-words long: certainly not" -- combien de mots ?
- Au niveau linguistique : "am", "are", "is", "was" = formes du meme mot (lexeme BE)

## 2.3 Representations symboliques : limites

### Representation par chaines de caracteres

```python
mot1 = "velo"
mot2 = "bicyclette"
print(mot1 == mot2)  # False -- pourtant meme sens !
```

**Avantages** : simple, comparaison efficace (tables de hachage)

**Inconvenients majeurs** :
- Aucune information semantique : "velo" != "bicyclette" alors qu'ils sont synonymes
- Comparaison purement binaire (egal ou different)
- Pas de gestion des formes flechies : "manger" != "mangera" != "mangerait"
- Inutilisable directement dans un reseau de neurones

## 2.4 Lexiques et reseaux semantiques

### WordNet

WordNet est une base lexicale organisee en **synsets** (ensembles de synonymes cognitifs).

```
  WordNet : Structure
  +---------------------------+
  |  Synset = { lemme1, lemme2, ... }  +  definition
  +---------------------------+
          |
  Relations entre synsets :
  +-- synonyme / antonyme
  +-- hyperonyme (is-a) : chien --> animal
  +-- hyponyme : animal --> chien
  +-- meronyme (has-part) : voiture --> roue
  +-- holonyme (is-part-of) : roue --> voiture
```

### Mesures de similarite avec WordNet

**Similarite basee sur le chemin** :
```
sim_path(c1, c2) = 1 / (1 + longueur_plus_court_chemin(c1, c2))
```

**Mesure de Wu-Palmer** (a connaitre pour le DS) :
```
Wu_Palmer(c1, c2) = 2 * depth(LCS(c1, c2)) / (depth(c1) + depth(c2))
```
ou LCS = Lowest Common Subsumer (ancetre commun le plus bas)

**Generalisation aux mots** :
```
sim_word(w1, w2) = max{ sim(c1, c2) | c1 in senses(w1), c2 in senses(w2) }
```

### Code Python : WordNet avec NLTK

```python
from nltk.corpus import wordnet as wn

# Trouver les synsets d'un mot
synsets = wn.synsets('dog')
print(synsets)  # [Synset('dog.n.01'), Synset('frump.n.01'), ...]

# Similarite Wu-Palmer
dog = wn.synset('dog.n.01')
cat = wn.synset('cat.n.01')
print(dog.wup_similarity(cat))  # ~0.86

# Plus bas ancetre commun
print(dog.lowest_common_hypernyms(cat))  # [Synset('carnivore.n.01')]
```

### FrameNet et SentiWordNet

| Ressource | Contenu | Usage |
|-----------|---------|-------|
| **FrameNet** | 13k sens, 1.2k frames semantiques | Roles semantiques des verbes |
| **SentiWordNet** | Scores pos/neg/obj pour chaque synset | Analyse de sentiment |

## 2.5 Semantique distributionnelle

### Le principe fondateur

> "You shall know a word by the company it keeps" -- Firth (1957)

> "Les parties d'une langue n'apparaissent pas arbitrairement les unes par rapport aux autres" -- Harris (1954)

**Idee** : les mots qui apparaissent dans des contextes similaires ont des sens proches.

### Matrice de co-occurrence

**Methode directe** :

1. Creer une matrice ou M[i][j] = nombre de fois que les mots i et j apparaissent ensemble dans une fenetre contextuelle
2. Appliquer une decomposition matricielle (SVD) : X = U S V^t
3. Utiliser les vecteurs tronques comme representation des mots

```
  Mot        chat   mange   souris   fromage
  chat        0       5       3        1
  mange       5       0       4        3
  souris      3       4       0        5
  fromage     1       3       5        0
```

**Limitations** : matrice tres grande, cout d'ajout de nouveaux mots.

## 2.6 Word2Vec

### Le concept revolutionnaire

Au lieu d'examiner les co-occurrences explicitement, on **apprend directement les vecteurs** en entrainant un reseau de neurones simple.

### Deux variantes

```
  CBOW                              Skip-gram
  (Continuous Bag of Words)         (le plus utilise)

  Contexte --> Mot central          Mot central --> Contexte

  le [___] mange la souris          le chat [___] la souris
       |                                 |
       v                                 v
  Predit "chat"                    Predit "le", "mange", "la", "souris"
```

| Variante | Entree | Sortie | Forces |
|----------|--------|--------|--------|
| **CBOW** | Mots du contexte | Mot central | Rapide, bon sur petits corpus, syntaxe |
| **Skip-gram** | Mot central | Mots du contexte | Precis, bon sur grands corpus, semantique |

### Objectif mathematique du Skip-gram

```
J(theta) = SUM_t SUM_{j in [-m,m], j!=0} ln p(w_{t+j} | w_t)
```

La probabilite contextuelle est definie par softmax :
```
p(o|c) = exp(u'_o . v_c) / SUM_{w in V} exp(u'_w . v_c)
```
ou :
- u_o = vecteur du mot de contexte o (matrice de sortie)
- v_c = vecteur du mot central c (matrice d'entree)

### Echantillonnage negatif (negative sampling)

Le softmax sur tout le vocabulaire est trop couteux. On approxime :

```
J(theta) = SUM_{t,j} [ sigma(u'_{w_{t+j}} . v_{w_t})
                       + SUM_{w ~ P[w]} sigma(-u'_w . v_{w_t}) ]
```

**Principe minimax** :
- **Maximiser** le produit scalaire pour les mots qui co-occurrent --> sigma(u'_o . v_c)
- **Minimiser** le produit scalaire pour les mots tires aleatoirement --> sigma(-u'_w . v_c)

**Details pratiques** :
- Distribution de tirage : P[w] = unigram(w)^(3/4) / Z (attenuer l'impact des mots frequents)
- Optimisation par descente de gradient stochastique
- Apres entrainement : u'_a . v_b approxime ln P[a|b]

### Proprietes fascinantes des embeddings Word2Vec

```python
# Relations vectorielles semantiques
vec("roi") - vec("homme") + vec("femme") ~= vec("reine")
vec("Paris") - vec("France") + vec("Allemagne") ~= vec("Berlin")
```

## 2.7 GloVe (Global Vectors)

### Motivation

Word2Vec n'utilise pas les statistiques **globales** du corpus. GloVe combine les avantages des deux approches.

### Objectif GloVe

```
J(theta) = 1/2 SUM_{i,j in V x V} f(P_ij) * (u'_i . v_j - ln P_ij)^2
```

ou P_ij est la probabilite de co-occurrence des mots i et j, et f est une fonction de ponderation.

### Comparaison Word2Vec vs GloVe

| Critere | Word2Vec | GloVe |
|---------|----------|-------|
| Type | Predictif (local) | Comptage (global) |
| Donnees | Fenetre locale | Matrice globale de co-occurrence |
| Efficacite | Plus lent | Plus rapide |
| Corpus minimal | Grand | Plus petit suffit |

## 2.8 Evaluation intrinseque des embeddings

### Similarite semantique

On mesure la **similarite cosinus** entre vecteurs :

```
cosine(x, y) = (x . y) / (||x|| * ||y||)
```

Puis on compare avec les jugements humains (correlation).

### Base de reference

**WordSim353** : paires de mots avec scores de similarite humains.

| Paire | Score humain |
|-------|-------------|
| love, sex | 6.77 |
| tiger, cat | 7.35 |
| tiger, tiger | 10.00 |
| book, paper | 7.46 |

## 2.9 Tokenisation sous-mot et FastText

### Le probleme des mots inconnus

Les methodes precedentes supposent que tous les mots ont ete vus a l'entrainement. En pratique, c'est rarement vrai (noms propres, neologismes, fautes de frappe...).

**Solution naive** : mapper vers un token `<UNK>` -- perte d'information.

### FastText : embeddings de sous-mots

**Principe** : decomposer chaque mot en n-grammes de caracteres (n = 3 a 6).

```
"where" --> {<wh, whe, her, ere, re>, <where>}

Embedding("where") = SUM des embeddings de ses n-grammes
```

**Avantage majeur** : peut calculer un embedding pour un mot jamais vu !

### BPE (Byte Pair Encoding) -- utilise dans GPT-3

**Algorithme** :
1. Decomposer tous les mots en lettres individuelles
2. Compter les paires de sous-mots adjacentes les plus frequentes
3. Fusionner la paire la plus frequente
4. Repeter jusqu'a atteindre la taille de vocabulaire voulue

**Exemple** :
```
Depart : ("h" "u" "g", 10), ("p" "u" "g", 5), ("p" "u" "n", 12), ("b" "u" "n", 4)
Etape 1 : paire "u" + "g" la plus frequente (10+5 = 15) --> fusion en "ug"
          ("h" "ug", 10), ("p" "ug", 5), ("p" "u" "n", 12), ("b" "u" "n", 4)
Etape 2 : paire "u" + "n" la plus frequente (12+4 = 16) --> fusion en "un"
          ("h" "ug", 10), ("p" "ug", 5), ("p" "un", 12), ("b" "un", 4)
Etape 3 : paire "h" + "ug" (10) --> fusion en "hug"
          ...
```

### WordPiece -- utilise dans BERT

Similaire a BPE mais utilise la vraisemblance pour choisir les fusions.

```
"Using a Transformer network is simple"
--> ['Using', 'a', 'transform', '##er', 'network', 'is', 'simple']
```

Le prefixe `##` indique que le sous-mot est une continuation.

## 2.10 Couche d'embedding dans un reseau de neurones

### Principe technique

Une couche d'embedding est une **matrice A de taille |V| x d** qui mappe chaque token (identifie par un index) vers un vecteur dense de dimension d.

```
  mot "chat" --> index 42 --> A[42] = [0.23, -0.45, 0.78, ...]
                                       (vecteur de dimension d)
```

**Point cle** : cette matrice A est un **parametre appris** du reseau. Elle peut etre :
- **Pre-entrainee** (Word2Vec, GloVe) puis figee
- **Pre-entrainee** puis fine-tunee avec la tache
- **Apprise from scratch** pour une tache specifique

## 2.11 Code Python complet : Word2Vec avec Gensim

```python
from gensim.models import Word2Vec

# Corpus d'exemple
corpus = [
    ["le", "chat", "mange", "la", "souris"],
    ["le", "chien", "mange", "un", "os"],
    ["la", "souris", "mange", "du", "fromage"],
    ["le", "chat", "dort", "sur", "le", "canape"],
]

# Entrainement Word2Vec (Skip-gram)
model = Word2Vec(
    sentences=corpus,
    vector_size=100,    # dimension des vecteurs
    window=5,           # taille de la fenetre contextuelle
    min_count=1,        # frequence minimale
    sg=1,               # 1 = Skip-gram, 0 = CBOW
    epochs=100
)

# Obtenir le vecteur d'un mot
vec_chat = model.wv["chat"]
print(f"Dimension : {vec_chat.shape}")  # (100,)

# Mots les plus similaires
similaires = model.wv.most_similar("chat", topn=3)
print(similaires)  # [('chien', 0.95), ('souris', 0.87), ...]

# Similarite entre deux mots
sim = model.wv.similarity("chat", "chien")
print(f"Similarite chat-chien : {sim:.3f}")
```

## 2.12 Pieges classiques

- **Confondre CBOW et Skip-gram** : CBOW predit le mot central, Skip-gram predit le contexte. Skip-gram est meilleur sur gros corpus et pour la semantique
- **Oublier l'echantillonnage negatif** : sans lui, le softmax est trop couteux (somme sur tout le vocabulaire)
- **Croire que Word2Vec capture le sens exact** : il capture des correlations statistiques, pas le "vrai" sens
- **Confondre similarite cosinus et distance euclidienne** : pour les embeddings, on utilise toujours le cosinus car il est invariant a la norme
- **Ignorer les mots inconnus** : FastText et BPE resolvent ce probleme, pas Word2Vec classique
- **Oublier la mesure de Wu-Palmer** : c'est la formule de similarite WordNet a connaitre pour le DS

## 2.13 Recapitulatif

| Concept | A retenir |
|---------|-----------|
| Hypothese distributionnelle | Contexte similaire = sens similaire |
| WordNet | Base lexicale, synsets, relations (hyperonymie, synonymie...) |
| Wu-Palmer | 2*depth(LCS) / (depth(c1) + depth(c2)) |
| Word2Vec Skip-gram | Predit le contexte a partir du mot central |
| Word2Vec CBOW | Predit le mot central a partir du contexte |
| Echantillonnage negatif | Approximation efficace du softmax |
| GloVe | Combine co-occurrences globales et locales |
| FastText | N-grammes de caracteres, gere mots inconnus |
| BPE | Fusion iterative des paires frequentes (GPT) |
| WordPiece | Variante pour BERT, prefixe ## |
| Similarite cosinus | Mesure standard entre embeddings |
| Couche d'embedding | Matrice apprise V x d dans un reseau |

### Evolution chronologique

```
  Symbolique --> WordNet --> Co-occurrence/SVD --> Word2Vec --> GloVe --> FastText --> BPE/WordPiece
  (1990s)      (1995)      (2000s)               (2013)      (2014)   (2016)       (2018+)
     |            |            |                     |           |        |             |
   Aucune     Relations    Vecteurs              Vecteurs    Global   Sous-mots    Tokenisation
   semantique  manuelles   parcimonieux          denses      +local   robustes     adaptative
```
