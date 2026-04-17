# Chapitre 4 -- Recherche d'Information

## 4.1 Definition et enjeux

### Qu'est-ce que la Recherche d'Information (RI) ?

> "Trouver des documents de nature non structuree (generalement du texte) qui satisfont un besoin d'information au sein de grandes collections." -- C. Manning

```
  Utilisateur                  Systeme de RI
  +-----------+                +-----------------------+
  | Besoin    |  -- requete -> | Indexation             |
  | d'info    |                | Modele de similarite   |
  |           |  <- resultats  | Classement             |
  +-----------+   classes      +-----------------------+
                                        |
                               +--------v--------+
                               |  Collection de   |
                               |  documents       |
                               +-----------------+
```

### Applications

- Moteurs de recherche Web (Google, Bing)
- Documents d'entreprise
- Bibliotheques numeriques
- Domaines specialises (droit, medecine)

## 4.2 Indexation

### Principes fondamentaux

L'indexation consiste a **representer le contenu** des documents par des termes pour pouvoir les retrouver.

```
  Indexation
  +------------------------------------------+
  |                                          |
  |  Langage controle        Langage libre   |
  |  (thesaurus, mots-cles) (texte integral) |
  |  - Uniforme             - Pas d'apprentissage|
  |  - Necessite formation  - Gere mal synonymes |
  |  - Indexation manuelle  - Indexation auto     |
  |                                          |
  +------------------------------------------+
```

### Termes d'index

**Representation** : Sac de mots (BoW)

**Types de termes** :
| Type | Exemples | Avantage | Inconvenient |
|------|----------|----------|-------------|
| Simples (N, V, A) | "pompe", "hydraulique" | Favorise le rappel | Ambigus |
| Complexes (N+N, A+N, N+prep+N) | "pompe a air", "recherche d'information" | Favorise la precision | Reduit le rappel |

### Selection des termes

**Critere de frequence** : garder les termes dont tf(t) > seuil

**Mots vides (stop words)** :
- ~30 mots = ~30% des occurrences
- Supprimer les 150 plus frequents reduit le stockage de ~25%
- Exemples : "de", "le", "la", "et", "est"

**IDF** : favorise les termes frequents dans peu de documents mais rares globalement
```
idf(t) = log(|collection| / df(t))
```

### Ponderation des termes

**Formule generale** :
```
w_{d,i} = l_i * g_i * n_i
```
- l_i : ponderation locale (frequence dans le document)
- g_i : ponderation globale (rarete dans la collection)
- n_i : normalisation (taille du document)

| Composante | Variantes |
|-----------|-----------|
| Locale (l) | tf, 1+log(tf), tf/max_tf, binaire |
| Globale (g) | idf = log(N/df), idf+1, 1 (pas de ponderation) |
| Normalisation (n) | cosinus : 1/sqrt(SUM (l*g)^2), ou 1 |

## 4.3 Modeles de RI

### Modele Booleen

**Principe** : requete = formule logique, document = ensemble de termes.

```
q = t1 AND t2     --> Dq = Dt1 INTER Dt2
q = t1 OR t2      --> Dq = Dt1 UNION Dt2
q = NOT t1        --> Dq = Collection \ Dt1
```

| Avantages | Inconvenients |
|-----------|--------------|
| Simple, facile a comprendre | Requetes difficiles a formuler |
| Vrai/faux clair | Correspondance exacte uniquement |
| | Pas de classement |
| | Resultats peu intuitifs |

### Modele Vectoriel (VSM -- Vector Space Model)

**Principe (Salton, 1975)** : documents et requetes sont des vecteurs dans le meme espace.

```
  Espace vectoriel

  terme2 ^
         |     * doc1
         |   *
         |  * requete
         | *        * doc2
         +-------------------> terme1

  On compare par similarite cosinus
```

**Document** : D_i = (w_{i,1}, w_{i,2}, ..., w_{i,n})^t

**Similarite cosinus** :
```
cos(D, Q) = (D . Q) / (||D|| * ||Q||)
```

| Avantages | Inconvenients |
|-----------|--------------|
| Ponderation des termes | Termes consideres independants |
| Requete = liste de mots-cles | Langage de requete moins expressif |
| Classement par score | Difficile d'expliquer les resultats |
| Documents partiellement pertinents | |

### Modele Probabiliste

**Principe (Robertson et al., 1982)** : estimer P(R=1 | d, q), la probabilite qu'un document d soit pertinent pour une requete q.

**Modele d'Independance Binaire (BIM)** :
```
s(q, d) = SUM_{w_i dans d} log[(p_i * (1-u_i)) / (u_i * (1-p_i))]
```
- p_i = P(terme i present | document pertinent)
- u_i = P(terme i present | document non pertinent)

### BM25 (Okapi) -- TRES IMPORTANT

**Formule** :
```
BM25(q, d) = SUM_{t in q} idf(t) * [tf(t,d) * (k1 + 1)] / [tf(t,d) + k1 * (1 - b + b * |d|/avgdl)]
             * [tf(t,q) * (k3 + 1)] / [tf(t,q) + k3]
```

