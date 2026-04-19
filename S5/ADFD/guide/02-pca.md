# Chapitre 2 : ACP -- Analyse en Composantes Principales

## Presentation

L'ACP est la technique centrale de la partie Analyse de Donnees (AD) du cours. Elle transforme un ensemble de variables correlees en un ensemble plus petit de variables non correlees appelees **composantes principales**, tout en preservant le maximum de variance (information).

## 1. Pourquoi l'ACP ?

| Probleme | Comment l'ACP aide |
|----------|-------------------|
| Trop de variables (malediction de la dimensionnalite) | Reduit a 2-3 dimensions significatives |
| Variables correlees | Cree des composantes non correlees |
| Difficulte de visualiser des donnees de haute dimension | Projette sur des plans factoriels 2D |
| Bruit dans les donnees | Conserve le signal (directions de forte variance), ecarte le bruit (faible variance) |

**Idee cle** : Si les variables sont correlees, la dimensionnalite effective est inferieure au nombre de variables. L'ACP trouve cette structure de dimension reduite.

## 2. Fondement mathematique

### Algorithme etape par etape

**Entree** : Matrice de donnees X avec n individus (lignes) et p variables (colonnes).

**Etape 1 -- Centrer (et eventuellement reduire) les donnees**

ACP normee = centrer ET standardiser. **Necessaire quand les variables ont des unites differentes.**

```
X_centered = X - mean(X)           # Centering (centrage)
X_scaled = X_centered / std(X)     # Reduction (reduction)
```

```python
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)
```

**Etape 2 -- Calculer la matrice de correlation (ou de covariance)**

Pour l'ACP normee, il s'agit de la matrice de correlation R :

```
R = (1/n) * X_scaled^T * X_scaled
```

R est une matrice symetrique p x p ou R[i,j] = correlation entre la variable i et la variable j.

**Note** : La convention `1/n` est standard dans les manuels francais d'analyse de donnees (ACP normee). En pratique, `sklearn.decomposition.PCA` utilise `1/(n-1)` (estimateur non biaise de la covariance), mais la difference est negligeable pour un grand n. Pour les examens, utiliser `1/n`.

**Etape 3 -- Calculer les valeurs propres et vecteurs propres**

Resoudre : R * v = lambda * v

- **Valeurs propres** lambda_1 >= lambda_2 >= ... >= lambda_p
- **Vecteurs propres** v_1, v_2, ..., v_p

Chaque valeur propre represente la variance capturee par la direction de son vecteur propre correspondant.

**Etape 4 -- Choisir le nombre de composantes**

Conserver les k premieres composantes capturant suffisamment de variance (typiquement 80-90%).

**Etape 5 -- Projeter les donnees**

```
PC_scores = X_scaled * V_k    # V_k = matrix of first k eigenvectors
```

### Formules cles

