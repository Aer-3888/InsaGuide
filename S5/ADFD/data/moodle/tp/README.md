# Travaux Pratiques ADFD - Analyse de Données et Fouille de Données

## Vue d'ensemble

Ce dossier contient les solutions complètes et documentées des travaux pratiques du cours ADFD (Analyse de Données et Fouille de Données) de 3ème année Informatique à l'INSA Rennes.

## Structure

```
tp/
├── README.md                  # Ce fichier
├── tp1/                       # TP1: Analyse en Composantes Principales (ACP)
│   ├── README.md             # Documentation théorique et méthodologique
│   └── src/
│       └── pca_cities_analysis.py
├── tp2/                       # TP2: Classification Hiérarchique (CAH)
│   ├── README.md             # Documentation théorique et méthodologique
│   └── src/
│       └── hierarchical_clustering.py
├── tp3-4/                     # TP3-4: Détection de POI (clustering spatial)
│   ├── README.md             # Documentation théorique et méthodologique
│   └── src/
│       └── poi_detection_rennes.py
└── _originals/                # Sujets et fichiers originaux
```

## Contenu des TPs

### TP 1: Analyse en Composantes Principales (PCA/ACP)

**Objectif**: Réduire la dimensionnalité de données multivariées (températures mensuelles de villes françaises) et visualiser les structures sous-jacentes.

**Concepts clés**:
- Réduction de dimensionnalité
- Composantes principales
- Plan factoriel des individus et variables
- Cercle des corrélations
- Variance expliquée et qualité de représentation

**Technologies**: scikit-learn PCA, pandas, matplotlib, seaborn

**Résultats**:
- 2 composantes principales capturent 85-90% de la variance
- Axe 1: Gradient Nord-Sud (température moyenne)
- Axe 2: Gradient Est-Ouest (amplitude thermique)
- Identification de 3-4 groupes climatiques

### TP 2: Classification Hiérarchique Ascendante (CAH-MIXTE)

**Objectif**: Regrouper les villes en clusters homogènes basés sur les composantes principales de l'ACP.

**Concepts clés**:
- Classification Hiérarchique Ascendante (CAH)
- Méthode de Ward (minimisation de variance)
- Dendrogramme et coupure
- Paragons (individus représentatifs)
- Métriques d'évaluation (Silhouette, Davies-Bouldin)

**Technologies**: scipy hierarchy, sklearn metrics

**Résultats**:
- Optimal: 3 clusters sur 2 composantes principales
- Cluster 1: Climat continental (Centre/Nord)
- Cluster 2: Climat océanique (Ouest)
- Cluster 3: Climat méditerranéen (Sud)

### TP 3-4: Détection et Caractérisation de Points d'Intérêt (POI)

**Objectif**: Identifier les zones d'intérêt touristique de Rennes à partir de photos géolocalisées Flickr.

**Concepts clés**:
- Clustering spatial avec DBSCAN
- Gestion du bruit et outliers
- Projection cartographique (GPS → Lambert 93)
- Caractérisation sémantique (tags, wordcloud)
- Comparaison DBSCAN vs K-means

**Technologies**: DBSCAN, K-means, folium, pyproj, wordcloud

**Résultats**:
- 15-25 POI identifiés (Parlement, Thabor, Champs Libres, etc.)
- DBSCAN supérieur à K-means pour données spatiales avec bruit
- Caractérisation par densité, tags, temporalité

## Pipeline d'analyse type

### 1. Exploration des données
```python
import pandas as pd
df = pd.read_csv('data.csv')
df.info()
df.describe()
df.plot()
```

### 2. Prétraitement
```python
from sklearn.preprocessing import StandardScaler

# Nettoyage
df = df.dropna()
df = df.drop_duplicates()

# Standardisation (obligatoire pour ACP)
scaler = StandardScaler()
data_scaled = scaler.fit_transform(df)
```

