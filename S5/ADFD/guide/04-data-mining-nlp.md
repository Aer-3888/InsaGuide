# Chapitre 4 : Fouille de donnees et traitement du langage (NLP)

## Presentation

La partie Fouille de Donnees (FD) du cours couvre l'extraction non supervisee de motifs dans les donnees : extraction de motifs frequents avec l'algorithme Apriori, regles d'association et pretraitement NLP de base pour la fouille de texte. Ces techniques sont appliquees dans les TP3-4 pour caracteriser les clusters de POI a l'aide des tags de photos.

## 1. Extraction de motifs frequents

### Definitions

| Terme | Definition |
|-------|-----------|
| **Item** | Un element unique (ex. "Lait", "rennes", un produit) |
| **Itemset / Motif** | Un ensemble d'items (ex. &#123;Lait, Oeufs&#125;) |
| **Transaction** | Un enregistrement contenant un ensemble d'items (ex. un panier d'achat) |
| **Support** | Fraction des transactions contenant l'itemset |
| **Motif frequent** | Un itemset avec un support >= seuil de support minimum |
| **Support minimum** (minsup) | Seuil defini par l'utilisateur |

### Formule du support

```
support(X) = |{T in DB : X is subset of T}| / |DB|
```

Ou DB est la base de donnees de transactions et T est une transaction individuelle.

**Exemple** : Si 3 transactions sur 5 contiennent &#123;Eggs, Kidney Beans&#125;, alors :
```
support({Eggs, Kidney Beans}) = 3/5 = 0.6 = 60%
```

### Propriete d'anti-monotonie

**Theoreme cle** : Si un itemset est non frequent, tous ses sur-ensembles sont aussi non frequents.

Contraposee : Si un itemset est frequent, tous ses sous-ensembles sont aussi frequents.

C'est le fondement de l'algorithme Apriori -- il permet d'elaguer l'espace de recherche.

## 2. L'algorithme Apriori

### Vue d'ensemble de l'algorithme

Apriori trouve tous les itemsets frequents en generant iterativement des candidats de taille croissante et en elaguant les non frequents.

```
1. L_1 = {frequent 1-itemsets}  (scan database, count, filter by minsup)
2. For k = 2, 3, ...
   a. C_k = generate candidates from L_{k-1}  (join + prune)
   b. Scan database, count support of each candidate in C_k
   c. L_k = {candidates in C_k with support >= minsup}
   d. If L_k is empty, stop
3. Return union of all L_k
```

### Generation de candidats (Etape 2a)

**Etape de jointure** : Fusionner deux itemsets de L_{k-1} qui partagent les k-2 premiers items.

**Etape d'elagage** : Supprimer tout candidat ayant un (k-1)-sous-ensemble absent de L_{k-1} (par anti-monotonie, il ne peut pas etre frequent).

### Exemple detaille

**Base de donnees** :

| Transaction | Items |
|-------------|-------|
| T1 | Milk, Onion, Nutmeg, Kidney Beans, Eggs, Yogurt |
| T2 | Dill, Onion, Nutmeg, Kidney Beans, Eggs, Yogurt |
| T3 | Milk, Apple, Kidney Beans, Eggs |
| T4 | Milk, Unicorn, Corn, Kidney Beans, Yogurt |
| T5 | Corn, Onion, Kidney Beans, Ice cream, Eggs |

**minsup = 60% (= 3 transactions)**

**Etape 1 : 1-itemsets frequents (L_1)**

| Item | Comptage | Support | Frequent ? |
|------|-------|---------|-----------|
| Eggs | 4 | 80% | Oui |
| Kidney Beans | 5 | 100% | Oui |
| Milk | 3 | 60% | Oui |
| Onion | 3 | 60% | Oui |
| Yogurt | 3 | 60% | Oui |
| Corn | 2 | 40% | Non |
| Nutmeg | 2 | 40% | Non |
| Apple | 1 | 20% | Non |
| Dill | 1 | 20% | Non |
| Ice cream | 1 | 20% | Non |
| Unicorn | 1 | 20% | Non |

