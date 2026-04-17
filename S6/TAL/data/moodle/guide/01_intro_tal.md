# Chapitre 1 -- Introduction au Traitement Automatique des Langues

## 1.1 Qu'est-ce que le TAL ?

### L'idee en une phrase

Le TAL (Traitement Automatique des Langues), aussi appele NLP (Natural Language Processing), est le domaine qui vise a faire comprendre et produire du langage humain par des machines.

### Definitions fondamentales

- **Langue** : systeme de signes conventionnels et regles de combinaison partage par une communaute (francais, anglais...)
- **Langage naturel** : langue developpee naturellement par les humains, par opposition aux langages construits (Esperanto) ou de programmation (Python)
- **TAL** : sous-domaine interdisciplinaire (linguistique + informatique + IA) visant a modeliser et reproduire la capacite humaine a produire et comprendre des enonces linguistiques

### Synonymes a connaitre

| Terme | Signification |
|-------|---------------|
| TAL | Traitement Automatique des Langues |
| TALN | Traitement Automatique du Langage Naturel |
| NLP | Natural Language Processing |
| Linguistique computationnelle | Computational Linguistics |

### Vue d'ensemble du domaine

```
                    +---------------------------+
                    |   Traitement Automatique   |
                    |      des Langues (TAL)     |
                    +---------------------------+
                               |
          +--------------------+--------------------+
          |                    |                     |
  +-------v-------+   +-------v-------+    +--------v--------+
  | Analyse de     |   | Production de |    | Interaction     |
  | collections    |   | donnees       |    | homme-machine   |
  | textuelles     |   | linguistiques |    |                 |
  +----------------+   +---------------+    +-----------------+
  | - Recherche    |   | - Traduction  |    | - Chatbots      |
  |   d'information|   |   automatique |    | - Dictee vocale |
  | - Classification|  | - Correction  |    | - Q&A           |
  | - Veille       |   | - Resume      |    | - Dialogue      |
  | - Extraction   |   | - Generation  |    |                 |
  +----------------+   +---------------+    +-----------------+
```

## 1.2 Applications concretes du TAL

### Analyse de collections textuelles
- **Recherche d'information** : Google, Bing (retrouver des documents pertinents)
- **Classification automatique** : routage de mails, detection de spam, categorisation thematique
- **Extraction d'information** : alimenter des bases de connaissances a partir de textes
- **Veille technologique** : surveillance automatisee de sources

