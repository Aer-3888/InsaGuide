# Chapitre 5 : Pandas et manipulation de donnees

## Presentation

Pandas est la bibliotheque Python utilisee tout au long du cours ADFD pour le chargement, l'exploration, le nettoyage et la transformation des donnees. La maitrise de Pandas est essentielle pour tous les TP et pour comprendre le code des solutions d'examen.

Ce chapitre est base sur le notebook `pandas_intro.ipynb` fourni dans le cours.

## 1. Structures de donnees principales

### DataFrame

Structure de donnees tabulaire 2D avec des lignes indexees et des colonnes nommees.

```python
import pandas as pd
import numpy as np

# Create from dictionary
df = pd.DataFrame({
    'Region': ['core worlds', 'mid rim', 'outer rim'],
    'Moons': [4, 3, 0],
    'Diameter': [12.240, 12.765, 14.410]
}, index=['Coruscant', 'Kashyyyk', 'Dagobah'])
```

### Series

Tableau 1D indexe (equivalent a une seule colonne d'un DataFrame).

```python
s = pd.Series([1, 2, 3], index=['a', 'b', 'c'])
```

### Attributs principaux

```python
df.index        # Row labels
df.columns      # Column names
df.shape        # (n_rows, n_columns)
df.dtypes       # Data types per column
len(df)         # Number of rows
```

## 2. Chargement des donnees

### Depuis un CSV (le cas le plus courant dans le cours)

```python
# Basic load
df = pd.read_csv("flickrRennes.csv")

# With index column
df = pd.read_csv("temperatures.csv", index_col=0)

# Specifying separator
df = pd.read_csv("data.csv", sep=";")
```

### Exploration des donnees

```python
df.head()           # First 5 rows
df.head(10)         # First 10 rows
df.tail()           # Last 5 rows
df.info()           # Column types, non-null counts, memory usage
df.describe()       # Statistics for numerical columns (mean, std, min, max, quartiles)
df.shape            # (rows, columns)
```

## 3. Selection des donnees

### Selection de colonnes (Projection)

```python
# Single column --> returns Series
df["Region"]
df.Region          # Alternative syntax (only for simple column names)

# Multiple columns --> returns DataFrame
df[["Moons", "Diameter"]]
```

### Selection de lignes (Filtrage)

```python
# Boolean mask
mask = df["Region"] == "outer rim"
df_outer = df[mask]

# Combined in one line
df_outer = df[df["Region"] == "outer rim"]

# Multiple conditions (use & for AND, | for OR, ~ for NOT)
df_filtered = df[(df["Moons"] > 2) & (df["Diameter"] < 15)]

# Complex predicates with apply
def keep(row):
    return row["Region"].endswith("rim")

mask = df.apply(keep, axis=1)
df_filtered = df[mask]
```

### Selection par position

```python
df.iloc[0]          # First row (by position)
df.iloc[0:3]        # First 3 rows
df.iloc[0, 1]       # Row 0, Column 1
df.loc["Coruscant"] # By label
```

## 4. Modification des donnees

### Ajout/Modification de colonnes

```python
# Add new column
df["Random"] = np.random.randn(len(df))

# Modify existing column
df["Moons"] = df["Moons"] * 2

# Apply function to column
df["Log_Diameter"] = np.log1p(df["Diameter"])
```

### Gestion des valeurs manquantes

```python
# Detect
df.isnull()                    # Boolean mask
df.isnull().sum()              # Count per column
df.isnull().sum() / len(df)    # Percentage per column

# Drop
df.dropna()                    # Drop rows with any NaN
df.dropna(subset=['lat'])      # Drop rows where 'lat' is NaN

# Fill
df.fillna(0)                   # Replace NaN with 0
df.fillna(df.mean())           # Replace with column mean
df["tags"].fillna("")          # Replace NaN in specific column
```

### Suppression des doublons

```python
# Remove exact duplicate rows
df = df.drop_duplicates()

# Remove duplicates based on specific columns
df = df.drop_duplicates(subset=['id_photo'])

# Keep first/last occurrence
df = df.drop_duplicates(subset=['user_id', 'date'], keep='first')
```

## 5. Agregation et regroupement

### Valeurs uniques et comptages

```python
# Number of unique values per column
df.nunique()

# Unique values in a column
df["Region"].unique()

# Count occurrences of each value
df["Region"].value_counts()
```

### GroupBy

L'equivalent SQL du GROUP BY : separer les donnees en groupes, appliquer une fonction, combiner les resultats.

```python
groups = df.groupby("Region")

# Aggregation functions
groups.size()          # Number of rows per group
groups.mean()          # Mean of each numeric column per group
groups.first()         # First row of each group
groups.count()         # Count non-null values per group
groups.sum()           # Sum per group
groups.agg(['mean', 'std'])  # Multiple aggregations

# Multiple grouping columns
photos.groupby(
    ['id_photographer', 'date_taken_year', 'date_taken_month',
     'date_taken_day', 'date_taken_hour'],
    as_index=False
).first()
```

**Le parametre `as_index=False`** : Empeche les colonnes groupees de devenir l'index (les conserve comme colonnes normales).

## 6. Iteration sur les donnees

```python
# Iterate over column names
for col_name in df:
    print(col_name)

# Iterate over rows (slow -- use vectorized operations when possible)
for index, row in df.iterrows():
    print(index, row["Region"])

# Apply function to each row (faster than iterrows)
df.apply(lambda row: row["Moons"] * 2, axis=1)
```

## 7. Types de donnees

### Verifier les types

```python
df.dtypes                          # Type of each column
df.select_dtypes(include=["object"])   # Only object (string) columns
df.select_dtypes(exclude=["object"])   # Only numeric columns
(df.dtypes != "object").sum()          # Count non-object columns
```

### Conversion de types

```python
df["Moons"] = df["Moons"].astype(float)
df["date"] = pd.to_datetime(df["date_taken"])
```

## 8. Visualisation avec Pandas

```python
# Histogram
df["Diameter"].hist(bins=30)

# Scatter plot
df.plot.scatter(x="GrLivArea", y="SalePrice")

# Box plot
df.boxplot(column="Diameter", by="Region")

# Bar chart
df["Region"].value_counts().plot.bar()
```

## 9. Motifs courants du cours

### Motif 1 : Tableau d'analyse des valeurs manquantes

```python
table_na = pd.DataFrame({
    'nb_na': df.isnull().sum(),
    'pct_na': (df.isnull().sum() / len(df)) * 100
})
table_na = table_na.sort_values('pct_na', ascending=False)
table_na.head(10)
```

### Motif 2 : Selectionner les colonnes numeriques pour l'ACP

```python
cols_numeric = ["LotArea", "MasVnrArea", "BsmtFinSF1", "TotalBsmtSF",
                "1stFlrSF", "GrLivArea", "GarageArea", "SalePrice"]
df_num = df[cols_numeric].copy()
```

### Motif 3 : Suppression de l'effet album photo

```python
# Group by user + time, keep first photo per group
photos = photos.groupby(
    ['id_photographer', 'date_taken_year', 'date_taken_month',
     'date_taken_day', 'date_taken_hour'],
    as_index=False
).first()
```

### Motif 4 : Ajouter les labels de clusters au DataFrame

```python
from sklearn.cluster import DBSCAN

dbscan = DBSCAN(eps=0.00030, min_samples=7)
photos["cluster"] = dbscan.fit_predict(photos[["lat", "long"]])
```

### Motif 5 : Analyser les clusters

```python
for cluster_id in sorted(photos["cluster"].unique()):
    if cluster_id == -1:
        continue
    cluster_photos = photos[photos["cluster"] == cluster_id]
    print(f"Cluster {cluster_id}: {len(cluster_photos)} photos, "
          f"{cluster_photos['id_photographer'].nunique()} users")
```

## Pieges courants

1. **Modifier une tranche vs. une copie** : `df[mask]["col"] = value` ne modifie PAS df. Utiliser `df.loc[mask, "col"] = value` a la place.
2. **Avertissement d'indexation chainee** : `df["col1"]["col2"]` peut produire un SettingWithCopyWarning. Utiliser `df.loc[:, "col"]` ou `.copy()`.
3. **Oublier `as_index=False`** dans groupby : Cree un MultiIndex qui peut etre deroutant.
4. **Utiliser `==` avec NaN** : `NaN == NaN` est False. Utiliser `df.isnull()` ou `pd.isna()`.
5. **Iterer avec des boucles for** quand des operations vectorisees existent : `df["col"] * 2` est 100x plus rapide qu'une boucle.

---

## AIDE-MEMOIRE

### Chargement et exploration

```python
df = pd.read_csv("file.csv")          # Load
df.head()                               # First rows
df.info()                               # Structure
df.describe()                           # Statistics
df.shape                                # (rows, cols)
```

### Selection

```python
df["col"]                    # Single column (Series)
df[["col1", "col2"]]        # Multiple columns (DataFrame)
df[df["col"] > 5]           # Filter rows
df.loc["label"]              # By row label
df.iloc[0]                   # By row position
```

### Nettoyage

```python
df.isnull().sum()            # Count NaN
df.dropna()                  # Drop NaN rows
df.fillna(value)             # Fill NaN
df.drop_duplicates()         # Remove duplicates
df.drop(columns=["col"])     # Drop column
```

### Agregation

```python
df.groupby("col").mean()     # Group and aggregate
df["col"].value_counts()     # Count values
df["col"].nunique()          # Count unique
df["col"].unique()           # List unique values
```

### Transformation

```python
df["new"] = df["old"] * 2               # New column
df["col"] = df["col"].astype(float)     # Type conversion
df["col"] = np.log1p(df["col"])         # Log transform
df.apply(func, axis=1)                  # Apply to rows
```

### Reference des methodes cles

| Methode | Retourne | Description |
|---------|----------|-------------|
| `head(n)` | DataFrame | Les n premieres lignes |
| `describe()` | DataFrame | Statistiques descriptives |
| `info()` | None (affiche) | Types de colonnes et nombre de non-nuls |
| `isnull()` | DataFrame (bool) | Masque des NaN |
| `dropna()` | DataFrame | Sans les lignes NaN |
| `fillna(v)` | DataFrame | NaN remplaces par v |
| `drop_duplicates()` | DataFrame | Sans doublons |
| `groupby(col)` | Objet GroupBy | Donnees regroupees |
| `value_counts()` | Series | Frequence de chaque valeur |
| `nunique()` | int ou Series | Nombre de valeurs uniques |
| `unique()` | array | Valeurs uniques |
| `apply(f)` | Series/DataFrame | Appliquer une fonction |
| `merge(df2)` | DataFrame | Jointure de type SQL |
| `sort_values(col)` | DataFrame | Trie par colonne |
