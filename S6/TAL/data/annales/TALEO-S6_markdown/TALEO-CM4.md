---
date: 2025-05-26T21:55:00
Projet: "[[S6-TALEO]]"
Auteur: m8v
---
# Résumé Exhaustif - Recherche d'Information (Information Retrieval)

## Introduction et Définition

**Définition de la Recherche d'Information (C. Manning)** : La recherche d'information consiste à trouver des documents de nature non structurée (généralement du texte) qui satisfont un besoin d'information au sein de grandes collections (généralement stockées sur ordinateur).

**Applications principales** :

- Moteurs de recherche Web (application la plus connue)
- Documents d'entreprise
- Bibliothèques numériques
- Domaines spécialisés (droit, médecine)

**Structure générale du cours** :

1. Représentation et indexation
2. Modèles et mesures de similarité
3. Évaluation
4. Expansion de requêtes
5. Focus sur le Web
6. Apprentissage automatique pour le classement (Learning to Rank)
7. RI et apprentissage profond

## 1. Représentation et Indexation

### Indexation : Concepts Fondamentaux

**Indexation manuelle** :

- Caractérisation du contenu conceptuel des documents et requêtes
- Utilisation d'un même langage/vocabulaire pour référer identiquement aux concepts
- Traduction dans un métalangage documentaire

**Indexation automatique** :

- Simulation par ordinateur de l'opération d'indexation intellectuelle
- Focus sur les résultats plutôt que sur la méthode
- Caractérisation d'un document pour pouvoir le retrouver

### Langages d'Indexation

**Langage contrôlé** :

- Concept décrit par un mot-clé, quelle que soit sa formulation
- Liste de termes approuvés
- **Mots-clés** : liste plate de termes, sans hiérarchie
- **Thésaurus** : termes approuvés, structurés par relations
- Nécessite l'apprentissage du langage
- Généralement utilisé pour l'indexation manuelle (uniformité)

**Langage non contrôlé** :

- Au niveau des mots, pas des concepts
- "Texte intégral" : listes plates de mots extraits des documents
- Pas besoin d'apprendre le langage
- Faible capacité à traiter différentes formulations d'un même concept
- Généralement utilisé pour l'indexation automatique

### Termes d'Index

**Représentation** : Sac de mots (Bag of Words - BoWs)

- Collection non ordonnée de termes d'index

**Questions principales** :

1. Qu'est-ce qu'un terme ?
2. Comment choisir les plus représentatifs ?

**Types de termes d'index** :

