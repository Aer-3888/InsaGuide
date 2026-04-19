# Guide de preparation aux examens ADFD

## Format des examens

Le cours ADFD comporte generalement **deux examens separes** :

| Examen | Nom | Duree | Poids | Sujets cles |
|--------|-----|-------|-------|-------------|
| **DS AD** | Analyse de Donnees | ~1.5-2h | ~50% | ACP, Cercle des correlations, Pretraitement, Reduction de dimension |
| **DS FD** | Fouille de Donnees | ~1.5-2h | ~50% | Clustering (DBSCAN, K-means, CAH), Apriori, Fouille de motifs |

Certaines annees combinent les deux en un seul examen **DS ADFD**.

**Documents autorises** : Generalement aucun document autorise (examen ferme). Verifier avec le professeur.

## Annales disponibles

| Annee | Partie | Fichier |
|-------|--------|---------|
| 2025 | AD | `Analyse de donnees.pdf` |
| 2025 | FD | `Fouille de donnees.pdf` |
| 2024 | FD | `adfd_2024_fouille.pdf` |
| 2024 | Combined | `main24_final.pdf` |
| 2023 | AD | `Sujet AD.pdf` |
| 2023 | FD | `Sujet FD.pdf` |
| 2023 | Student copy | `Youenn ADFD.pdf` |
| 2021 | Combined | `Sujet 2021.pdf` |
| 2021 | Student copy | `Hugo DS 2021.pdf` |
| 2020 | AD | `Sujet AD 2020.pdf` |
| 2020 | Correction | `Exo1 Correction_.docx` |
| 2019 | Combined | `Sujet.pdf` |
| 2017 | AD | `Sujet AD 2017.pdf` + correction |
| 2016 | AD | `Sujet AD 2016.pdf` + student copy |
| 2016 | FD | `Sujet FD 2016.pdf` + corrections |
| 2015 | AD | `Sujet AD 2015.pdf` |
| 2013 | FD | `Sujet FD 2013.pdf` |

## Strategie d'examen

### Gestion du temps

| Partie de l'examen | Strategie recommandee |
|--------------------|----------------------|
| 5 premieres minutes | Lire TOUTES les questions, identifier les faciles vs les difficiles |
| Questions avec tableaux de donnees | Les faire en premier -- elles sont mecaniques et rapportent des points |
| Interpretation ACP | Prendre le temps sur le cercle des correlations -- c'est la que se trouvent la plupart des points |
| Apriori a la main | Suivre l'algorithme etape par etape, montrer son travail |
| Reponses courtes / justification | Etre concis mais precis -- 2-3 phrases maximum |

### Quoi prioriser

**Sujets a haut rendement** (frequemment testes, beaucoup de points) :

1. **Lecture du cercle des correlations** -- Presque chaque examen AD inclut cela. Savoir :
   - Identifier quelles variables sont correlees avec quels axes
   - Expliquer ce que chaque axe "signifie" en termes du domaine
   - Identifier les paires de variables correlees/anti-correlees/independantes
   - Evaluer la qualite de representation (proximite au bord du cercle)

2. **Algorithme Apriori a la main** -- Chaque examen FD demande de :
   - Calculer le support d'itemsets donnes
   - Generer des candidats et elaguer par anti-monotonie
   - Trouver tous les itemsets frequents pour un minsup donne

3. **DBSCAN etape par etape** -- Beaucoup d'examens FD incluent :
   - Classifier les points en noyau, frontiere ou bruit
   - Derouler l'algorithme sur un petit exemple 2D
   - Comparer DBSCAN avec K-means

4. **Interpretation valeurs propres / variance** -- Savoir :
   - Lire un diagramme des valeurs propres (scree plot)
   - Decider du nombre de composantes a conserver
   - Calculer la variance expliquee cumulee

### Types de questions courants

#### Type 1 : "Interpreter ce cercle des correlations"
Etant donne un cercle des correlations, expliquer :
- Que represente chaque axe ?
- Quelles variables contribuent le plus a chaque axe ?
- Y a-t-il des variables correlees ? Lesquelles ?
- Ou se situerait l'individu X sur le plan factoriel et pourquoi ?

**Strategie** : Regarder quelles variables sont les plus proches de chaque axe. Nommer l'axe selon la signification metier de ces variables. Puis chercher les groupes de variables sur le cercle.

#### Type 2 : "Appliquer Apriori a ce jeu de donnees"
Etant donne une petite base de transactions et un minsup :
- Trouver L_1 (1-itemsets frequents)
- Generer C_2, calculer les supports, trouver L_2
- Generer C_3 avec elagage par anti-monotonie, trouver L_3
- Lister tous les itemsets frequents

**Strategie** : Utiliser une approche par tableau systematique. Montrer chaque candidat et son comptage de support. Indiquer clairement les etapes d'elagage.

#### Type 3 : "Avec ces parametres DBSCAN, classifier ces points"
Etant donne un ensemble de points 2D, eps et min_samples :
- Pour chaque point, lister ses voisins
- Classifier en noyau, frontiere ou bruit
- Former les clusters
- Comparer avec le resultat K-means

**Strategie** : Dessiner les points, tracer des cercles de rayon eps autour de chacun. Compter les voisins methodiquement.

#### Type 4 : "Expliquer la difference entre..."
Questions de comparaison (CAH vs K-means, DBSCAN vs K-means, ACP normee vs non normee) :

**Strategie** : Utiliser un tableau de comparaison structure. Couvrir ces points :
- Quand utiliser chacun
- Avantages et inconvenients
- Parametres requis
- Type de clusters produits

