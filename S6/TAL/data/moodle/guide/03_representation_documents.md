# Chapitre 3 -- Representation des documents

## 3.1 Du mot au document

### Problematique

On sait representer des **mots** (chapitre 2). Maintenant, comment representer un **document entier** (phrase, paragraphe, article, tweet...) sous forme d'un vecteur de dimension fixe ?

```
  Document = texte quelconque
  +----------------------------------------------------------+
  | "Ce film est absolument fantastique, les acteurs sont     |
  |  brillants et la mise en scene est magnifique"            |
  +----------------------------------------------------------+
                          |
                          v
           Vecteur de dimension fixe
           [0.23, -0.45, 0.78, 0.12, ...]
                          |
                          v
           Utilisable pour : classification, recherche
           d'information, comparaison de documents
```

### Applications visees

- **Classification thematique** : sport, politique, economie...
- **Detection de sentiment** : positif, negatif, neutre
- **Recherche d'information** : comparer requete et documents
- **Comparaison de documents** : similarite entre textes

## 3.2 Hypothese fondamentale : le sac de mots (Bag of Words)

### Principe

> L'**ordre des mots n'a pas d'importance** : seuls comptent les mots presents (et eventuellement leurs frequences).

```
  Document : "Le chat mange la souris"
                    |
                    v
          Sac de mots = { le:1, chat:1, mange:1, la:1, souris:1 }

  "La souris mange le chat" --> meme sac de mots !
  (mais sens tres different...)
```

### Construction en deux etapes

**Etape 1 : Selection des termes**
- Tokenisation et normalisation
- Lemmatisation ou racinisation (optionnel)
- Suppression des mots vides (stop words)
- Selection par frequence ou par categorie (noms, verbes, adjectifs)

**Etape 2 : Attribution des poids**

| Methode | Formule | Cas d'usage |
|---------|---------|-------------|
| Binaire | delta(w,d) = 1 si w dans d, 0 sinon | Presence/absence |
| Frequence brute | n(w,d) = nombre d'occurrences | Importance locale |
| Frequence relative | n(w,d) / SUM_v n(v,d) | Normalise par longueur |
| **TF-IDF** | tf(w,d) * idf(w) | **Standard en RI** |

## 3.3 Ponderation TF-IDF

### Idee intuitive

Un mot est important pour un document s'il y apparait **souvent** (TF haut) mais qu'il est **rare dans la collection** (IDF haut).

```
  TF-IDF = Importance locale  x  Rarete globale
           (dans le document)     (dans la collection)

  Mot "le" : TF eleve, IDF ~= 0  --> TF-IDF ~= 0  (mot non informatif)
  Mot "syntaxe" : TF moyen, IDF eleve --> TF-IDF eleve (mot discriminant)
```

### Formules

**TF (Term Frequency)** -- frequence normalisee dans le document :
```
tf(w, d) = n(w, d) / SUM_{v in V} n(v, d)
```

**IDF (Inverse Document Frequency)** -- rarete dans la collection :
```
idf(w) = log(|D| / df(w))
```
ou df(w) = nombre de documents contenant w, |D| = taille de la collection

**TF-IDF complet** :
```
tfidf(w, d) = tf(w, d) * idf(w)
```

### Exemple concret

Donnees : 4 documents, vocabulaire = {aimer, manger, Paul, Virginie, je}

| Mot | Apparait dans... | IDF = log(4/df) |
|-----|------------------|-----------------|
| aimer | 3 docs sur 4 | log(4/3) = 0.125 |
| manger | 2 docs sur 4 | log(4/2) = 0.301 |
| Paul | 1 doc sur 4 | log(4/1) = 0.602 |
| Virginie | 2 docs sur 4 | log(4/2) = 0.301 |
| je | 4 docs sur 4 | log(4/4) = 0 |

**Observation** : "je" a un IDF de 0 car il apparait dans tous les documents -- il n'est pas discriminant. "Paul" a le plus fort IDF car il n'apparait que dans 1 document.

### Code Python : TF-IDF avec scikit-learn

```python
from sklearn.feature_extraction.text import TfidfVectorizer

corpus = [
    "Le chat mange la souris",
    "La souris mange du fromage",
    "Le chien dort sur le canape",
    "Le chat et le chien jouent ensemble"
]

vectorizer = TfidfVectorizer()
tfidf_matrix = vectorizer.fit_transform(corpus)

# Afficher les termes et leurs scores pour le doc 0
feature_names = vectorizer.get_feature_names_out()
for i, name in enumerate(feature_names):
    score = tfidf_matrix[0, i]
    if score > 0:
        print(f"  {name}: {score:.3f}")
```

## 3.4 Classificateur Bayesien Naif (Naive Bayes)

### Principe theorique

On veut classifier un document d dans une classe c. Par le theoreme de Bayes :

```
p(c|d) = p(d|c) * p(c) / p(d)
```

Comme p(d) est constant pour toutes les classes, on maximise simplement :
```
c_hat = argmax_c  p(d|c) * p(c)
```

