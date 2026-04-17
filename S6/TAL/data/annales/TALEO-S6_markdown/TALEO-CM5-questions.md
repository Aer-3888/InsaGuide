---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
### 🔹 **Notions générales**

**Q1.** _Qu’est-ce qu’une tâche d’étiquetage en TAL ? Donne deux exemples._

**R :** C’est une tâche où chaque token d’une phrase reçoit une étiquette. Exemples :

- Détection de limites de phrase
    
- Reconnaissance d’entités nommées (NER)
    

---

**Q2.** _Donne un exemple d’annotation avec le système BIO pour la phrase suivante :_  
_"Barack Obama est né à Hawaï."_

**R :** `[B-PER I-PER O O O B-LOC O]`

---

### 🔹 **Approches naïves**

**Q3.** _Quel est le principal défaut des classificateurs locaux ?_

**R :** Ils ignorent les dépendances entre étiquettes (ex. : une étiquette dépend de la précédente).

---

**Q4.** _Vrai ou faux : Les approches par règles sont plus performantes que les HMM sur les tâches complexes._

**R :** Faux. Elles sont limitées par l’ambiguïté et l’absence d’apprentissage statistique.

---

### 🔹 **Modèles de Markov Cachés (HMM)**

**Q5.** _Quelle est la factorisation de p(w,t) dans un HMM ?_

**R :**  
p(w,t)=p(t1)p(w1∣t1)∏i=2np(ti∣ti−1)p(wi∣ti)p(w,t) = p(t_1)p(w_1|t_1) \prod_{i=2}^{n} p(t_i|t_{i-1})p(w_i|t_i)

---

**Q6.** _Dans un HMM, à quoi servent les matrices A, B et le vecteur π ?_

**R :**

- A : probabilités de transition entre états
    
- B : probabilités d’émission (token donné l’état)
    
- π : distribution initiale sur les états
    

---

**Q7.** _Quel algorithme utilise-t-on pour inférer la séquence d’étiquettes la plus probable dans un HMM ?_

**R :** L’algorithme de **Viterbi**.

---

**Q8.** _Quels types de tâches sont bien gérés par les HMM ?_

**R :** Les tâches simples comme l’étiquetage morpho-syntaxique (POS tagging).

---

### 🔹 **CRF (Champs Aléatoires Conditionnels)**

**Q9.** _Pourquoi les CRF ont-ils été introduits ?_

**R :** Pour lever les limitations des HMM, notamment :

- Hypothèse de Markov trop stricte
    
- Indépendance conditionnelle irréaliste
    

---

**Q10.** _Comment s’écrit la probabilité d’un CRF linéaire pour une séquence ?_

**R :**  
P(t∣w)=1Z(w)exp⁡(∑kλkfk(t,w))P(t|w) = \frac{1}{Z(w)} \exp\left(\sum_k \lambda_k f_k(t,w)\right)

---

**Q11.** _Donne deux types de fonctions de caractéristiques typiques dans un CRF._

**R :**

- f1(ts−1,ts)=δ(ts−1=j,ts=i)f_1(t_{s-1}, t_s) = \delta(t_{s-1}=j, t_s=i)
    
- f2(ts,w)=δ(ts=i,ws=u)f_2(t_s, w) = \delta(t_s=i, w_s=u)
    

---

**Q12.** _Quels sont les avantages principaux des CRF ?_

**R :**

- Permettent des caractéristiques complexes
    
- Meilleure performance sur tâches complexes
    
- Modèle discriminant (modélise directement p(t|w))
    

---

**Q13.** _Comment les paramètres d’un CRF sont-ils appris ?_

**R :** Par **optimisation du log-vraisemblance** (méthodes : gradient, BFGS, etc.).

---

### 🔹 **Réseaux de Neurones Récurrents (RNN)**

**Q14.** _Quels sont les composants d’un RNN de base pour l’étiquetage de séquence ?_

**R :**

- Couche d'embedding
    
- Couche récurrente : ht=σ(U(xt+ht−1))h_t = \sigma(U(x_t + h_{t-1}))
    
- Couche de sortie : y^t=softmax(Vht)\hat{y}_t = \text{softmax}(Vh_t)
    

---

**Q15.** _Quelle est la principale limitation des RNN simples ?_

**R :** Ils peuvent avoir du mal à capturer les dépendances longues (vanishing gradient).