### Production de donnees linguistiques
- **Traduction automatique** : DeepL, Google Translate (passage d'une langue a une autre)
- **Correction automatique** : correcteurs orthographiques/grammaticaux, claviers predictifs
- **Generation textuelle** : creation de texte a partir de donnees (bulletins meteo, rapports)
- **Resume automatique** : condenser un texte long en conservant l'essentiel

### Interaction homme-machine
- **Agents conversationnels** : ChatGPT, assistants vocaux (Siri, Alexa)
- **Dictee vocale** : Dragon Dictate, Via Voice
- **Systemes de questions-reponses** : interrogation de bases en langage naturel

## 1.3 Les niveaux d'analyse linguistique

Un texte peut etre analyse a plusieurs niveaux, du plus basique au plus abstrait. Ces niveaux sont **imbriques**, pas sequentiels.

### Exemple fil rouge

Phrase : *"Le president des antialcooliques mangeait une pomme avec un couteau"*

```
  +-------------------+
  |  Phonetique /     |  Sons de la parole
  |  Phonologique     |  Ex: "Dans ces meubles laques..." ambiguite orale
  +--------+----------+
           |
  +--------v----------+
  |  Graphique        |  Segmentation en mots (tokenisation)
  |                   |  Ex: "S.N.C.F." vs "aujourd'hui" vs "Jean-Paul"
  +--------+----------+
           |
  +--------v----------+
  |  Lexical /        |  Identification des mots et leurs proprietes
  |  Morphologique    |  Ex: "president" = nom ou verbe ?
  +--------+----------+
           |
  +--------v----------+
  |  Syntaxique       |  Structure des phrases (qui fait quoi)
  |                   |  Ex: "la petite brise la glace" = 2 analyses
  +--------+----------+
           |
  +--------v----------+
  |  Semantique       |  Sens des mots et enonces
  |                   |  Ex: "avocat" = fruit ou homme de loi ?
  +--------+----------+
           |
  +--------v----------+
  |  Pragmatique      |  Fonction dans le contexte
  |                   |  Ex: "Il fait froid ici" = demande de fermer la fenetre ?
  +--------+----------+
```

### Detail de chaque niveau

#### Niveau phonetique et phonologique
- Etude des sons de la parole et de leur organisation
- Ambiguites orales : "Dans ces meubles laques, rideaux et dais moroses" vs "Danse, aime, bleu laquais, ris d'oser des mots roses"

#### Niveau graphique
- Segmentation du texte en unites de base (mots/tokens)
- Difficultes : role des points ("S.N.C.F."), apostrophes ("aujourd'hui"), traits d'union ("Jean-Paul")

#### Niveau lexical et morphologique
- Identification des mots et de leurs proprietes grammaticales
- **Ambiguites statiques** : "president" (verbe "presider" ou nom), "ferme" (verbe/nom/adjectif)
- **Ambiguites dynamiques** : "rat" peut etre nom ou adjectif selon le contexte

#### Niveau syntaxique
- Organisation des mots en groupes (syntagmes) et phrases
- **Ambiguite structurelle** : "la petite brise la glace" (la petite fille brise la glace OU le petit vent rafraichit)
- **Ambiguite d'attachement** : "j'ai vu un film avec Brad Pitt" (Brad Pitt joue dans le film OU je l'ai vu en compagnie de Brad Pitt)

#### Niveau semantique
- Construction d'une representation du sens
- **Homonymie** : "avocat" (fruit vs homme de loi) -- aucun lien semantique
- **Polysemie** : "agneau" (animal vs viande) -- lien semantique
- **Metonymie** : "boire un verre" (le contenu, pas le contenant)

#### Niveau pragmatique
- Fonction d'un enonce dans son contexte d'utilisation
- "Il fait froid ici" peut etre une constatation ou une demande implicite

## 1.4 Difficultes du TAL

### Pourquoi c'est si difficile ?

```
  Difficultes du TAL
  +--------------------------------------------+
  |                                            |
  |  1. Nombre infini de phrases correctes     |
  |     (impossible de tout lister)            |
  |                                            |
  |  2. Ambiguite a TOUS les niveaux           |
  |     (lexical, syntaxique, semantique...)   |
  |                                            |
  |  3. Connaissances implicites               |
  |     (sens commun, culture, contexte)       |
  |                                            |
  |  4. Variations d'expression multiples      |
  |     ("velo" = "bicyclette" = "petite reine")|
  |                                            |
  |  5. Donnees non structurees                |
  |     (pas de schema, pas de semantique      |
  |      a priori)                             |
  |                                            |
  +--------------------------------------------+
```

### Variations d'expression (crucial pour la RI)

| Type | Exemple |
|------|---------|
| Graphique/morphologique | "mot cle", "mot-cle", "mots-cles", "Mot-Cle" |
| Syntaxique | "acidite du sang", "acidite sanguine", "sang acide" |
| Semantique | "velo", "bicyclette", "cyclisme" |
| Paraphrastique | "Il pleut" vs "Le temps est pluvieux" |

### Connaissances implicites
- **Resolution de references** : "Le chat poursuit la souris car **elle** est rapide" -- qui est "elle" ?
- **Sens commun** : "Il a mange un steak avec des frites" vs "Il a mange un steak avec un couteau" (instrument vs accompagnement)
- **Metaphores** : "Il a un coeur de pierre" (pas literal)

## 1.5 Tokenisation : le traitement graphique

### Principe

La tokenisation est le **decoupage d'un texte en unites elementaires** (tokens) : mots, ponctuation, nombres...

### Regles et exceptions

| Cas | Resultat attendu | Difficulte |
|-----|-------------------|------------|
| "j'ai" | "j'" + "ai" | Coupure a l'apostrophe |
| "aujourd'hui" | "aujourd'hui" | Ne PAS couper |
| "S.N.C.F." | "S.N.C.F." | Points ne sont pas des fin de phrase |
| "31/12/2021" | "31/12/2021" | Date = un seul token |
| "New York" | "New York" | Expression multi-mots |

### Code Python : tokenisation avec spaCy et NLTK

```python
# --- Avec NLTK ---
from nltk.tokenize import word_tokenize
texte = "J'ai mange aujourd'hui a 12h30."
tokens_nltk = word_tokenize(texte, language='french')
print(tokens_nltk)
# ['J', "'", 'ai', 'mange', 'aujourd', "'", 'hui', 'a', '12h30', '.']

# --- Avec spaCy ---
import spacy
nlp = spacy.load("fr_core_news_sm")
doc = nlp("J'ai mange aujourd'hui a 12h30.")
tokens_spacy = [token.text for token in doc]
print(tokens_spacy)
# ['J'', 'ai', 'mange', 'aujourd'hui', 'a', '12h30', '.']
```

**Observation** : spaCy gere mieux les cas francais comme "aujourd'hui".

## 1.6 Traitement lexical et morphologique

### Vocabulaire essentiel

```
  Signe linguistique
  +-------------------+
  |  Signifie (idee)  |  <-->  |  Signifiant (forme)  |
  +-------------------+        +----------------------+

  Hierarchie des unites :
  Token  -->  Mot-forme  -->  Lexeme  -->  Lexie  -->  Vocable
  (graphique) (autonome)  (formes flechies) (+ locutions) (meme signifiant)
```

| Terme | Definition | Exemple |
|-------|-----------|---------|
| **Token** | Chaine graphique normalisee | "mangeaient" |
| **Mot-forme** | Signe linguistique autonome | "mangeaient" |
| **Lexeme** | Unite regroupant les formes flechies | {mange, manges, mangeons, mangeaient...} |
| **Lemme** | Forme canonique d'un lexeme | "manger" |
| **Radical (stem)** | Support morphologique | "mang-" |
| **Morpheme** | Plus petite unite significative | "mang-" + "-eaient" |

### Lemmatisation vs Racinisation (stemming)

| Aspect | Lemmatisation | Racinisation |
|--------|--------------|-------------|
| Principe | Ramene a la forme canonique | Coupe les suffixes |
| Resultat | Mot valide du dictionnaire | Radical (pas toujours un mot) |
| Exemple | "mangeaient" --> "manger" | "mangeaient" --> "mang" |
| Outils | spaCy, TreeTagger | Algorithme de Porter, Lovins |
| Precision | Haute | Moyenne |
| Vitesse | Plus lent | Plus rapide |

### Code Python : lemmatisation

```python
import spacy
nlp = spacy.load("fr_core_news_sm")
doc = nlp("Les enfants mangeaient des pommes rouges")

for token in doc:
    print(f"{token.text:15} -> lemme: {token.lemma_:15} POS: {token.pos_}")
# Les             -> lemme: le              POS: DET
# enfants         -> lemme: enfant          POS: NOUN
# mangeaient      -> lemme: manger          POS: VERB
# des             -> lemme: de              POS: ADP
# pommes          -> lemme: pomme           POS: NOUN
# rouges          -> lemme: rouge           POS: ADJ
```

## 1.7 Apercu de la syntaxe

### Deux types d'analyse syntaxique

```
  Analyse en CONSTITUANTS              Analyse en DEPENDANCES
  (arbres syntagmatiques)              (relations binaires)

       S                               regarde
      / \                              /    |    \
    NP    VP                        Paul  chien    noir
   / \   / \                              |
  Le chat mange                           le
           |
          NP
         / \
        la souris
```

### Grammaires formelles (Chomsky)

Une grammaire G = (V_N, V_T, R, S) ou :
- V_N : vocabulaire non-terminal (S, NP, VP, PP...)
- V_T : vocabulaire terminal (les mots)
- R : regles de production (S --> NP VP, NP --> Det N, ...)
- S : symbole de depart

## 1.8 Apercu de la semantique

### Representations du sens

| Methode | Principe | Exemple |
|---------|----------|---------|
| Vecteurs (embeddings) | Mots = points dans un espace | Word2Vec, GloVe |
| Lexiques semantiques | Base de synonymes/relations | WordNet, FrameNet |
| Reseaux semantiques | Graphe de concepts lies | Relations is-a, has-part |
| Logique des predicats | Formalisme logique | manger(Jean, pomme) |

### Hypothese distributionnelle (Harris, 1954)

> "You shall know a word by the company it keeps" -- Firth (1957)

Les mots qui apparaissent dans des contextes similaires ont des sens proches. C'est le fondement de Word2Vec et des embeddings modernes.

## 1.9 Perspective historique

```
  1950                1990                2010              Aujourd'hui
    |                   |                   |                   |
    v                   v                   v                   v
  RATIONALISME       EMPIRISME        DEEP LEARNING        LLMs
  - Regles           - Corpus          - Embeddings        - Transformers
  - Grammaires       - Statistiques    - Word2Vec          - BERT, GPT
  - Symbolique       - N-grammes       - RNN/LSTM          - Fine-tuning
  - ELIZA (1966)     - Brown Corpus    - Bengio (2003)     - ChatGPT
                     - HMM, CRF       - Mikolov (2013)
```

| Epoque | Approche | Idee cle |
|--------|----------|----------|
| 1950-1990 | Rationalisme | Regles linguistiques manuelles, grammaires formelles |
| 1990-2010 | Empirisme | Corpus + statistiques, apprentissage automatique |
| 2010-?? | Deep Learning | Reseaux de neurones, embeddings, modeles bout-en-bout |

## 1.10 Frameworks Python pour le TAL

| Framework | Usage principal | Points forts |
|-----------|----------------|-------------|
| **spaCy** | Production, pipelines NLP | Rapide, modeles pre-entraines, API moderne |
| **NLTK** | Recherche, pedagogie | Corpus integres, large couverture |
| **Gensim** | Embeddings | Word2Vec, FastText, TF-IDF, LDA |
| **Hugging Face** | Modeles pre-entraines | BERT, GPT, fine-tuning facile |
| **Stanford CoreNLP** | Outils complets (Java) | 53 langues, liaison Python |

## 1.11 Pieges classiques

- **Confondre langue et langage** : le TAL traite les langues naturelles, pas les langages de programmation
- **Croire que les niveaux sont sequentiels** : ils sont imbriques et interagissent
- **Sous-estimer l'ambiguite** : meme les phrases simples peuvent etre ambigues ("la petite brise la glace")
- **Oublier les connaissances implicites** : le TAL est difficile justement parce qu'il faut du "sens commun"
- **Confondre lemmatisation et racinisation** : la lemmatisation donne un mot valide, le stemming non

## 1.12 Recapitulatif

| Concept | A retenir |
|---------|-----------|
| TAL | Domaine interdisciplinaire (linguistique + info + IA) |
| Niveaux d'analyse | Phonetique, graphique, lexical, syntaxique, semantique, pragmatique |
| Tokenisation | Decoupage en tokens, plein d'exceptions |
| Lemmatisation | Forme canonique (manger), vs stemming (mang-) |
| Ambiguite | Present a TOUS les niveaux, difficulte majeure |
| Hypothese distributionnelle | Le sens vient du contexte d'apparition |
| 3 epoques | Rationalisme --> Empirisme --> Deep Learning |
