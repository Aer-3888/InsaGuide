# Chapitre 6 -- Modeles de langage

## 6.1 Qu'est-ce qu'un modele de langage ?

### Definition

Un **modele de langage** definit une distribution de probabilite sur les phrases d'un vocabulaire V.

```
P["Cette phrase est tres probable"]       --> probabilite ELEVEE
P["Phrase cette pas tres probable est"]   --> probabilite FAIBLE
```

### A quoi ca sert ?

```
  Modele de langage
  +--------------------------------------------+
  |                                            |
  |  Applications :                            |
  |  +-- Identification de langue              |
  |  +-- Reconnaissance vocale                 |
  |  +-- Traduction automatique                |
  |  +-- Correction orthographique             |
  |  +-- Prediction de texte (clavier)         |
  |  +-- Grammaires probabilistes              |
  |  +-- Generation de texte (GPT, etc.)       |
  |                                            |
  +--------------------------------------------+
```

### Types d'approches

| Approche | Description | Robustesse |
|----------|-------------|------------|
| Grammaires probabilistes | Puissantes mais complexes | Faible |
| **N-grammes** | Simples et efficaces | Haute |
| Modeles neuronaux | Sophistiques et performants | Haute |

## 6.2 Vocabulaire et preparation

### Etapes de preparation

1. **Selection des mots** : garder les k mots les plus frequents (64k-200k en pratique)
2. **Tokenisation** : URLs, nombres, traits d'union, apostrophes, locutions
3. **Gestion du vocabulaire** :
   - Vocabulaire ouvert : token `<unk>` pour les mots inconnus
   - Vocabulaire ferme : tokenisation sous-mot (BPE, WordPiece)

## 6.3 L'approximation n-gramme

### Le probleme

La probabilite d'une phrase se decompose par la regle de la chaine :
```
P["Jean aime Marie"] = P[Jean] * P[aime | Jean] * P[Marie | Jean aime]
```

Mais P[w_i | w_1, ..., w_{i-1}] est impossible a estimer pour un long historique (trop de combinaisons).

### La solution n-gramme

**Approximation** : on ne garde que les n-1 derniers mots :
```
P[w_i | w_1, ..., w_{i-1}]  ~=  P[w_i | w_{i-n+1}, ..., w_{i-1}]
```

| Nom | n | Historique | Exemple |
|-----|---|-----------|---------|
| Unigramme | 1 | Rien | P[w_i] |
| **Bigramme** | 2 | 1 mot | P[w_i \| w_{i-1}] |
| **Trigramme** | 3 | 2 mots | P[w_i \| w_{i-2}, w_{i-1}] |
| 4-gramme | 4 | 3 mots | P[w_i \| w_{i-3}, w_{i-2}, w_{i-1}] |

### Representation

**Table de distribution** : pour chaque historique h, une distribution sur les mots suivants P[w|h].

**Graphe stochastique** : noeud = historique, arc = transition avec probabilite.

### Generation de texte

En echantillonnant depuis P[w|h] :
- Ordre 1 : "REPRESENTING AND SPEEDILY IS AN GOOD APT..." (incoherent)
- Ordre 2 : "THE HEAD AND IN FRONTAL ATTACK ON AN ENGLISH WRITER..." (mieux)
- Ordre 4+ : phrases presque naturelles

## 6.4 Perplexite : mesure de qualite -- TRES IMPORTANT

### Definition

La perplexite mesure la qualite de prediction d'un modele de langage.

**Formule** :
```
PP(q, w) = 2^{-1/n * SUM_{i=1}^{n} log2(q(w_i | historique))}
```

Ou de facon equivalente :
```
PP(q, w) = (1 / P_q(w_1, ..., w_n))^{1/n}
```

### Interpretation

- **Plus la perplexite est faible, meilleur est le modele**
- Interpretee comme le "nombre moyen de choix" pour predire le mot suivant
- PP = 1 : prediction parfaite
- PP = |V| : pas mieux que le hasard

### Relation avec la vraisemblance

La perplexite est l'inverse de la vraisemblance geometrique :
```
PP = exp(-1/n * SUM log P(w_i | contexte))
```

