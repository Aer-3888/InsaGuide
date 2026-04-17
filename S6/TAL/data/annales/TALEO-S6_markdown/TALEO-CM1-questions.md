---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---

### 🔹 **2. Définitions fondamentales**

**Q4.** Quelle est la différence entre une langue et un langage naturel ?  
**R4.** Une langue est un système de signes conventionnels, tandis qu’un langage naturel est une langue développée naturellement et utilisée comme langue maternelle.

**Q5.** Que signifie l’acronyme TAL ?  
**R5.** Traitement Automatique des Langues.

**Q6.** Donne deux synonymes du TAL.  
**R6.** NLP (Natural Language Processing), linguistique computationnelle.

---

### 🔹 **3. Applications pratiques du TAL**

**Q7.** Cite deux exemples d’applications du TAL dans l’analyse de collections textuelles.  
**R7.**

- Recherche d'information (moteurs de recherche)
    
- Classification automatique (ex : détection de spam)
    

**Q8.** Donne deux exemples d’applications du TAL dans l’interaction homme-machine.  
**R8.**

- Agents conversationnels (ex : ChatGPT)
    
- Logiciels de dictée vocale (ex : Dragon Dictate)
    

**Q9.** Quelle est la différence entre la correction automatique et la génération textuelle ?  
**R9.**

- La correction automatique aide à détecter/corriger les erreurs dans un texte.
    
- La génération textuelle crée un texte à partir de données ou de spécifications.
    

---

### 🔹 **4. Niveaux d’analyse linguistique**

**Q10.** Quels sont les niveaux d’analyse linguistique abordés dans l’exemple de phrase ?  
**R10.** Phonétique/phonologique, graphique, lexical/morphologique, syntaxique, sémantique, pragmatique.

**Q11.** Donne un exemple d’ambiguïté syntaxique.  
**R11.** "J’ai été voir un film avec Brad Pitt" : l’ambiguïté vient de l’attachement de "avec Brad Pitt".

**Q12.** Pourquoi dit-on que les niveaux d’analyse ne sont pas strictement séquentiels ?  
**R12.** Parce qu’ils sont imbriqués et souvent interdépendants (ex : une ambiguïté sémantique peut influencer l’analyse syntaxique).

---

### 🔹 **5. Difficultés du TAL**

**Q13.** Pourquoi est-il difficile de modéliser une langue naturelle ?  
**R13.** Parce qu’il y a un nombre infini de phrases bien formées, des évolutions constantes du vocabulaire, et des ambiguïtés à tous les niveaux.

**Q14.** Donne un exemple de connaissance implicite.  
**R14.** Comprendre à quoi renvoie "il" dans une phrase nécessite des connaissances de contexte ou du monde réel.

**Q15.** Qu’est-ce qu’une variation paraphrastique ?  
**R15.** Plusieurs formulations différentes peuvent exprimer la même idée (ex : "vélo", "bicyclette", "faire du cyclisme").

---

### 🔹 **6. Traitement au niveau graphique**

**Q16.** Qu’est-ce que la tokenisation ?  
**R16.** Le découpage d’un texte en unités élémentaires appelées tokens (mots, ponctuation...).

**Q17.** Pourquoi la tokenisation est-elle complexe ?  
**R17.** À cause des exceptions (ex : "aujourd’hui" ne se découpe pas), des abréviations, des dates, etc.

**Q18.** Cite deux outils de tokenisation.  
**R18.** NLTK, spaCy, Stanford Tokenizer.

---

### 🔹 **7. Traitement lexical et morphologique**

**Q19.** Quelle est la différence entre un lexème et une lexie ?  
**R19.**

- Un **lexème** est une unité lexicale regroupant les formes d’un mot.
    
- Une **lexie** est un lexème + les locutions complexes associées.
    

**Q20.** Qu’est-ce qu’un morphème ?  
**R20.** La plus petite unité porteuse de sens dans un mot.

**Q21.** Quelle est la différence entre lemmatisation et racinisation ?  
**R21.**

- **Lemmatisation** ramène un mot à sa forme canonique (ex : "mangeons" → "manger").
    
- **Racinisation** supprime les suffixes pour retrouver le radical (ex : "manger", "mangeais", "mangé" → "mang").
    

**Q22.** Cite deux outils de lemmatisation ou racinisation.  
**R22.** TreeTagger, spaCy, stemmers de Porter ou Lovins.

---

### 🔹 **8. Traitement syntaxique**

**Q23.** Qu’est-ce qu’une analyse syntaxique ?  
**R23.** C’est l’identification de la structure grammaticale d’une phrase.

**Q24.** Quelle est la différence entre analyse en constituants et en dépendances ?  
**R24.**

- **Constituants** : structure hiérarchique (arbres syntaxiques)
    
- **Dépendances** : relations binaires entre les mots (sujet-verbe, verbe-objet)
    

**Q25.** Que contient une grammaire formelle selon Chomsky ?  
**R25.**

- Vocabulaire non-terminal (V_N)
    
- Vocabulaire terminal (V_T)
    
- Règles de production (R)
    
- Symbole de départ (S)
    
Merci pour la précision ! Voici les **paragraphes 9 et 10** sous **forme de questions-réponses**, idéales pour la révision ou la préparation d’un exposé.

---

## 📚 9. Représentation et traitement sémantique

### 🔍 Qu’est-ce que la sémantique en TAL (Traitement automatique des langues) ?

C’est l’étude du **sens** des mots et des énoncés, dans le but de produire une **représentation conceptuelle** compréhensible par une machine.