#### Type 5 : "Combien de composantes conserver ?"
Etant donne des valeurs propres ou un scree plot :
- Appliquer la regle des 80%
- Appliquer le critere de Kaiser (valeur propre > 1)
- Identifier le coude

**Strategie** : Montrer les trois methodes et enoncer sa conclusion. Si elles ne sont pas d'accord, prioriser la regle des 80%.

## Checklist par sujet

### ACP (Examen Analyse de Donnees)

- [ ] Savoir quand utiliser l'ACP normee vs. non normee
  - Normee : variables avec des unites differentes ou des echelles tres differentes
  - Non normee : variables homogenes et comparables
- [ ] Etre capable de calculer les valeurs propres d'une matrice de correlation (cas 2x2)
- [ ] Lire les diagrammes des valeurs propres et determiner le nombre de composantes
- [ ] Interpreter le cercle des correlations (competence la plus importante)
- [ ] Interpreter le plan factoriel des individus
- [ ] Calculer les contributions et la qualite de representation
- [ ] Lier les axes aux variables originales via le cercle
- [ ] Expliquer l'ACP a un non-expert en 2-3 phrases
- [ ] Connaitre les etapes mathematiques : centrer, calculer la matrice de correlation, diagonaliser, projeter

### Clustering (Examen Fouille de Donnees)

- [ ] Derouler K-means pas a pas (2D, petit exemple)
- [ ] Derouler DBSCAN pas a pas
- [ ] Classifier les points en noyau/frontiere/bruit pour DBSCAN
- [ ] Connaitre la formule du critere de Ward et sa signification
- [ ] Lire un dendrogramme et choisir le nombre de clusters
- [ ] Comparer CAH, K-means, DBSCAN (format tableau)
- [ ] Calculer le score de silhouette pour un exemple simple
- [ ] Savoir ce que signifient l'inertie intra-classe et inter-classe
- [ ] Expliquer la methode du coude pour choisir K
- [ ] Savoir pourquoi DBSCAN est prefere pour les donnees spatiales

### Itemsets frequents (Examen Fouille de Donnees)

- [ ] Calculer le support a la main
- [ ] Appliquer Apriori etape par etape
- [ ] Utiliser l'anti-monotonie pour elaguer les candidats
- [ ] Calculer la confiance et le lift des regles d'association
- [ ] Connaitre la difference entre itemsets fermes, maximaux et frequents
- [ ] Savoir ce que fait minsup et comment le choisir

### Pretraitement

- [ ] Nommer les strategies de gestion des valeurs manquantes
- [ ] Connaitre la difference entre les methodes d'imputation (moyenne, mediane, mode)
- [ ] Expliquer pourquoi la standardisation est necessaire avant l'ACP
- [ ] Savoir ce que fait la transformation log et quand l'utiliser
- [ ] Expliquer la difference entre normalisation et standardisation

## Formules essentielles

### ACP

```
Standardize:    z = (x - mean) / std
Correlation:    r(x_j, F_k) = v_jk * sqrt(lambda_k)
Variance %:     lambda_k / sum(lambda_i) * 100
Contribution:   CTR(i,k) = F_ik^2 / (n * lambda_k)
cos^2:          F_ik^2 / sum_j(F_ij^2)
```

### Clustering

```
Ward:           Delta(A,B) = (n_A*n_B)/(n_A+n_B) * ||c_A - c_B||^2
Silhouette:     s(i) = (b(i) - a(i)) / max(a(i), b(i))
K-means:        min sum_k sum_{i in C_k} ||x_i - c_k||^2
DBSCAN:         core point if |N_eps(p)| >= min_samples
```

### Apriori

```
Support:        sup(X) = |{T : X in T}| / |DB|
Confidence:     conf(X->Y) = sup(X union Y) / sup(X)
Lift:           lift(X->Y) = conf(X->Y) / sup(Y)
Anti-mono:      sup(X) < minsup => sup(X union Y) < minsup
```

## Erreurs courantes a eviter

1. **Confondre le cercle des correlations avec le plan factoriel** : Le cercle montre les VARIABLES (mois, caracteristiques). Le plan factoriel montre les INDIVIDUS (villes, maisons). Ne jamais les melanger.

2. **Oublier de justifier DBSCAN plutot que K-means** : Quand on demande de choisir un algorithme, toujours expliquer POURQUOI. Pour des donnees spatiales avec du bruit, la reponse est presque toujours DBSCAN.

3. **Ne pas montrer l'elagage dans Apriori** : Les examinateurs veulent voir que vous appliquez l'anti-monotonie. Ecrire explicitement "elague car &#123;A,C&#125; n'est pas dans L_2" lors de la generation de C_3.

4. **Mal lire les variables proches de l'origine sur le cercle des correlations** : Si la fleche d'une variable est courte (pres du centre), elle N'EST PAS bien representee -- ne pas interpreter sa position.

5. **Dire "l'ACP reduit le bruit"** : Plus precisement, l'ACP conserve les directions de forte variance et ecarte celles de faible variance. Si le bruit est dans les directions de faible variance, il est supprime. Mais l'ACP ne "sait" pas ce qu'est le bruit.

6. **Utiliser DBSCAN sur des coordonnees non metriques** : Si on vous donne des coordonnees GPS, mentionner que la conversion en metres est necessaire pour que eps soit significatif.

7. **Oublier que K-means est non deterministe** : Differentes initialisations donnent des resultats differents. Toujours mentionner `random_state` ou `n_init`.

8. **Ne pas calculer la variance cumulee** : Quand on demande "combien de composantes ?", toujours montrer la variance cumulee atteignant le seuil de 80%.
