# Cheat Sheet TALEO -- Preparation DS

> DS : 1 heure, sans document, calculatrice autorisee
> Questions independantes, mix cours + calculs + schemas

---

## 1. FORMULES INDISPENSABLES

### Representation des mots

```
Similarite cosinus :    cos(x, y) = (x . y) / (||x|| * ||y||)

Wu-Palmer :             sim(c1, c2) = 2 * depth(LCS) / (depth(c1) + depth(c2))

Word2Vec Skip-gram :    J = SUM_t SUM_j log p(w_{t+j} | w_t)
                        p(o|c) = exp(u'_o . v_c) / SUM_w exp(u'_w . v_c)
```

### Representation des documents

```
TF :                    tf(w,d) = n(w,d) / SUM_v n(v,d)

IDF :                   idf(w) = log(|D| / df(w))

TF-IDF :                tfidf(w,d) = tf(w,d) * idf(w)

Naive Bayes :           c_hat = argmax_c p(c) * PROD p(w_i | c)

Lissage Laplace :       p(w|c) = (count(w,c) + 1) / (N_c + |V|)
```

### Recherche d'information

```
Precision :             P = |pertinents recuperes| / |recuperes|

Rappel :                R = |pertinents recuperes| / |pertinents totaux|

F1 :                    F1 = 2*P*R / (P+R)

BM25 :                  SUM idf(t) * [tf(t,d)*(k1+1)] / [tf(t,d) + k1*(1-b+b*|d|/avgdl)]

PageRank :              PR(u) = (1-d)/N + d * SUM PR(v)/L(v)

nDCG :                  DCG(k) = SUM (2^rel(i) - 1) / log2(i+1)
                        nDCG(k) = DCG(k) / IDCG(k)

Rocchio :               q1 = alpha*q0 + beta*(1/|Dr|)*SUM d - gamma*(1/|Dnr|)*SUM d
```

### Modeles de langage

```
N-gramme :              P[w_i | w_{i-n+1}, ..., w_{i-1}]

Estimation ML :         P[w|h] = C(hw) / C(h)

Lissage Laplace :       P[w|h] = (C(hw) + 1) / (C(h) + |V|)

Perplexite :            PP = 2^{-1/n * SUM log2 P(w_i)}
                        (PLUS BASSE = MEILLEUR)

Interpolation :         P_I = SUM lambda_i * P_ML[w|h_i]   (SUM lambda = 1)
```

### Etiquetage de sequences

```
HMM :                   p(w,t) = p(t1)*p(w1|t1) * PROD p(t_i|t_{i-1})*p(w_i|t_i)
                        Parametres : A (transitions), B (emissions), pi (init)

Viterbi :               H(i,k) = max_j [H(j,k-1) * a_ji * b_i(w_k)]

CRF :                   P(t|w) = (1/Z(w)) * exp(SUM lambda_k * f_k(t,w))
```

### Analyse syntaxique

```
PCFG :                  P(arbre) = PRODUIT P(regle_i)

CKY :                   O(n^3 * |R|^2), necessite CNF

UAS :                   Arcs tete correcte / total arcs
LAS :                   Arcs tete+label corrects / total arcs
```

---

## 2. STRUCTURE TYPE DU DS (basee sur annales 2016-2023)

### Section 1 : Analyse syntaxique (3-4 pts)
- Dessiner un/des arbres d'analyse pour une phrase avec PCFG
- Calculer la probabilite de chaque arbre
- Expliquer l'interet des PCFG

### Section 2 : Questions de cours (4-5 pts)
- Definition precision/rappel
- Particularite du nDCG
- Signification et role de l'IDF
- Analyse en dependances d'une phrase
- Distance pour embeddings (cosinus)

### Section 3 : Representation des documents (5-7 pts)
- Calcul Naive Bayes avec lissage de Laplace
- Classification d'un nouveau document
- Autres techniques de classification

### Section 4 : Modeles de langue (4-5 pts)
- Lissage adapte aux n-grammes ?
- Fonctionnement d'un RNN pour modele de langue

---

## 3. QUESTIONS CLASSIQUES ET REPONSES TYPES

### Q : Qu'est-ce que l'IDF et a quoi sert-il ?
**R** : IDF = Inverse Document Frequency = log(|D|/df(w)). Il donne un poids eleve aux termes rares dans la collection et faible aux termes frequents partout (mots vides). Utilise dans TF-IDF pour ponderer les termes d'indexation.