- **Termes simples** : noms (N), verbes (V), adjectifs (A)
- **Termes complexes** : N N, A N, N prep N (pompe à air, piston hydraulique, recherche d'information...)
- Termes simples : ambigus, favorisent le rappel, pas la précision
- Termes complexes : favorisent la précision, pas le rappel

### Sélection des Termes d'Index

**Critère de fréquence des termes** :

- Calculer tf(ti) : nombre d'occurrences du terme ti dans le document
- Choisir un seuil T ; assigner au document tous les termes ti pour lesquels tf(ti) > T

**Mots vides (stop words)** :

- Mots fréquents non pertinents pour décrire un document (de, le, chimie...)
- ~30 mots représentent ~30% des occurrences de "termes"
- Supprimer les 150 termes les plus fréquents réduit le stockage d'environ 25%

**Fréquence inverse de document (IDF)** :

- df(ti) : fréquence documentaire de ti (nombre de documents où il apparaît)
- idf = log(|Ω|/df(ti)) où |Ω| est la taille de la collection
- Favorise les termes fréquents dans quelques documents mais rares dans le reste

**Autres critères** :

- Catégories morphosyntaxiques : garder seulement N, V, A...
- Critère de discrimination des termes

### Pondération des Termes

**Objectif** : Indiquer qu'un terme est plus précis qu'un autre pour décrire un document

**Formule générale** : wd,i = li * gi * ni

- li : pondération locale (précision du terme dans le document)
- gi : pondération globale (précision du terme dans la collection)
- ni : normalisation (taille du document)

**Pondération locale** :

- Fréquence du terme (tf)
- tf logarithmique : 1 + log(tf)
- tf normalisée : tf/max_tf
- tf binaire : 1 si présent, 0 sinon

**Pondération globale** :

- IDF : log(N/df)
- IDF lissé : log(N/df) + 1
- Pas de pondération globale : 1

**Normalisation** :

- Normalisation cosinus : 1/√(Σ(li*gi)²)
- Pas de normalisation : 1

## 2. Modèles et Mesures de Similarité

### Modèle Booléen

**Principe** :

- Basé sur la théorie des ensembles et l'algèbre booléenne
- Document : conjonction de ses mots de représentation
- Requête : formule avec présence/absence de mots combinés avec ∨, ∧ et ¬

**Exemples** :

- q = t → Dq = Dt
- q = t1 ∧ t2 → Dq = Dt1 ∩ Dt2
- q = t1 ∨ t2 → Dq = Dt1 ∪ Dt2
- q = ¬t1 → Dq = Ω \ Dt1

**Avantages** :

- Modèle simple, facile à comprendre
- Requête : vrai ou faux pour un document donné

**Inconvénients** :

- Requêtes difficiles à formuler
- Seule correspondance exacte considérée
- Résultats peu intuitifs
- Pas de classement

### Modèle Vectoriel (VSM)

**Principe (Salton 75, 89)** :

- Documents et requêtes positionnés dans un même espace vectoriel
- Représentés par des vecteurs comparables avec mesures de similarité
- Vecteur : formé par les mots apparaissant dans la collection
- Une coordonnée = un mot
- Di = (wi,1, wi,2, ..., wi,n)ᵗ

**Matrice terme × document M** :

- Souvent creuse → problème pour algorithmes
- Densifications possibles : LSI (Latent Semantic Indexing)
- Taille proportionnelle à n et |Ω| → coût potentiellement prohibitif

**Avantages** :

- Pondération des termes
- Requête facile : liste de mots-clés
- Mesures de similarité offrent un classement
- Documents partiellement pertinents obtenables

**Inconvénients** :

- Tous les termes considérés indépendants (sac de mots)
- Langage de requête moins expressif
- Plus difficile de comprendre pourquoi un document est sélectionné

### Mesures de Similarité

**Mesures d'ensemble** (ne considèrent pas les poids) :

- **Dice** : dDice(D,Q) = 2 * |D∩Q|/(|D|+|Q|)
- **Jaccard** : dJaccard(D,Q) = |D∩Q|/|D∪Q|
- **Différence symétrique normalisée** : dD(D,Q) = |D△Q|/(|D|+|Q|)

**Mesures géométriques** (prennent en compte la pondération) :

- **Mesure cosinus** : cos(D,Q) = (D·Q)/(||D|| × ||Q||)
- **Distance L1** : dL1(D,Q) = ||D-Q||L1 = Σ|wd,i - wq,i|
- **Distance euclidienne (L2)** : dL2(D,Q) = ||D-Q||L2

**Mesures distributionnelles** :

- Si D et Q normalisés avec norme L1, peuvent être vus comme distributions de probabilité
- Distance χ²
- Divergence de Kullback-Leibler, Jensen-Shannon...

### Modèles Probabilistes

**Principe (Robertson et al. 82, van Rijsbergen 79)** :

- Étant donnés q et d, quelle est la probabilité que d soit pertinent pour q ?
- Variable aléatoire Rd,q = R associée à chaque tirage (d,q)
- R = 1 si d pertinent pour q, 0 sinon
- Classer documents d selon probabilité a posteriori P(R=1|d, qnew)

**Modèle d'Indépendance Binaire (BIM)** :

- 3 hypothèses :
    1. Vecteurs d et q binaires (0/1)
    2. Termes modélisés comme apparaissant dans documents indépendamment
    3. Termes n'apparaissant pas dans q également probables dans documents pertinents/non pertinents

**Score de pertinence** : s(q,d) = Σ(wi,d) log[(pi(1-ui))/(ui(1-pi))]

- pi : probabilité qu'un terme i apparaisse dans document pertinent pour q
- ui : probabilité qu'un terme i apparaisse dans document non pertinent pour q

### Schéma de Pondération BM25 (Okapi)

**Robertson & Walker 94** :

- Prise en compte de la fréquence des termes et longueur des documents
- Score BM25 : s(q,d) = Σ[idf(t) × (tf(t,d) × (k1+1))/(tf(t,d) + k1×(1-b+b×|d|/avgdl)) × (tf(t,q) × (k3+1))/(tf(t,q) + k3)]

Où :

- k1 ∈ [1.2, 2.0] = 1.2
- k3 = 1000
- b = 0.75
- |d| : longueur de d
- avgdl : longueur moyenne des documents
- tf(t,d) : fréquence de t dans d
- tf(t,q) : fréquence de t dans q
- df(t) : fréquence documentaire du terme t

### Index Inversé

**Principe** :

- Accès rapide aux documents
- di = {...(tj, wi,j),...} → tj = {...(di, wi,j),...}
- Intérêt : entrer dans la collection seulement pour documents pertinents

**Cas booléen** :

- Pour chaque terme de requête, trouver listes de documents dans index inversé
- Si termes combinés avec ∧ : intersection des listes
- Si termes combinés avec ∨ : union des listes

## 3. Évaluation

### Collections et Jugements de Pertinence

**Éléments nécessaires** :

- Collection de documents
- Ensemble de requêtes (30-50)
- Ensemble de jugements de pertinence

**Types de jugements** :

- **Binaires** : pertinent (1) / non pertinent (0)
- **Multi-valués** : parfait (5) > excellent (4) > bon (3) > correct (2) > mauvais (0)

**Hypothèses implicites** :

- Jugement total : pour chaque requête, possible de dire quel document est pertinent
- Jugement binaire : pas de graduation entre pertinent/non pertinent
- Pas d'additivité : pertinence d'un document indépendante des autres

**Collections de référence** :

- Cranfield, TREC, CLEF, NTCIR, MS MARCO

### Évaluation de Résultats Non Classés

**Précision** : fraction des documents récupérés qui sont pertinents Précision = (documents pertinents récupérés)/(documents récupérés)

**Rappel** : fraction des documents pertinents qui sont récupérés Rappel = (documents pertinents récupérés)/(documents pertinents)

**Mesure F** : moyenne harmonique pondérée de P et R F₁ = (2×P×R)/(P+R)

### Évaluation de Résultats Classés

**Courbe précision-rappel** :

- Précision interpolée : Pinterp(r) = maxr'≥r P(r')
- Précision moyenne interpolée à 11 points (R = 0, 0.1, 0.2, ..., 1.0)