### 3. Réduction de dimensionnalité (ACP)
```python
from sklearn.decomposition import PCA

pca = PCA(n_components=2)
principal_components = pca.fit_transform(data_scaled)

# Variance expliquée
print(pca.explained_variance_ratio_)
```

### 4. Clustering
```python
from sklearn.cluster import DBSCAN, KMeans
from scipy.cluster.hierarchy import linkage, dendrogram

# DBSCAN (spatial, avec bruit)
dbscan = DBSCAN(eps=100, min_samples=10)
labels_dbscan = dbscan.fit_predict(coords)

# K-means (partitionnement)
kmeans = KMeans(n_clusters=3)
labels_kmeans = kmeans.fit_predict(principal_components)

# CAH (hiérarchique)
linkage_matrix = linkage(principal_components, method='ward')
```

### 5. Évaluation
```python
from sklearn.metrics import silhouette_score, davies_bouldin_score

silhouette = silhouette_score(data, labels)
davies_bouldin = davies_bouldin_score(data, labels)
```

### 6. Visualisation
```python
import matplotlib.pyplot as plt
import seaborn as sns

# Plan factoriel
plt.scatter(principal_components[:, 0], principal_components[:, 1], c=labels)

# Dendrogramme
dendrogram(linkage_matrix, labels=names)

# Carte interactive
import folium
m = folium.Map(location=[48.117, -1.678])
```

## Méthodes comparées

| Méthode | Usage optimal | Avantages | Inconvénients |
|---------|---------------|-----------|---------------|
| **ACP** | Réduction de dimensionnalité | Visualisation 2D, corrélations | Linéaire, perd info non-linéaire |
| **CAH (Ward)** | Clustering hiérarchique | Dendrogramme, pas de k fixé | O(n³), sensible aux outliers |
| **K-means** | Clustering rapide | Scalable, simple | k fixé, clusters sphériques |
| **DBSCAN** | Clustering spatial avec bruit | Formes arbitraires, détecte outliers | Paramètres difficiles |

## Métriques d'évaluation

### Silhouette Score
```
Score ∈ [-1, 1]
- Proche de 1: Bien séparé
- Proche de 0: Chevauchement
- Négatif: Mal assigné
```

### Davies-Bouldin Index
```
Score ≥ 0
- Plus faible = meilleur
- Mesure ratio dispersion/séparation
```

### Inertie (WCSS)
```
Within-Cluster Sum of Squares
- Plus faible = clusters compacts
- Utilisé pour méthode du coude
```

## Bibliothèques Python essentielles

```python
# Manipulation de données
import pandas as pd
import numpy as np

# Visualisation
import matplotlib.pyplot as plt
import seaborn as sns

# Machine Learning
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import DBSCAN, KMeans
from sklearn.metrics import silhouette_score, davies_bouldin_score

# Classification hiérarchique
from scipy.cluster.hierarchy import dendrogram, linkage, fcluster

# Cartographie
import folium
from folium.plugins import HeatMap

# Projection géographique
from pyproj import Transformer

# Analyse de texte
from wordcloud import WordCloud
from collections import Counter
```

## Installation des dépendances

```bash
# Environnement virtuel (recommandé)
python -m venv venv
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows

# Installation
pip install pandas numpy matplotlib seaborn
pip install scikit-learn scipy
pip install folium pyproj
pip install wordcloud
pip install jupyter notebook  # Pour les notebooks
```

## Exécution des scripts

### TP1: ACP
```bash
cd tp1/src
python pca_cities_analysis.py
```

Génère:
- `correlation_matrix.png`: Matrice de corrélation
- `scree_plot.png`: Variance expliquée par composante
- `pca_individuals.png`: Plan factoriel des villes
- `pca_variables.png`: Cercle des corrélations
- `pca_biplot.png`: Biplot combiné
- `dendrogram.png`: Dendrogramme CAH
- `clusters_N.png`: Visualisation des N clusters

