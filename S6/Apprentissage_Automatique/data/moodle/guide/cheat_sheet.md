# Cheat Sheet -- Apprentissage Automatique (DS)

> Fiche de revision concise pour le DS d'Apprentissage Automatique. Basee sur l'analyse des annales 2013-2023.

---

## Structure typique du DS

D'apres l'analyse des annales (2013-2023), le DS suit generalement ce format :

| Element | Detail |
|---------|--------|
| **Duree** | 2h a 2h30 |
| **Nombre d'exercices** | 3 a 5 exercices |
| **Parties** | Souvent 2 parties (2 enseignants differents : Christian Raymond / Vincent Claveau) |
| **Documents** | Generalement aucun document autorise |
| **Format** | Questions de cours + exercices de calcul + questions sur les TP |

### Repartition typique des themes

| Theme | Frequence dans les annales | Type de questions |
|-------|---------------------------|-------------------|
| **Arbres de decision** | Quasi-systematique | Calcul d'entropie, gain, construction d'arbre, elagage |
| **Methodes bayesiennes** | Tres frequent | Calcul de Bayes, Naive Bayes, classification de texte |
| **KNN** | Frequent | Choix de K, calcul de distance, prediction |
| **Evaluation** | Frequent | Matrice de confusion, precision, rappel, F1, validation croisee |
| **Boosting / AdaBoost** | Occasionnel (surtout depuis 2018) | Algorithme, calcul de poids, prediction |
| **Inference grammaticale** | Occasionnel | Automates, fusion d'etats, PTA |
| **Generalites** | Toujours | Biais-variance, sur/sous-apprentissage |

---

## Questions recurrentes par theme

### 1. Arbres de decision (presque tous les ans)

**Questions typiques :**
- [ ] Calculer l'entropie d'un ensemble de donnees
- [ ] Calculer le gain d'information pour chaque attribut
- [ ] Determiner quel attribut choisir comme racine
- [ ] Construire l'arbre complet etape par etape
- [ ] Expliquer le probleme du sur-apprentissage dans les arbres
- [ ] Decrire les methodes d'elagage (pre/post)
- [ ] Expliquer la difference entre ID3, C4.5 et CART
- [ ] Classifier un nouvel exemple avec l'arbre construit

**Questions de TP :**
- [ ] Expliquer ce qu'affichent les noeuds/feuilles d'un arbre scikit-learn
- [ ] Interpreter la courbe accuracy vs alpha (CCP)

### 2. Methodes bayesiennes (tres frequent)

**Questions typiques :**
- [ ] Ecrire et appliquer le theoreme de Bayes
- [ ] Calculer les probabilites a priori, vraisemblance, et a posteriori
- [ ] Expliquer l'hypothese d'independance du Naive Bayes
- [ ] Classifier un nouvel exemple avec Naive Bayes (calcul complet)
- [ ] Expliquer le lissage de Laplace et pourquoi il est necessaire
- [ ] Comparer Naive Bayes avec les arbres de decision

### 3. KNN (frequent)

**Questions typiques :**
- [ ] Classifier un exemple avec K voisins donnes
- [ ] Expliquer l'influence de K sur le biais et la variance
- [ ] Calculer la distance euclidienne entre deux points
- [ ] Expliquer pourquoi K=1 donne 100% sur le train
- [ ] Decrire le probleme de la malediction de la dimensionnalite
- [ ] Expliquer la difference entre KNN classification et regression

### 4. Evaluation (toujours present)

**Questions typiques :**
- [ ] Remplir une matrice de confusion a partir de predictions
- [ ] Calculer accuracy, precision, rappel, F1
- [ ] Expliquer pourquoi on ne doit pas evaluer sur le train
- [ ] Decrire la validation croisee K-fold
- [ ] Expliquer le compromis biais-variance
- [ ] Identifier si un modele est en sur/sous-apprentissage a partir de scores train/test

### 5. Boosting / AdaBoost

**Questions typiques :**
- [ ] Decrire le principe general du boosting
- [ ] Calculer le poids de vote alpha d'un classifieur
- [ ] Mettre a jour les poids des exemples apres une iteration
- [ ] Faire une prediction avec un ensemble de classifieurs ponderes
- [ ] Expliquer ce qu'est un decision stump

---

## Formules essentielles a connaitre

### Entropie

```
H(S) = - somme_i ( p_i * log2(p_i) )
```

