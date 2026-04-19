# Methodologie d'examen : Comment aborder chaque type de question

Ce document analyse les types de questions recurrents dans toutes les annales disponibles (2013-2025) et fournit des strategies de resolution systematiques.

## Partie A : Types de questions Analyse de Donnees (AD)

### A1. Interpretation de l'ACP a partir de figures (Frequence la plus elevee)

**Apparait dans** : 2015, 2016, 2017, 2019, 2020, 2021, 2023, 2025

**Ce qui est donne** : Un cercle des correlations et/ou un plan factoriel des individus, accompagne d'un tableau de donnees et d'un resume des valeurs propres.

**Ce qu'il faut faire** :

#### Etape 1 : Determiner le nombre de composantes a conserver

Lire le tableau des valeurs propres. Calculer la variance cumulee. Indiquer quelles composantes depassent le seuil de 80%.

Exemple de reponse :
> "Les deux premieres composantes capturent respectivement 45% et 25% de la variance, soit 70% cumulee. En ajoutant la 3e composante (12%), on atteint 82%, ce qui depasse le seuil de 80%. On retient donc 3 composantes."

#### Etape 2 : Nommer les axes a partir du cercle des correlations

Regarder quelles variables sont les plus proches de chaque axe (correlation absolue la plus elevee).

Modele de reponse :
> "L'axe 1 est principalement lie aux variables [X, Y, Z] (correlations positives proches de 1) et negativement aux variables [A, B] (correlations proches de -1). Cet axe represente donc [interpretation metier]."

#### Etape 3 : Identifier les groupes de variables sur le cercle des correlations

- Variables proches : correlees positivement
- Variables opposees : correlees negativement
- Variables a 90 degres : independantes

Exemple :
> "Les variables Charbon et Gaz naturel sont proches sur le cercle, indiquant une correlation positive: les pays qui produisent beaucoup d'electricite au charbon en produisent aussi beaucoup au gaz. En revanche, Energies renouvelables est a l'oppose, indiquant une correlation negative."

#### Etape 4 : Interpreter les individus sur le plan factoriel

