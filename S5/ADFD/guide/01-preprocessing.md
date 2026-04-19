# Chapitre 1 : Pretraitement des donnees

## Presentation

Le pretraitement des donnees est la premiere etape, et la plus critique, dans tout pipeline d'analyse ou de fouille de donnees. Les donnees reelles ne sont presque jamais propres -- elles contiennent des valeurs manquantes, des valeurs aberrantes, des incoherences et des biais. La qualite de votre analyse depend entierement de la qualite du pretraitement.

## 1. Le pipeline d'analyse de donnees

```
Donnees brutes --> Pretraitement --> Analyse (ACP, Clustering) --> Interpretation --> Connaissances
```

L'etape de pretraitement comprend :
1. Comprendre les donnees (types, distributions, dimensions)
2. Traiter les valeurs manquantes
3. Detecter et traiter les valeurs aberrantes (points aberrants)
4. Transformer les variables (normalisation, transformations log, encodage)
5. Selectionner ou extraire les variables pertinentes (reduction de dimension)

## 2. Types de variables

| Type | Exemples | Operations |
|------|----------|------------|
| **Quantitative continue** | Temperature, taille, prix | Moyenne, ecart-type, correlation |
| **Quantitative discrete** | Nombre de pieces, comptage | Mode, frequence |
| **Qualitative ordinale** | Note de qualite (1-10), niveau d'etudes | Mediane, rang |
| **Qualitative nominale** | Couleur, ville, genre | Mode, frequence |

**Point cle pour les examens** : Les variables codees en entiers (ex. OverallQual = 1-10) peuvent etre categorielles (qualitatives) et non numeriques. Toujours verifier la semantique, pas seulement le dtype.

## 3. Valeurs manquantes

### Detection

```python
# Count missing values per column
df.isnull().sum()

# Percentage of missing values
(df.isnull().sum() / len(df)) * 100

# Visualize missing patterns
import seaborn as sns
sns.heatmap(df.isnull(), cbar=True)
```

### Strategies de traitement

| Strategie | Quand l'utiliser | Code |
|-----------|-----------------|------|
| **Suppression des lignes** | Tres peu de valeurs manquantes (&lt;5%) | `df.dropna()` |
| **Suppression des colonnes** | Colonne avec >50% de valeurs manquantes | `df.drop(columns=[...])` |
| **Imputation par la moyenne** | Variable numerique, distribution symetrique | `SimpleImputer(strategy="mean")` |
| **Imputation par la mediane** | Variable numerique, distribution asymetrique | `SimpleImputer(strategy="median")` |
| **Imputation par le mode** | Variables categorielles | `SimpleImputer(strategy="most_frequent")` |
| **Imputation par constante** | Logique metier specifique | `SimpleImputer(strategy="constant", fill_value=0)` |

### Exemple pratique (TP1)

Le jeu de donnees House Prices contient 81 variables. L'analyse des valeurs manquantes revele :

```
PoolQC         99.5%   --> Supprimer (trop de valeurs manquantes)
MiscFeature    96.3%   --> Supprimer
Alley          93.8%   --> Supprimer
Fence          80.8%   --> Supprimer
MasVnrType     59.7%   --> Examiner le contexte
LotFrontage    17.7%   --> Imputer par la mediane
GarageYrBlt     5.5%   --> Imputer par la mediane
MasVnrArea      0.55%  --> Imputer par la mediane (seulement 8 valeurs)
```

**Regle de decision** : Si une colonne a >50% de valeurs manquantes, elle porte peu d'information -- la supprimer est generalement la meilleure option. Pour les colonnes numeriques avec &lt;20% de valeurs manquantes, l'imputation par la mediane est l'approche standard.

```python
from sklearn.impute import SimpleImputer

imputer = SimpleImputer(strategy="median")
df_imputed = pd.DataFrame(
    imputer.fit_transform(df_num),
    columns=df_num.columns,
    index=df_num.index
)
```

## 4. Valeurs aberrantes (Points Aberrants)

### Methodes de detection

**1. Basee sur les percentiles (utilisee dans le cours)** :
```python
q99 = df.quantile(0.99)
mask = (df <= q99).all(axis=1)
df_clean = df[mask]
```

**2. IQR (Ecart interquartile)** :
```python
Q1 = df.quantile(0.25)
Q3 = df.quantile(0.75)
IQR = Q3 - Q1
lower = Q1 - 1.5 * IQR
upper = Q3 + 1.5 * IQR
mask = ((df >= lower) & (df <= upper)).all(axis=1)
```

**3. Z-score** : Les points avec |z| > 3 sont consideres comme aberrants.
```python
from scipy import stats
z_scores = np.abs(stats.zscore(df))
mask = (z_scores < 3).all(axis=1)
```

### Traitement

- **Suppression** : Quand les valeurs aberrantes sont des erreurs ou du bruit extreme
- **Plafonnement** (winsorization) : Remplacer les valeurs extremes par la borne du percentile
- **Transformation log** : Reduit l'impact des valeurs extremes

### Exemple pratique (TP1)

Avant suppression des valeurs aberrantes : 1460 observations
Apres suppression au 99e percentile : 1326 observations (~9% supprimees)

Impact sur la regression lineaire :
- RMSE sans nettoyage : ~39 280$
- RMSE avec nettoyage : ~32 393$
- **Amelioration : reduction de ~6 888$ de l'erreur de prediction**

