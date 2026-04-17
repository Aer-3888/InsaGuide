---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
# Résumé Exhaustif - Introduction au Traitement Automatique des Langues (TAL)

## 1. INFORMATIONS GÉNÉRALES DU COURS

### Structure du cours

- **7 cours magistraux** (2h chacun)
- **6 travaux pratiques** (2h chacun)
- **Évaluation** : 1 examen (1h, sans notes) + série de 3 TP (projet)

### Équipe pédagogique

- **Guillaume Gravier** : Chargé de recherche CNRS, IRISA/Linkmedia
- **Pascale Sébillot** : Professeure INSA Rennes, IRISA/Linkmedia
- **Caio Corro** : Maître de conférences INSA Rennes, IRISA/Linkmedia
- **Nicolas Fouqué/Christian Raymond** : Ingénieur de recherche/Maître de conférences

### Plan détaillé des cours

1. Introduction au TAL
2. Représentation des mots
3. Représentation des documents
4. Application à la recherche d'information
5. Outils fondamentaux pour le TAL (HMM, CRF, LSTM...)
6. Modélisation de langue
7. Application à l'analyse syntaxique

### Travaux pratiques

- Représentation des mots
- Projet de recherche d'information (3 TP)
- Représentation des documents et classification de textes (2 TP)

### Ouvrages de référence

- **Jurafsky & Martin** (2025) : Speech and Language Processing, 3ème édition
- **Yoav Goldberg** (2017) : Neural Network Methods for Natural Language Processing
- **Manning & Schütze** (1999) : Foundations of Statistical Natural Language Processing

## 2. DÉFINITIONS FONDAMENTALES

### Langage naturel

- **Langue** : Système de signes conventionnels et règles de combinaison commun à une communauté
- **Langage naturel** : Langue utilisée comme langue maternelle, développée naturellement (vs langages construits/programmation)

### Traitement Automatique des Langues (TAL)

- **Définition** : Sous-domaine interdisciplinaire (linguistique, informatique, IA) concernant les interactions ordinateur-langage humain
- **Objectif** : Modéliser et reproduire avec des machines la capacité humaine à produire et comprendre des énoncés linguistiques
- **Synonymes** : NLP (Natural Language Processing), Linguistique computationnelle, TALN

## 3. APPLICATIONS PRATIQUES DU TAL

### Traitement et analyse de collections textuelles

- **Recherche d'information** et moteurs de recherche
- **Classification automatique** : routage de mails, détection de spam
- **Veille technologique**
- **Extraction d'information** pour alimenter bases de données/bases de connaissances

### Production de données linguistiques

- **Traduction automatique** : Systran, Google Translate, DeepL
- **Correction automatique** et aides à la saisie
    - Correcteurs orthographiques/syntaxiques
    - Claviers auto-correcteurs, aides à la saisie (Dasher, Swype)
    - Systèmes d'accentuation automatique
- **Génération textuelle** à partir de spécifications formelles/données
- **Résumé automatique**
- **Légendage d'images**

### Interaction

- **Agents conversationnels** et systèmes de dialogue (ChatGPT, interfaces vocales)
- **Logiciels de dictée** (Dragon Dictate, Via Voice)
- **Interrogation de bases de données** en langage naturel
- **Systèmes de questions-réponses**

## 4. NIVEAUX D'ANALYSE LINGUISTIQUE

### Exemple d'analyse : "Le président des antialcooliques mangeait une pomme avec un couteau"

#### Niveau phonétique et phonologique

- **Phonétique** : Étude des sons de la parole
- **Phonologique** : Organisation des sons
- **Ambiguïtés** : "Dans ces meubles laqués, rideaux et dais moroses" / "Danse, aime, bleu laquais, ris d'oser des mots roses"

#### Niveau graphique

- **Segmentation** du texte en unités de base (mots)
- **Ambiguïtés** : Rôle des points, apostrophes, traits d'union (S.N.C.F., aujourd'hui, Jean-Paul)

#### Niveau lexical et morphologique

- **Identification** des composants lexicaux et de leurs propriétés
- **Ambiguïtés** :
    - Statiques : "président" (verbe/nom), "ferme" (verbe/nom/adjectif)
    - Dynamiques : "rat" (nom/adjectif selon contexte)

#### Niveau syntaxique

- **Identification** des composants de niveau supérieur (syntagmes) et organisation
- **Ambiguïtés** :
    - Structure hiérarchique : "la petite brise la glace"
    - Attachement : "j'ai été voir un film avec Brad Pitt"