### 🧠 Quels sont les moyens de représentation du sens en TAL ?

- **Vecteurs** basés sur les cooccurrences textuelles
    
- **Lexiques sémantiques** (ex. : WordNet)
    
- **Réseaux sémantiques** (graphes de concepts)
    
- **Logique des prédicats**
    

### 📐 Qu’est-ce qu’une représentation vectorielle du sens ?

C’est une méthode issue de l’**analyse distributionnelle** (Harris, 1954), selon laquelle les mots ayant des contextes similaires ont des significations proches. Exemples : **word embeddings** comme Word2Vec (Mikolov, 2013).

### 🧩 Qu’est-ce que le principe de compositionnalité ?

Selon **Frege**, le sens d’un tout (phrase) dépend du sens de ses parties (mots) et de leur structure syntaxique.  
**Limites** : cela ne fonctionne pas pour les métaphores ou les expressions idiomatiques.

### 🤖 Comment représente-t-on le sens via la logique des prédicats ?

- **Noms propres** → constantes (ex. : Jean)
    
- **Noms communs / adjectifs** → prédicats (ex. : homme(x))
    
- **Verbes** → prédicats relationnels (ex. : manger(x,y))
    
- **Combinaisons** → connecteurs logiques (∧, ∨, ¬, →)
    
- **Quantificateurs** : ∃ (il existe), ∀ (pour tout)  
    **Limites** : ambiguïtés, flou sémantique, temps, croyances, modalités.
    

### 🕸 Qu’est-ce qu’un réseau sémantique ?

Un **graphe** où les **concepts** sont reliés par des relations sémantiques comme :

- **is-a** (ex. : un chien _est un_ animal)
    
- **has-part** (ex. : une voiture _a pour partie_ un moteur)  
    → Permet **l’héritage** des propriétés.
    

### 🧱 Quelles extensions des réseaux sémantiques existent ?

- **Frames** (Minsky, 1974) : structures représentant des concepts avec propriétés héritées
    
- **Scripts** (Schank & Abelson, 1977) : scénarios typiques (ex. aller au resto)
    
- **Graphes conceptuels** (Sowa, 1984) : graphes formels combinables
    

### 📚 Quels sont les principaux lexiques et bases sémantiques ?

- **WordNet** : base regroupant des mots selon leurs relations sémantiques
    
- **FrameNet** : décrit les **cadres sémantiques** associés aux verbes (ex. : "acheter" implique un acheteur, un vendeur, un produit)
    

---

## 🎙️ 10. Reconnaissance automatique de la parole (RAP)

### 🔊 Comment se déroule la production de la parole ?

Elle suit une chaîne de traitement :  
**Cerveau → Sémantique → Syntaxe → Lexique → Prosodie → Signal acoustique**

### ❓ Quel est l’objectif de la reconnaissance automatique de la parole (RAP) ?

Transformer un **signal acoustique** en une **chaîne de mots**, malgré les nombreuses **variabilités** (locuteurs, accent, bruit, etc.).

### ⚠️ Quelles sont les principales difficultés de la RAP ?

- Variabilité **inter/intra-locuteur**
    
- Bruit ambiant, qualité du micro (variabilité acoustique)
    
- Vocabulaire vaste, langage naturel (variabilité grammaticale)
    
- Parole **continue** (pas de pauses nettes entre mots)
    

### 🎛️ Comment le signal est-il traité ?

- Analyse en **trames courtes** (ex. : 20 ms)
    
- Extraction des **caractéristiques spectrales** (formants)
    
- Utilisation de **MFCC** (Mel-Frequency Cepstral Coefficients)
    
- Mesure des **variations dynamiques** : Δ (delta), ΔΔ (delta-delta)
    

### 🧮 Quelle est l’équation fondamentale de la RAP ?

$w^=arg⁡max⁡wP(w∣y)=arg⁡max⁡wp(y∣w)⋅P(w)\hat{w} = \arg\max_w P(w|y) = \arg\max_w p(y|w) \cdot P(w)$

- **p(y|w)** : vraisemblance acoustique (modèle acoustique)
    
- **P(w)** : probabilité des mots (modèle de langue)
    

### 🧩 Quels sont les composants d’un système de RAP ?

- **Modèle acoustique** : HMM, réseaux bayésiens, réseaux neuronaux
    
- **Modèle de langue** : n-grammes, grammaires stochastiques, RNN
    
- **Décodage** : via **algorithme de Viterbi**
    

### 🧾 Quelle est la sortie d’un système de RAP ?

Une transcription avec :

- Pas de ponctuation
    
- Pas de majuscules
    
- Potentielles **erreurs** (orthographe, omissions, insertions)
    

### ❌ Quels types d’erreurs sont courants ?

- Mauvaises transcriptions (sons proches, homophones)
    
- Mots absents du lexique
    
- Oubli ou ajout de mots outils (le, de, etc.)
    
- Accord fautif
    

### 📏 Comment mesurer les performances ?

- **WER (Word Error Rate)** : % d’erreurs sur les mots (insertion + suppression + substitution)
    
- **SER (Sentence Error Rate)** : % de phrases mal reconnues
    

### 🔄 Quelles sont les évolutions modernes ?

- **RNN / LSTM bidirectionnels**
    
- Modèles **end-to-end** avec **CTC** (Connectionist Temporal Classification)
    

---

Souhaites-tu que je transforme aussi les autres paragraphes en questions-réponses ?