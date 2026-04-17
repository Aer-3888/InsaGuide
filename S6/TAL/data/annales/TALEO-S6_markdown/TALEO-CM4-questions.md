---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
## 🔹 **Introduction & Définition**

**Q1.** Quelle est la définition de la Recherche d'Information (selon C. Manning) ?  
**R1.** C’est le processus visant à retrouver, dans de grandes collections de documents non structurés (généralement du texte), ceux qui satisfont un besoin d'information.

**Q2.** Cite quatre domaines d’application de la Recherche d’Information.  
**R2.**

1. Moteurs de recherche Web
    
2. Gestion documentaire en entreprise
    
3. Bibliothèques numériques
    
4. Domaines spécialisés (droit, médecine, etc.)
    

**Q3.** Quels sont les grands thèmes abordés dans un cours typique de RI ?  
**R3.**

1. Représentation et indexation
    
2. Modèles et mesures de similarité
    
3. Évaluation
    
4. Expansion de requêtes
    
5. Focus sur le Web
    
6. Apprentissage pour le classement (L2R)
    
7. RI et apprentissage profond
    

---

## 🔹 **1. Représentation et Indexation**

**Q4.** Quelle est la différence entre l’indexation manuelle et automatique ?  
**R4.**

- **Manuelle** : faite par des humains, avec un vocabulaire contrôlé.
    
- **Automatique** : faite par ordinateur, focalisée sur le résultat, sans métalangage.
    

**Q5.** Qu’est-ce qu’un langage d’indexation contrôlé ?  
**R5.** C’est un langage où chaque concept est représenté par un terme approuvé (ex : mots-clés ou thésaurus) utilisé de manière uniforme, généralement en indexation manuelle.

**Q6.** Qu’est-ce qu’un sac de mots (BoW) ?  
**R6.** C’est une représentation non ordonnée des termes d’un document, sans tenir compte de la structure syntaxique.

**Q7.** Pourquoi supprime-t-on les mots vides (stop words) ?  
**R7.** Car ils sont fréquents mais peu informatifs ; leur suppression réduit la taille du stockage (~25%).

**Q8.** Donne la formule de l’IDF (Inverse Document Frequency).  
**R8.** IDF(t) = log(|Ω| / df(t))  
Avec |Ω| la taille de la collection, et df(t) le nombre de documents contenant t.

**Q9.** Quelle est la formule générale de pondération des termes ?  
**R9.** wᵢ,ⱼ = lᵢ × gᵢ × nᵢ

- lᵢ : pondération locale (ex : tf)
    
- gᵢ : pondération globale (ex : IDF)
    
- nᵢ : normalisation (ex : cosinus)
    

---

## 🔹 **2. Modèles & Similarité**

**Q10.** Comment fonctionne le modèle booléen ?  
**R10.** Il repose sur la logique booléenne (∧, ∨, ¬) ; un document est soit pertinent soit non pertinent, sans classement.

**Q11.** Quelles sont les limites du modèle booléen ?  
**R11.** Difficulté de formulation, absence de classement, résultats peu intuitifs.

**Q12.** En quoi consiste le modèle vectoriel ?  
**R12.** Il représente documents et requêtes dans un espace vectoriel ; leur similarité est mesurée par des métriques (cosinus, distance euclidienne, etc.).

**Q13.** Donne la formule de la similarité cosinus.  
**R13.** cos(D,Q) = (D·Q) / (||D|| × ||Q||)

**Q14.** Que modélise le modèle probabiliste ?  
**R14.** Il estime la probabilité qu’un document soit pertinent pour une requête donnée, basée sur P(R=1|d,q).

**Q15.** Qu’est-ce que le score BM25 prend en compte ?  
**R15.** La fréquence des termes, la longueur du document, et la position des termes dans les documents et les requêtes.

---

## 🔹 **3. Évaluation**

**Q16.** Qu’est-ce que la précision et le rappel ?  
**R16.**

- **Précision** = pertinents récupérés / récupérés
    
- **Rappel** = pertinents récupérés / pertinents totaux
    

**Q17.** Quelle est la formule de la mesure F1 ?  
**R17.** F₁ = 2PR / (P + R)

**Q18.** Qu’est-ce que MAP (Mean Average Precision) ?  
**R18.** Moyenne des précisions obtenues à chaque position pertinente, sur toutes les requêtes.

**Q19.** Qu’est-ce que nDCG mesure ?  
**R19.** La qualité du classement des documents en tenant compte du degré de pertinence et de la position (documents très pertinents mieux valorisés s’ils sont en haut).

---

## 🔹 **4. Expansion de Requêtes**

**Q20.** Pourquoi l’expansion de requêtes est-elle utile ?  
**R20.** Elle compense les problèmes de formulation, de synonymie, et augmente le rappel.

**Q21.** Quelle est l'idée de base de l'algorithme de Rocchio ?  
**R21.** Reformuler la requête initiale en l’ajustant vers les documents pertinents et en s’éloignant des non pertinents.

**Q22.** Qu'est-ce que le pseudo retour de pertinence ?  
**R22.** Automatisation du feedback utilisateur en considérant les premiers documents retournés comme pertinents.

---

## 🔹 **5. Focus sur le Web**

**Q23.** Quel est le rôle d’un crawler ?  
**R23.** Explorer les pages Web, en suivre les liens, et récupérer les données pour indexation.

**Q24.** Qu’est-ce que le PageRank ?  
**R24.** Une mesure de l'importance d'une page Web basée sur la structure des liens hypertextes, simulant un surfeur aléatoire.