L_1 = {Eggs, Kidney Beans, Milk, Onion, Yogurt}

**Etape 2 : 2-itemsets frequents (L_2)**

Generer toutes les paires de L_1, compter le support :

| Itemset | Support | Frequent ? |
|---------|---------|-----------|
| &#123;Eggs, Kidney Beans&#125; | 4/5 = 80% | Oui |
| &#123;Eggs, Onion&#125; | 3/5 = 60% | Oui |
| &#123;Kidney Beans, Milk&#125; | 3/5 = 60% | Oui |
| &#123;Kidney Beans, Onion&#125; | 3/5 = 60% | Oui |
| &#123;Yogurt, Kidney Beans&#125; | 3/5 = 60% | Oui |
| &#123;Eggs, Milk&#125; | 2/5 = 40% | Non |
| &#123;Eggs, Yogurt&#125; | 2/5 = 40% | Non |
| &#123;Milk, Onion&#125; | 1/5 = 20% | Non |
| &#123;Milk, Yogurt&#125; | 2/5 = 40% | Non |
| &#123;Onion, Yogurt&#125; | 2/5 = 40% | Non |

**Etape 3 : 3-itemsets frequents (L_3)**

A partir de L_2, les candidats doivent avoir tous leurs 2-sous-ensembles dans L_2.

| Candidat | Tous les 2-sous-ensembles frequents ? | Support | Frequent ? |
|----------|--------------------------------------|---------|-----------|
| &#123;Eggs, Kidney Beans, Onion&#125; | EK:Oui, EO:Oui, KO:Oui | 3/5=60% | Oui |
| &#123;Eggs, Kidney Beans, Milk&#125; | EK:Oui, EM:Non | -- | Elague |
| &#123;Eggs, Kidney Beans, Yogurt&#125; | EK:Oui, EY:Non | -- | Elague |
| ... | ... | ... | ... |

L_3 = &#123;&#123;Eggs, Kidney Beans, Onion&#125;&#125;

**Resultat final** : Tous les itemsets frequents = L_1 union L_2 union L_3

### Implementation Python

```python
from mlxtend.frequent_patterns import apriori
from mlxtend.preprocessing import TransactionEncoder

# Transform transactions to boolean matrix
te = TransactionEncoder()
te_array = te.fit(dataset).transform(dataset)
df = pd.DataFrame(te_array, columns=te.columns_)

# Run Apriori
frequent_itemsets = apriori(df, min_support=0.6, use_colnames=True)

# Add length column
frequent_itemsets['length'] = frequent_itemsets['itemsets'].apply(len)

# Filter by length
long_itemsets = frequent_itemsets[frequent_itemsets['length'] >= 2]
```

## 3. Regles d'association

### Definitions

Une regle d'association a la forme : X --> Y (si X alors Y), ou X et Y sont des itemsets disjoints.

| Metrique | Formule | Signification |
|----------|---------|---------------|
| **Support** | support(X union Y) | Frequence d'apparition conjointe de X et Y |
| **Confiance** | support(X union Y) / support(X) | P(Y \| X) -- probabilite de Y sachant X |
| **Lift** | confiance(X->Y) / support(Y) | Combien Y est plus probable avec X qu'au hasard |

### Interpretation

