---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
### 🔹 **TOKENS, MOTS ET CONCEPTS LINGUISTIQUES**

**Q : Qu’est-ce qu’un _token_ ?**  
R : Une chaîne graphique normalisée, sans signification propre.

**Q : Quelle est la différence entre un _lemme_ et un _lexème_ ?**  
R : Le _lemme_ est la forme canonique d’un mot (ex. « aimer »), tandis que le _lexème_ désigne l’ensemble de ses formes fléchies (aime, aimait, etc.).

**Q : Qu’est-ce que le _radical_ d’un mot ?**  
R : C’est la base morphologique portant le sens, comme « aim- » dans « aimer ».

---

### 🔹 **TOKENISATION**

**Q : Quelle est la tâche principale de la tokenisation ?**  
R : Diviser le texte en phrases, puis en unités appelées _tokens_.

**Q : Donne un exemple de difficulté rencontrée en tokenisation.**  
R : « j’ai » doit être segmenté en « j' » et « ai », mais pas « aujourd’hui ».

**Q : Quels outils peuvent être utilisés pour tokenizer ?**  
R : NLTK, spaCy, Stanford Tokenizer.

**Q : Quelle est la différence entre la tokenisation NLTK et spaCy ?**  
R : Les deux découpent différemment selon les règles internes ; NLTK retourne une liste de chaînes, spaCy des objets `Token`.

---

### 🔹 **REPRÉSENTATIONS SYMBOLIQUES**

**Q : Quels sont les avantages des représentations par chaînes de caractères ?**  
R : Simplicité d’implémentation et efficacité via hachage.

**Q : Et les inconvénients ?**  
R : Manque de sémantique, difficulté à gérer flexions et relations synonymiques.

---

### 🔹 **LEXIQUES ET RÉSEAUX SÉMANTIQUES**

**Q : Qu’est-ce qu’un _synset_ dans WordNet ?**  
R : Un ensemble de synonymes désignant un même sens.

**Q : Quelle est la différence entre FrameNet et WordNet ?**  
R : FrameNet se concentre sur les rôles sémantiques des verbes, WordNet sur les relations lexicales entre mots.

**Q : Que fournit SentiWordNet ?**  
R : Des scores de positivité, négativité et objectivité pour chaque synset.

---

### 🔹 **MESURES DE SIMILARITÉ SÉMANTIQUE**

**Q : Quelle est la formule de la similarité de Wu-Palmer ?**  
R : `2 * depth(LCS) / (depth(c1) + depth(c2))`

**Q : Comment calcule-t-on la similarité entre deux mots avec WordNet ?**  
R : En prenant la similarité maximale entre tous les couples de sens possibles.

---

### 🔹 **DÉSAMBIGUÏSATION SÉMANTIQUE (WSD)**

**Q : Quelle est la tâche de la désambiguïsation lexicale ?**  
R : Associer le bon sens à un mot dans un contexte donné.

**Q : Quelles sont les deux grandes familles d’approches ?**  
R : Basées sur la connaissance (définitions) et basées sur l’apprentissage supervisé.

---

### 🔹 **REPRÉSENTATIONS DISTRIBUÉES**

**Q : Pourquoi représenter les mots sous forme vectorielle ?**  
R : Pour capturer les relations sémantiques et syntaxiques dans un espace numérique.

**Q : Que signifie “You shall know a word by the company it keeps” ?**  
R : Le sens d’un mot est déterminé par les mots qui l’entourent.

---

### 🔹 **CO-OCCURRENCE ET SVD**

**Q : Que représente une matrice de co-occurrence ?**  
R : La fréquence de co-apparition des mots dans une fenêtre de contexte.

**Q : Quelle technique permet de réduire la dimension de cette matrice ?**  
R : La décomposition en valeurs singulières (SVD).

---

### 🔹 **WORD2VEC**

**Q : Quelle est la différence entre CBOW et Skip-gram ?**  
R : CBOW prédit le mot central à partir du contexte ; Skip-gram fait l’inverse.

**Q : Quelle est l’idée principale du Skip-gram ?**  
R : Maximiser la probabilité des mots du contexte donnés un mot central.

---

### 🔹 **APPROXIMATION PAR ÉCHANTILLONNAGE NÉGATIF**

**Q : À quoi sert l’échantillonnage négatif ?**  
R : À entraîner Word2Vec efficacement en ne considérant qu’un petit nombre de paires négatives par mot.

---

### 🔹 **GLOVE**

**Q : Quelle est la différence majeure entre GloVe et Word2Vec ?**  
R : GloVe utilise les co-occurrences globales, alors que Word2Vec s’appuie sur les co-occurrences locales.

---

### 🔹 **ÉVALUATION INTRINSÈQUE**

**Q : Quelle mesure utilise-t-on pour comparer deux vecteurs de mots ?**  
R : La similarité cosinus.

**Q : Existe-t-il une base de données pour valider ces scores ?**  
R : Oui, WordSim353.

---

### 🔹 **TOKENISATION SOUS-MOT & FASTTEXT**

**Q : Pourquoi tokenizer en sous-mots ?**  
R : Pour gérer les mots rares ou inconnus.

**Q : Comment fonctionne FastText ?**  
R : Il décompose les mots en n-grammes de caractères pour produire des vecteurs plus robustes.

---

Souhaites-tu que je te prépare un **quiz** basé sur ces questions-réponses ?