**P@k et R@k** :

- Précision (resp. rappel) quand les k premiers documents sont considérés
- P@k(q) = (1/k) × Σᵢ₌₁ᵏ Relᵢ(q,d)

**Précision Moyenne (MAP)** :

- Pour une requête q : AveP(q) = moyenne des scores de précision correspondant aux rangs de chaque document pertinent
- MAP : moyenne de ces valeurs AveP pour toutes les requêtes

**Gain Cumulé Actualisé Normalisé (nDCG)** :
**Normalized DCG (nDCG)**
- nDCG(k,q) = DCG(k,q)/IDCG(k,q)
- Utilisé quand jugements de pertinence non binaires disponibles
- Documents très pertinents plus utiles s'ils apparaissent tôt
- Evaluated over a number k of top search results
**Cumulative gain**
- CG(k,q) = Σᵢ₌₁ᵏ (2^rel(i,q) - 1)
**Discounted cumulative gain**
- DCG(k,q) = Σᵢ₌₁ᵏ (2^rel(i,q) - 1)/log₂(i+1)


## 4. Expansion de Requêtes

### Problématique

**Difficultés** :

- Difficulté à formuler de bonnes requêtes
- Synonymie et existence de différentes façons d'exprimer une même idée
- Conduit à un faible rappel

**Solution** : Expansion de requêtes = reformulation des requêtes initiales, ajout de termes pour obtenir de meilleurs résultats

### Méthodes Locales

**Retour de pertinence (Relevance Feedback)** :

- Utilisateur dans la boucle pour améliorer l'ensemble de résultats
- Documents marqués pertinents/non pertinents après requête initiale
- Système calcule meilleure représentation du besoin d'information

**Algorithme de Rocchio (1971)** : q₁ = α×q₀ + β×(1/|Dr|)×Σ(d∈Dr) + γ×(1/|Dnr|)×Σ(d∈Dnr)

- Dr et Dnr : ensembles de documents pertinents et non pertinents
- α, β, γ : poids (ex : α=1, β=0.75, γ=0.15)

**Pseudo Retour de Pertinence** :

- Automatisation de la partie manuelle du retour de pertinence
- Les k premiers documents classés considérés comme pertinents
- Application du même algorithme

### Méthodes Globales

**Expansion avec ressources lexicales** :

- WordNet, thésaurus, dictionnaire de synonymes
- Famille morphologique si pas de racinisation/lemmatisation

