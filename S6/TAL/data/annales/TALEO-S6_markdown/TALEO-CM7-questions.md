---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
### 📚 Partie 1 : Concepts fondamentaux

**Q1.** Quelle est la différence entre un constituant et une dépendance ?  
**R :**

- Un **constituant** est un groupe de mots formant une unité syntaxique (ex. : [le chat noir]).
    
- Une **dépendance** relie deux mots (un mot gouverneur et un mot dépendant), illustrant leur relation syntaxique (ex. : « mange » → sujet : « chat »).
    

---

**Q2.** Qu’est-ce qu’un arbre syntaxique ?  
**R :**  
Un arbre syntaxique est une représentation hiérarchique de la structure d’une phrase, où chaque nœud représente une catégorie grammaticale ou un mot, selon une **grammaire** donnée (constituants ou dépendances).

---

**Q3.** Qu’est-ce qu’une grammaire hors-contexte (CFG) ?  
**R :**  
C’est une grammaire formelle composée de règles de production de la forme :  
`A → B C` ou `A → "mot"`  
où `A`, `B`, `C` sont des symboles non-terminaux, permettant de générer des phrases à partir d’un axiome (souvent `S`).

---

### 🧠 Partie 2 : Analyse syntaxique

**Q4.** Quelle est la différence entre analyse ascendante et descendante ?  
**R :**

- **Descendante** : commence par le symbole de départ (`S`) et tente de produire la phrase.
    
- **Ascendante** : part des mots de la phrase et tente de remonter jusqu'à `S`.
    

---

**Q5.** Quelle est la complexité de l’analyse syntaxique avec les CFG ?  
**R :**  
L’algorithme CYK a une complexité en temps de **O(n³)** (où `n` est la longueur de la phrase), mais nécessite une grammaire en forme normale de Chomsky.

---

**Q6.** Qu’est-ce qu’un parseur déterministe ?  
**R :**  
C’est un analyseur qui, à chaque étape, fait une seule hypothèse (pas de backtracking), souvent utilisé dans les parseurs **shift-reduce**.

---

### 📊 Partie 3 : Méthodes statistiques

**Q7.** Que sont les modèles probabilistes de CFG (PCFG) ?  
**R :**  
Ce sont des CFG où chaque règle est associée à une probabilité. On peut ainsi choisir l’arbre de dérivation le plus probable parmi plusieurs candidats.

---

**Q8.** Quelle est la formule de probabilité d’un arbre avec une PCFG ?  
**R :**  
C’est le **produit des probabilités** des règles utilisées dans l’arbre :  
`P(arbre) = Π P(règle_i)`

---

**Q9.** Qu’est-ce qu’un modèle de transition en parsing ?  
**R :**  
Un modèle dans lequel l’analyse syntaxique est vue comme une suite d’actions (ex. : shift, reduce), souvent utilisée avec des classifieurs (ex. perceptron ou SVM) pour prédire la prochaine action à chaque étape.

---

**Q10.** Qu’est-ce qu’un parser basé sur les dépendances (transition-based dependency parser) ?  
**R :**  
C’est un parseur qui construit un arbre de dépendance en manipulant une **pile**, une **file d'attente**, et un **ensemble d’arcs**, en appliquant des transitions (`shift`, `left-arc`, `right-arc`), en général apprises par apprentissage supervisé.

---

Souhaites-tu des questions supplémentaires sur des points précis comme :

- Universal Dependencies
    
- Transformations X-barre
    
- Parsing neural
    
- Représentations vectorielles syntaxiques (TreeLSTM, etc.)  
    ?

---

## 🧠 Partie 1 : Généralités et définitions

### QCM

**1. Quelle est la principale fonction de la syntaxe en TAL ?**  
A. Déterminer la signification d’un mot  
B. Analyser les relations structurelles entre les mots  
C. Trouver les synonymes d’un mot  
D. Compter le nombre de phrases dans un texte  
**Réponse :** B

**2. Lequel de ces objectifs est propre à l'analyse syntaxique ?**  
A. Traduire automatiquement un texte  
B. Générer un résumé  
C. Associer à une phrase une structure arborescente  
D. Extraire des entités nommées  
**Réponse :** C

---

## ✅ Partie 2 : Types de grammaires

### QCM

**3. Dans la hiérarchie de Chomsky, une grammaire hors-contexte est de type :**  
A. Type 0  
B. Type 1  
C. Type 2  
D. Type 3  
**Réponse :** C

**4. Quelle est la principale limitation des grammaires régulières ?**  
A. Elles ne peuvent pas être utilisées pour l’analyse syntaxique  
B. Elles ne peuvent pas capturer les structures récursives imbriquées  
C. Elles ne permettent pas d’analyser des textes en français  
D. Elles sont trop complexes à écrire  
**Réponse :** B

### Vrai / Faux

**5. Une grammaire régulière peut modéliser toutes les phrases grammaticalement correctes d’une langue naturelle.**  
**Réponse :** Faux

**6. Les grammaires contextuelles permettent une plus grande expressivité que les grammaires hors-contexte.**  
**Réponse :** Vrai