**Parametres standards** :
- k1 = 1.2 (saturation de la frequence du terme)
- b = 0.75 (normalisation par la longueur)
- k3 = 1000 (frequence dans la requete)
- avgdl = longueur moyenne des documents

**Pourquoi BM25 est important** : c'est la baseline standard en RI, encore difficile a battre.

### Index inverse

**Principe** : au lieu de stocker les termes par document, on stocke les documents par terme.

```
  Index direct :                    Index inverse :
  doc1 -> {chat, mange, souris}    chat -> {doc1, doc4}
  doc2 -> {chien, dort}            mange -> {doc1, doc3}
  doc3 -> {souris, mange}          souris -> {doc1, doc3}
  doc4 -> {chat, dort}             chien -> {doc2}
                                   dort -> {doc2, doc4}
```

**Interet** : acces direct aux documents pertinents sans parcourir toute la collection.

## 4.4 Mesures d'evaluation

### Evaluation de resultats non classes

**Precision** :
```
P = |documents pertinents recuperes| / |documents recuperes|
```

**Rappel** :
```
R = |documents pertinents recuperes| / |documents pertinents totaux|
```

**F1-mesure** (moyenne harmonique) :
```
F1 = 2 * P * R / (P + R)
```

```
  Toute la collection
  +-----------------------------------------------+
  |                                               |
  |   Documents           Documents recuperes     |
  |   pertinents          par le systeme          |
  |   +----------+        +----------+            |
  |   |          |        |          |            |
  |   |    A     |  B     |    C     |            |
  |   |          +--------+          |            |
  |   |          |  D     |          |            |
  |   +----------+--------+----------+            |
  |                                               |
  +-----------------------------------------------+

  Precision = D / (C + D)
  Rappel = D / (A + D)
```

### Evaluation de resultats classes (ranked)

**P@k et R@k** : precision et rappel en ne considerant que les k premiers resultats.

**MAP (Mean Average Precision)** -- TRES IMPORTANT :
```
AveP(q) = moyenne des precisions aux rangs des documents pertinents
MAP = moyenne des AveP sur toutes les requetes
```

**nDCG (Normalized Discounted Cumulative Gain)** -- POUR LES JUGEMENTS NON BINAIRES :

```
CG(k) = SUM_{i=1}^{k} (2^{rel(i)} - 1)

DCG(k) = SUM_{i=1}^{k} (2^{rel(i)} - 1) / log2(i + 1)

nDCG(k) = DCG(k) / IDCG(k)
```

**Particularite du nDCG** (question type DS) :
- Utilise des jugements de pertinence **gradues** (pas seulement 0/1)
- Penalise les documents pertinents mal classes (discount logarithmique)
- Normalise par le classement ideal (IDCG)

## 4.5 Expansion de requetes

### Pourquoi ?

Les requetes sont souvent courtes et mal formulees. L'expansion vise a ajouter des termes pour ameliorer le rappel.

### Methodes locales

**Retour de pertinence (Relevance Feedback)** :
1. L'utilisateur soumet une requete initiale
2. Le systeme retourne des resultats
3. L'utilisateur marque certains comme pertinents/non pertinents
4. Le systeme reformule la requete

**Algorithme de Rocchio (1971)** :
```
q1 = alpha * q0 + beta * (1/|Dr|) * SUM_{d in Dr} d
                - gamma * (1/|Dnr|) * SUM_{d in Dnr} d
```
- Dr = documents pertinents, Dnr = documents non pertinents
- alpha=1, beta=0.75, gamma=0.15 (valeurs typiques)

**Pseudo Retour de Pertinence** : on considere les k premiers documents comme pertinents (pas de retour utilisateur).

### Methodes globales

- Expansion avec WordNet/thesaurus
- Co-occurrences de mots
- LSI, LDA
- Reformulations d'autres utilisateurs (logs de requetes)

## 4.6 Le Web et PageRank

### Specificites de la RI sur le Web

- Milliards de pages, contenu dynamique
- Requetes courtes et imprecises
- Beaucoup de contenu non pertinent (spam)
- Nouvelle source : les **hyperliens**

### Composants d'un moteur de recherche

```
  +----------+      +------------------+      +------------------+
  |  Crawler  | --> |  Base d'index     | --> |  Moteur de        |
  |  (spider) |     |  (index inverse)  |     |  recherche        |
  +----------+      +------------------+      +------------------+
       |                                            |
       v                                            v
  Visite les pages,                           Algorithme de
  suit les liens,                             classement
  re-visite regulierement                     (BM25 + PageRank + ...)
```

### PageRank (Page et Brin, 1998) -- IMPORTANT

**Idee** : un surfeur aleatoire clique sur des liens au hasard. Les pages les plus visitees sont les plus "importantes".

