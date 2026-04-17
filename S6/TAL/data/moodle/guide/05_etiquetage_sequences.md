# Chapitre 5 -- Etiquetage de sequences : HMM, CRF, RNN

## 5.1 Les taches d'etiquetage

### Definition

L'etiquetage de sequences consiste a **assigner une etiquette a chaque token** d'une phrase.

```
  Phrase :  "A   Marseille  Jean-Claude  Gaudin  est  elu   depuis  1995"
  Labels :  [O   B-LOC     B-PER        I-PER   O    O     O       B-TIME]
```

### Exemples de taches

| Tache | Entree | Sortie |
|-------|--------|--------|
| **POS tagging** | "Le chat mange" | DET NOUN VERB |
| **NER** (entites nommees) | "Jean habite a Paris" | B-PER O O B-LOC |
| **Chunking** | "Le gros chat noir" | B-NP I-NP I-NP I-NP |
| **Slot filling** | "un resto italien a Rennes" | quoi quoi nil ou |
| **Detection de phrases** | "The cat is black The dog" | 0 0 0 1 0 0 |

### Le systeme BIO -- TRES IMPORTANT

```
  B = Beginning   (debut d'une entite)
  I = Inside      (interieur d'une entite)
  O = Outside     (hors entite)
```

**Exemple** :
```
  "Le president Emmanuel Macron a visite Paris"
   O  O         B-PER    I-PER  O O       B-LOC
```

Si n types d'entites --> 2n + 1 etiquettes possibles (B-X, I-X pour chaque type + O).

## 5.2 Approches naives et leurs limites

### Regles manuelles
- Lister les etiquettes possibles pour chaque mot
- Appliquer des regles locales
- **Limite** : trop d'ambiguites non resolues

### Classificateur local
- Classifier chaque token independamment
- Regarde le contexte local (fenetre)
- **Limite** : ignore les dependances entre etiquettes successives

```
  Classificateur local :          Modele de sequence :
  Chaque token independant        Dependances entre etiquettes

  O  B-PER  ?  O                  O  B-PER  I-PER  O
  (pas de contrainte              (apres B-PER, on attend
   entre etiquettes)               I-PER ou O, pas B-PER)
```

## 5.3 Modeles de Markov Caches (HMM)

### Intuition

Un HMM suppose que la phrase observee est **generee** par une sequence d'etats caches (les etiquettes).

```
  Etats caches     t1 -----> t2 -----> t3 -----> t4
  (etiquettes)     DET       NOUN      VERB      NOUN
                   |          |          |          |
                   v          v          v          v
  Observations     w1         w2         w3         w4
  (mots)          "Le"      "chat"    "mange"   "souris"
```

### Formulation mathematique

```
p(w, t) = p(t) * p(w|t)
```

**Deux hypotheses simplificatrices** :

1. **Hypothese de Markov** : p(t_i | t_1,...,t_{i-1}) = p(t_i | t_{i-1})
2. **Independance conditionnelle** : p(w_i | t_1,...,t_n, w_1,...) = p(w_i | t_i)

**Expression finale** :
```
p(w, t) = p(t_1) * p(w_1|t_1) * PRODUIT_{i=2}^{n} p(t_i|t_{i-1}) * p(w_i|t_i)
```

### Parametres du HMM : lambda = (A, B, pi)

| Parametre | Notation | Signification |
|-----------|----------|---------------|
| **A** | a_{ij} = P(t_i \| t_{j-1}) | Matrice de transition entre etats |
| **B** | b_k(w) = P(w \| t_k) | Matrice d'emission (mot sachant etat) |
| **pi** | pi_i = P(t_1 = i) | Distribution initiale |

### Estimation des parametres (par comptage)

```
P(t_i | t_{i-1}) = C(t_{i-1}, t_i) / C(t_{i-1})    [transitions]
P(w | t) = C(t, w) / C(t)                            [emissions]
```

Sur un corpus d'entrainement etiquete.

### Algorithme de Viterbi -- TRES IMPORTANT

**Objectif** : trouver la sequence d'etiquettes la plus probable.

```
t_hat = argmax_t  p(w, t)
```

