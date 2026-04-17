# TPs TAL - Traitement Automatique des Langues

Ce dossier contient les TPs (travaux pratiques) pour le cours de Traitement Automatique des Langues (Natural Language Processing).

## Contenu Disponible

### Documents TP
- `spacy.pdf` - TP sur la bibliothèque spaCy pour le NLP en Python
- `inforetrieval.pdf` - TP sur la recherche d'information (Information Retrieval)

Ces TPs couvrent des aspects pratiques du traitement automatique des langues en utilisant des outils et bibliothèques modernes.

## Ressources Complémentaires

### Cours (`../cours/`)
Le dossier cours contient 14 fichiers de cours :
- `TALEO_course2_2026.pdf`, `TALEO_course3_2026.pdf`, etc. - Cours TALEO (TAL English Oriented) version 2026
- `TALEO_course2.pdf`, `TALEO_course3.pdf`, etc. - Cours TALEO versions précédentes
- `Cours.pdf` - Support de cours général
- `ExamTALEO2022.pdf` - Examen 2022

### Annales (`../annales/`)
Le dossier annales contient 37 examens passés et exercices :
- Examens TALEO des années précédentes
- Corrections disponibles pour certains examens
- Exercices types sur différents aspects du TAL

## Sujets Couverts

Le cours de TAL aborde les thèmes suivants :

### 1. Prétraitement de Texte
- **Tokenisation** : découpage en mots, phrases, tokens
- **Normalisation** : casse, accents, ponctuation
- **Lemmatisation** : réduction à la forme canonique
- **Stemming** : troncature des mots
- **Stop words** : filtrage des mots vides
- **Segmentation** : phrases, paragraphes

### 2. Analyse Morphologique
- **Part-of-Speech Tagging (POS)** : étiquetage grammatical
- **Named Entity Recognition (NER)** : reconnaissance d'entités nommées
- **Morphologie** : analyse des formes de mots
- **Expressions régulières** : pattern matching dans le texte

### 3. Analyse Syntaxique
- **Parsing** : analyse de la structure grammaticale
- **Dependency parsing** : arbres de dépendances
- **Constituency parsing** : arbres syntagmatiques
- **Chunking** : extraction de groupes syntaxiques

### 4. Analyse Sémantique
- **Word embeddings** : représentations vectorielles de mots (Word2Vec, GloVe)
- **Semantic similarity** : similarité sémantique
- **Word sense disambiguation** : désambiguïsation lexicale
- **Semantic role labeling** : rôles sémantiques

### 5. Modèles de Langage
- **N-grams** : modèles statistiques de langage
- **Language models** : probabilités de séquences
- **Perplexité** : mesure de qualité d'un modèle
- **Smoothing techniques** : lissage de probabilités

### 6. Recherche d'Information (Information Retrieval)
- **TF-IDF** : pondération de termes
- **Vector Space Model** : modèle vectoriel
- **Cosine similarity** : similarité entre documents
- **Boolean retrieval** : recherche booléenne
- **Inverted index** : index inversé
- **Ranking** : classement de documents

### 7. Classification de Texte
- **Bag of Words** : représentation par sac de mots
- **Naive Bayes** : classificateur probabiliste
- **Text categorization** : catégorisation automatique
- **Sentiment analysis** : analyse de sentiments
- **Feature extraction** : extraction de caractéristiques

### 8. Applications du TAL
- **Machine translation** : traduction automatique
- **Question answering** : systèmes de questions-réponses
- **Text summarization** : résumé automatique
- **Information extraction** : extraction d'information structurée
- **Chatbots** : agents conversationnels

## TPs Détaillés

### TP 1 : spaCy

**Objectif :** Découvrir et utiliser la bibliothèque spaCy pour le TAL en Python.

**Contenu du TP :**
- Installation et configuration de spaCy
- Chargement de modèles de langue (français, anglais)
- Tokenisation et segmentation
- POS tagging (étiquetage grammatical)
- Named Entity Recognition (NER)
- Dependency parsing
- Word vectors et similarité
- Pipeline de traitement personnalisé

**Technologies :**
- **Python 3** : langage de programmation
- **spaCy** : bibliothèque NLP moderne
- **Modèles pré-entraînés** : fr_core_news_md, en_core_web_md

**Installation :**
```bash
# Installer spaCy
pip install spacy

# Télécharger le modèle français
python -m spacy download fr_core_news_md

# Télécharger le modèle anglais
python -m spacy download en_core_web_md
```