## 5. Transformations de variables

### Standardisation (Centrage-Reduction)

**Indispensable pour l'ACP.** Centre les donnees a moyenne=0 et reduit a ecart-type=1.

Formule : `z = (x - moyenne) / ecart-type`

```python
from sklearn.preprocessing import StandardScaler

scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)
```

**Quand l'utiliser** : Toujours avant l'ACP (ACP normee) et quand les variables ont des unites ou des echelles differentes.

### Transformation logarithmique

Utilisee pour les distributions asymetriques a droite (beaucoup de petites valeurs, peu de grandes valeurs).

```python
# log1p = log(1 + x), handles zeros
df_log = np.log1p(df[cols_to_log])
```

**Cas d'usage courant** : Variables de surface (LotArea, GarageArea), variables de prix, donnees de comptage.

**Piege** : Les variables avec beaucoup de zeros (comme WoodDeckSF ou 52% des valeurs sont 0) auront un pic en log(1) = 0 apres transformation. C'est normal mais doit etre note.

### Encodage des variables categorielles

| Methode | Cas d'usage | Exemple |
|---------|------------|---------|
| **One-hot encoding** | Variables nominales avec peu de categories | `pd.get_dummies(df, columns=['Color'])` |
| **Label encoding** | Variables ordinales | `LabelEncoder().fit_transform(df['Quality'])` |
| **Target encoding** | Categorielle a haute cardinalite avec cible | Moyenne de la cible par categorie |

## 6. Selection de variables

Le cours presente quatre familles de methodes :

### Methodes a base de filtres
- Independantes de l'algorithme d'apprentissage
- Rapides mais performance moderee
- Exemples : **Seuil de variance**, **Filtre de correlation**, **Information mutuelle**

### Methodes enveloppantes (Wrapper)
- Dependent du modele d'apprentissage
- Couteuses mais bonne performance
- Exemples : **Selection forward**, **Elimination backward**, **Recherche exhaustive**

### Methodes integrees (Embedded)
- La selection se fait pendant l'apprentissage
- Compromis entre vitesse et performance
- Exemples : **Selection par arbres de decision**, **Lasso**, **Ridge**, **Elastic Net**

### Methodes hybrides
- Combinent filtre + wrapper ou filtre + embedded
- Exemples : **Importance par permutation**, **Elimination recursive de variables (RFE)**

## 7. Extraction de variables

Au lieu de selectionner des variables existantes, on cree de nouvelles variables qui resument les donnees :

| Methode | Description | Cas d'usage |
|---------|-------------|------------|
| **ACP** | Projection lineaire maximisant la variance | Usage general, donnees continues |
| **t-SNE** | Plongement non lineaire pour la visualisation | Visualisation de donnees de haute dimension |

L'ACP est detaillee dans le [Chapitre 2](02-pca.md).

## Pieges courants

1. **Imputer avant de separer train/test** : L'imputation doit etre ajustee sur les donnees d'entrainement uniquement, puis appliquee aux donnees de test pour eviter la fuite de donnees.
2. **Oublier de standardiser avant l'ACP** : L'ACP sur des donnees non standardisees sera dominee par les variables ayant les plus grandes echelles.
3. **Supprimer trop de lignes** : Si la suppression des NaN enleve >10% des donnees, privilegier l'imputation.
4. **Traiter des variables categorielles codees en entiers comme numeriques** : Toujours verifier la semantique des variables.
5. **Appliquer une transformation log a des valeurs nulles ou negatives** : Utiliser `log1p` (log(1+x)) pour les donnees contenant des zeros.

---

## AIDE-MEMOIRE

### Valeurs manquantes -- Reference rapide

| Situation | Action |
|-----------|--------|
| Colonne >50% manquante | Supprimer la colonne |
| Numerique, &lt;20% manquant | Imputer par la mediane |
| Categorielle, &lt;20% manquant | Imputer par le mode |
| Peu de lignes concernees (&lt;5%) | Supprimer les lignes |
| Schema structure | Investiguer la cause d'abord |

### Formules cles

| Transformation | Formule | Python |
|---------------|---------|--------|
| Standardisation | z = (x - mu) / sigma | `StandardScaler()` |
| Min-Max | x' = (x - min) / (max - min) | `MinMaxScaler()` |
| Log | x' = log(1 + x) | `np.log1p(x)` |
| Valeur aberrante (Z-score) | \|z\| > 3 = aberrante | `stats.zscore(x)` |
| Valeur aberrante (IQR) | x &lt; Q1 - 1.5*IQR ou x > Q3 + 1.5*IQR | Calcul manuel |

### Pipeline de pretraitement

```python
# 1. Load
df = pd.read_csv("data.csv")

# 2. Explore
df.info()
df.describe()
df.isnull().sum()

# 3. Handle missing values
imputer = SimpleImputer(strategy="median")
df_imputed = imputer.fit_transform(df_num)

# 4. Remove outliers
q99 = df.quantile(0.99)
df_clean = df[(df <= q99).all(axis=1)]

# 5. Transform skewed variables
df_clean[cols] = np.log1p(df_clean[cols])

# 6. Standardize (for PCA)
scaler = StandardScaler()
X_scaled = scaler.fit_transform(df_clean)
```