### TP2: Classification Hiérarchique
```bash
cd tp2/src
python hierarchical_clustering.py
```

Génère:
- `comparison_linkage_methods.png`: Comparaison Ward/Complete/Average/Single
- `elbow_curve.png`: Courbe du coude (nombre optimal de clusters)
- `dendrogram_ward.png`: Dendrogramme avec méthode Ward
- `clusters_pca_N.png`: Clusters sur plan factoriel
- `poi_stats_dbscan.csv`: Statistiques par cluster

### TP3-4: Détection de POI
```bash
cd tp3-4/src
python poi_detection_rennes.py
```

Génère:
- `spatial_distribution.png`: Distribution spatiale et heatmap
- `k_distance_graph.png`: Graphe pour déterminer eps
- `comparison_dbscan_kmeans.png`: Comparaison des méthodes
- `poi_map_dbscan.png`: Carte des POI DBSCAN
- `poi_map_kmeans.png`: Carte des POI K-means
- `poi_stats_dbscan.csv`: Caractéristiques des POI

## Concepts théoriques clés

### 1. Analyse en Composantes Principales (ACP)

**Objectif**: Trouver les directions de variance maximale dans les données

**Mathématiques**:
```
X_centré = X - mean(X)
Covariance = X_centré^T · X_centré / (n-1)
Valeurs propres λ et vecteurs propres v: Cov · v = λ · v
Composantes principales = X_centré · v
```

**Interprétation**:
- Vecteurs propres = nouvelles directions (axes factoriels)
- Valeurs propres = variance selon chaque direction
- Composantes principales = projection des données sur nouvelles directions

### 2. Classification Hiérarchique Ascendante (CAH)

**Critère de Ward**:
```
Minimise l'augmentation de variance intra-cluster à chaque fusion
Δ(A,B) = (n_A * n_B) / (n_A + n_B) * ||center_A - center_B||²
```

**Dendrogramme**:
- Hauteur = distance/dissimilarité au moment de la fusion
- Coupure horizontale = choix du nombre de clusters
- Sauts importants = nombre naturel de clusters

### 3. DBSCAN

**Algorithme**:
```
1. Marquer tous les points comme non visités
2. Pour chaque point p non visité:
   a. Marquer p comme visité
   b. N = voisins de p dans rayon eps
   c. Si |N| < min_samples:
      - Marquer p comme bruit
   d. Sinon:
      - Créer nouveau cluster C
      - Ajouter p à C
      - Pour chaque point q dans N:
        - Si q non visité:
          - Marquer q comme visité
          - N' = voisins de q dans rayon eps
          - Si |N'| ≥ min_samples:
            - Ajouter N' à N
        - Si q n'appartient à aucun cluster:
          - Ajouter q à C
```

**Paramètres**:
- **eps**: Distance maximale entre deux points du même cluster
- **min_samples**: Nombre minimum de points pour former un cluster dense

## Applications pratiques

### Marketing et Business
- Segmentation de clients (RFM: Recency, Frequency, Monetary)
- Ciblage publicitaire géographique
- Analyse de panier d'achat (association rules)

### Biologie et Santé
- Classification d'espèces (taxonomie)
- Analyse de profils génétiques
- Groupes de patients à risque
- Découverte de biomarqueurs

### Géographie et Urbanisme
- Zonage climatique
- Planification urbaine (POI, zones de chalandise)
- Analyse de mobilité
- Détection de hotspots (criminalité, accidents)

### Finance
- Regroupement d'actifs similaires (portfolio management)
- Détection de fraude (outliers)
- Segmentation de risque crédit

### Informatique
- Compression d'images (k-means sur pixels)
- Recommandation de contenu
- Détection d'anomalies réseaux
- Classification de documents

## Ressources complémentaires

### Documentation officielle
- Scikit-learn: https://scikit-learn.org/stable/
- Scipy: https://docs.scipy.org/doc/scipy/
- Pandas: https://pandas.pydata.org/docs/
- Matplotlib: https://matplotlib.org/stable/contents.html