**Exemple d'utilisation :**
```python
import spacy

# Charger le modèle
nlp = spacy.load("fr_core_news_md")

# Traiter un texte
doc = nlp("Le chat mange une souris dans le jardin.")

# POS tagging
for token in doc:
    print(f"{token.text}: {token.pos_} ({token.tag_})")

# Named Entity Recognition
for ent in doc.ents:
    print(f"{ent.text}: {ent.label_}")

# Dependency parsing
for token in doc:
    print(f"{token.text} <-{token.dep_}- {token.head.text}")
```

**Ressources :**
- Documentation spaCy : https://spacy.io/
- Tutoriels : https://spacy.io/usage/spacy-101
- Modèles disponibles : https://spacy.io/models

### TP 2 : Information Retrieval

**Objectif :** Implémenter un système de recherche d'information basique.

**Contenu du TP :**
- Construction d'un index inversé
- Implémentation de TF-IDF
- Modèle vectoriel (Vector Space Model)
- Calcul de similarité cosinus
- Ranking de documents
- Évaluation (précision, rappel, F-measure)

**Concepts clés :**

**TF-IDF (Term Frequency - Inverse Document Frequency) :**
```
TF(t, d) = (nombre d'occurrences de t dans d) / (nombre total de mots dans d)
IDF(t) = log(nombre total de documents / nombre de documents contenant t)
TF-IDF(t, d) = TF(t, d) * IDF(t)
```

**Similarité Cosinus :**
```
cos(q, d) = (q · d) / (||q|| * ||d||)
```

**Exemple d'implémentation :**
```python
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# Corpus de documents
documents = [
    "Le chat mange une souris",
    "Le chien aboie dans le jardin",
    "Un chat noir dort sur le tapis"
]

# Créer la matrice TF-IDF
vectorizer = TfidfVectorizer()
tfidf_matrix = vectorizer.fit_transform(documents)

# Requête
query = "chat noir"
query_vec = vectorizer.transform([query])

# Calculer similarités
similarities = cosine_similarity(query_vec, tfidf_matrix)
print(similarities)
```

**Ressources :**
- Introduction to Information Retrieval : https://nlp.stanford.edu/IR-book/
- scikit-learn text feature extraction : https://scikit-learn.org/stable/modules/feature_extraction.html#text-feature-extraction

## Technologies et Outils

### Python et Bibliothèques
- **Python 3.8+** : langage de programmation
- **spaCy** : NLP de production
- **NLTK** : Natural Language Toolkit (référence académique)
- **scikit-learn** : machine learning et classification
- **gensim** : topic modeling et word embeddings
- **transformers (Hugging Face)** : modèles de langage pré-entraînés (BERT, GPT)

### Installation des Dépendances
```bash
# Créer un environnement virtuel
python -m venv venv
source venv/bin/activate  # Linux/Mac
# ou
venv\Scripts\activate  # Windows

# Installer les bibliothèques
pip install spacy nltk scikit-learn gensim transformers

# Télécharger les ressources NLTK
python -c "import nltk; nltk.download('punkt'); nltk.download('stopwords')"

# Télécharger les modèles spaCy
python -m spacy download fr_core_news_md
python -m spacy download en_core_web_md
```

### Jupyter Notebooks
Les TPs peuvent être réalisés dans des notebooks Jupyter :
```bash
pip install jupyter
jupyter notebook
```

## Datasets et Corpus

### Corpus Français
- **French TreeBank** : corpus annoté en syntaxe
- **WikiText-FR** : texte Wikipedia français
- **Common Crawl (FR)** : large corpus web

### Corpus Anglais
- **Penn TreeBank** : corpus de référence
- **Brown Corpus** : corpus varié
- **Reuters Corpus** : articles de presse
- **IMDB Reviews** : critiques de films (sentiment analysis)

### Ressources NLTK
```python
import nltk

# Télécharger des corpus
nltk.download('brown')
nltk.download('reuters')
nltk.download('movie_reviews')

# Utiliser un corpus
from nltk.corpus import brown
words = brown.words()
```

## Évaluation et Métriques

### Métriques de Classification
- **Précision** : P = TP / (TP + FP)
- **Rappel** : R = TP / (TP + FN)
- **F-mesure** : F1 = 2 * (P * R) / (P + R)
- **Accuracy** : (TP + TN) / (TP + TN + FP + FN)

### Métriques de Recherche d'Information
- **Précision@k** : précision des k premiers résultats
- **MAP** (Mean Average Precision) : précision moyenne
- **NDCG** (Normalized Discounted Cumulative Gain) : gain cumulé normalisé