**Cas particuliers :**
- Ensemble pur (une seule classe) : H = 0
- 50/50 (deux classes) : H = 1
- 3 classes equiprobables : H = log2(3) = 1.585

### Gain d'information

```
Gain(S, A) = H(S) - somme_v ( |S_v| / |S| * H(S_v) )
```

### Indice de Gini

```
Gini(S) = 1 - somme_i ( p_i^2 )
```

### Theoreme de Bayes

```
P(C | X) = P(X | C) * P(C) / P(X)

P(X) = somme_c P(X | c) * P(c)
```

### Naive Bayes (hypothese d'independance)

```
P(x1, x2, ..., xn | C) = produit_i P(xi | C)
```

### Distance euclidienne

```
d(x, y) = racine( somme_i (x_i - y_i)^2 )
```

### AdaBoost -- Poids de vote

```
alpha_t = (1/2) * ln( (1 - epsilon_t) / epsilon_t )
```

### AdaBoost -- Mise a jour des poids

```
w_i(t+1) = w_i(t) * exp(-alpha_t * y_i * h_t(x_i)) / Z_t

Z_t = 2 * racine( epsilon_t * (1 - epsilon_t) )
```

### AdaBoost -- Prediction

```
H(x) = signe( somme_t alpha_t * h_t(x) )
```

### Metriques d'evaluation

```
Accuracy  = (VP + VN) / (VP + VN + FP + FN)
Precision = VP / (VP + FP)
Rappel    = VP / (VP + FN)
F1        = 2 * Precision * Rappel / (Precision + Rappel)
```

---

## Algorithmes a connaitre (pseudo-code)

### Construction d'un arbre de decision (ID3)

```
ConstruireArbre(S, attributs):
    si tous les exemples de S sont de la meme classe c:
        retourner Feuille(c)
    si attributs est vide:
        retourner Feuille(classe_majoritaire(S))
    
    A* = argmax_A Gain(S, A)
    creer Noeud(A*)
    
    pour chaque valeur v de A*:
        S_v = {x dans S | x.A* = v}
        si S_v est vide:
            ajouter Feuille(classe_majoritaire(S))
        sinon:
            ajouter ConstruireArbre(S_v, attributs \ {A*})
```

### KNN

```
KNN(x, K, X_train, Y_train):
    distances = [distance(x, x_i) pour x_i dans X_train]
    k_voisins = les K exemples avec les plus petites distances
    retourner classe_majoritaire(k_voisins)
```

### Naive Bayes

```
NaiveBayes(x, classes, X_train, Y_train):
    pour chaque classe c:
        score(c) = log P(c) + somme_i log P(x_i | c)
    retourner argmax_c score(c)
```

---

## Tableaux de comparaison rapide

### Comparaison des algorithmes

| Algorithme | Avantages | Inconvenients | Quand l'utiliser |
|-----------|-----------|--------------|-----------------|
| **Arbre de decision** | Interpretable, pas de normalisation | Sur-apprentissage facile | Donnees categorielles, besoin d'interpretabilite |
| **Naive Bayes** | Rapide, bon en haute dimension | Hypothese d'independance | Texte, spam, classification de documents |
| **KNN** | Simple, pas d'hypothese | Lent en prediction, malediction dim. | Petits datasets, peu de features |
| **AdaBoost** | Precis, resistant a l'overfitting | Sensible au bruit, lent | Donnees propres, classification binaire |
| **Random Forest** | Tres precis, peu d'hyperparametres | Boite noire, lourd en memoire | Usage general, benchmark de base |

### Biais-Variance par algorithme

| Algorithme | Biais | Variance | Complexite |
|-----------|-------|----------|-----------|
| **Arbre profond** | Faible | Forte | Elevee |
| **Arbre elague** | Moyen | Moyenne | Moderee |
| **KNN (K petit)** | Faible | Forte | - |
| **KNN (K grand)** | Fort | Faible | - |
| **Naive Bayes** | Fort (hyp. independance) | Faible | Faible |
| **AdaBoost** | Diminue avec T | Augmente lentement | Augmente avec T |

---

## Conseils pour le DS

### Gestion du temps

| Etape | Temps recommande |
|-------|-----------------|
| Lecture du sujet | 10 min |
| Questions de cours (definitions, explications) | 20-30 min |
| Exercices de calcul (entropie, Bayes, KNN) | 40-50 min |
| Questions sur les TP (code, interpretation) | 20-30 min |
| Relecture | 10 min |