Identifier quels individus sont extremes (eloignes de l'origine) sur chaque axe. Lier leur position a l'interpretation des variables de l'etape 2.

Exemple :
> "La Chine et les USA sont situes a droite sur l'axe 1, ce qui correspond a une forte production d'electricite totale (coherent avec les variables Charbon et Gaz). La France est separee sur l'axe 2, coherent avec sa forte production nucleaire."

### A2. Questions sur la qualite de representation

**Apparait dans** : 2015, 2017, 2021, 2023

**Ce qu'il faut calculer** : Valeurs de cos^2 ou valeurs de contribution.

**Formule** : cos^2(i, k) = F_ik^2 / somme_j(F_ij^2)

**Strategie** :
1. Lire les coordonnees de l'individu sur chaque axe dans le tableau
2. Elever chaque coordonnee au carre
3. Diviser par la somme de toutes les coordonnees au carre
4. Un cos^2 eleve (> 0.5) signifie que l'individu est bien represente sur cet axe

Exemple de calcul :
> Point A has coordinates (2.1, 0.3) on PC1 and PC2.
> cos^2(A, PC1) = 2.1^2 / (2.1^2 + 0.3^2) = 4.41 / 4.50 = 0.98
> Point A is very well represented on the first factorial plane (98%).

### A3. "Pourquoi l'ACP normee ?" / "Quel type d'ACP ?"

**Apparait dans** : Presque chaque examen AD

**Reponse standard** :
> "On utilise l'ACP normee (centree-reduite) car les variables ont des unites differentes [ou des echelles differentes]. Sans standardisation, les variables avec les plus grandes valeurs numeriques domineraient l'analyse. L'ACP normee travaille sur la matrice de correlation plutot que la matrice de covariance."

**Quand NON normee** : Seulement si toutes les variables sont dans la meme unite ET ont des ordres de grandeur comparables (rare en examen).

### A4. Calcul de valeurs propres (Matrice 2x2)

**Apparait dans** : 2015, 2017

**Methode** : Pour une matrice de correlation 2x2 :
```
R = | 1    r |
    | r    1 |

lambda_1 = 1 + r
lambda_2 = 1 - r
```

Pour le cas general, resoudre : det(R - lambda * I) = 0

### A5. Questions de pretraitement

**Apparait dans** : 2020, 2021, 2025

Questions courantes :
- "Comment traiteriez-vous les valeurs manquantes dans ce jeu de donnees ?"
- "Pourquoi la standardisation est-elle necessaire ?"
- "Quel est l'impact des valeurs aberrantes sur l'ACP ?"

**Strategie** : Etre specifique sur la methode ET justifier le choix en fonction des caracteristiques des donnees.

---

## Partie B : Types de questions Fouille de Donnees (FD)

### B1. Apriori a la main (Frequence la plus elevee)

**Apparait dans** : 2013, 2016, 2019, 2021, 2023, 2024

**Donne** : Une base de transactions (5-10 transactions) et un seuil de support minimum.

**Modele de solution etape par etape** :

```
STEP 1: Count support of each individual item
-------------------------------------------------
Item    | Count | Support | Frequent?
--------|-------|---------|----------
A       | 7     | 7/10    | Yes (>= minsup)
B       | 3     | 3/10    | No (< minsup)
...

L_1 = {A, C, D, E, ...}  (items with support >= minsup)

STEP 2: Generate C_2 (all pairs from L_1)
-------------------------------------------------
Candidate  | Count | Support | Frequent?
-----------|-------|---------|----------
{A, C}     | 5     | 5/10    | Yes
{A, D}     | 3     | 3/10    | No
...

L_2 = &#123;&#123;A,C&#125;, &#123;C,E&#125;, ...&#125;

STEP 3: Generate C_3 (from L_2, with anti-monotonicity pruning)
-------------------------------------------------
Candidate    | All 2-subsets in L_2? | Count | Frequent?
-------------|----------------------|-------|----------
{A, C, E}   | {A,C}: Yes, {A,E}: Yes, {C,E}: Yes | 4 | Yes
{A, C, D}   | {A,C}: Yes, {A,D}: No | PRUNED | --
...
```

**ESSENTIEL** : Toujours montrer l'etape d'elagage explicitement. Ecrire "Elague par anti-monotonie car &#123;X,Y&#125; n'est pas dans L_2."

### B2. Construction d'un FP-Tree

**Apparait dans** : 2024

**Donne** : Une base de transactions et un support minimum.

**Etapes** :
1. Compter les frequences des items, supprimer les items non frequents
2. Trier les items par frequence (decroissante) dans chaque transaction
3. Construire l'arbre en inserant les transactions une par une
4. Construire la base de motifs conditionnels pour chaque item (de bas en haut)
5. Construire les FP-trees conditionnels et extraire les itemsets frequents

**Conseil** : Dessiner l'arbre clairement avec les etiquettes et les comptages des noeuds. Montrer la table d'en-tete avec les liens entre noeuds.

### B3. Classification DBSCAN (Noyau/Frontiere/Bruit)

**Apparait dans** : 2016, 2019, 2023, 2024, 2025

**Donne** : Un ensemble de points 2D, une valeur eps, une valeur min_samples.

**Solution etape par etape** :

```
STEP 1: For each point, list neighbors within eps
-------------------------------------------------
Point | Neighbors (distance < eps) | Count | Type
------|---------------------------|-------|------
P1    | P2, P3, P5               | 3     | Core (>= min_samples=3)
P2    | P1, P3                   | 2     | Border (< min_samples, but neighbor of core P1)
P3    | P1, P2, P4, P5           | 4     | Core
P6    | (none)                   | 0     | Noise

STEP 2: Form clusters by connectivity
-------------------------------------------------
Cluster 1: P1, P2, P3, P4, P5 (connected through core points)
Noise: P6
```

**Conseil** : Dessiner les points sur du papier quadrille, tracer des cercles de rayon eps autour de chacun, et compter visuellement.

### B4. K-Means etape par etape

**Apparait dans** : 2016, 2019, 2025

**Donne** : Centroides initiaux et points de donnees.

**Etapes** :

```
Iteration 1:
  Centroids: C1=(1,2), C2=(5,3)
  
  Point | dist(C1) | dist(C2) | Assigned to
  ------|----------|----------|------------
  (0,1) | 1.41     | 5.39     | C1
  (2,3) | 1.41     | 3.00     | C1
  (6,4) | 5.39     | 1.41     | C2
  
  New centroids:
  C1 = mean of {(0,1), (2,3)} = (1, 2)
  C2 = mean of {(6,4)} = (6, 4)
  
Iteration 2: ...
(Continue until centroids don't change)
```

### B5. Comparer DBSCAN vs K-Means

**Apparait dans** : 2016, 2019, 2023, 2025

**Modele de reponse** (utiliser un tableau) :

| Critere | K-means | DBSCAN |
|---------|---------|--------|
| Parametre d'entree | K (nombre de clusters) | eps, min_samples |
| Forme des clusters | Convexe uniquement | Arbitraire |
| Gestion du bruit | Non (tous les points assignes) | Oui (label = -1) |
| Deterministe | Non (depend de l'initialisation) | Oui (pour noyaux/bruit) |
| Complexite | O(nkd) - rapide | O(n log n) - moderee |
| Ideal pour | Grandes donnees, K connu, clusters spheriques | Donnees spatiales, K inconnu, presence de bruit |

### B6. Regles d'association (Confiance, Lift)

**Apparait dans** : 2013, 2016, 2023

**Donne** : Itemsets frequents avec supports, on demande de calculer la confiance et le lift de regles specifiques.

**Formules** :
```
confidence(A -> B) = support(A union B) / support(A)
lift(A -> B) = confidence(A -> B) / support(B)
```

**Interpretation** :
- confiance = 0.8 signifie "80% des transactions contenant A contiennent aussi B"
- lift > 1 signifie "A et B apparaissent ensemble plus que prevu par le hasard"
- lift = 1 signifie "A et B sont independants"

### B7. Analyse formelle de concepts (Treillis de Concepts)

**Apparait dans** : 2023, 2024

**Donne** : Un diagramme de treillis de concepts, on demande d'identifier les extensions et intensions.

**Definitions** :
- **Extension** d'un concept : l'ensemble des objets (individus) du concept
- **Intension** d'un concept : l'ensemble des attributs (proprietes) partages par tous les objets de l'extension

**Strategie** : Suivre les lignes du treillis. L'extension est l'union des objets sous le noeud. L'intension est l'intersection des attributs au-dessus du noeud.

### B8. Itemsets fermes vs maximaux

**Apparait dans** : 2024

**Definitions** :
- **Itemset ferme** : Un itemset frequent X tel qu'aucun sur-ensemble propre de X n'a le meme support. De maniere equivalente, X = fermeture(X).
- **Itemset maximal** : Un itemset frequent X tel qu'aucun sur-ensemble propre de X n'est frequent.

**Difference cle** : 
> "Les motifs fermes conservent l'information de support (on peut retrouver le support de tout motif frequent a partir des motifs fermes). Les motifs maximaux ne conservent pas l'information de support mais sont moins nombreux. Les motifs fermes sont un compromis entre l'ensemble complet des motifs frequents (trop nombreux) et les motifs maximaux (perte d'information)."

### B9. Metriques de recherche d'information

**Apparait dans** : 2013

**Donne** : Une liste ordonnee de resultats de recherche avec des etiquettes de pertinence (P/N).

**Formules** :
```
Precision at k = |relevant in top k| / k
Recall at k = |relevant in top k| / |total relevant|
MAP = mean of precision values at each relevant document position
R-Precision = Precision at R (where R = total relevant documents)
```

### B10. Questions de fouille de texte / NLP

**Apparait dans** : 2013

**Racinisation (Stemming) vs Lemmatisation** :
- **Racinisation** : Troncature grossiere pour trouver la racine (porter → port). Rapide mais imprecis.
- **Lemmatisation** : Reduction basee sur un dictionnaire vers le lemme (mieux → bon). Precis mais plus lent.

**Impact sur la precision** : La racinisation peut diminuer la precision en confondant des mots differents ayant des racines similaires (ex. "universite" et "univers" ont la meme racine "univers").

---

## Partie C : Conseils specifiques par annee

### Examen 2025 (le plus recent)

- **Partie AD** : ACP sur un nouveau jeu de donnees. Attendre l'interpretation du cercle des correlations, le choix du nombre de composantes, les plans factoriels individus/variables.
- **Partie FD** : Clustering + fouille de motifs. Attendre le deroulement de DBSCAN, des questions de comparaison et Apriori.

### Examen 2023

- **Partie AD (6 pages)** : Exercice complet d'ACP avec pretraitement.
- **Partie FD (8 pages)** : Analyse formelle de concepts (treillis), Apriori et questions sur les tables de codes KRIMP.

### Examen 2024

- **Partie FD (10 pages)** : Treillis de concepts, itemsets fermes vs maximaux, construction FP-Tree, DBSCAN.

### Tendances historiques

Les examens sont remarquablement constants :
1. L'AD comporte toujours un exercice d'interpretation d'ACP (cercle des correlations + plan factoriel)
2. La FD comporte toujours un exercice de fouille d'itemsets (Apriori ou FP-Growth)
3. La FD comporte generalement un exercice de clustering (DBSCAN et/ou K-means)
4. Les examens recents (2023+) incluent des questions d'analyse formelle de concepts

## Checklist finale avant l'examen

### La veille
- [ ] Pratiquer la lecture d'un cercle des correlations d'une annale
- [ ] Derouler Apriori a la main sur un exemple a 5 transactions
- [ ] Derouler DBSCAN sur un exemple a 6 points
- [ ] Revoir les formules : support, confiance, lift, silhouette, cos^2, contribution
- [ ] Connaitre le tableau de comparaison : CAH vs K-means vs DBSCAN

### Pendant l'examen
- [ ] Lire TOUTES les questions d'abord (5 minutes)
- [ ] Commencer par les questions de calcul mecanique (Apriori, deroulement DBSCAN)
- [ ] Pour les questions d'interpretation : toujours lier les variables aux axes, puis les individus aux axes
- [ ] Montrer toutes les etapes de calcul -- le credit partiel est accorde
- [ ] Pour les questions "justifier" : donner la raison, pas seulement la reponse
- [ ] Verifier la variance cumulee lors du choix du nombre de composantes
