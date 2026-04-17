---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
### 🧠 **1. Concepts de base**

**Q1.** Qu’est-ce qu’un modèle de langage ?  
**R :** C’est un modèle probabiliste qui attribue une probabilité à une séquence de mots dans un vocabulaire donné. Il estime P[w1, w2, ..., wn].

**Q2.** À quoi sert un modèle de langage ?  
**R :** À des tâches comme la correction orthographique, la traduction automatique, la reconnaissance vocale, la prédiction de texte, ou encore l’identification de langue.

---

### 📘 **2. N-grammes et approximation**

**Q3.** Quelle est l’idée principale derrière les modèles n-grammes ?  
**R :** Approximons la probabilité d’un mot sachant tout l’historique par un historique court :  
P[wi|w1...wi-1] ≈ P[wi|wi-n+1...wi-1]

**Q4.** Quelle est la formule du modèle trigramme ?  
**R :** P[wi|wi-2, wi-1]

**Q5.** Quels sont les avantages des n-grammes ?  
**R :** Simplicité, efficacité, estimation directe à partir de fréquences.

**Q6.** Quels sont leurs inconvénients ?  
**R :** Faible portée contextuelle, explosion combinatoire, sparsité des données.

---

### 📊 **3. Évaluation par la perplexité**

**Q7.** Qu’est-ce que la perplexité ?  
**R :** Une mesure de la qualité prédictive d’un modèle de langage.  
Formule :  
P(q, x1n) = 2^(-1/n ∑ log2(q(xi)))

**Q8.** Que signifie une perplexité plus basse ?  
**R :** Que le modèle prédit mieux les mots suivants dans un texte.

---

### 🧮 **4. Estimation et problèmes pratiques**

**Q9.** Qu’est-ce que l’estimation par maximum de vraisemblance ?  
**R :** PML[w|h] = C(hw) / C(h), c’est-à-dire la fréquence relative de la suite.

**Q10.** Quel problème pose la loi de Zipf aux n-grammes ?  
**R :** Beaucoup de n-grammes n’apparaissent qu’une fois → sparsité.

---

### 🧂 **5. Lissage**

**Q11.** Pourquoi a-t-on besoin de lissage ?  
**R :** Pour attribuer une probabilité non nulle aux événements jamais vus dans le corpus d’entraînement.

**Q12.** Quelle est la formule du lissage de Laplace (add-one) ?  
**R :** P[w|h] = (c(hw) + 1)/(c(h) + |V|)

**Q13.** Quel est l’intérêt du lissage de Kneser-Ney ?  
**R :** Il utilise la diversité contextuelle des mots rares pour mieux estimer les probabilités.

---

### 🔁 **6. Interpolation & Back-off**

**Q14.** Quelle est la différence entre interpolation et back-off ?  
**R :**

- Interpolation combine les estimations à tous les ordres (ex. trigramme + bigramme + unigramme).
    
- Back-off n’utilise que le plus haut ordre possible, et recule si c(hw) = 0.
    

**Q15.** Pourquoi utilise-t-on une version récursive de l’interpolation ?  
**R :** Pour adapter dynamiquement les poids selon la fréquence des contextes.

---

### 🧱 **7. Limites et extensions aux N-grammes**

**Q16.** Pourquoi dit-on que les n-grammes ont une mémoire courte ?  
**R :** Parce qu’ils ne prennent en compte qu’un contexte local (n-1 mots précédents).

**Q17.** Quelle est l’idée d’un modèle de classe ?  
**R :** On regroupe les mots en classes pour réduire la complexité :  
P[w|contexte] = P[classe|contexte] × P[w|classe]

---

### 🧠 **8. Modèles neuronaux**

**Q18.** Quelle est l’architecture du modèle de Bengio (2003) ?  
**R :**

- Embedding des mots
    
- Concatenation
    
- MLP avec softmax
    
- Entraînement par log-vraisemblance
    

**Q19.** Pourquoi les RNN sont-ils utiles en langage naturel ?  
**R :** Parce qu’ils mémorisent un historique arbitrairement long via l’état caché.

**Q20.** Comment s’entraîne un RNN ?  
**R :** En maximisant la vraisemblance de la séquence suivante (auto-supervisé).

**Q21.** Quelle est la différence entre un RNN classique et un RNN bidirectionnel ?  
**R :** Le RNN bidirectionnel prend en compte le passé et le futur d’un mot.

---

### 📌 **9. Applications et concepts à retenir**

**Q22.** Donne deux applications typiques des modèles de langage.  
**R :** Prédiction de texte (clavier), traduction automatique (ex. Google Translate).

**Q23.** Quelles sont les 3 familles de techniques de lissage à retenir ?  
**R :** Additive (Laplace), Discounting (Kneser-Ney, Good-Turing), Interpolation/Back-off.

**Q24.** Quelle est la formule générale de la perplexité ?  
**R :** PP = 2^(-1/n ∑ log2(q(wi)))  
ou : PP = k√(1/Pq(w1...wk))