### Strategies

1. **Commencer par les questions de cours** : elles sont souvent faciles et rapportent des points.
2. **Pour les calculs d'entropie** : poser le calcul proprement avant de calculer. Les erreurs viennent souvent d'un oubli de terme ou d'une mauvaise fraction.
3. **Pour le theoreme de Bayes** : toujours ecrire la formule complete avant de remplacer. Ne pas oublier P(X) (l'evidence).
4. **Pour les arbres** : dessiner l'arbre etape par etape, meme si c'est long. Les correcteurs veulent voir le raisonnement.
5. **Si bloque** : passer a la question suivante. Les exercices sont souvent independants.

### Pieges frequents dans les annales

| Piege | Comment l'eviter |
|-------|-----------------|
| Evaluer sur le train et conclure que le modele est bon | Toujours evaluer sur un jeu de test separe |
| Oublier le lissage de Laplace dans Naive Bayes | Ajouter 1 au numerateur quand une probabilite est nulle |
| Confondre log2 et ln dans l'entropie | Le cours utilise log en base 2 (sauf mention contraire) |
| Se tromper dans les fractions du gain d'information | Bien ponderer par la taille du sous-ensemble / taille totale |
| Dire que Naive Bayes suppose l'independance des features "tout court" | C'est l'independance **conditionnelle** sachant la classe |
| Confondre precision et rappel | Precision = "parmi mes positifs predits". Rappel = "parmi les vrais positifs" |
| Oublier l'etat puits dans un automate | Un AFD complet a une transition pour chaque (etat, symbole) |
| Dire qu'AdaBoost overfitte quand T augmente | AdaBoost est relativement resistant au sur-apprentissage |

---

## Vocabulaire cle (francais / anglais)

| Francais | Anglais |
|----------|---------|
| Apprentissage supervise | Supervised learning |
| Arbre de decision | Decision tree |
| Classifieur faible | Weak learner |
| Elagage | Pruning |
| Entropie | Entropy |
| Gain d'information | Information gain |
| Inference grammaticale | Grammatical inference |
| Matrice de confusion | Confusion matrix |
| Methodes d'ensemble | Ensemble methods |
| Precision | Precision |
| Rappel | Recall |
| Sur-apprentissage | Overfitting |
| Sous-apprentissage | Underfitting |
| Taux d'erreur | Error rate |
| Validation croisee | Cross-validation |
| Vraisemblance | Likelihood |

---

## Checklist de revision

Avant le DS, verifie que tu sais :

**Theorie :**
- [ ] Expliquer la difference entre apprentissage supervise et non supervise
- [ ] Definir et expliquer le compromis biais-variance
- [ ] Definir sur-apprentissage et sous-apprentissage avec des exemples
- [ ] Expliquer pourquoi on separe train et test

**Arbres de decision :**
- [ ] Calculer l'entropie d'un ensemble
- [ ] Calculer le gain d'information pour un attribut
- [ ] Construire un arbre ID3 complet sur un petit jeu de donnees
- [ ] Expliquer l'elagage (pourquoi et comment)

**Bayesien :**
- [ ] Appliquer le theoreme de Bayes sur un exercice numerique
- [ ] Classifier un exemple avec Naive Bayes (calcul complet)
- [ ] Expliquer le lissage de Laplace

**KNN :**
- [ ] Classifier un exemple avec KNN (calcul des distances + vote)
- [ ] Expliquer l'influence de K sur le modele
- [ ] Utiliser GridSearchCV pour trouver le meilleur K

**Evaluation :**
- [ ] Remplir et interpreter une matrice de confusion
- [ ] Calculer accuracy, precision, rappel, F1
- [ ] Expliquer et appliquer la validation croisee K-fold

**Boosting :**
- [ ] Decrire l'algorithme AdaBoost etape par etape
- [ ] Calculer alpha et les nouveaux poids d'exemples
- [ ] Faire une prediction avec un ensemble de stumps ponderes

**Code (TP) :**
- [ ] Savoir utiliser `train_test_split`, `cross_val_score`, `GridSearchCV`
- [ ] Savoir utiliser `DecisionTreeClassifier`, `KNeighborsClassifier`, `MultinomialNB`
- [ ] Savoir lire et interpreter un `classification_report`
- [ ] Savoir interpreter un arbre affiche par `plot_tree`