### Q : Particularite du nDCG ?
**R** : Le nDCG utilise des jugements de pertinence **gradues** (pas seulement binaires), penalise les documents pertinents mal classes grace a un discount logarithmique, et normalise par le classement ideal (IDCG).

### Q : Interet des PCFG par rapport aux CFG ?
**R** : Les probabilites permettent de **desambiguiser** les phrases ayant plusieurs arbres d'analyse valides en choisissant l'arbre le plus probable. Elles permettent aussi de classer les analyses par probabilite.

### Q : Distance pour la similarite semantique entre embeddings ?
**R** : La **similarite cosinus** : cos(x,y) = (x.y) / (||x|| * ||y||). Elle vaut 1 pour des vecteurs identiques, 0 pour des vecteurs orthogonaux, -1 pour des vecteurs opposes. Invariante a la norme des vecteurs.

### Q : Lissage de Laplace adapte aux n-grammes ?
**R** : Non. Laplace redistribue trop de masse vers les n-grammes non vus car |V|^n est enorme. Quand on augmente la constante, le modele tend vers une distribution uniforme (perplexite augmente). Preferer Kneser-Ney ou interpolation.

### Q : Fonctionnement d'un RNN pour modele de langage ?
**R** : Entrees : embedding du mot w_t + etat cache h_{t-1}. Sortie : nouvel etat cache h_t (resume de l'historique). Prediction : softmax(V*h_t) donne P(w_{t+1}). Apprentissage : minimiser l'entropie croisee entre la prediction et le mot reel suivant (auto-supervise).

### Q : Difference HMM vs CRF ?
**R** : HMM = generatif, modelise p(w,t) = p(t)*p(w|t) avec hypotheses fortes (Markov + independance conditionnelle). CRF = discriminant, modelise directement p(t|w) sans hypotheses restrictives, permet des fonctions de caracteristiques arbitraires.

### Q : Donnez l'analyse en dependances de "Paul regarde le chien noir"
**R** :
```
regarde --nsubj--> Paul
regarde --obj----> chien
chien   --det----> le
chien   --amod---> noir
```

---

## 4. ALGORITHMES CLES

### Viterbi (HMM/CRF)
```
1. Initialisation : H(i, 1) = pi_i * b_i(w_1) pour chaque etat i
2. Recursion : H(i, k) = max_j [H(j, k-1) * a_ji * b_i(w_k)]
3. Terminaison : meilleur etat final = argmax_i H(i, n)
4. Backtracking : remonter pour trouver la sequence complete
Complexite : O(n * |T|^2)
```

### CKY (parsing)
```
1. Remplir la diagonale (mots --> categories terminales)
2. Pour chaque longueur l = 2 a n :
     Pour chaque debut i :
       Pour chaque coupure k :
         Si B in table[i][k] et C in table[k+1][i+l-1]
         et A --> B C existe : ajouter A dans table[i][i+l-1]
3. Si S in table[1][n] : phrase acceptee
Complexite : O(n^3 * |R|^2)
```

### Naive Bayes avec Laplace
```
1. Compter n(w, c) pour chaque mot w et classe c
2. Calculer N_c = SUM_w n(w, c) et |V| = taille vocabulaire
3. p(w|c) = (n(w,c) + 1) / (N_c + |V|)
4. p(c) = nb docs de classe c / nb docs total
5. Classification : c_hat = argmax_c p(c) * PROD p(w_i|c)
```

### BPE (tokenisation sous-mot)
```
1. Depart : chaque mot = sequence de lettres
2. Compter les paires adjacentes dans tout le corpus
3. Fusionner la paire la plus frequente
4. Repeter jusqu'a taille de vocabulaire voulue
```

---

## 5. COMPARAISONS RAPIDES

### Modeles de RI

| Modele | Type | Classement | Forces |
|--------|------|-----------|--------|
| Booleen | Ensemble | Non | Simple |
| Vectoriel | Geometrique | Oui (cosinus) | Flexible |
| Probabiliste (BM25) | Statistique | Oui | Performant |

### Modeles d'etiquetage

| Modele | Type | Caracteristiques | Dependances longues |
|--------|------|-----------------|-------------------|
| HMM | Generatif | Non | Non |
| CRF | Discriminant | Manuelles | Partiellement |
| RNN | Discriminant | Apprises | Oui |

### Embeddings de mots

| Methode | Type | Mots inconnus | Forces |
|---------|------|-------------|--------|
| Word2Vec CBOW | Local | Non | Rapide, syntaxe |
| Word2Vec Skip-gram | Local | Non | Precis, semantique |
| GloVe | Global | Non | Efficace, peu de donnees |
| FastText | Local + n-grammes | Oui | Robuste |

### Approches L2R

| Approche | Entree | Limite |
|----------|--------|--------|
| Pointwise | Score(q,d) | Ignore l'ordre relatif |
| Pairwise | d1 vs d2 | Pas de position absolue |
| Listwise | Liste complete | Complexe |

---

## 6. PIEGES FREQUENTS EN DS

| Piege | Correction |
|-------|-----------|
| Perplexite elevee = bon modele | **FAUX** : plus basse = meilleur |
| Lissage Laplace pour n-grammes | **INADAPTE** : redistribue trop de masse |
| CBOW predit le contexte | **FAUX** : CBOW predit le mot central |
| HMM modelise p(t\|w) | **FAUX** : HMM modelise p(w,t), c'est CRF qui fait p(t\|w) |
| IDF eleve = mot frequent | **FAUX** : IDF eleve = mot rare (discriminant) |
| nDCG = jugements binaires | **FAUX** : nDCG utilise des jugements gradues |
| UAS > LAS toujours | **VRAI** : LAS est plus strict (tete + label) |
| CKY fonctionne avec toute CFG | **FAUX** : necessite la forme normale de Chomsky |
| P(arbre PCFG) = somme des regles | **FAUX** : c'est le PRODUIT des probabilites |
| Laplace : (count+1)/(total+1) | **FAUX** : c'est (count+1)/(total+|V|) |

---

## 7. CHECKLIST AVANT LE DS

- [ ] Savoir calculer TF-IDF pour un mot dans un document
- [ ] Savoir appliquer Naive Bayes avec lissage de Laplace
- [ ] Savoir classifier un document avec Naive Bayes
- [ ] Connaitre les definitions precision, rappel, F1, MAP, nDCG
- [ ] Savoir dessiner un arbre de constituants avec une PCFG
- [ ] Savoir calculer P(arbre) = PRODUIT des P(regles)
- [ ] Savoir expliquer l'interet des PCFG
- [ ] Connaitre la formule de PageRank et son interpretation
- [ ] Savoir expliquer Viterbi (programmation dynamique)
- [ ] Connaitre la difference HMM vs CRF
- [ ] Savoir dessiner une analyse en dependances
- [ ] Connaitre la formule de perplexite et son interpretation
- [ ] Savoir expliquer pourquoi Laplace est inadapte aux n-grammes
- [ ] Savoir expliquer le fonctionnement d'un RNN pour modele de langage
- [ ] Connaitre la similarite cosinus et son usage pour les embeddings
- [ ] Savoir ce que sont BM25, Rocchio, BPE

---

## 8. AIDE-MEMOIRE VOCABULAIRE

| Sigle | Signification |
|-------|---------------|
| TAL/NLP | Traitement Automatique des Langues |
| RI/IR | Recherche d'Information |
| BoW | Bag of Words (sac de mots) |
| TF-IDF | Term Frequency - Inverse Document Frequency |
| HMM | Hidden Markov Model |
| CRF | Conditional Random Field |
| RNN | Recurrent Neural Network |
| LSTM | Long Short-Term Memory |
| GRU | Gated Recurrent Unit |
| CFG | Context-Free Grammar |
| PCFG | Probabilistic CFG |
| CKY | Cocke-Kasami-Younger (algorithme de parsing) |
| CNF | Chomsky Normal Form |
| POS | Part of Speech (categorie grammaticale) |
| NER | Named Entity Recognition |
| BIO | Begin-Inside-Outside |
| UAS | Unlabeled Attachment Score |
| LAS | Labeled Attachment Score |
| MAP | Mean Average Precision |
| nDCG | Normalized Discounted Cumulative Gain |
| BM25 | Best Matching 25 (Okapi) |
| L2R | Learning to Rank |
| BPE | Byte Pair Encoding |
| SVD | Singular Value Decomposition |
| PP | Perplexite |