**Formule** :
```
PR(u) = (1-d)/N + d * SUM_{v in B_u} PR(v) / L(v)
```
- B_u = ensemble des pages pointant vers u
- L(v) = nombre de liens sortants de v
- d = facteur d'amortissement (~0.85)
- N = nombre total de pages

**Teleportation** : avec probabilite (1-d), le surfeur saute vers une page aleatoire (evite les culs-de-sac).

## 4.7 Learning to Rank (L2R)

### Trois approches

```
  Learning to Rank
  +--------------------------------------------+
  |                                            |
  |  Pointwise        Pairwise       Listwise  |
  |  Score par doc     Paires de      Classement|
  |                    preference     complet   |
  |                                            |
  |  Score(q,d)-->     d1 > d2 ?     Meilleure |
  |  rang              Classification permutation|
  |                    binaire                   |
  |                                            |
  |  Limite:           Limite:       Limite:    |
  |  ignore l'ordre    ignore la     Complexe   |
  |  relatif           position                 |
  +--------------------------------------------+
```

| Approche | Entree | Methode | Limite |
|----------|--------|---------|--------|
| **Pointwise** | Paire (q,d) | Regression/classification | Ignore l'ordre relatif |
| **Pairwise** | Paire (d1,d2) | d1 meilleur que d2 ? | Pas de position absolue |
| **Listwise** | Liste de documents | Optimise MAP/nDCG | Complexe |

## 4.8 RI et Deep Learning

### Deux idees principales

1. **Injecter des embeddings** dans les modeles traditionnels (expansion de requetes par embeddings)
2. **Apprentissage bout-en-bout** des representations et du classement

### Modeles bases representation (siamois)

- Requete et document representes **independamment**
- Comparaison par similarite cosinus
- Avantage : representations de documents calculables offline
- Exemple : **DSSM** (Huang et al., 2013)

### Modeles bases interaction

- Matrice de similarite entre termes de q et d
- Extraction de signaux de pertinence
- Exemple : **DRMM** (Guo et al., 2016) -- premier a battre BM25

### MonoBERT (Nogueira & Cho, 2019)

```
  Entree : [CLS] requete [SEP] document [SEP]
                |
                v
           Modele BERT
                |
                v
  Representation [CLS] --> couche FC --> score de pertinence
```

- Attention all-to-all entre mots de q et d
- Tres bons resultats mais couteux (applique en re-classement sur top-1000 de BM25)

## 4.9 Code Python : recherche d'information simple

```python
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

# Collection de documents
documents = [
    "Le chat mange la souris",
    "La souris mange du fromage",
    "Le chien dort sur le canape",
    "Le chat et le chien jouent",
    "La souris a peur du chat"
]

# Requete
requete = "chat souris"

# Indexation TF-IDF
vectorizer = TfidfVectorizer()
tfidf_docs = vectorizer.fit_transform(documents)
tfidf_query = vectorizer.transform([requete])

# Calcul de similarite cosinus
scores = cosine_similarity(tfidf_query, tfidf_docs).flatten()

# Classement
ranking = np.argsort(scores)[::-1]
for rank, idx in enumerate(ranking):
    print(f"  Rang {rank+1}: doc{idx+1} (score={scores[idx]:.3f}) "
          f"'{documents[idx]}'")
```

## 4.10 Pieges classiques

- **Confondre precision et rappel** : precision = parmi ce qu'on retourne, rappel = parmi ce qui est pertinent
- **Oublier que nDCG utilise des jugements gradues** : c'est sa particularite par rapport a MAP (question classique en DS)
- **Confondre IDF et TF-IDF** : IDF seul mesure la rarete d'un terme, TF-IDF combine avec la frequence locale
- **Oublier le facteur d'amortissement dans PageRank** : d~0.85, la teleportation evite les impasses
- **Croire que BM25 est obsolete** : c'est encore une baseline tres solide, meme face au deep learning
- **Confondre les 3 approches L2R** : pointwise = score par doc, pairwise = comparaison de paires, listwise = classement complet
- **MonoBERT en re-classement** : on ne l'applique pas a toute la collection, seulement au top-k de BM25

## 4.11 Recapitulatif

| Concept | A retenir |
|---------|-----------|
| Indexation | Representation des documents par des termes ponderes |
| Index inverse | terme --> liste de documents (acces rapide) |
| Modele booleen | Logique (AND/OR/NOT), pas de classement |
| Modele vectoriel | Vecteurs + cosinus, classement par score |
| BM25 | Modele probabiliste standard, baseline solide |
| Precision | Pertinents parmi les recuperes |
| Rappel | Recuperes parmi les pertinents |
| F1 | 2PR/(P+R) |
| MAP | Moyenne des precisions aux rangs pertinents |
| nDCG | Jugements gradues + discount logarithmique |
| Rocchio | Reformulation de requete par feedback |
| PageRank | Importance = (1-d)/N + d * SUM PR(v)/L(v) |
| DRMM | Premier modele neural a battre BM25 |
| MonoBERT | [CLS] q [SEP] d [SEP], re-classement |