---

**Q16.** _Quel est l'intérêt d’un RNN bidirectionnel ?_

**R :** Il combine le contexte passé et futur pour chaque token, ce qui améliore la précision.

---

**Q17.** _Cite un inconvénient des RNN par rapport aux CRF._

**R :**

- Plus coûteux en calcul
    
- Moins interprétables (boîte noire)
    

---

### 🔹 **Comparaison des modèles**

|Critère|HMM|CRF|RNN|
|---|---|---|---|
|Hypothèses fortes ?|✅|❌|❌|
|Dépendances longues ?|❌|Partiellement|✅|
|Caractéristiques manuelles ?|❌|✅|❌|
|Besoin de beaucoup de données ?|❌|⚠️|✅|
|Interprétabilité|✅|✅|❌|

---

### 🔹 **Applications et considérations pratiques**

**Q18.** _Donne trois tâches concrètes qui utilisent l’étiquetage de séquence._

**R :**

- Reconnaissance d'entités nommées (NER)
    
- Segmentation de mots
    
- Slot filling dans le dialogue
    

---

**Q19.** _Quels critères influencent le choix du modèle à utiliser ?_

**R :**

- Complexité de la tâche
    
- Quantité de données disponibles
    
- Besoins en interprétabilité
    
- Contraintes de calcul
    

---
## 🧠 PARTIE 1 — Compréhension générale

### Q1. _Qu’est-ce qu’une tâche de type "étiquetage de séquence" ? Donne 3 exemples concrets._

**R :**  
C’est une tâche où chaque token d’une séquence se voit attribuer une étiquette.  
Exemples :

- Étiquetage morpho-syntaxique (POS tagging)
    
- Reconnaissance d’entités nommées (NER)
    
- Segmentation de mots
    

---

### Q2. _Quel est le rôle du schéma BIO ? Explique les trois lettres._

**R :**

- **B** (Beginning) : début d'une entité
    
- **I** (Inside) : intérieur de l'entité
    
- **O** (Outside) : hors d'une entité  
    Ce système permet de structurer les entités dans les séquences.
    

---

### Q3. **Vrai ou Faux :** Le schéma BIO peut être utilisé pour du chunking.

**R :** Vrai.

---

### Q4. **QCM :** Lequel des éléments suivants est _le moins adapté_ pour gérer des dépendances entre les étiquettes d'une séquence ?

A. HMM  
B. CRF  
C. RNN  
D. Classificateur local

**R :** D. Classificateur local

---

## 🧠 PARTIE 2 — HMM (Modèle de Markov Caché)

### Q5. _Donne l’expression mathématique de la probabilité jointe p(w,t) dans un HMM._

**R :**  
p(w,t)=p(t1)p(w1∣t1)∏i=2np(ti∣ti−1)p(wi∣ti)p(w,t) = p(t_1)p(w_1|t_1) \prod_{i=2}^{n} p(t_i|t_{i-1})p(w_i|t_i)

---

### Q6. _Pourquoi parle-t-on de "modèle génératif" avec les HMM ?_

**R :** Parce que le modèle définit comment la séquence d’observations (tokens) est **générée** à partir des états cachés (étiquettes), via les probabilités p(t)p(t) et p(w∣t)p(w|t).

---

### Q7. _Décris le rôle des éléments suivants dans un HMM :_

- A
    
- B
    
- π
    

**R :**

- **A** : matrice de transition entre états (tᵢ → tᵢ₊₁)
    
- **B** : matrice d’émission (tᵢ → wᵢ)
    
- **π** : distribution initiale sur les états
    

---

### Q8. _Quel algorithme utilise-t-on pour retrouver la séquence la plus probable d’étiquettes dans un HMM ?_

**R :** L’algorithme de **Viterbi**.

---

### Q9. _Quels types de tâches sont bien adaptées aux HMM ? Pourquoi ?_

**R :**  
Les tâches avec peu d’ambiguïté et dépendances locales, comme l’étiquetage morpho-syntaxique.  
→ Simplicité du modèle + hypothèses valides.

---

## 🧠 PARTIE 3 — CRF (Champs Aléatoires Conditionnels)

### Q10. _Donne la différence fondamentale entre HMM et CRF._

**R :**  
HMM : modèle génératif (p(w,t))  
CRF : modèle discriminant (p(t|w))

---

