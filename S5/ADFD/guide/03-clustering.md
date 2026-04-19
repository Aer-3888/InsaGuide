# Chapitre 3 : Methodes de classification non supervisee

## Presentation

Le clustering est la tache consistant a regrouper un ensemble d'objets de sorte que les objets d'un meme groupe (cluster) soient plus similaires entre eux qu'avec les objets des autres groupes. Ce chapitre couvre les trois methodes etudiees dans le cours : **CAH (Classification Ascendante Hierarchique)**, **K-means** et **DBSCAN**.

## 1. Classification Ascendante Hierarchique (CAH)

### Algorithme

La CAH construit une hierarchie de clusters en fusionnant successivement les deux clusters les plus proches.

```
1. Start: each individual is its own cluster (n clusters)
2. Compute distance between all pairs of clusters
3. Merge the two closest clusters
4. Recompute distances
5. Repeat steps 3-4 until only one cluster remains
6. Cut the dendrogram at the desired level
```

### Criteres de liaison

La decision cle est comment definir la "distance" entre deux clusters :

| Critere | Formule | Proprietes |
|---------|---------|------------|
| **Ward** | Minimise l'augmentation de la variance intra-cluster totale | Ideal pour les donnees continues, forme des clusters compacts de taille similaire |
| **Lien complet** | Distance maximale entre deux points des deux clusters | Forme des clusters compacts, sensible aux valeurs aberrantes |
| **Lien moyen** | Moyenne de toutes les distances deux a deux | Compromis entre lien simple et complet |
| **Lien simple** | Distance minimale entre deux points | Trouve des clusters allonges, souffre de l'"effet de chaine" |

**Critere de Ward** (celui utilise dans ce cours) :

```
Delta(A, B) = (n_A * n_B) / (n_A + n_B) * ||center_A - center_B||^2
```

Ceci mesure l'augmentation de la variance intra-cluster totale lors de la fusion des clusters A et B.

### Le dendrogramme

Visualisation arborescente du processus de fusion :
- **Axe X** : Etiquettes des individus
- **Axe Y** : Distance/dissimilarite a laquelle les fusions ont lieu
- **Hauteur de fusion** : Plus la hauteur est grande, plus les clusters fusionnes sont dissimilaires

**Lecture d'un dendrogramme** :
1. Les grands sauts verticaux indiquent des frontieres naturelles de clusters
2. Une coupe horizontale a tout niveau produit une partition
3. Le "bon" nombre de clusters correspond aux sauts significatifs

```python
from scipy.cluster.hierarchy import dendrogram, linkage, fcluster

# Compute linkage
Z = linkage(X, method='ward')

# Plot dendrogram
dendrogram(Z, labels=names, leaf_font_size=10)
plt.title('Dendrogramme - Methode de Ward')
plt.xlabel('Individus')
plt.ylabel('Distance')

# Cut to get n clusters
clusters = fcluster(Z, t=3, criterion='maxclust')
```

### Methode CAH-MIXTE (TP2)

C'est la methode enseignee dans le cours : combiner ACP + CAH.

```
1. Run PCA on standardized data
2. Keep first k principal components (80-90% variance)
3. Apply CAH with Ward criterion on PC coordinates
4. Choose number of clusters from dendrogram
5. Identify paragons and interpret clusters
```

### Parangons

Un **parangon** est l'individu le plus proche du centre de gravite (barycentre) de son cluster -- le membre le plus representatif.

```python
from scipy.spatial.distance import cdist

for cluster_id in unique_clusters:
    cluster_points = X_pca[labels == cluster_id]
    centroid = cluster_points.mean(axis=0)
    distances = cdist(cluster_points, [centroid]).flatten()
    paragon_idx = np.argmin(distances)
    print(f"Cluster {cluster_id} paragon: {names[paragon_idx]}")
```

### Resultats du TP2 (Villes francaises)

**Classification optimale** : 3 clusters sur 2 composantes principales

| Cluster | Type de climat | Villes | Parangon |
|---------|---------------|--------|----------|
| 1 | Continental (Centre/Nord) | Strasbourg, Lille, Grenoble, Lyon, Vichy, Clermont-Ferrand, Paris | Vichy |
| 2 | Oceanique (Ouest) | Brest, Rennes, Nantes | Rennes |
| 3 | Mediterraneen (Sud) | Nice, Marseille, Montpellier, Toulouse, Bordeaux | Toulouse |