**Hypothese naive** : les mots sont **independants** conditionnellement a la classe :
```
p(d|c) = PRODUIT_{i=1}^{n} p(w_i | c)
```

### Estimation des probabilites

**Deux estimateurs possibles** :

| Estimateur | Formule | Usage |
|-----------|---------|-------|
| **Binaire** | p(w\|c) = SUM_d delta(w,d) / SUM_v SUM_d delta(v,d) | Presence/absence |
| **Frequentiel** | p(w\|c) = SUM_d n(w,d) / SUM_v SUM_d n(v,d) | Nombre d'occurrences |

### Probleme des probabilites nulles

Si un mot n'a jamais ete vu dans une classe, sa probabilite est 0, et tout le produit tombe a 0.

**Exemple** : document d = {manger: 10, Paul: 1}
- p(d|love) = ... x p(manger|love)^10 x ... = ... x 0^10 = **0**

### Lissage de Laplace (add-one) -- TRES IMPORTANT POUR LE DS

**Formule** :
```
p(w|c) = (n(w,c) + 1) / (N_c + |V|)
```
ou :
- n(w,c) = nombre d'occurrences de w dans les documents de classe c
- N_c = nombre total de mots dans la classe c
- |V| = taille du vocabulaire

**Idee** : on ajoute 1 a chaque comptage pour eviter les zeros.

### Exercice type DS (exam 2022)

**Donnees** :

| Classe | bien | super | fantastique | decevant | mauvais | nul |
|--------|------|-------|-------------|----------|---------|-----|
| positif | 4 | 2 | 1 | 2 | 0 | 0 |
| negatif | 1 | 3 | 0 | 3 | 4 | 7 |

- N_positif = 4+2+1+2+0+0 = 9, N_negatif = 1+3+0+3+4+7 = 18
- |V| = 6

**Avec lissage de Laplace** :
```
p(bien|positif) = (4 + 1) / (9 + 6) = 5/15 = 1/3
p(bien|negatif) = (1 + 1) / (18 + 6) = 2/24 = 1/12
```

**Pour classifier "fantastique mais decevant"** (en ignorant "mais" hors vocabulaire) :
```
p(positif|d) ~ p(positif) * p(fantastique|positif) * p(decevant|positif)
             = 0.5 * (2/15) * (3/15)
             = 0.5 * 2/15 * 3/15

p(negatif|d) ~ p(negatif) * p(fantastique|negatif) * p(decevant|negatif)
             = 0.5 * (1/24) * (4/24)
             = 0.5 * 1/24 * 4/24
```

On compare et on choisit la classe avec la probabilite la plus elevee.

### Autres techniques de lissage

| Methode | Formule | Idee |
|---------|---------|------|
| Laplace | (c(w) + 1) / (N + \|V\|) | Ajouter 1 a chaque comptage |
| Interpolation | lambda*P[w] + (1-lambda)*P_ML[w\|c] | Melanger avec distribution uniforme |
| Good-Turing | Redistribuer la masse des frequences rares | Bases sur les frequences de frequences |

### Loi de Zipf

> "Les evenements frequents sont rares et les evenements rares sont frequents"

```
rang(w) x freq(w) = constante
```

**Consequence** : enormement de mots n'apparaissent qu'une fois (hapax). Le lissage est donc **indispensable**.

## 3.5 Maximum d'entropie (= Regression logistique)

### Principe

Au lieu de modeliser p(d|c) puis appliquer Bayes, on modelise **directement** p(c|d).

**Forme generale** :
```
P[C = k | d] = exp(lambda_0^(k) + SUM_i lambda_i^(k) * x_i)
               / SUM_j exp(lambda_0^(j) + SUM_i lambda_i^(j) * x_i)
```

C'est exactement une **regression logistique multinomiale** (softmax).

### Fonctions de caracteristiques

Ce sont les "features" x_i mesurees sur le document :
- Proportion de mots positifs/negatifs
- Presence de mots-cles specifiques
- Proportion de pronoms personnels
- Longueur du document
- etc.

## 3.6 Modele d'espace vectoriel et classifieurs

### Metriques de comparaison

| Metrique | Formule | Usage |
|----------|---------|-------|
| Produit scalaire | x . y = SUM_i x_i * y_i | Non normalise |
| Norme L2 | \|\|x-y\|\| = sqrt(SUM_i (x_i - y_i)^2) | Distance |
| **Cosinus** | cos(x,y) = (x.y) / (\|\|x\|\| * \|\|y\|\|) | **Standard en RI** |

### Classifieurs utilisables

| Classifieur | Principe |
|-------------|----------|
| **k-NN** | k plus proches voisins dans l'espace vectoriel |
| **Regression logistique** | p(c\|d) = sigma(alpha_0 + SUM alpha_w * f(w,d)) |
| **SVM** | Trouver l'hyperplan de separation optimale |
| **Reseau de neurones** | Couches cachees + softmax |

## 3.7 Limites du sac de mots et solutions

### Problemes du BoW