#### Niveau sémantique

- **Construction** d'une représentation du sens
- **Ambiguïtés** :
    - Homonymie : "avocat" (fruit/homme de loi)
    - Polysémie : "agneau" (animal/viande), "verre" (contenu/contenant)
    - Portée des quantificateurs

#### Niveau pragmatique

- **Identification** de la fonction d'un énoncé dans son contexte
- **Ambiguïtés** : Implications contextuelles dans les conversations

**Important** : Les niveaux sont imbriqués, pas séquentiels (illusion du pipeline)

## 5. DIFFICULTÉS DU TAL

### Difficulté de description des langues naturelles

- **Nombre infini** de phrases bien formées
- **Différence** entre correction et compréhensibilité
- **Vocabulaire évolutif**

### Données non structurées

- **Absence de sémantique** apportée par une structure a priori

### Spécificités des langues naturelles

- **Ambiguïté** (à tous les niveaux)
- **Connaissances implicites**
- **Multiples façons** d'exprimer une même idée

### Connaissances implicites

- **Connaissances partagées** : encyclopédiques, sens commun, scénarios
- **Interprétations "évidentes"** : Résolution des références pronominales
- **Usages métaphoriques/métonymiques**
- **Plusieurs niveaux impliqués** dans la compréhension

### Variations d'expression

- **Graphiques/morphologiques** : "mot clé", "Mot-clé", "mots-clés"
- **Syntaxiques** : "acidité du sang", "acidité élevée du sang", "acidité sanguine"
- **Sémantiques** : "vélo", "bicyclette", "cyclisme"
- **Paraphrases**

## 6. TRAITEMENT AU NIVEAU GRAPHIQUE

### Tokenisation

- **Découpage** d'un texte en phrases et en tokens
- **Basé sur** la ponctuation et les espaces
- **Nombreuses règles** et exceptions :
    - "j'ai" → "j" + "ai" vs "aujourd'hui" → "aujourd'hui"
    - "31/12/2021" → "31/12/2021" vs "31 décembre 2021"
- **Gestion** des guillemets, parenthèses
- **Outils** : Stanford Tokenizer, NLTK, spaCy

## 7. TRAITEMENT LEXICAL ET MORPHOLOGIQUE

### Concepts fondamentaux

- **Lexicologie** : Inventaire et classification des usages des mots
- **Morphologie** : Processus de formation des mots
    - Division en **morphèmes** (plus petites unités significatives)
    - **Flexion** : Ajustement conditionné par contraintes syntaxiques
    - **Dérivation** : Création de nouvelles unités lexicales
    - **Composition** : Concaténation de formes

### Vocabulaire technique

- **Signe** : Association idée/concept (signifié) ↔ forme (signifiant)
- **Mot-forme** : Signe linguistique avec autonomie de fonctionnement
- **Lexème** : Unité lexicale regroupant les mots-formes distinguées par la flexion
- **Lexie** : Lexème + locutions (expressions complexes)
- **Vocable** : Ensemble de lexies associées au même signifiant
- **Polysémie** : Propriété d'un vocable contenant plusieurs lexies
- **Homonymie** : Lexies différentes partageant le même signifiant sans lien sémantique

### Morphologie détaillée

- **Morphème** : Signe linguistique à signifié élémentaire
- **Affixe** : Morphème non autonome (suffixe, préfixe)
- **Radical** : Support morphologique d'une lexie
- **Lemme** : Mot-forme canonique représentant une lexie

### Objectifs du traitement

- **Typer** les mots-formes
- **Reconnaître** structure et propriétés
- **Faciliter** les étapes postérieures
- **Associer** informations diverses :
    - Représentation arborescente/linéaire
    - Catégorie morpho-syntaxique (PoS)
    - Lemme
    - Informations flexionnelles/sémantiques
    - Cadre de sous-catégorisation

### Outils et moyens

- **Lexiques** : Accès direct aux mots connus
- **Analyseurs morphologiques** : Règles de combinaison + ajustements orthographiques
- **Représentation efficace** : Automates à états finis
- **Lemmatiseurs** : TreeTagger, spaCy
- **Raciniseurs** (stemmers) : Algorithmes de Lovins, Porter

## 8. TRAITEMENT SYNTAXIQUE

### Syntaxe