## 2. K-Means

### Algorithme

K-means partitionne les donnees en K clusters en minimisant la variance intra-cluster (inertie intra-classe).

```
1. Choose K (number of clusters)
2. Initialize K centroids randomly
3. Assign each point to the nearest centroid
4. Recompute centroids as the mean of assigned points
5. Repeat steps 3-4 until convergence (assignments don't change)
```

### Proprietes cles

| Propriete | Detail |
|-----------|--------|
| **Complexite** | O(n * k * d * iterations) -- rapide, lineaire |
| **Forme des clusters** | Toujours convexe (spherique/ellipsoidal) |
| **Necessite** | K doit etre specifie a l'avance |
| **Sensibilite** | Sensible a l'initialisation et aux valeurs aberrantes |
| **Determinisme** | Differentes executions peuvent donner des resultats differents |

### Choix de K

**Methode du coude** :
```python
inertias = []
for k in range(2, 11):
    kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
    kmeans.fit(X)
    inertias.append(kmeans.inertia_)

plt.plot(range(2, 11), inertias, 'o-')
plt.xlabel('Number of clusters K')
plt.ylabel('Inertia (WCSS)')
plt.title('Elbow Method')
```

Chercher le "coude" ou le taux de decroissance ralentit.

### Implementation

```python
from sklearn.cluster import KMeans

kmeans = KMeans(n_clusters=3, random_state=42, n_init=10)
labels = kmeans.fit_predict(X)

# Cluster centers
centers = kmeans.cluster_centers_

# Inertia (within-cluster sum of squares)
inertia = kmeans.inertia_
```

## 3. DBSCAN

### Algorithme (Density-Based Spatial Clustering of Applications with Noise)

DBSCAN trouve des clusters comme des regions de forte densite de points separees par des regions de faible densite.

**Parametres** :
- **eps (epsilon)** : Distance maximale entre deux points pour etre consideres comme voisins
- **min_samples (minPts)** : Nombre minimum de points pour former une region dense (point noyau)

**Types de points** :
| Type | Definition |
|------|-----------|
| **Point noyau** (core point) | A >= min_samples voisins dans le rayon eps |
| **Point frontiere** (border point) | Dans le rayon eps d'un point noyau, mais &lt; min_samples propres voisins |
| **Bruit** (noise) | Ni noyau ni frontiere -- label = -1 |

### Algorithme etape par etape

```
For each unvisited point p:
    1. Mark p as visited
    2. Find all neighbors N within eps radius
    3. If |N| < min_samples:
       - Mark p as noise (may be reassigned later)
    4. Else:
       - Create new cluster C
       - Add p to C
       - For each point q in N:
         - If q is unvisited:
           - Mark q as visited
           - Find q's neighbors N'
           - If |N'| >= min_samples: add N' to N
         - If q is not in any cluster: add q to C
```

### Choix des parametres

**eps** : Utiliser le graphe des k-distances :
1. For each point, compute distance to its k-th nearest neighbor (k = min_samples - 1)
2. Sort distances and plot
3. Choose eps at the "elbow" of the curve

```python
from sklearn.neighbors import NearestNeighbors

neighbors = NearestNeighbors(n_neighbors=5)
neighbors.fit(coords)
distances, _ = neighbors.kneighbors(coords)
k_distances = np.sort(distances[:, -1])

plt.plot(k_distances)
plt.xlabel('Points (sorted)')
plt.ylabel('5th neighbor distance')
plt.title('K-Distance Graph')
```

**min_samples** : Regle empirique : 2 * dimensions, ou specifique au domaine (ex. 7-10 pour des donnees spatiales de photos).

### Implementation

```python
from sklearn.cluster import DBSCAN

dbscan = DBSCAN(eps=0.00030, min_samples=7)
labels = dbscan.fit_predict(coords)

# Number of clusters (excluding noise)
n_clusters = len(set(labels)) - (1 if -1 in labels else 0)

# Number of noise points
n_noise = list(labels).count(-1)
```

