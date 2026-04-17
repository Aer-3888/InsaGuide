---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
## 🧾 1. **Définition et tokenisation des documents**

**Q1 : Qu'est-ce qu'un "document" dans le contexte du TAL ?**  
**R :** C’est tout contenu textuel structuré, comme un livre, un paragraphe, une phrase, un article, un tweet, etc.

**Q2 : Qu'est-ce qu’un "token" ?**  
**R :** Un token est une unité élémentaire de texte (souvent un mot ou une sous-unité de mot) extraite lors de la tokenisation.

**Q3 : Pourquoi représente-t-on les documents comme des vecteurs ?**  
**R :** Pour effectuer des tâches comme la classification, l’analyse de sentiment ou la recherche d’information, en comparant les documents entre eux dans un espace vectoriel.

**Q4 : Quelle hypothèse sous-tend le modèle "Bag of Words" ?**  
**R :** L’ordre des mots n’a pas d’importance (hypothèse d’indépendance des tokens).

---

## 🎲 2. **Approche Naive Bayes**

**Q5 : Quelle est la formule simplifiée de Bayes utilisée ?**  
**R :** p(c|d) = p(d|c) × p(c)

**Q6 : Quelle est l’hypothèse clé du classificateur Naive Bayes ?**  
**R :** Les mots du document sont indépendants conditionnellement à la classe.

**Q7 : Quelle différence entre l’estimateur binaire et l’estimateur fréquentiel ?**  
**R :**

- Binaire : considère seulement la présence ou absence d’un mot.
    
- Fréquentiel : prend en compte le nombre d’occurrences du mot.
    

---

## 🧪 3. **Régularisation et lissage**

**Q8 : Pourquoi le lissage est-il nécessaire dans Naive Bayes ?**  
**R :** Pour éviter que la probabilité d’un document devienne nulle si un mot n’a jamais été observé dans une classe.

**Q9 : Que fait le lissage de Laplace (additif) ?**  
**R :** Il ajoute 1 à chaque fréquence pour éviter les zéros.

**Q10 : Qu’exprime la loi de Zipf ?**  
**R :** Que la fréquence d’un mot est inversement proportionnelle à son rang dans le corpus.

---

## 📊 4. **Maximum d'entropie (MaxEnt)**

**Q11 : Quel est le principe du maximum d’entropie ?**  
**R :** Choisir la distribution la plus incertaine (maximisant l’entropie) parmi celles qui respectent les contraintes imposées par les données.

**Q12 : À quel modèle connu est équivalent MaxEnt ?**  
**R :** À la régression logistique multinomiale.

**Q13 : Que sont les fonctions de caractéristiques fₖ ?**  
**R :** Ce sont des mesures calculées sur le document, comme la proportion de mots positifs, ou la présence d’un mot-clé donné.

---

## 👜 5. **Modèle sac de mots (Bag-of-Words)**

**Q14 : Quelles étapes composent le modèle Bag-of-Words ?**  
**R :**

1. Sélection des termes (tokenisation, lemmatisation, filtrage)
    
2. Attribution de poids (présence, fréquence brute, fréquence relative)
    

**Q15 : Quel est le principal défaut du modèle BoW ?**  
**R :** Il ignore l’ordre et le contexte des mots, ce qui limite la compréhension sémantique.

---

## 📈 6. **Pondération TF-IDF**

**Q16 : Que signifie TF-IDF ?**  
**R :** Term Frequency - Inverse Document Frequency

**Q17 : Pourquoi utiliser le facteur IDF ?**  
**R :** Pour réduire l’influence des mots trop fréquents et peu discriminants.

**Q18 : Que signifie un IDF nul ?**  
**R :** Le mot apparaît dans tous les documents → il n’est pas informatif.

---

## 📐 7. **Modèle d’espace vectoriel**

**Q19 : Quelles sont les principales métriques utilisées pour comparer les vecteurs ?**  
**R :**

- Produit scalaire
    
- Distance euclidienne (L2)
    
- Cosinus de similarité
    

**Q20 : Quels classificateurs peut-on utiliser dans l’espace vectoriel ?**  
**R :** k-NN, régression logistique, SVM, réseaux de neurones.

---

## 🔍 8. **Limites du modèle BoW et solutions**

**Q21 : Quels sont les inconvénients du modèle BoW ?**  
**R :**

