# ADFD -- Analyse de Donnees et Fouille de Donnees

## Presentation du cours

L'ADFD est un cours de 3e annee (S5) a l'INSA Rennes, departement Informatique. Il couvre les bases de l'analyse de donnees et de la fouille de donnees, du pretraitement des donnees aux methodes d'apprentissage non supervise pour la reduction de dimension, le clustering et l'extraction de motifs.

**Enseignants** : Peggy Cellier (INSA Rennes), avec des contributions TP de Francesco Bariatti, Ludovic Jean-Baptiste (Universite de Caen), Mehdi Kaytoue (INSA Lyon)

## Structure du cours

Le cours est divise en deux grandes parties :

| Partie | Sujets |
|--------|--------|
| **AD** -- Analyse de Donnees | Pretraitement, ACP, Reduction de dimension |
| **FD** -- Fouille de Donnees | Clustering, Itemsets frequents, Fouille de motifs, NLP |

## Liste des chapitres

| # | Fichier | Sujet | Concepts cles |
|---|---------|-------|---------------|
| 1 | [01-preprocessing.md](01-preprocessing.md) | Pretraitement des donnees | Valeurs manquantes, valeurs aberrantes, normalisation, encodage |
| 2 | [02-pca.md](02-pca.md) | ACP (Analyse en Composantes Principales) | Valeurs propres, cercle des correlations, variance, plans factoriels |
| 3 | [03-clustering.md](03-clustering.md) | Methodes de clustering | CAH, K-means, DBSCAN, dendrogrammes, metriques |
| 4 | [04-data-mining-nlp.md](04-data-mining-nlp.md) | Fouille de donnees et NLP | Itemsets frequents, Apriori, pretraitement de texte |
| 5 | [05-pandas.md](05-pandas.md) | Pandas et manipulation de donnees | DataFrames, groupby, filtrage, gestion CSV |

## Concepts cles en un coup d'oeil

### Analyse de Donnees (AD)

- **Pretraitement** : Nettoyage des donnees avant analyse -- gestion des valeurs manquantes, des valeurs aberrantes (points aberrants), normalisation (standardisation) et encodage des variables categorielles.
- **ACP** (Analyse en Composantes Principales) : La technique centrale de la partie AD. Transforme des variables correlees en composantes principales non correlees qui maximisent la variance capturee. Produit le cercle des correlations et les plans factoriels.
- **Reduction de dimension** : Categorie plus large incluant la selection de variables (methodes filtre, wrapper, embedded) et l'extraction de variables (ACP, t-SNE).

### Fouille de Donnees (FD)

- **Clustering** : Regroupement des observations en clusters homogenes. Methodes etudiees : CAH avec critere de Ward, K-means, DBSCAN.
- **Itemsets frequents** : Algorithme Apriori pour la fouille d'items co-occurrents au-dessus d'un seuil de support minimum.
- **Fouille de motifs** : Techniques avancees pour l'extraction de motifs sequentiels et de regles d'association.
- **Pretraitement NLP/Texte** : Suppression des mots vides, normalisation des accents, filtrage par regex pour l'analyse des tags.

## Format des examens

Le cours comporte generalement deux examens separes :

| Examen | Duree | Contenu |
|--------|-------|---------|
| **DS AD** (Analyse de Donnees) | ~2h | Interpretation de l'ACP, lecture du cercle des correlations, questions de pretraitement |
| **DS FD** (Fouille de Donnees) | ~2h | Clustering (DBSCAN, K-means, CAH), fouille d'itemsets, algorithme Apriori |

Certaines annees ont un seul examen combine (ADFD).

## Bibliotheques Python utilisees

```python
# Data manipulation
import pandas as pd
import numpy as np

# Visualization
import matplotlib.pyplot as plt
import seaborn as sns

# Machine Learning
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from sklearn.impute import SimpleImputer
from sklearn.cluster import DBSCAN, KMeans

# Hierarchical clustering
from scipy.cluster.hierarchy import dendrogram, linkage, fcluster
from scipy.spatial.distance import cdist

# Evaluation metrics
from sklearn.metrics import silhouette_score, davies_bouldin_score

# Cartography (for TP3-4)
import folium

# Text / NLP (for TP3-4)
import nltk
from nltk.corpus import stopwords
from mlxtend.frequent_patterns import apriori
from mlxtend.preprocessing import TransactionEncoder
```

## Strategie de revision

1. **Maitriser l'interpretation de l'ACP en premier** -- c'est le sujet le plus teste dans les examens AD.
2. **Connaitre les algorithmes de clustering par coeur** -- etre capable de derouler DBSCAN et K-means pas a pas sur de petits exemples.
3. **Pratiquer Apriori a la main** -- les examens de fouille d'itemsets incluent toujours un calcul manuel.
4. **Comprendre quand utiliser quoi** -- les examens demandent souvent de justifier le choix de methode.
5. **Lire le cercle des correlations** -- c'est la competence la plus importante pour reussir l'examen.