**Q25.** Donne la formule de PageRank.  
**R25.** PR(u) = ((1 - d)/N) + d × Σ [PR(v) / L(v)], où v ∈ Bu (pages pointant vers u), et d est le facteur d’amortissement (~0.85).

---

## 🔹 **6. Learning to Rank (L2R)**

**Q26.** Qu’est-ce que Learning to Rank ?  
**R26.** Utilisation de l'apprentissage supervisé pour apprendre un modèle qui classe les documents selon leur pertinence à une requête.

**Q27.** Quelles sont les trois approches principales du L2R ?  
**R27.**

1. **Pointwise** : score par document
    
2. **Pairwise** : comparaison de paires
    
3. **Listwise** : apprentissage sur classements entiers
    

**Q28.** Quelle est la limite de l’approche pointwise ?  
**R28.** Elle ignore l’ordre relatif entre les documents et la position dans le classement.

---
Voici une version **plus jolie et structurée** du chapitre **"7. Recherche d’Information et Apprentissage Profond"**, avec une mise en page claire et des éléments visuels pour faciliter la mémorisation :

---

# 🔍 7. Recherche d’Information & Apprentissage Profond

## 🧠 Deux Idées Fondamentales

1. **Injection de représentations sémantiques** (embeddings de mots/documents) dans les modèles traditionnels de RI.
    
2. **Apprentissage bout-en-bout** de représentations + fonction de classement via réseaux de neurones.
    

---

## 🔁 Expansion de Requêtes par Embeddings

> **Roy et al., 2016**  
> 📌 Expansion de la requête `q` avec ses _k plus proches voisins_ dans l’espace sémantique (embeddings).

---

## 🧭 Dual Embedding Space Model

> **Nalisnick et al., 2016**

- 📄 Document : centroïde des **vecteurs OUT** normalisés de ses mots.
    
- ❓ Requête : vecteur **IN** du mot (dans Word2Vec).
    
- 🔁 Similarité = cosinus entre représentation `q` et `d`.
    
- 🧠 Utilise les **deux espaces** (entrée & sortie) de Word2Vec.
    

---

## ⚠️ Limites des Embeddings

- ❌ Non appris **pour la tâche de RI**
    
- 👍 Bons pour **correspondance sémantique**
    
- ⚠️ Or, **pertinence ≠ similarité sémantique**
    

### ✅ Solution : Apprentissage orienté classement

- Objectif : apprendre à **classer** les documents
    
- Approches **neuronales** bout-en-bout
    

---

## 🧮 Deux Types de Modèles Neuronaux

### 🔷 Modèles **Représentation** (type _siamois_)

- Requête et document représentés **indépendamment**
    
- Comparaison via :
    
    - Produit scalaire
        
    - Cosinus
        
    - MLP
        
- ➕ Représentation de documents calculable _offline_
    

### 🔶 Modèles **Interaction**

- Calcul d'une **matrice de similarité** entre les termes de `q` et `d`
    
- Extrait des **signaux de pertinence**
    
- Combine ces signaux pour prédire un score
    

---

## 🔬 Modèles Neuronaux Clés

### 📚 **DSSM** (Deep Semantic Similarity Model)

> _Huang et al., 2013_

- 🧰 Modèle basé sur la **représentation**
    
- 🔠 Word-hashing (n-grammes de caractères)
    
- 🔄 Fully-connected layers pour embeddings
    
- 🔍 Similarité cosinus pour la recherche
    
- ⚖️ Apprentissage avec triples : `(q, d+, d−)`
    

---

### 📊 **DRMM** (Deep Relevance Matching Model)

> _Guo et al., 2016_

- 🧰 Modèle **interaction**
    
- 🔗 Pour chaque mot de `q`, histogramme des similarités (cosinus)
    
- 📊 Histogrammes → MLP
    
- ⚖️ Ponderation (term gating) : poids = `idf(t)`
    
- 💥 Premier à **battre BM25** !
    
- 🔺 Fonction perte (hinge) :
    
    L(q,d+,d−)=max⁡(0,1−s(q,d+)+s(q,d−))L(q, d^+, d^-) = \max(0, 1 - s(q, d^+) + s(q, d^-))

---

### 🤖 **MonoBERT**

> _Nogueira & Cho, 2019_

- 📦 Entrée = `[CLS], q, [SEP], d, [SEP]`
    
- 🧠 Représentation `[CLS]` utilisée pour classer
    
- 🛠️ Fine-tuning BERT **end-to-end** pour RI
    
- 🔥 Performances très élevées
    
- 🔁 Attention "all-to-all" entre mots de `q` et `d`
    

---

## ⚙️ Limitations de BERT & Solutions

- 🧱 **Restriction de longueur** d’entrée BERT
    
- 🧭 Approches pour contourner :
    
    - Indexation offline (ex : **ColBERT**)
        
    - **Re-ranking** avec MonoBERT : seulement sur les **top-k** (ex. top-1000) documents de BM25
        

---

## 📌 Récapitulatif : Points Clés à Retenir

|Thème|Idée principale|
|---|---|
|**Indexation**|Représenter les documents par des termes pertinents|
|**Modèles**|Booléen (binaire), Vectoriel (souple), Probabiliste (formel)|
|**Évaluation**|Mesures adaptées : Précision, Rappel, MAP, nDCG|
|**Expansion**|Améliorer les requêtes (feedback, synonymes)|
|**Web**|Nouveaux défis + solutions (ex : PageRank, crawling)|
|**Learning to Rank**|Approches pointwise, pairwise, listwise|
|**Deep Learning**|Embeddings & modèles neuraux end-to-end (BERT, DRMM, DSSM)|

---