### Métriques de Traduction
- **BLEU** : comparaison avec traductions de référence
- **METEOR** : métrique plus sophistiquée
- **Perplexité** : qualité d'un modèle de langage

## Projets Types

### Mini-Projets Possibles
1. **Analyseur de sentiments** : classifier des avis (positif/négatif/neutre)
2. **Extracteur d'informations** : extraire entités et relations
3. **Moteur de recherche** : recherche dans un corpus
4. **Chatbot simple** : réponses basées sur patterns
5. **Résumé automatique** : extractif ou abstractif
6. **Traducteur** : utiliser des modèles pré-entraînés

## Examens et Évaluations

### Format des Examens
- Questions de cours (concepts, définitions)
- Exercices pratiques (calculs TF-IDF, parsing, etc.)
- Analyse de code Python
- Questions de compréhension sur algorithmes
- Parfois : mini-projet à rendre

### Préparation
1. **Maîtriser les concepts** : tokenisation, POS, NER, parsing, TF-IDF
2. **Pratiquer avec spaCy et NLTK** : connaître les APIs
3. **Faire les annales** : 37 examens disponibles
4. **Comprendre les algorithmes** : Viterbi, CYK, beam search
5. **Réviser les métriques** : savoir les calculer

## Ressources en Ligne

### Cours et Tutoriels
- **Stanford NLP** : https://web.stanford.edu/~jurafsky/slp3/
- **spaCy Course** : https://course.spacy.io/
- **NLTK Book** : https://www.nltk.org/book/
- **Hugging Face Course** : https://huggingface.co/course/chapter1

### Documentation
- spaCy : https://spacy.io/
- NLTK : https://www.nltk.org/
- scikit-learn : https://scikit-learn.org/
- Hugging Face Transformers : https://huggingface.co/transformers/

### Datasets
- Kaggle NLP datasets : https://www.kaggle.com/datasets?tags=13204-NLP
- Papers with Code NLP : https://paperswithcode.com/area/natural-language-processing

### Outils
- **Jupyter** : environnement interactif
- **Google Colab** : notebooks avec GPU gratuit
- **Hugging Face Hub** : modèles pré-entraînés
- **spaCy Universe** : extensions et projets

## Conseils pour Réussir

### Pour les TPs
1. **Installer les outils tôt** : éviter les problèmes de dernière minute
2. **Tester sur des exemples simples** : avant de complexifier
3. **Lire la documentation** : spaCy et NLTK sont bien documentés
4. **Expérimenter** : essayer différents modèles et paramètres
5. **Commenter le code** : expliquer la logique

### Pour les Examens
1. **Connaître les définitions** : POS, NER, parsing, lemmatisation, etc.
2. **Savoir calculer TF-IDF** : à la main et conceptuellement
3. **Comprendre les pipelines** : chaîne de traitement NLP
4. **Réviser les algorithmes** : HMM, CRF, etc.
5. **Faire les annales** : meilleur entraînement

### Erreurs à Éviter
- Confondre stemming et lemmatisation
- Oublier de normaliser les vecteurs (cosinus)
- Mal interpréter les métriques (précision vs rappel)
- Ne pas gérer l'encodage des caractères (UTF-8)
- Négliger le prétraitement (tokenisation, etc.)

## Structure du Dépôt

```
TAL/
├── tp/                         # Ce dossier
│   ├── README.md              # Ce fichier
│   ├── spacy.pdf              # TP spaCy
│   └── inforetrieval.pdf      # TP recherche d'information
├── cours/                     # 14 fichiers de cours TALEO
│   ├── TALEO_course2_2026.pdf
│   ├── TALEO_course3_2026.pdf
│   ├── Cours.pdf
│   └── ExamTALEO2022.pdf
├── annales/                   # 37 examens et exercices
├── td/                        # Travaux dirigés
├── fiches/                    # Fiches de révision
└── README.md                  # Description générale du cours
```

## Support

Pour toute question :
- Consulter les supports de cours dans `../cours/`
- Consulter les annales dans `../annales/`
- Poser des questions pendant les TD
- Utiliser le forum Moodle du cours
- Documentation officielle des bibliothèques

## Liens Utiles

- Page Moodle du cours : https://moodleng.insa-rennes.fr/
- spaCy : https://spacy.io/
- NLTK : https://www.nltk.org/
- scikit-learn NLP : https://scikit-learn.org/stable/tutorial/text_analytics/working_with_text_data.html
- Hugging Face : https://huggingface.co/