- **Étude** des principes et contraintes gouvernant la combinaison des mots
- **Analyse syntaxique** : Dévoilement de la structure syntaxique
    - **Analyse en constituants** : Arbre des composants
    - **Analyse en dépendances** : Relations grammaticales binaires dirigées

### Grammaires formelles (Chomsky)

- **Formalisation** de la compétence linguistique humaine
- **G = (V_N, V_T, R, S)**
    - V_N : Vocabulaire non-terminal
    - V_T : Vocabulaire terminal (mots)
    - R : Ensemble de productions/règles
    - S : Symbole de départ

### Hiérarchie des grammaires

- **Grammaires hors-contexte** : Un non-terminal à gauche, chaîne quelconque à droite
- **Grammaires régulières** : Restrictions sur la position des non-terminaux

### Limites et outils

- **Limitations** des grammaires hors-contexte :
    - Expression des accords (multiplication des catégories)
    - Dépendances à longue distance
- **Outils** : MaltParser, Stanford CoreNLP, spaCy, analyseurs partiels (chunkers)

## 9. REPRÉSENTATION ET TRAITEMENT SÉMANTIQUE

### Sémantique

- **Étude du sens** :
    - Des mots (sémantique lexicale)
    - Des énoncés
- **Objectif** : Représentation conceptuelle en langage formel

### Moyens de représentation

- **Vecteurs** basés sur cooccurrences textuelles
- **Lexiques sémantiques**
- **Réseaux de relations sémantiques**
- **Logique des prédicats**

### Représentations vectorielles

- **Analyse distributionnelle** (Harris 1954)
- **Plongements de mots** (word embedding, Mikolov 2013)
- **Principe** : Mots apparaissant dans contextes similaires sont sémantiquement liés

### Principe de compositionnalité

- **Énoncé** (Frege) : Le sens du tout est fonction du sens des parties et de leur combinaison
- **Composition** dirigée par la structure syntaxique
- **Limites** : Expressions idiomatiques, métaphores

### Sémantique par calcul des prédicats

- **Noms propres** : Constantes (Jean)
- **Adjectifs/noms communs** : Prédicats (homme(x))
- **Verbes** : Prédicats (manger(x,y))
- **Combinaisons** : Connecteurs logiques (∧, ∨, ¬, →)
- **Quantificateurs** : ∃, ∀
- **Limites** : Vague, modalités, croyances, aspects temporels, ordres

### Réseaux sémantiques

- **Représentation** par graphe de concepts liés par relations
- **Relations importantes** :
    - **is-a** (sort-of) : Hiérarchies, héritage de propriétés
    - **has-for-part** (is-part-of)
- **Extensions** :
    - **Frames** (Minsky 1974) : Concepts en treillis avec propriétés héritées
    - **Scripts** (Schank & Abelson 1977) : Séquences d'actions stéréotypiques
    - **Graphes conceptuels** (Sowa 1984) : Graphes canoniques combinables

### Lexiques et réseaux sémantiques

- **FrameNet** : Description sémantique des verbes (13k sens, 1.2k cadres)
- **WordNet** : Base lexicale avec relations entre sens des mots (100k+ noms, 20k adjectifs, 10k verbes)

## 10. RECONNAISSANCE AUTOMATIQUE DE LA PAROLE (RAP)

### Production de la parole

- **Chaîne** : Cerveau → Signal acoustique
- **Niveaux** : Sémantique → Syntaxe → Lexique → Prosodie → Signal

### Difficultés de la RAP

- **Objectif** : Correspondance signal acoustique ↔ chaîne de mots
- **Variabilités** :
    - Inter/intra-locuteur
    - Acoustique/canal (qualité capteurs, bruit ambiant)
    - Grammaticale (taille vocabulaire, contraintes)
    - Fluidité (mots isolés vs parole continue, lu vs conversationnel)

### Traitement du signal

- **Analyse court-terme** : Trames de quelques millisecondes
- **Information spectrale** : Énergie par bandes de fréquence
- **Enveloppe spectrale** : Pics (formants) caractéristiques des phones
- **MFCC** : Coefficients cepstraux mel-fréquentiels
- **Information dynamique** : Δ et ΔΔ

### Équation fondamentale de la RAP statistique

**ŵ = arg max_w P[w|y] = arg max_w p(y|w) P[w]**

- **p(y|w)** : Vraisemblance acoustique (modèle acoustique)
- **P[w]** : Probabilité a priori des mots (modèle de langue)
- **Lexique de prononciation** : Lien mots ↔ phones

### Composants