---

## 🌳 Partie 3 : Arbres syntaxiques

### QCM

**7. Dans un arbre syntaxique, une feuille représente :**  
A. Un mot de la phrase  
B. Une catégorie grammaticale  
C. Un syntagme  
D. Une règle de réécriture  
**Réponse :** A

**8. Lequel des éléments suivants est typiquement une catégorie non-lexicale dans un arbre syntaxique ?**  
A. "chat"  
B. "mange"  
C. "le"  
D. "SN" (syntagme nominal)  
**Réponse :** D

### Vrai / Faux

**9. Tous les arbres syntaxiques sont binaires.**  
**Réponse :** Faux

**10. Un arbre syntaxique est toujours unique pour une phrase donnée.**  
**Réponse :** Faux (ambiguïté syntaxique)

### Question ouverte

**11. Explique la différence entre un arbre de constituants et un arbre de dépendances.**  
**Réponse attendue :**

- Un arbre de constituants montre comment une phrase est divisée en syntagmes (SN, SV, etc.).
    
- Un arbre de dépendances relie les mots entre eux selon leurs relations syntaxiques, avec un mot "tête".
    

---

## 📚 Partie 4 : Formalismes grammaticaux

### QCM

**12. Quelle est la caractéristique d'une grammaire lexicalisée ?**  
A. Elle ne contient que des règles sans symboles terminaux  
B. Elle est construite uniquement à partir de dictionnaires  
C. Elle associe les mots aux règles syntaxiques  
D. Elle ne traite que les structures verbales  
**Réponse :** C

**13. Lequel des formalismes suivants est lexicalisé ?**  
A. Grammaire hors-contexte  
B. Grammaire de dépendances  
C. Grammaire d’unification  
D. TAG (Tree Adjoining Grammar)  
**Réponse :** D

### Vrai / Faux

**14. Les grammaires d’unification permettent la vérification de contraintes d’accord.**  
**Réponse :** Vrai

**15. Les TAG permettent de modéliser des structures récursives imbriquées plus facilement que les CFG.**  
**Réponse :** Vrai

---

## 🧩 Partie 5 : Ambiguïtés syntaxiques

### QCM

**16. Quelle phrase est syntaxiquement ambiguë ?**  
A. Le chat dort sur le canapé.  
B. J’ai vu l’homme avec le télescope.  
C. Les enfants jouent dans le parc.  
D. Elle lit un livre.  
**Réponse :** B

**17. L’ambiguïté de la phrase "J’ai vu l’homme avec le télescope" est de type :**  
A. Sémantique uniquement  
B. Lexicale  
C. Syntaxique  
D. Morphologique  
**Réponse :** C

### Question ouverte

**18. Donne un exemple de phrase avec une ambiguïté syntaxique et explique les deux interprétations.**  
**Réponse attendue :**  
Phrase : "Je mange les pommes avec un couteau."

- Interprétation 1 : Je mange des pommes à l’aide d’un couteau.
    
- Interprétation 2 : Je mange des pommes qui ont un couteau.
    

---

## 🔄 Partie 6 : Algorithmes d’analyse syntaxique

### QCM

**19. L’algorithme CKY (Cocke-Kasami-Younger) fonctionne avec :**  
A. Grammaires régulières  
B. Grammaires hors-contexte en forme normale de Chomsky  
C. Grammaires de dépendances  
D. Arbres de probabilité  
**Réponse :** B

**20. L’algorithme d’Earley permet :**  
A. La génération automatique de textes  
B. La reconnaissance avec toutes les grammaires hors-contexte  
C. La segmentation morphologique  
D. Le parsing top-down uniquement  
**Réponse :** B

### Vrai / Faux

**21. L’algorithme CKY est un parseur bottom-up.**  
**Réponse :** Vrai

**22. L’algorithme d’Earley est efficace uniquement pour les phrases sans ambiguïté.**  
**Réponse :** Faux

---

## 🧮 Partie 7 : Syntaxe probabiliste

### QCM

**23. Une grammaire hors-contexte probabiliste (PCFG) permet :**  
A. De générer des phrases aléatoires  
B. D’estimer la probabilité des structures syntaxiques  
C. De corriger l’orthographe  
D. D’annoter les textes avec des étiquettes morphologiques  
**Réponse :** B

**24. Quelle est la méthode courante pour apprendre une PCFG à partir de données ?**  
A. Backpropagation  
B. Algorithme EM  
C. Méthode de Newton  
D. Réécriture logique  
**Réponse :** B

---

## 🛠️ Partie 8 : Applications et évaluation

### QCM

**25. Une application typique de l’analyse syntaxique est :**  
A. OCR (reconnaissance de caractères)  
B. Correction grammaticale  
C. Traduction automatique  
D. Les deux B et C  
**Réponse :** D

**26. Un corpus syntaxiquement annoté est appelé :**  
A. Graphe de dépendances  
B. Treebank  
C. Lemmebank  
D. Syntaxbook  
**Réponse :** B

---