### Tutoriels
- ACP: https://scikit-learn.org/stable/modules/decomposition.html#pca
- DBSCAN: https://scikit-learn.org/stable/modules/clustering.html#dbscan
- Hierarchical clustering: https://docs.scipy.org/doc/scipy/reference/cluster.hierarchy.html

### Livres recommandés
- "The Elements of Statistical Learning" - Hastie, Tibshirani, Friedman
- "Pattern Recognition and Machine Learning" - Christopher Bishop
- "Data Mining: Concepts and Techniques" - Han, Kamber, Pei

### Cours en ligne
- Coursera: "Machine Learning" - Andrew Ng
- edX: "Data Science: Machine Learning"
- Fast.ai: "Practical Deep Learning"

## Conseils pour les examens

### Questions fréquentes

1. **Quand utiliser ACP normée vs ACP non normée?**
   - Normée: Variables d'échelles différentes (obligatoire si unités différentes)
   - Non normée: Variables homogènes et comparables

2. **Comment choisir le nombre de composantes principales?**
   - Règle des 80%: Conserver les composantes totalisant ≥80% de variance
   - Règle de Kaiser: Conserver les composantes avec λ > 1
   - Scree plot: Chercher le "coude"

3. **DBSCAN ou K-means?**
   - DBSCAN: Données spatiales, formes arbitraires, présence de bruit
   - K-means: Grand volume, k connu, clusters sphériques

4. **Comment interpréter un dendrogramme?**
   - Hauteur = dissimilarité
   - Sauts importants = nombre naturel de clusters
   - Coupure horizontale = partitionnement

5. **Que signifie un Silhouette score de 0.3?**
   - Clusters moyennement séparés (0.25-0.5)
   - Pas mauvais mais pas excellent
   - Peut indiquer chevauchement ou mauvais k

### Checklist avant examen

- [ ] Comprendre les différences ACP vs AFD (Analyse Factorielle Discriminante)
- [ ] Savoir interpréter cercle des corrélations et plan factoriel
- [ ] Connaître les critères de liaison (Ward, Complete, Average, Single)
- [ ] Maîtriser les métriques (Silhouette, Davies-Bouldin, Inertie)
- [ ] Savoir choisir eps et min_samples pour DBSCAN
- [ ] Comprendre la différence clustering vs classification
- [ ] Connaître les limites de chaque méthode

## Améliorations possibles

### Techniques avancées
1. **t-SNE**: Visualisation non-linéaire (meilleure que ACP pour structures complexes)
2. **UMAP**: Alternative à t-SNE, plus rapide et préserve mieux la structure globale
3. **HDBSCAN**: Extension de DBSCAN pour densités variables
4. **Gaussian Mixture Models**: Clustering probabiliste
5. **Spectral Clustering**: Pour clusters non-convexes

### Feature engineering
1. Extraction de features temporelles (jour, heure, saison)
2. Création de ratios et combinaisons de variables
3. Encoding de variables catégorielles (one-hot, target encoding)
4. Normalisation adaptée (StandardScaler, MinMaxScaler, RobustScaler)

### Validation
1. Cross-validation pour stabilité des clusters
2. Bootstrap pour intervalle de confiance
3. Comparaison avec données de référence (ground truth)
4. Tests statistiques (ANOVA, chi-carré) pour validation

## Auteurs et contributions

Ces solutions ont été développées pour les étudiants de 3INFO INSA Rennes dans le cadre du cours ADFD.

Les scripts sont conçus pour être:
- **Pédagogiques**: Commentaires détaillés et noms de variables explicites
- **Modulaires**: Fonctions réutilisables et classes bien structurées
- **Reproductibles**: Données d'exemple incluses
- **Extensibles**: Facilement adaptables à d'autres jeux de données

## Licence

Ces ressources sont destinées à un usage éducatif dans le cadre du cours ADFD à l'INSA Rennes.