**Attention** : toujours mesuree sur un corpus de test (pas d'entrainement !).

## 6.5 Estimation par maximum de vraisemblance

### Formule

```
P_ML[w | h] = C(h w) / C(h)
```
ou C(.) = nombre d'occurrences dans le corpus d'entrainement.

### Exemple concret

Corpus : "le chat mange la souris le chat dort"

Pour un bigramme :
```
P(chat | le) = C("le chat") / C("le") = 2 / 2 = 1.0
P(mange | chat) = C("chat mange") / C("chat") = 1 / 2 = 0.5
P(dort | chat) = C("chat dort") / C("chat") = 1 / 2 = 0.5
```

### Probleme de Zipf et sparsete

**Observation** : plus n augmente, plus le nombre de n-grammes distincts explose, et la plupart n'apparaissent qu'une fois (singletons).

```
  n       Nb n-grammes distincts   Nb singletons
  1       50 000                   ~20 000
  2       500 000                  ~300 000
  3       2 000 000                ~1 500 000
```

**Consequence** : enormement de n-grammes ont une probabilite estimee a 0 alors qu'ils sont possibles.

## 6.6 Techniques de lissage (Smoothing) -- TRES IMPORTANT

### Principe general

**Emprunter** de la masse probabiliste aux evenements observes pour la **redistribuer** aux evenements non observes.

```
  Sans lissage :              Avec lissage :
  P(vu) = C/N                P(vu) = (C - delta) / N
  P(non vu) = 0              P(non vu) = delta * ... / N
```

### Lissage de Laplace (Add-One)

```
P[w | h] = (C(hw) + 1) / (C(h) + |V|)
```

**Avantage** : simple
**Inconvenient** : redistribue trop de masse aux evenements non vus, surtout avec un grand vocabulaire

### Lissage Dirichlet

```
P[w | h] = (C(hw) + lambda * P[w]) / (C(h) + lambda)
```

Interpolation entre l'estimation ML et la distribution a priori P[w].

### Discounting absolu

```
P*[w | h] = max(C(hw) - delta, 0) / SUM_v C(hv)
```

Soustrait une constante delta a chaque comptage.

### Kneser-Ney -- LE PLUS PERFORMANT

Raffinement du discounting absolu ou delta depend du contexte et la redistribution utilise la **diversite contextuelle** des mots rares.

### Good-Turing

```
C*(hw) = (C(hw) + 1) * N_{C(hw)+1} / N_{C(hw)}
```
ou N_c = nombre de n-grammes qui apparaissent exactement c fois.

**Idee** : utiliser la "frequence des frequences" pour re-estimer les probabilites.

### Lissage de Laplace et modeles n-grammes (question DS 2022)

> **La technique de Laplace est-elle adaptee aux n-grammes ?**

**Reponse** : Laplace redistribue trop de masse vers les n-grammes non vus car |V|^n est enorme. Quand on augmente la constante de lissage, le modele tend vers une distribution uniforme (perte d'information). En TP, on observe que la perplexite augmente avec la constante de lissage. Des techniques comme Kneser-Ney ou l'interpolation sont bien plus adaptees.

## 6.7 Interpolation et Back-off

### Interpolation lineaire

Les n-grammes d'ordre inferieur sont mieux estimes (plus de donnees). On les combine :

**Interpolation standard** :
```
P_I[w | h_n] = lambda_0 * P_ML[w]
             + lambda_1 * P_ML[w | h_1]
             + ...
             + lambda_n * P_ML[w | h_n]
```
avec SUM lambda_i = 1

**Interpolation recursive** :
```
P_I[w | h_n] = lambda(h_n) * P_ML[w | h_n]
             + (1 - lambda(h_n)) * P_I[w | h_{n-1}]
```

### Back-off (retour en arriere)

Utiliser l'estimation de plus haut ordre si elle est fiable, sinon **reculer** :
```
P_bo[w | h_n] = | C*(h_n w) / C(h_n)           si C(h_n w) > 0
                | alpha(h_n) * P_bo[w | h_{n-1}] sinon
```

### Combinaison Good-Turing + Back-off

```
P_k[w | h_n] = | C(h_n w) / C(h_n)               si C(h_n w) > k
               | C*(h_n w) / C(h_n)              si 0 < C(h_n w) <= k
               | alpha(h_n) * P_k[w | h_{n-1}]   sinon
```

## 6.8 Modeles de langage neuronaux

### Modele Feed-Forward (Bengio et al., 2003)

**Architecture** :
```
  w_{i-n+1}, ..., w_{i-1}    (n-1 mots precedents)
       |             |
       v             v
  [embedding]   [embedding]   (couche d'embedding c())
       |             |
       +------+------+
              |
              v
         [MLP + tanh]          (couches cachees)
              |
              v
         [softmax]             (distribution sur V)
              |
              v
         P[w_i | contexte]
```

**Formules** :
```
y = U * tanh(H * x + b)
P[w_i | contexte] = exp(y_{w_i}) / SUM_k exp(y_k)
```

**Fonction objectif** :
```
J = (1/T) * SUM_t log f(w_t | w_{t-n+1}, ..., w_{t-1}; theta) + R(theta)
```

### Modeles Recurrents (RNN)

**Avantage sur feed-forward** : historique de longueur variable (pas limite a n-1 mots).

```
  w1        w2        w3        ...       wn
  |         |         |                   |
  v         v         v                   v
  h1 -----> h2 -----> h3 -----> ... ----> hn
  |         |         |                   |
  v         v         v                   v
  P(w2|w1)  P(w3|..)  P(w4|..)           P(w_{n+1}|..)
```

**Principe** :
```
P[w_i | w_{i-1}, ..., w_1]  ~=  f(w_i, h_{i-1})
```
ou h_{i-1} est le resume de tout l'historique.

**Entrainement** :
- **Auto-supervise** : le texte lui-meme fournit les labels
- **Objectif** : maximiser la log-vraisemblance (= minimiser l'entropie croisee)
```
J(theta) = SUM_t log(y_t[index(w_{t+1})])
```

### Modeles bidirectionnels

```
  ht = f(h_{t-1}, w_t)   : encode w_1, ..., w_t     --> predit w_{t+1}
  h't = f'(h'_{t+1}, w_t) : encode w_t, ..., w_n     --> predit w_{t-1}

  Prediction : y_t = softmax(A * [h_{t-1} ; h'_{t+1}] + b)
```

### Question type DS (exam 2022)

> **Expliquer le fonctionnement d'un modele de langue RNN (GRU/LSTM).**

**Reponse type** :
- **Entrees de la cellule** : embedding du mot courant x_t + etat cache precedent h_{t-1}
- **Sortie de la cellule** : nouvel etat cache h_t (resume de tout l'historique)
- **Prediction** : softmax(V * h_t) donne la distribution sur le mot suivant
- **Critere d'apprentissage** : pour une cellule donnee a la position t, on cherche a predire le mot w_{t+1} (le mot suivant). On minimise l'entropie croisee entre la distribution predite et le mot reel.

## 6.9 Code Python : modele de langage n-gramme

```python
from collections import defaultdict, Counter
import math

def build_bigram_model(corpus):
    """Construit un modele bigramme avec lissage de Laplace."""
    # Compter les bigrammes et unigrammes
    bigram_counts = Counter()
    unigram_counts = Counter()

    for sentence in corpus:
        tokens = ["<s>"] + sentence.split() + ["</s>"]
        for i in range(len(tokens) - 1):
            bigram_counts[(tokens[i], tokens[i+1])] += 1
            unigram_counts[tokens[i]] += 1
        unigram_counts[tokens[-1]] += 1

    vocab_size = len(unigram_counts)

    def prob(word, history):
        """P(word | history) avec lissage de Laplace."""
        return (bigram_counts[(history, word)] + 1) / \
               (unigram_counts[history] + vocab_size)

    return prob, vocab_size, unigram_counts

def perplexity(prob_fn, test_sentence, vocab_size):
    """Calcule la perplexite sur une phrase."""
    tokens = ["<s>"] + test_sentence.split() + ["</s>"]
    n = len(tokens) - 1
    log_prob_sum = 0

    for i in range(1, len(tokens)):
        p = prob_fn(tokens[i], tokens[i-1])
        log_prob_sum += math.log2(p)

    return 2 ** (-log_prob_sum / n)

# Exemple
corpus = [
    "le chat mange la souris",
    "la souris mange du fromage",
    "le chat dort sur le canape",
]

prob, vocab_size, _ = build_bigram_model(corpus)
pp = perplexity(prob, "le chat mange du fromage", vocab_size)
print(f"Perplexite : {pp:.2f}")
```

## 6.10 Pieges classiques

- **Perplexite** : plus elle est BASSE, meilleur est le modele (piege frequent)
- **Lissage de Laplace pour n-grammes** : trop de masse redistribuee, inadapte pour n > 2. Preferer Kneser-Ney ou interpolation
- **Augmenter la constante de lissage** : tend vers distribution uniforme (perte d'information)
- **Confondre n-gramme et n** : un bigramme a n=2 mais ne regarde que 1 mot d'historique
- **RNN vs feed-forward** : le RNN n'a pas de limite fixe d'historique (grace a h_t)
- **Entrainement auto-supervise** : pas besoin d'annotation manuelle, le texte sert de label
- **Test vs entrainement** : la perplexite se mesure sur un corpus de TEST
- **Bidirectionnel** : pour les modeles de langage purs (generation), on ne peut pas etre bidirectionnel (on n'a pas le futur). Le bidirectionnel est pour les modeles de type BERT (comprehension)

## 6.11 Recapitulatif

| Concept | A retenir |
|---------|-----------|
| Modele de langage | Distribution de probabilite sur les phrases |
| N-gramme | P[w_i \| w_{i-n+1},...,w_{i-1}], approximation de l'historique |
| Perplexite | 2^{-1/n * SUM log2 P(w_i)}, plus basse = meilleur |
| Estimation ML | C(hw)/C(h), probleme de sparsete |
| Lissage Laplace | (C+1)/(N+\|V\|), inadapte pour n-grammes |
| Kneser-Ney | Meilleur lissage, diversite contextuelle |
| Interpolation | Melange d'ordres differents |
| Back-off | Recule si pas d'observation |
| Bengio (2003) | Premier modele neuronal, embeddings + MLP |
| RNN | Historique variable via h_t, auto-supervise |
| LSTM/GRU | Portes pour controler le flux d'information |
| Bidirectionnel | Contexte passe + futur (BERT, pas generation) |

### Formules essentielles

```
Bigramme :     P[w_i | w_{i-1}]
Trigramme :    P[w_i | w_{i-2}, w_{i-1}]
ML :           P[w|h] = C(hw) / C(h)
Laplace :      P[w|h] = (C(hw) + 1) / (C(h) + |V|)
Perplexite :   PP = 2^{-1/n * SUM log2 P(w_i)}
Interpolation: P_I = SUM lambda_i * P_ML[w|h_i], SUM lambda = 1
```