### Q11. _Pourquoi dit-on qu’un CRF est "conditionnel" ?_

**R :** Parce qu’il modélise directement la probabilité conditionnelle des étiquettes **donnée la séquence observée**, c’est-à-dire p(t∣w)p(t|w).

---

### Q12. _Définis le rôle des fonctions de caractéristiques (feature functions) dans un CRF._

**R :**  
Elles capturent des indices utiles à la prédiction, comme des motifs sur les mots, leurs formes, leur position, etc.  
Elles sont pondérées pour former la fonction de score du modèle.

---

### Q13. **QCM :** Parmi les caractéristiques suivantes, lesquelles peuvent être utilisées dans un CRF linéaire ?

A. Mot actuel  
B. Mot précédent  
C. Catégorie grammaticale du mot suivant  
D. Longueur de la phrase

**R :** A, B, C (D peut être difficile à exploiter de manière locale dans un CRF linéaire de type chaîne).

---

### Q14. _Qu'est-ce que le terme Z(w) dans un CRF ?_

**R :**  
C’est la fonction de **partition**, qui sert à normaliser la distribution pour que p(t∣w)p(t|w) soit une vraie probabilité.

---

### Q15. _Quels sont les avantages des CRF sur les HMM ?_

**R :**

- Pas d’hypothèse d’indépendance conditionnelle
    
- Permet des dépendances riches sur les observations
    
- Meilleure performance sur des tâches complexes
    

---

### Q16. _Comment apprend-on les poids d’un CRF ?_

**R :** Par **maximisation du log-vraisemblance régularisé**, souvent avec BFGS ou autre méthode de gradient.

---

### Q17. _Quels outils logiciels permettent d’utiliser des CRF facilement ?_

**R :**

- **CRF++**
    
- **Wapiti**
    

---

## 🧠 PARTIE 4 — Réseaux de Neurones Récurrents (RNN)

### Q18. _Décris brièvement l’architecture d’un RNN pour l’étiquetage de séquence._

**R :**

- Embedding du mot → vecteur xtx_t
    
- Combinaison avec état précédent ht−1h_{t-1}
    
- Application d’une fonction d’activation ht=σ(U(xt+ht−1))h_t = \sigma(U(x_t + h_{t-1}))
    
- Prédiction y^t=softmax(Vht)\hat{y}_t = \text{softmax}(Vh_t)
    

---

### Q19. _Pourquoi utilise-t-on des RNN bidirectionnels ?_

**R :**  
Pour prendre en compte le contexte **passé** et **futur** du token à prédire.

---

### Q20. _Quels sont les avantages des RNN sur les CRF ?_

**R :**

- Pas besoin de définir manuellement les caractéristiques
    
- Apprentissage automatique de représentations
    
- Capacité à modéliser les dépendances longues
    

---

### Q21. _Quels sont les inconvénients majeurs des RNN ?_

**R :**

- Moins interprétables
    
- Coûteux en calcul
    
- Besoin de grandes quantités de données
    

---

## 🧠 PARTIE 5 — Exercices pratiques

### Q22. _Complète le schéma BIO pour la phrase suivante :_

"Le président Emmanuel Macron a visité Paris."

**R :**  
[O O B-PER I-PER O O B-LOC O]

---

### Q23. _On considère un HMM avec les transitions suivantes :_

- P(NOM|DET) = 0.6
    
- P(VER|NOM) = 0.8
    
- P(DET|VER) = 0.3
    
- P(NOM|VER) = 0.4
    

**Quelle est la probabilité de la séquence DET → NOM → VER ?**  
(si P_init(DET) = 1)

**R :**  
P = 1 × P(NOM|DET) × P(VER|NOM) = 1 × 0.6 × 0.8 = **0.48**

---

### Q24. _Quelle architecture serait la plus adaptée pour une tâche de slot-filling avec dépendances complexes ?_

**R :**  
Un **RNN bidirectionnel** ou **un CRF avec caractéristiques riches**.

---

## 🧠 PARTIE 6 — Synthèse comparative

### Q25. _Complète le tableau suivant :_

|Modèle|Type|Dépendances longues|Besoin de features manuelles|Interprétable ?|
|---|---|---|---|---|
|HMM|Génératif|❌|❌|✅|
|CRF|Discriminant|⚠️ (locales)|✅|✅|
|RNN|Discriminant|✅|❌|❌|