| Concept | Formule | Signification |
|---------|---------|---------------|
| **Valeur propre** | lambda_k | Variance expliquee par la composante k |
| **Inertie totale** | Somme des valeurs propres = p (pour l'ACP normee) | Variance totale des donnees |
| **Part de variance expliquee** | lambda_k / Somme(lambda_i) | % d'information dans la composante k |
| **Variance cumulee** | Somme(lambda_1..k) / Somme(lambda_i) | % d'information dans les k premieres composantes |
| **Correlation variable-axe** | r(x_j, F_k) = v_jk * sqrt(lambda_k) | Force de la relation entre la variable j et l'axe k |
| **Contribution d'un individu** | (coord_i^2) / (n * lambda_k) | Contribution de l'individu i a l'axe k |
| **Qualite de representation** (cos^2) | coord_i^2 / Somme(coord_i^2 sur tous les axes) | Qualite de la representation de l'individu i sur les axes retenus |

## 3. Choix du nombre de composantes

Trois regles courantes :

### Regle 1 : Regle des 80% de variance (la plus utilisee dans ce cours)
Conserver le nombre minimum de composantes tel que la variance cumulee expliquee >= 80%.

### Regle 2 : Critere de Kaiser
Conserver les composantes ayant une valeur propre > 1 (pour l'ACP normee). Justification : une composante doit expliquer plus de variance qu'une seule variable originale.

### Regle 3 : Diagramme des valeurs propres (Scree Plot)
Tracer les valeurs propres et chercher un "coude" -- un point ou la decroissance ralentit significativement.

```python
pca = PCA()
pca.fit(X_scaled)

# Scree plot
plt.bar(range(1, len(pca.explained_variance_ratio_)+1),
        pca.explained_variance_ratio_ * 100)
plt.xlabel('Component')
plt.ylabel('Explained Variance (%)')
plt.title('Scree Plot')
```

### Exemple (TP1 -- Temperatures des villes)

| Composante | Valeur propre | Variance (%) | Cumulee (%) |
|------------|--------------|--------------|-------------|
| PC1 | ~8.5 | ~70% | 70% |
| PC2 | ~2.0 | ~17% | 87% |
| PC3 | ~0.7 | ~6% | 93% |
| ... | ... | ... | ... |

**Decision** : 2 composantes capturent ~87% de l'information -- suffisant pour l'analyse.

## 4. Interpretation du plan factoriel des individus

Le plan factoriel represente chaque individu (observation) comme un point dans l'espace defini par deux composantes principales.

### Regles de lecture

1. **Proximite = Similarite** : Les individus proches ont des profils similaires sur toutes les variables originales.
2. **Distance a l'origine** : Les individus eloignes du centre sont "extremes" -- ils caracterisent fortement les axes.
3. **Opposition** : Les individus de part et d'autre d'un axe ont des comportements opposes sur les variables qui definissent cet axe.
4. **Pres de l'origine** : Les individus proches du centre sont "moyens" ou mal representes (verifier cos^2).

### Exemple (TP1 : Villes francaises par temperature)

```
                        PC2 (Amplitude thermique)
                         ^
    Grenoble, Lyon       |       Brest
    Strasbourg           |       Rennes, Nantes
    (continental)        |       (oceanique)
    ---------------------+----------------------> PC1 (Temperature moyenne)
    Lille                 |
    Vichy                 |
                          |       Marseille, Nice
                          |       Montpellier, Toulouse
                                  (mediterraneen)
```

**Interpretation** :
- **PC1 (Axe 1, ~70%)** : Gradient Nord-Sud = temperature moyenne. Les villes a droite (Marseille, Nice) sont plus chaudes globalement. Les villes a gauche (Lille, Strasbourg) sont plus froides.
- **PC2 (Axe 2, ~17%)** : Gradient Est-Ouest = amplitude thermique. Les villes en haut (Grenoble, Strasbourg) ont de grandes differences de temperature entre ete et hiver. Les villes en bas (Brest, Rennes) ont un climat oceanique doux avec une faible amplitude.

## 5. Le cercle des correlations

**C'est la visualisation la plus importante du cours et le sujet le plus teste en examen.**

Le cercle des correlations represente chaque variable originale comme un point dans un cercle unite. Les coordonnees sont les correlations entre la variable et chaque composante principale.

### Regles de lecture

1. **Proche du bord du cercle** (longueur proche de 1) : La variable est bien representee sur ces deux axes.
2. **Proche d'un axe** : La variable est fortement correlee avec cette composante.
3. **Deux variables proches** : Elles sont positivement correlees.
4. **Deux variables diametralement opposees** : Elles sont negativement correlees.
5. **Deux variables a 90 degres** : Elles sont non correlees (independantes).
6. **Proche de l'origine** : La variable est mal representee sur ces axes -- regarder d'autres composantes.

### Calcul des correlations (Loadings)

```python
# Method 1: From pca.components_ (true correlation between variable and axis)
loadings = pca.components_.T * np.sqrt(pca.explained_variance_)

# Method 2: Direct correlation formula
# r(x_j, PC_k) = pca.components_[k, j] * sqrt(eigenvalue_k)
```

**Note importante sur le notebook du TP1** : La fonction `correlation_circle_plotly` fournie dans le TP utilise `pcs[0, i]` et `pcs[1, i]` (c'est-a-dire `pca.components_[k, j]`) directement comme coordonnees, SANS multiplier par `sqrt(valeur_propre_k)`. Cela signifie que les fleches representent les coordonnees du vecteur propre (poids dans la composante principale), et non les vraies correlations. Pour l'interpretation en examen, utiliser la formule avec `sqrt(lambda_k)` pour obtenir les valeurs de correlation reelles.

### Tracer le cercle des correlations

```python
fig, ax = plt.subplots(figsize=(8, 8))

# Unit circle
circle = plt.Circle((0, 0), 1, fill=False, color='gray', linestyle='--')
ax.add_patch(circle)

# Plot variables as arrows
for i, var_name in enumerate(variable_names):
    x = loadings[i, 0]  # Correlation with PC1
    y = loadings[i, 1]  # Correlation with PC2
    ax.arrow(0, 0, x, y, head_width=0.05, color='red')
    ax.text(x * 1.15, y * 1.15, var_name, fontsize=10)

ax.set_xlim(-1.2, 1.2)
ax.set_ylim(-1.2, 1.2)
ax.set_xlabel(f'PC1 ({var_explained[0]*100:.1f}%)')
ax.set_ylabel(f'PC2 ({var_explained[1]*100:.1f}%)')
ax.set_aspect('equal')
```

### Exemple (TP1 : Mois de temperature)

Sur le cercle des correlations pour les temperatures des villes :
- **Tous les mois pointent grosso modo dans la meme direction sur PC1** : Toutes les temperatures sont positivement correlees (les villes chaudes sont chaudes tous les mois).
- **Les mois d'ete (Juin, Juillet) sont orientes vers PC2** : Ils contribuent a la dimension d'amplitude.
- **Les mois d'hiver (Decembre, Janvier) s'ecartent de PC2** : Ils mettent en evidence la distinction oceanique vs continental.
- **Mars et Octobre sont tres proches de l'axe PC1** : Ce sont les meilleurs indicateurs de la temperature moyenne.

## 6. Contribution et qualite de representation

### Contribution d'un individu a un axe

```
CTR(i, k) = (F_ik)^2 / (n * lambda_k)
```

Ou F_ik est la coordonnee de l'individu i sur l'axe k. Si CTR > 1/n, l'individu contribue plus que la moyenne.

### Qualite de representation (cos^2)

```
cos^2(i, k) = (F_ik)^2 / sum_j(F_ij)^2
```

Un cos^2 eleve signifie que l'individu est bien represente sur l'axe k. Si cos^2 est faible sur les deux axes retenus, la position de l'individu dans le plan factoriel n'est pas fiable.

### Contributions des variables

Pour les variables, la contribution a un axe est liee au carre de la correlation avec cet axe :

```
CTR(var_j, axis_k) = r(x_j, F_k)^2 / lambda_k
```

Puisque somme_j r(x_j, F_k)^2 = lambda_k (pour l'ACP normee), cela donne une proportion dont la somme vaut 1 sur toutes les variables pour un axe donne. Une variable contribue significativement si sa contribution depasse 1/p (ou p est le nombre de variables).

**Note sur le notebook du TP1** : Le DataFrame `loadings` dans le TP stocke `pca.components_.T` (les poids du vecteur propre, pas les correlations). Les elever au carre donne les poids au carre, qui sont proportionnels aux contributions puisque chaque vecteur propre est de norme unitaire (la somme des composantes vaut 1).

```python
loadings = pd.DataFrame(
    pca.components_.T,
    columns=[f'PC{i+1}' for i in range(n_components)],
    index=variable_names
)

# Contributions = squared loadings
contributions = loadings ** 2
```

## 7. Explication des axes par des variables qualitatives

Apres l'ACP, on peut colorer le plan factoriel par une variable qualitative pour voir si elle explique les axes :

```python
# Color by SalePrice (quantitative)
plt.scatter(X_pca[:, 0], X_pca[:, 1], c=df['SalePrice'], cmap='viridis')

# Color by OverallQual (qualitative)
for qual_value in df['OverallQual'].unique():
    mask = df['OverallQual'] == qual_value
    plt.scatter(X_pca[mask, 0], X_pca[mask, 1], label=str(qual_value))
```

D'apres le TP1 (House Prices) :
- **SalePrice** est correlee avec PC2 : les prix eleves apparaissent d'un cote.
- **OverallQual** : Les faibles qualites (1-3) se regroupent a gauche de PC1 ; les hautes qualites (8-10) a droite.
- **Neighborhood** : Ne structure PAS les donnees sur PC1/PC2 -- les axes capturent la surface/structure, pas la localisation.

## 8. Connexion entre ACP et classification

Les resultats de l'ACP peuvent servir d'entree pour le clustering (CAH, K-means) :

1. Realiser l'ACP, conserver k composantes (ex. 2)
2. Utiliser les coordonnees sur les composantes comme nouvelles variables
3. Appliquer la CAH ou K-means sur ces coordonnees reduites

C'est la methode **CAH-MIXTE** vue dans le TP2. Voir le [Chapitre 3 : Clustering](03-clustering.md).

## Pieges courants

1. **Utiliser une ACP non normee quand les variables ont des unites differentes** : Toujours utiliser l'ACP normee (StandardScaler) sauf si toutes les variables sont dans la meme unite.
2. **Confondre composantes et loadings** : Les composantes sont les coordonnees des individus ; les loadings sont les correlations des variables avec les axes.
3. **Lire le cercle des correlations pour des variables proches de l'origine** : Si une variable est pres du centre du cercle, elle N'EST PAS bien representee sur ces axes -- ne pas interpreter sa position.
4. **Interpreter la distance entre un individu et une variable** : Le plan factoriel des individus et le cercle des correlations sont a des echelles differentes. Ne comparer que les individus entre eux, et les variables entre elles.
5. **Oublier que le signe des axes est arbitraire** : La direction (positive/negative) d'un axe est arbitraire. Ce qui compte est le positionnement relatif.

---

## AIDE-MEMOIRE

### Pipeline ACP

```python
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

# 1. Standardize
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# 2. Fit PCA
pca = PCA(n_components=2)  # or n_components=None for all
X_pca = pca.fit_transform(X_scaled)

# 3. Results
pca.explained_variance_ratio_    # % variance per component
pca.explained_variance_          # eigenvalues
pca.components_                  # eigenvectors (loadings matrix)
np.cumsum(pca.explained_variance_ratio_)  # cumulative variance
```

### Reference rapide

| Ce que vous cherchez | Comment l'obtenir |
|---------------------|------------------|
| Valeurs propres | `pca.explained_variance_` |
| % de variance par composante | `pca.explained_variance_ratio_` |
| Variance cumulee | `np.cumsum(pca.explained_variance_ratio_)` |
| Coordonnees des individus sur les axes | `pca.transform(X_scaled)` ou `X_pca` |
| Correlations des variables avec les axes | `pca.components_.T * np.sqrt(pca.explained_variance_)` |
| Contribution d'une variable a l'axe k | `(pca.components_.T * np.sqrt(pca.explained_variance_))[:, k]**2` (correlations au carre) |

### Chiffres cles a retenir

| Regle | Valeur |
|-------|--------|
| Variance cumulee minimale a conserver | 80% |
| Critere de Kaiser (seuil de valeur propre) | > 1 |
| Bonne qualite de representation (cos^2) | > 0.5 |
| Seuil de contribution significative | > 1/p (p = nombre de variables) |

### Guide rapide d'interpretation du cercle des correlations

| Position sur le cercle | Signification |
|-----------------------|---------------|
| Sur le bord du cercle | Tres bien representee |
| Proche de l'axe PC1 | Fortement correlee avec PC1 |
| Proche de l'axe PC2 | Fortement correlee avec PC2 |
| Deux variables proches | Correlees positivement |
| Deux variables opposees | Correlees negativement |
| Deux variables a 90 degres | Non correlees |
| Pres du centre | Mal representee -- verifier d'autres axes |

### Vocabulaire d'examen (Francais/Anglais)

| Francais | Anglais |
|----------|---------|
| Valeur propre | Eigenvalue |
| Vecteur propre | Eigenvector |
| Inertie | Variance / Inertia |
| Cercle des correlations | Correlation circle |
| Plan factoriel | Factorial plane |
| Composante principale | Principal component |
| ACP normee | Normalized PCA (with standardization) |
| Centrer-reduire | Center and scale (standardize) |
| Contribution | Contribution (importance to axis) |
| Qualite de representation | Quality of representation (cos^2) |
| Axe factoriel | Factorial axis / Principal component |