**Methode** : programmation dynamique (evite l'enumeration exponentielle).

**Recursion** :
```
H(i, k) = max_{j} [H(j, k-1) * a_{ji} * b_i(w_k)]
```

H(i, k) = meilleure probabilite pour etre dans l'etat i a la position k.

**Complexite** : O(n * |T|^2) au lieu de O(|T|^n) par enumeration.

### Exemple concret

Transitions :
```
P(NOUN|DET) = 0.6
P(VERB|NOUN) = 0.8
```

Pour "DET NOUN VERB" avec pi(DET)=1 :
```
P = 1 * P(NOUN|DET) * P(VERB|NOUN) = 1 * 0.6 * 0.8 = 0.48
```

### Performances et limites des HMM

**Performances** : ~98% de precision en POS tagging

**Limites** :
- Hypothese de Markov trop restrictive pour taches complexes
- Independance conditionnelle irrealiste (le mot ne depend que de son etiquette)
- Modele **generatif** : modelise p(w,t) au lieu de p(t|w) directement

## 5.4 Champs Aleatoires Conditionnels (CRF)

### Motivation

Les CRF resolvent les limitations des HMM en modelisant **directement** p(t|w).

```
  HMM (generatif) :                CRF (discriminant) :
  Modelise p(w, t)                 Modelise p(t | w)
  = p(t) * p(w|t)                 = (1/Z(w)) * exp(SUM lambda_k * f_k(t,w))

  --> Hypotheses fortes            --> Pas d'hypothese d'independance
  --> Caracteristiques limitees    --> Caracteristiques arbitraires
```

### Formulation

**CRF lineaire pour sequences** :
```
P(t | w) = (1/Z(w)) * exp(SUM_k lambda_k * f_k(t, w))
```

ou :
- Z(w) = fonction de partition (normalisation)
- lambda_k = poids appris
- f_k = fonctions de caracteristiques

### Fonctions de caracteristiques

Les fonctions f_k sont **binaires** et se decomposent sur les positions :
```
f_k(t, w) = SUM_s f_k(t_{s-1}, t_s, w, s)
```

**Exemples** :
| Fonction | Description |
|----------|-------------|
| f(t_{s-1}, t_s) = delta(t_{s-1}=DET, t_s=NOUN) | Transition DET --> NOUN |
| f(t_s, w_s) = delta(t_s=VERB, w_s="mange") | Mot "mange" avec etiquette VERB |
| f(t_s, w_{s-1}, w_{s+1}) = delta(t_s=ADJ, w_{s-1}="tres") | Contexte du mot |
| f(t_s, w_s) = delta(t_s=NP, w_s commence par majuscule) | Forme du mot |

### Lien HMM --> CRF

Un HMM est un **cas particulier** de CRF ou :
- Les fonctions de caracteristiques sont limitees aux transitions et emissions
- Les poids lambda correspondent aux log-probabilites

### Inference et apprentissage

**Inference** : algorithme de type Viterbi (meme recursion)
```
t_hat = argmax_t SUM_k lambda_k * f_k(t, w)
```

**Apprentissage** : optimisation du log-vraisemblance par gradient (BFGS, etc.)

**Outils** : CRF++ , Wapiti

### Avantages des CRF sur les HMM

| Critere | HMM | CRF |
|---------|-----|-----|
| Type | Generatif | Discriminant |
| Hypotheses | Markov + indep. conditionnelle | Aucune hypothese restrictive |
| Caracteristiques | Limitees (mot, transition) | Arbitraires (contexte, forme...) |
| Complexite | Simple | Plus complexe |
| Performances NER | Moyennes | Bonnes |

## 5.5 Reseaux de Neurones Recurrents (RNN)

### Architecture de base

```
  x1        x2        x3        ...       xn
  |         |         |                   |
  [embed]   [embed]   [embed]             [embed]
  |         |         |                   |
  v         v         v                   v
  h1 -----> h2 -----> h3 -----> ... ----> hn
  |         |         |                   |
  v         v         v                   v
  y1_hat    y2_hat    y3_hat              yn_hat
  (softmax) (softmax) (softmax)           (softmax)
```

**Composants** :
```
x_t = C(w_t)                           # embedding du mot
h_t = sigma(U * (x_t + h_{t-1}))       # etat cache (recurrence)
y_hat_t = softmax(V * h_t)             # prediction de l'etiquette
```

**Decision** : c_hat_t = argmax_i y_hat_t(i)

**Fonction objectif** : entropie croisee
```
J(theta) = -SUM_i SUM_t SUM_j delta(y_t = j) * ln(y_hat_t(j))
```

### RNN bidirectionnels

```
  -->  h1 --> h2 --> h3 --> h4    (sens gauche-droite)
  <--  h'1 <-- h'2 <-- h'3 <-- h'4  (sens droite-gauche)

  Representation de w2 = [h2 ; h'2]  (contexte complet)
```

**Avantage** : chaque mot a acces a son contexte **passe et futur**.

### LSTM-CRF (etat de l'art)

Combine :
- **LSTM bidirectionnel** : predictions individuelles riches
- **Couche CRF** : coherence des dependances entre etiquettes

```
  mots --> BiLSTM --> scores par etiquette --> CRF --> sequence optimale
```

## 5.6 POS Tagging : resume des approches

### Metriques d'evaluation

- **Precision** : ~96-97% sur tous les mots (etat de l'art)
- ~3-4 erreurs par 100 mots, soit environ 1 erreur par phrase
- Maximum theorique : ~98%

### Sources d'information

| Source | Precision seule |
|--------|----------------|
| Contexte uniquement (etiquettes voisines) | ~77% |
| Mot uniquement (etiquette la plus frequente) | ~90-92% |
| Les deux combines | ~96-97% |

### Code Python : POS tagging avec spaCy

```python
import spacy
nlp = spacy.load("fr_core_news_sm")

doc = nlp("Le chat mange la souris noire")
for token in doc:
    print(f"{token.text:12} POS={token.pos_:6} Tag={token.tag_:8} "
          f"Dep={token.dep_}")
# Le           POS=DET    Tag=DET      Dep=det
# chat         POS=NOUN   Tag=NOUN     Dep=nsubj
# mange        POS=VERB   Tag=VERB     Dep=ROOT
# la           POS=DET    Tag=DET      Dep=det
# souris       POS=NOUN   Tag=NOUN     Dep=obj
# noire        POS=ADJ    Tag=ADJ      Dep=amod
```

## 5.7 Reconnaissance d'entites nommees (NER)

### Code Python : NER avec spaCy

```python
import spacy
nlp = spacy.load("fr_core_news_sm")

doc = nlp("Emmanuel Macron a visite la Tour Eiffel a Paris le 14 juillet")
for ent in doc.ents:
    print(f"  {ent.text:20} --> {ent.label_}")
# Emmanuel Macron      --> PER
# Tour Eiffel          --> LOC
# Paris                --> LOC
# 14 juillet           --> MISC
```

## 5.8 Comparaison des trois approches

```
  +----------+    +----------+    +----------+
  |   HMM    |    |   CRF    |    |   RNN    |
  +----------+    +----------+    +----------+
  | Generatif|    |Discrimin.|    |Discrimin.|
  |          |    |          |    |          |
  | p(w,t)   |    | p(t|w)   |    | p(t|w)   |
  |          |    |          |    |          |
  | Hyp.     |    | Features |    | Features |
  | fortes   |    | manuelles|    | apprises |
  |          |    |          |    |          |
  | Rapide   |    | Moderee  |    | Lent     |
  | Peu de   |    | Moyenne  |    | Beaucoup |
  | donnees  |    | de       |    | de       |
  |          |    | donnees  |    | donnees  |
  +----------+    +----------+    +----------+
```

| Critere | HMM | CRF | RNN |
|---------|-----|-----|-----|
| Type | Generatif | Discriminant | Discriminant |
| Hypotheses fortes | Oui | Non | Non |
| Dependances longues | Non | Partiellement | Oui |
| Features manuelles | Non | Oui | Non |
| Besoin de donnees | Faible | Moyen | Eleve |
| Interpretabilite | Bonne | Bonne | Faible |
| Performance POS | ~97% | ~97% | ~97%+ |
| Performance NER | Moyenne | Bonne | Tres bonne |

## 5.9 Pieges classiques

- **Confondre generatif et discriminant** : HMM modelise p(w,t), CRF modelise p(t|w) directement
- **Oublier les hypotheses du HMM** : Markov (etiquette ne depend que de la precedente) + independance conditionnelle (mot ne depend que de son etiquette)
- **Confondre Z(w) du CRF** : c'est la fonction de partition, pas une probabilite -- elle sert a normaliser
- **Croire que le RNN remplace tout** : pour peu de donnees, HMM ou CRF peuvent etre meilleurs
- **Oublier le systeme BIO** : B = debut, I = interieur, O = exterieur -- 2n+1 etiquettes pour n types
- **Viterbi** : c'est de la programmation dynamique, PAS une enumeration de toutes les sequences
- **LSTM-CRF** : c'est la combinaison BiLSTM + CRF qui est l'etat de l'art, pas l'un OU l'autre

## 5.10 Recapitulatif

| Concept | A retenir |
|---------|-----------|
| Etiquetage de sequences | Une etiquette par token |
| Systeme BIO | B=debut, I=interieur, O=exterieur |
| HMM | Generatif : p(w,t) = p(t)*p(w\|t), parametres A, B, pi |
| Viterbi | Programmation dynamique, O(n*\|T\|^2) |
| CRF | Discriminant : p(t\|w) = exp(SUM lambda*f)/Z(w) |
| Fonctions de caract. | Binaires, decomposees, arbitraires |
| RNN | Embedding + recurrence + softmax |
| BiRNN | Contexte passe + futur |
| LSTM-CRF | Etat de l'art (BiLSTM + CRF) |
| POS tagging | ~96-97% precision |