- **Modélisation acoustique** : HMM, réseaux bayésiens, réseaux profonds
- **Modélisation de langue** : Grammaires stochastiques, n-grammes, réseaux de neurones
- **Décodage** : Algorithme de Viterbi

### Sortie et erreurs

- **Particularités** : Pas de ponctuation, pas de majuscules, erreurs de transcription
- **Types d'erreurs** :
    - Glissements (conditions acoustiques, mots hors vocabulaire)
    - Fautes d'orthographe (accords, participes passés)
    - Insertions/omissions de mots outils
- **Mesures de confiance** (imparfaites)
- **Listes N-best**, graphes de mots, réseaux de confusion

### Performance

- **WER** (Word Error Rate) : Distance d'édition minimale
- **SER** (Sentence Error Rate)

### Évolutions modernes

- **Réseaux récurrents** (LSTM bidirectionnels)
- **Entraînement bout-en-bout** sans alignement (CTC)

## 11. PERSPECTIVE HISTORIQUE

### Première époque (1950-1990) : Rationalisme

- **Début** : Fin 2nde guerre mondiale, naissance informatique
- **Focus** : Traduction automatique comme problème de chiffrement
- **1954** : Premier système MT (IBM-Georgetown, russe→anglais, 250 mots, 6 règles)
- **1960** : Rapport Bar-Hillel (limites de la MT automatique)
- **1966** : Rapport ALPAC (suspension financements MT)

#### Développements linguistiques cruciaux

- **1951-54** : Zellig Harris (linguistique distributionnelle)
- **1957** : Noam Chomsky (syntaxe, grammaires formelles)
- **Deux mondes** : Traitement parole (stochastique) vs TAL (symbolique)

#### Intelligence Artificielle

- **1956** : École d'été Dartmouth (début IA)
- **1966** : ELIZA (Weizenbaum) - Premier chatbot basé sur mots-clés et patterns

#### Approches sémantiques (70-80s)

- **Focus** : Représentation des connaissances
- **Peu d'accent** sur la syntaxe
- **Modélisation** des connaissances générales
- **Formalismes** : Réseaux sémantiques, frames, scripts, graphes conceptuels

### Deuxième époque (1990-2010) : Empirisme

- **Rupture** fin 80s-début 90s
- **Facteurs** :
    - Essor Internet et grands corpus
    - Brown Corpus (1960) : 1M mots
    - British National Corpus (1994) : 100M mots
- **Linguistique de corpus** + apprentissage automatique

#### Changement de paradigme

**Rationalisme → Empirisme**

- Linguistique → Statistiques
- Compréhension précise → Sens utile
- Modèles exacts → Modèles probabilistes

#### Nouvelles représentations du sens

- **Rationaliste** : Vision syntactico-logique, modèle générique du monde
- **Empirique** : Sens dépendant du contexte, sac de mots, n-grammes

### Troisième époque (2010-20??) : Apprentissage profond

- **Tendance forte** vers l'apprentissage profond
- **Jalons** :
    - Travaux fondateurs de Bengio (2003)
    - Word2vec de Mikolov (2013)
    - Réseaux récurrents pour modélisation de langue
    - Architectures neuronales variées avec plongements

## 12. FRAMEWORKS MODERNES

### Frameworks Python

- **Gensim** : Plongements de mots/documents (Word2vec, fastText, tf-idf, LSI, LDA)
- **spaCy** : Framework flexible pour production, pipelines standard, entraînement modèles
- **NLTK** : Environnement complet recherche TAL, corpus et lexiques, outils standard

### Autres frameworks

- **Stanford CoreNLP** : Outils Java étendus, liaison Python, 53 langues
- **AllenNLP** : Environnement recherche, modèles pré-entraînés, interface PyTorch
- **PyTorch/torchtext** : Entraînement modèles neuronaux, manipulation corpus

## 13. SOURCES ET RÉFÉRENCES

### Ouvrages principaux

- Frederick Jelinek (1998) : Statistical Methods for Speech Recognition
- Yoav Goldberg (2017) : Neural Network Methods for NLP
- Jurafsky & Martin : Speech and Language Processing
- Manning & Schütze (1999) : Foundations of Statistical NLP

### Cours et polycopiés

- Philippe Langlais (Université de Montréal)
- Isabelle Tellier (Université de Lille 3)
- Jean Véronis (Université de Provence)
- Anne Vilnat (Université Paris Sud)
- François Yvon (Télécom ParisTech)