**Construction automatique de ressources** :

- Co-occurrences de mots
- Méthodes basées sur graphes
- LSI, LDA...

**Exploitation de reformulations d'autres utilisateurs sur le Web**

## 5. Focus sur le Web

### Caractéristiques Spécifiques

**"Base de données" de documents** :

- Plusieurs milliards de pages Web accessibles
- Très dynamique, croissance exponentielle

**Conséquences sur moteurs de recherche** :

- Base de données énorme → index distribué
- Requêtes de mauvaise qualité :
    - Erreurs de frappe/orthographe
    - Imprécises, mal formulées (quelques mots)
- Grand nombre de documents potentiellement non pertinents
- Nouvelle source de connaissance : les hyperliens

### Composants des Moteurs de Recherche

1. **Spider, robot, crawler** :
    
    - Visite les pages Web
    - Les "lit"
    - Suit les liens
    - Visite régulièrement à nouveau
2. **Base de données d'index** :
    
    - Stockage de ce que le spider a trouvé
    - Peut être énorme (Google : centaines de milliards de pages)
3. **Logiciel de moteur de recherche** :
    
    - Algorithme qui recherche dans le catalogue pour trouver et organiser les réponses

### Critères de Pertinence

**Critères traditionnels** :

- Fréquence et position des termes de requête dans le document
- Fréquence de ces termes dans la base d'index (idf)
- Pénalisation des pages avec "spamming"

**Nouveaux critères** :

- Popularité, fréquence de référence
- Opinion sur la page
- Nombre de liens vers cette page → Algorithme PageRank

### PageRank

**Principe (Page et Brin 1998)** :

- Produit une distribution de probabilité représentant la probabilité qu'un surfeur cliquant aléatoirement sur des liens arrive sur une page particulière

**Histoire** :

- Surfeur aléatoire se déplace d'une page A vers une page choisie aléatoirement parmi celles liées par A
- Certaines pages visitées plus souvent ("plus importantes")
- Si pas de lien sortant ou ennui : téléportation vers autre nœud

**Formule itérative** : PR(u) = ((1-d)/N) + d × Σ(v∈Bu) [PR(v)/L(v)]

- Bu : ensemble des pages pointant vers u
- L(v) : nombre de liens depuis v
- d : facteur d'amortissement (généralement 0.85)

## 6. Learning to Rank (L2R)

### Principe Général

**Définition** : Application de techniques d'apprentissage automatique supervisé pour apprendre des modèles de classement

**Caractéristiques** :

- Usage extensif de caractéristiques conçues manuellement
- Basées sur propriétés statistiques des termes
- Propriétés intrinsèques des requêtes et documents
- Tendance majeure fin années 1980 - début 2010s

**3 approches** : pointwise, pairwise, listwise

### Approche Pointwise

**Principe** :

- Apprendre à assigner un score à chaque objet (paire (q,d))
- Espoir que le score reflète le rang

**Méthodes** :

- **Régression** : SVR, arbres de décision boostés, réseaux de neurones
- **Classification** : objets avec labels de classe binaires avec ordre

**RI comme problème de classification binaire** :

- Jugements de pertinence : q₁: (d₁,1), (d₂,0)... q₂: (d₁,0), (d₂,1)...
- Exemples d'entraînement : vecteur x représentant paire (q,d)
- Classifier binaire appris, valeur de fonction de décision utilisée pour ordonner

**Inconvénients** :

- Score assigné à chaque document indépendamment
- Ordre relatif entre documents non considéré dans apprentissage
- Position de chaque document dans liste finale invisible à fonction de perte

### Approche Pairwise

**Principe** :

- Pas de classement complet disponible, mais ordre partiel sous forme de paires de préférence
- Fonction f doit préserver ordre partiel : x⁽¹⁾ ≻ x⁽²⁾ ⇔ f(x⁽¹⁾) > f(x⁽²⁾)

**Transformation** :

- Information de paire de préférence transformée en information de classification
- x⁽¹'²⁾ = (x⁽¹⁾ - x⁽²⁾)
- y⁽¹'²⁾ = +1 si x⁽¹⁾ ≻ x⁽²⁾, 0 sinon

**Inconvénients** :

- Fonction de perte considère seulement ordre relatif entre deux documents
- Regarder seulement une paire rend difficile dérivation position finale
- Pas de différence entre erreurs faites en haut ou milieu du classement

### Approche Listwise