### Proprietes cles

| Propriete | Detail |
|-----------|--------|
| **Complexite** | O(n * log n) avec index spatial, O(n^2) sans |
| **Forme des clusters** | Arbitraire -- toute forme y compris concave |
| **Necessite** | eps et min_samples (mais PAS K) |
| **Gestion du bruit** | Oui -- points de bruit etiquetes -1 |
| **Determinisme** | Deterministe pour les points noyaux et le bruit (les points frontieres peuvent varier) |

## 4. Comparaison : CAH vs K-means vs DBSCAN

| Caracteristique | CAH (Ward) | K-means | DBSCAN |
|----------------|-----------|---------|--------|
| **Parametre d'entree** | Aucun (coupe du dendrogramme) | K (nombre de clusters) | eps, min_samples |
| **Forme des clusters** | Compacts, spheriques | Convexes, spheriques | Arbitraire |
| **Gestion du bruit** | Non | Non | Oui |
| **Passage a l'echelle** | O(n^3) -- petites donnees uniquement | O(n) -- tres scalable | O(n log n) -- moyen |
| **Hierarchique** | Oui (dendrogramme) | Non | Non |
| **Deterministe** | Oui | Non (depend de l'initialisation) | Quasiment oui |
| **Ideal pour** | Petites donnees, structure hierarchique | Grandes donnees, K connu | Donnees spatiales avec bruit |

### Quand utiliser quoi

- **CAH** : Petits jeux de donnees (&lt;1000 points), on veut explorer differents nombres de clusters, les donnees ont une structure hierarchique. Utilise dans TP1/TP2.
- **K-means** : Grands jeux de donnees, clusters approximativement spheriques, K est connu ou estimable. Bon comme reference de base.
- **DBSCAN** : Donnees spatiales/geographiques, clusters de formes variees, presence de bruit/valeurs aberrantes. Utilise dans TP3-4.

## 5. Metriques d'evaluation

### Score de silhouette

Mesure a quel point un objet est similaire a son propre cluster par rapport aux autres clusters.

Pour chaque point i :
```
a(i) = mean distance to other points in same cluster (cohesion)
b(i) = mean distance to points in nearest other cluster (separation)
s(i) = (b(i) - a(i)) / max(a(i), b(i))
```

| Plage de score | Interpretation |
|---------------|----------------|
| s proche de 1 | Point bien assigne |
| s proche de 0 | Point a la frontiere entre clusters |
| s &lt; 0 | Point probablement mal assigne |
| Moyenne > 0.5 | Bon clustering |
| Moyenne 0.25-0.5 | Clustering moyen |
| Moyenne &lt; 0.25 | Mauvais clustering |

```python
from sklearn.metrics import silhouette_score
score = silhouette_score(X, labels)
```

### Indice de Davies-Bouldin

Rapport entre la dispersion intra-cluster et la separation inter-cluster.

```
DB = (1/K) * sum_i max_{j!=i} (sigma_i + sigma_j) / d(c_i, c_j)
```

- **Plus bas = meilleur** (minimum = 0)
- Ne necessite pas de verite terrain

```python
from sklearn.metrics import davies_bouldin_score
score = davies_bouldin_score(X, labels)
```

### Inertie / WCSS (Inertie Intra-Classe)

Somme des carres intra-cluster : somme des distances au carre de chaque point a son centre de cluster.

```
WCSS = sum_k sum_{i in C_k} ||x_i - center_k||^2
```

- **Plus bas = meilleur** pour un K fixe
- Decroit toujours quand K augmente -- utiliser la methode du coude

```python
# For K-means
inertia = kmeans.inertia_

# Manual calculation
inertia = 0
for k in unique_clusters:
    cluster_points = X[labels == k]
    center = cluster_points.mean(axis=0)
    inertia += np.sum((cluster_points - center) ** 2)
```

## 6. Considerations pour le clustering spatial (TP3-4)

### Conversion GPS vers coordonnees cartesiennes

DBSCAN utilise la distance euclidienne, mais les coordonnees GPS ne sont pas en metres. Deux approches sont utilisees dans le cours :

**Approche 1 (utilisee dans le notebook du TP)** : Appliquer DBSCAN directement sur les coordonnees GPS brutes avec un eps tres petit (ex. 0.00030 degres). C'est une approximation qui fonctionne pour de petites regions mais n'est pas metriquement precise.

**Approche 2 (utilisee dans le code source du TP)** : Convertir d'abord les GPS en coordonnees cartesiennes approximatives :
```python
# 1 degree latitude ~ 111 km
# 1 degree longitude ~ 71 km (at 48 degrees N, cos(48) ~ 0.67)
df['x'] = (df['longitude'] + 1.7) * 71000   # meters
df['y'] = (df['latitude'] - 48.0) * 111000   # meters
```

**Methode propre** (Lambert 93) :
```python
from pyproj import Transformer
transformer = Transformer.from_crs("EPSG:4326", "EPSG:2154")
x, y = transformer.transform(lat, lon)
```

### Effet "Album Photo"

Un seul utilisateur prenant de nombreuses photos au meme endroit gonfle la densite sans indiquer un veritable interet. Solution :

```python
# Keep only one photo per user per hour
photos = photos.groupby(
    ['id_photographer', 'date_taken_year', 'date_taken_month',
     'date_taken_day', 'date_taken_hour'],
    as_index=False
).first()
```

Cela reduit le jeu de donnees Flickr de 29 541 lignes a ~1 232.

## Pieges courants

1. **Utiliser DBSCAN sur des coordonnees GPS brutes** : Toujours convertir en metres d'abord.
2. **Oublier de retirer le bruit pour calculer les metriques** : Filtrer label=-1 avant silhouette_score.
3. **Comparer K-means avec differentes valeurs de K en utilisant l'inertie** : L'inertie decroit toujours avec K -- comparer avec la silhouette plutot.
4. **Utiliser la CAH sur de grands jeux de donnees** : Le lien de Ward est O(n^3) -- impraticable pour >5000 points.
5. **Choisir eps par essai-erreur** : Utiliser le graphe des k-distances pour un choix raisonne.
6. **Ne pas standardiser avant la CAH** : Si les variables ont des echelles differentes, standardiser d'abord (ou utiliser les coordonnees ACP).

---

## AIDE-MEMOIRE

### Comparaison rapide des algorithmes

```
Besoin d'une structure hierarchique ?     --> CAH
Grand jeu de donnees, K connu ?           --> K-means
Donnees spatiales avec bruit ?            --> DBSCAN
Nombre de clusters inconnu ?              --> DBSCAN ou CAH
Clusters de forme arbitraire ?            --> DBSCAN
```

### Modeles de code

**CAH**:
```python
from scipy.cluster.hierarchy import linkage, fcluster, dendrogram
Z = linkage(X, method='ward')
labels = fcluster(Z, t=3, criterion='maxclust')
dendrogram(Z, labels=names)
```

**K-means**:
```python
from sklearn.cluster import KMeans
km = KMeans(n_clusters=3, random_state=42, n_init=10)
labels = km.fit_predict(X)
```

**DBSCAN**:
```python
from sklearn.cluster import DBSCAN
db = DBSCAN(eps=100, min_samples=10)
labels = db.fit_predict(coords)
```

### Reference rapide des metriques

| Metrique | Bonne valeur | Python |
|----------|-------------|--------|
| Silhouette | > 0.5 | `silhouette_score(X, labels)` |
| Davies-Bouldin | &lt; 1.0 | `davies_bouldin_score(X, labels)` |
| WCSS / Inertie | Methode du coude | `kmeans.inertia_` |

### Termes cles (Francais/Anglais)

| Francais | Anglais |
|----------|---------|
| Classification ascendante hierarchique (CAH) | Hierarchical Agglomerative Clustering |
| Dendrogramme | Dendrogram |
| Critere de Ward | Ward's criterion |
| Inertie intra-classe | Within-cluster inertia (WCSS) |
| Inertie inter-classe | Between-cluster inertia |
| Parangon | Paragon (individu le plus representatif) |
| Barycentre | Centroid / Centre de gravite |
| Point noyau | Core point (DBSCAN) |
| Point frontiere | Border point (DBSCAN) |
| Bruit | Noise |
| Score de silhouette | Silhouette score |