```
  Limites du Bag of Words
  +-------------------------------------------+
  |  1. Pas d'ordre des mots                  |
  |     "chat mange souris" = "souris mange   |
  |      chat" (meme vecteur !)               |
  |                                           |
  |  2. Haute dimension, tres parcimonieux    |
  |     (la plupart des composantes = 0)      |
  |                                           |
  |  3. Pas de semantique distributionnelle   |
  |     "chat" et "minou" = vecteurs          |
  |      totalement differents                |
  |                                           |
  |  4. Documents sans mots communs           |
  |     --> similarite = 0 (meme si lies)     |
  +-------------------------------------------+
```

### Solution : embeddings de documents

## 3.8 Embeddings de documents

### Methode simple : moyenne des embeddings de mots

```
vec(document) = (1/n) * SUM_{i=1}^{n} embedding(w_i)
```

**Avantages** : simple, efficace, utilise les embeddings pre-entraines
**Inconvenients** : perd l'ordre, les mots frequents dominent

### RNN pour les embeddings de documents

```
  w1      w2      w3      ...     wn
  |       |       |               |
  v       v       v               v
  [emb]   [emb]   [emb]          [emb]
  |       |       |               |
  v       v       v               v
  h1 ---> h2 ---> h3 ---> ... -> hn  = embedding du document
```

**Principe** : l'etat cache h_i resume l'information de w_1 a w_i. L'etat final h_n est l'embedding du document.

### Cellules recurrentes

#### LSTM (Long Short-Term Memory)

```
i_t = sigma(W_i * x_t + U_i * h_{t-1} + b_i)    # porte d'entree
f_t = sigma(W_f * x_t + U_f * h_{t-1} + b_f)    # porte d'oubli
o_t = sigma(W_o * x_t + U_o * h_{t-1} + b_o)    # porte de sortie
c_t = f_t (*) c_{t-1} + i_t (*) tanh(W_c * x_t + U_c * h_{t-1})
h_t = o_t (*) tanh(c_t)
```

#### GRU (Gated Recurrent Unit)

Version simplifiee du LSTM avec 2 portes au lieu de 3 :
```
z_t = sigma(W_z * x_t + U_z * h_{t-1} + b_z)    # porte de mise a jour
r_t = sigma(W_r * x_t + U_r * h_{t-1} + b_r)    # porte de reset
h_t = (1 - z_t) (*) h_{t-1} + z_t (*) tanh(W * x_t + U * (r_t (*) h_{t-1}))
```

## 3.9 Evaluation des embeddings

### Evaluation intrinseque

**Semantic Textual Similarity (STS)** : comparer la similarite predite avec les jugements humains.

### Evaluation extrinseque (benchmarks)

**GLUE** (General Language Understanding Evaluation) :

| Tache | Description |
|-------|-------------|
| CoLA | Phrase grammaticalement correcte ? |
| SST | Prediction de sentiment |
| MRPC | Detection de paraphrases |
| MNLI | Inference textuelle |
| SQuAD | Question-reponse |

**FLUE** : equivalent francais de GLUE (avec FlauBERT).

### Triplet loss pour la recherche d'information

```
L(a, p, n) = max(||f(a) - f(p)||^2 - ||f(a) - f(n)||^2 + alpha, 0)
```
ou a = ancre (requete), p = exemple positif, n = exemple negatif, alpha = marge.

## 3.10 Pieges classiques

- **Oublier le lissage** : sans lissage de Laplace, Naive Bayes explose (probabilites nulles). C'est un sujet recurrent en DS
- **Se tromper dans la formule de Laplace** : c'est (count + 1) / (total + |V|), pas (count + 1) / (total + 1)
- **Confondre TF et TF-IDF** : TF seul donne beaucoup de poids aux mots frequents non informatifs
- **IDF = 0** : un mot present dans TOUS les documents a un IDF nul, donc un TF-IDF nul
- **Naive Bayes : independance** : l'hypothese d'independance est fausse en pratique, mais le classifieur marche quand meme bien
- **Ne pas normaliser** : en RI, toujours utiliser le cosinus (invariant a la longueur du document)
- **Confondre LSTM et GRU** : LSTM a 3 portes (entree, oubli, sortie), GRU n'en a que 2 (mise a jour, reset)

## 3.11 Recapitulatif

| Concept | A retenir |
|---------|-----------|
| Bag of Words | Ignore l'ordre, vecteur parcimonieux |
| TF-IDF | tf(w,d) * log(\|D\|/df(w)), standard en RI |
| Naive Bayes | p(c\|d) ~ PROD p(w_i\|c) * p(c) |
| Lissage de Laplace | (count + 1) / (total + \|V\|) |
| Loi de Zipf | rang * freq = constante |
| Max entropie | = regression logistique multinomiale |
| Cosinus | Mesure standard de similarite |
| Moyenne embeddings | vec(doc) = moyenne des embeddings des mots |
| LSTM | 3 portes : entree, oubli, sortie |
| GRU | 2 portes : mise a jour, reset |
| GLUE / FLUE | Benchmarks d'evaluation extrinseque |
| Triplet loss | Rapprocher positifs, eloigner negatifs |