**Principe** :

- Espace d'entrée = ensemble de documents associés à une requête
- Fonction f doit fournir classement complet de l'ensemble

**Méthodes** :

- Assigner degrés de pertinence à tous documents → fonction de perte basée sur approximation de mesures d'évaluation IR (MAP, nDCG)
- Fournir permutation de l'ensemble → fonction de perte mesure différence entre permutations

**Inconvénient** : Complexité

## 7. RI et Apprentissage Profond

### Deux Idées Principales

1. **Injection de représentations sémantiques** (embeddings mots/documents) dans modèles IR traditionnels
2. **Apprentissage bout-en-bout** des représentations et fonction de classement

### Exemple : Expansion de Requêtes

**Roy et al., 2016** : Expansion de q avec ses k plus proches voisins dans l'espace sémantique

### Dual Embedding Space Model

**Nalisnick et al., 2016** :

- Représentation document : centroïde des vecteurs OUT normalisés de ses mots
- Similarité cosinus entre représentations de d et q : vecteur OUT pour d et IN pour q
- Utilisation des espaces d'embeddings d'entrée et sortie d'un modèle Word2vec

### Limites des Embeddings

**Problèmes** :

- Embeddings non appris pour tâche IR
- Bons pour correspondance sémantique
- Mais IR liée à pertinence plutôt qu'à sémantique

**Solution** : Guider représentation selon tâche de recherche

- Objectif : classement
- Réseaux de neurones capables de classer documents
- Approches IR neurales bout-en-bout

### Modèles Représentation vs. Interaction

**Modèles basés représentation (siamois)** :

- Apprennent indépendamment représentations vectorielles denses de requêtes et documents
- Comparaison au moment du classement (similarité cosinus, produit scalaire, MLP...)
- Permettent calcul offline des représentations de documents

**Modèles basés interaction** :

- Production matrice de similarité capturant interactions entre termes de requête et document
- Extraction signaux de pertinence de la matrice
- Combinaison et traitement pour produire score de pertinence

### Deep Semantic Matching Model (DSSM)

**Huang et al., 2013** :

- Modèle basé représentation
- 1 requête, 1 document pertinent, plusieurs non pertinents
- Word-hashing : n-grammes de caractères
- Séries de couches fully-connected pour représentation vectorielle
- Similarité cosinus au moment de la recherche

### Deep Relevance Matching Model (DRMM)

**Guo et al., 2016** :

- Modèle basé interaction
- Pour chaque terme de requête : agrégation des similarités (cosinus entre embeddings) dans histogramme
- Chaque histogramme passé à réseau de neurones
- Multiplication par valeur (term gating) : idf du terme de requête
- Perte hinge : L(q, d+, d-; Θ) = max(0, 1 - s(q, d+) + s(q, d-))
- Premier modèle à battre BM25 !

### MonoBERT

**Nogueira & Cho 2019** :

- Utilisation de BERT avec [[CLS],q,[SEP],d,[SEP]] comme séquence d'entrée
- Représentation contextuelle finale du token [CLS] utilisée comme entrée d'une couche fully-connected
- Modèle entraîné bout-en-bout pour tâche de classification de pertinence
- Très bons résultats : attention all-to-all capture interactions entre/dans termes de q et d

### Remarques Conclusives

**Restriction de longueur d'entrée de BERT** :

- Différentes solutions proposées
- Solutions avec indexation offline des documents (ex : ColBERT)
- MonoBERT appliqué sur top-1000 documents classés par BM25 → re-classement

**Domaine de recherche très actif**

---

## Points Clés à Retenir

1. **Indexation** : Processus fondamental de représentation des documents par des termes
2. **Modèles** : Booléen (simple mais limité), Vectoriel (flexible), Probabiliste (théoriquement fondé)
3. **Évaluation** : Précision, Rappel, MAP, nDCG selon le type de résultats
4. **Expansion** : Amélioration des requêtes par feedback ou ressources externes
5. **Web** : Défis spécifiques (échelle, qualité requêtes) et solutions (PageRank)
6. **Learning to Rank** : Approches pointwise, pairwise, listwise pour optimiser le classement
7. **Deep Learning** : Révolution avec embeddings puis modèles bout-en-bout comme BERT

Ce résumé couvre l'ensemble des concepts, algorithmes, méthodes d'évaluation et évolutions récentes présentés dans le cours de 342 slides sur la recherche d'information.