| Valeur du lift | Signification |
|---------------|---------------|
| lift > 1 | Association positive (X et Y apparaissent ensemble plus que prevu) |
| lift = 1 | Independance (pas d'association) |
| lift &lt; 1 | Association negative (X et Y s'evitent) |

### Exemple

A partir des donnees precedentes :
- Regle : &#123;Onion, Kidney Beans&#125; --> &#123;Eggs&#125;
- support(&#123;Onion, KB, Eggs&#125;) = 60%
- confiance = 60% / 60% = 100%
- lift = 100% / 80% = 1.25

Interpretation : Si un panier contient Onion et Kidney Beans, il contient toujours Eggs. Le lift de 1.25 signifie que cette combinaison est 25% plus probable qu'au hasard.

## 4. Pretraitement de texte pour le NLP

Dans les TP3-4, les tags des photos Flickr sont pretraites avant la fouille. Le pipeline :

### Etape 1 : Conversion en minuscules

```python
def lowerCase(tags):
    return tags.lower()
```

### Etape 2 : Suppression des accents

```python
def supprimeAccent(tags):
    # Maps accented characters to their unaccented equivalents
    # e.g., 'e' with acute -> 'e', 'a' with grave -> 'a', etc.
    # Note: The actual accented keys (e.g., unicode chars) may not render
    # correctly in all editors. The principle is a character-by-character map.
    accent_map = {
        '\u00e0': 'a', '\u00e2': 'a', '\u00e4': 'a',  # a grave, circumflex, diaeresis
        '\u00e9': 'e', '\u00e8': 'e', '\u00ea': 'e', '\u00eb': 'e',  # e acute, grave, circumflex, diaeresis
        '\u00ee': 'i', '\u00ef': 'i',  # i circumflex, diaeresis
        '\u00f4': 'o', '\u00f6': 'o',  # o circumflex, diaeresis
        '\u00f9': 'u', '\u00fb': 'u', '\u00fc': 'u',  # u grave, circumflex, diaeresis
    }
    result = []
    for char in tags:
        result.append(accent_map.get(char, char))
    return ''.join(result)
```

Approche plus robuste (recommandee) :
```python
import unicodedata
def remove_accents(text):
    nfkd = unicodedata.normalize('NFKD', text)
    return ''.join(c for c in nfkd if not unicodedata.combining(c))
```

### Etape 3 : Suppression des mots vides

Les mots vides sont des mots courants qui ne portent pas de sens semantique (le, la, de, des, un, une, etc.).

```python
from nltk.corpus import stopwords
stopwordslist = stopwords.words("french")

def supprimeStopwords(tags):
    words = tags.split()
    return ' '.join(w for w in words if w not in stopwordslist)
```

### Etape 4 : Suppression des identifiants photo

Les tags comme "IMG_7719" ou "DSC_2692" sont generes par l'appareil et ne portent pas de sens.

```python
import re

def supprimeIdentPhoto(tags):
    regex_img = re.compile(r'^img_', re.IGNORECASE)
    regex_dsc = re.compile(r'^dsc_', re.IGNORECASE)
    words = tags.split()
    return ' '.join(w for w in words
                    if not regex_img.match(w) and not regex_dsc.match(w))
```

### Etape 5 : Conserver uniquement les mots alphanumeriques

Supprimer les mots contenant des caracteres speciaux (URLs, emojis, ponctuation).

```python
def supprimeCarSpeciaux(tags):
    pattern = re.compile(r'^[\w-]+$')
    words = tags.split()
    return ' '.join(w for w in words if pattern.match(w))
```

### Pipeline complet

```python
photos["tags"] = photos["tags"].fillna("")
for idx, row in photos.iterrows():
    tags = row["tags"]
    tags = lowerCase(tags)
    tags = supprimeAccent(tags)
    tags = supprimeStopwords(tags)
    tags = supprimeIdentPhoto(tags)
    tags = supprimeCarSpeciaux(tags)
    photos.at[idx, "tags"] = tags
```

## 5. Etiquetage des clusters avec Apriori (TP3-4)

Apres le clustering des photos avec DBSCAN, utiliser Apriori sur les tags de chaque cluster pour trouver son etiquette la plus caracteristique :

```python
def identify_cluster(cluster_nb, photos, cluster_labels):
    # Get photos in this cluster
    cluster_photos = photos[photos['cluster'] == cluster_nb]
    
    # Build transaction list from tags
    transactions = []
    for tags in cluster_photos['tags']:
        if tags and tags.strip():
            transactions.append(tags.split())
    
    if not transactions:
        return
    
    # Encode as boolean matrix
    te = TransactionEncoder()
    te_array = te.fit(transactions).transform(transactions)
    df_tags = pd.DataFrame(te_array, columns=te.columns_)
    
    # Apply Apriori (play with min_support: 0.3-0.6)
    freq = apriori(df_tags, min_support=0.3, use_colnames=True)
    
    if freq.empty:
        return
    
    # Keep itemsets of length >= 2
    freq['length'] = freq['itemsets'].apply(len)
    freq = freq[freq['length'] >= 2]
    
    if freq.empty:
        return
    
    # Sort by support (descending), then by length (descending)
    freq = freq.sort_values(['support', 'length'], ascending=[False, False])
    
    # Take the top itemset as the cluster label
    best = freq.iloc[0]['itemsets']
    cluster_labels[cluster_nb] = ', '.join(sorted(best))
```

## 6. Fouille avancee de motifs (Contenu de cours)

Le cours couvre egalement (cours 7 et cours 10) :

### Fouille de motifs sequentiels
Trouver des sequences ordonnees d'itemsets qui apparaissent frequemment dans une base de sequences.

Exemple : &#123;Pain, Beurre&#125; --> &#123;Lait&#125; --> &#123;Oeufs&#125; (les clients qui achetent du pain et du beurre, puis du lait, puis des oeufs)

### Itemsets fermes et maximaux
- **Itemset ferme** : Itemset frequent dont aucun sur-ensemble propre n'a le meme support
- **Itemset maximal** : Itemset frequent dont aucun sur-ensemble propre n'est frequent

Ils reduisent le nombre de motifs tout en preservant toute l'information.

## Pieges courants

1. **Mettre minsup trop bas** : Produit un nombre exponentiel d'itemsets, dont la plupart sont ininteressants.
2. **Mettre minsup trop haut** : Rate des motifs importants. Commencer autour de 0.3-0.5 et ajuster.
3. **Confondre support et confiance** : Le support concerne la frequence de l'itemset entier ; la confiance est la probabilite conditionnelle.
4. **Ne pas gerer les tags vides** : Toujours verifier les NaN/chaines vides avant Apriori.
5. **Oublier de supprimer les mots vides** : Des mots courants comme "rennes" ou "france" domineront tous les clusters s'ils ne sont pas traites.

---

## AIDE-MEMOIRE

### Apriori etape par etape (pour l'examen)

```
1. Count support of all single items --> L_1
2. Generate pairs from L_1 --> C_2
3. Count support of C_2 --> keep frequent --> L_2
4. Generate triples from L_2 (prune by anti-monotonicity) --> C_3
5. Count support of C_3 --> keep frequent --> L_3
6. Continue until L_k is empty
```

### Regles d'anti-monotonie

```
{A} infrequent  -->  {A, B}, {A, C}, {A, B, C}, ... all infrequent
{A, B} frequent  -->  {A} and {B} must be frequent
```

### Formules cles

| Metrique | Formule |
|----------|---------|
| support(X) | count(X in DB) / \|DB\| |
| confidence(X → Y) | support(X union Y) / support(X) |
| lift(X → Y) | confidence(X → Y) / support(Y) |

### Pipeline de pretraitement NLP

```
Raw tags --> lowercase --> remove accents --> remove stopwords
         --> remove IMG/DSC --> remove special chars --> clean tags
```

### Reference rapide Python

```python
# Apriori
from mlxtend.frequent_patterns import apriori
from mlxtend.preprocessing import TransactionEncoder

te = TransactionEncoder()
df = pd.DataFrame(te.fit(data).transform(data), columns=te.columns_)
freq = apriori(df, min_support=0.6, use_colnames=True)

# Association rules
from mlxtend.frequent_patterns import association_rules
rules = association_rules(freq, metric="confidence", min_threshold=0.7)
```

### Vocabulaire d'examen (Francais/Anglais)

| Francais | Anglais |
|----------|---------|
| Motif frequent | Frequent itemset |
| Support minimal | Minimum support |
| Regle d'association | Association rule |
| Confiance | Confidence |
| Anti-monotonie | Anti-monotonicity (downward closure) |
| Elagage | Pruning |
| Candidat | Candidate itemset |
| Mots vides | Stopwords |
| Pretraitement | Preprocessing |