- Oublie l’ordre des mots
    
- Haute dimension
    
- Pas de sémantique (chat ≠ minou)
    
- Pas de similarité entre documents sans mots communs
    

**Q22 : Quelle solution générale propose-t-on ?**  
**R :** Utiliser des représentations compactes basées sur des **variables latentes** ou des **représentations distribuées** (embeddings, etc.)

---
Voici un ensemble de **questions-réponses pour réviser** les parties **Plongements de documents**, **Auto-encodeurs**, **RNN**, **Évaluation des embeddings**, **Classification**, et **Concepts clés** :

---

## 📘 **Plongements de documents**

**Q1.** Quel est le rôle d'une couche d'embedding ?  
**R :** Transformer chaque token en un vecteur dense de dimension ℝᵈ.

**Q2.** Quelle est une méthode simple pour obtenir un embedding de document ?  
**R :** Faire la moyenne des embeddings des mots du document :

d⃗=1nd∑i=1ndembedding(wi)\vec{d} = \frac{1}{n_d} \sum_{i=1}^{n_d} \text{embedding}(w_i)

---

## 🔧 **Auto-encodeurs**

**Q3.** À quoi servent les auto-encodeurs ?  
**R :** À apprendre des représentations compactes des données.

---

## 🔁 **Réseaux de neurones récurrents (RNN)**

**Q4.** Que représente l’état caché hih_i dans un RNN ?  
**R :** Un résumé de l’entrée jusqu’au token wiw_i, intégrant l'information séquentielle.

**Q5.** Que fait la cellule LSTM avec ses "gates" (portes) ?  
**R :**

- `iₜ` : décide quoi ajouter
    
- `fₜ` : décide quoi oublier
    
- `oₜ` : décide quoi transmettre
    
- Le tout contrôle l’état de cellule ctcₜ et l’état caché hthₜ
    

**Q6.** Quelle est la différence entre LSTM et GRU ?  
**R :** GRU est une version simplifiée avec deux portes (mise à jour `zₜ` et reset `rₜ`) au lieu de trois dans LSTM, mais permet aussi de contrôler le flux d’information dans le temps.

---

## 📊 **Évaluation des embeddings**

**Q7.** Quelle est la différence entre évaluation intrinsèque et extrinsèque ?  
**R :**

- **Intrinsèque** : mesure la qualité des embeddings eux-mêmes (ex : similarité sémantique).
    
- **Extrinsèque** : mesure l’impact des embeddings sur des tâches (ex : classification, QA).
    

**Q8.** Citez 3 tâches du benchmark GLUE.  
**R :**

1. CoLA : grammaticalité
    
2. MRPC : paraphrase
    
3. MNLI : inférence
    

**Q9.** Quel est l’équivalent français de GLUE ?  
**R :** FLUE, basé sur le modèle FlauBERT.

---

## 🧠 **Classification avec embeddings**

**Q10.** Deux usages des embeddings dans les réseaux feed-forward ?  
**R :**

1. Utiliser des embeddings pré-entraînés fixes
    
2. Réentraîner les embeddings avec les données de la tâche
    

**Q11.** Quel est le rôle de la **triplet loss** en recherche d'information ?  
**R :** Forcer les documents pertinents à être plus proches d'une requête que les documents non pertinents.  
Formule :

L(a,p,n)=max⁡(∥f(a)−f(p)∥2−∥f(a)−f(n)∥2+α,0)L(a, p, n) = \max(\|f(a) - f(p)\|^2 - \|f(a) - f(n)\|^2 + \alpha, 0)

---

## 📌 **Concepts clés à retenir**

**Q12.** Quelle est l’hypothèse du modèle bag-of-words ?  
**R :** L’ordre des mots n’a pas d’importance.

**Q13.** Quel est l’intérêt du TF-IDF ?  
**R :** Met en balance la fréquence locale d’un mot dans un document et sa rareté globale.

**Q14.** Qu’est-ce que le modèle de maximum d’entropie ?  
**R :** Un modèle de régression logistique multinomiale.

**Q15.** Pourquoi le lissage est-il important ?  
**R :** Pour éviter les problèmes de zéros dans les probabilités à cause de la loi de Zipf et des données rares.

---

Souhaites-tu que je transforme tout ça en **flashcards imprimables** ou en **quiz interactif** ?