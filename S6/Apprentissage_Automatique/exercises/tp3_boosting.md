# TP3 - Arbres de decision et boosting avec BonzaiBoost

> Instructions du TP issues de : `data/moodle/tp/tp3_boosting/README.md` et `data/moodle/tp/tp3_boosting/TP3_but_4.pdf`

---

## Dataset : Adult Income (Census)

**Probleme :** Predire si une personne gagne plus de 50K$/an a partir de donnees de recensement.

- `adult.data` : Donnees d'entrainement (32 561 enregistrements)
- `adult.test` : Donnees de test (16 281 enregistrements)
- `adult.names` : Description du dataset et definition des attributs

**Attributs (14 features) :**

| Feature | Type | Valeurs |
|---------|------|---------|
| age | Continue | Age de la personne |
| workclass | Nominale | Private, Self-emp-not-inc, Federal-gov, etc. |
| fnlwgt | Ignoree | Poids du recensement (non utilise) |
| education | Nominale | Bachelors, Some-college, HS-grad, etc. |
| education-num | Continue | Nombre d'annees d'etudes |
| marital-status | Nominale | Married-civ-spouse, Divorced, Never-married, etc. |
| occupation | Nominale | Tech-support, Exec-managerial, Prof-specialty, etc. |
| relationship | Nominale | Wife, Own-child, Husband, etc. |
| race | Nominale | White, Asian-Pac-Islander, Black, etc. |
| sex | Nominale | Female, Male |
| capital-gain | Ignoree | (non utilise) |
| capital-loss | Ignoree | (non utilise) |
| hours-per-week | Continue | Heures travaillees par semaine |
| native-country | Nominale | United-States, England, etc. (41 pays) |

**Classes cibles :**
- `sup50K` (~24%) : Revenu > 50K$/an
- `infeq50K` (~76%) : Revenu &lt;= 50K$/an

---

## Exercice 1 : Baseline naive

### Quelle est l'accuracy train/test du classifieur naif ?

Le classifieur naif predit la classe majoritaire pour toutes les instances.

**Reponse :**

```bash
# Se deplacer dans le repertoire du dataset
cd adult/

# Generer le classifieur naif (profondeur 0 = pas de question = classe majoritaire)
../bonzaiboost -S adult -d 0

# Evaluer sur les donnees d'entrainement
../bonzaiboost -S adult -C < adult.data > /dev/null

# Evaluer sur les donnees de test
../bonzaiboost -S adult -C < adult.test > /dev/null
```

**Sortie attendue :**
- Accuracy entrainement : ~75.9% (= proportion de `infeq50K` dans adult.data)
- Accuracy test : ~76.1% (proportion similaire dans adult.test)

### Pourquoi cela peut-il etre trompeur ?

**Reponse :**

Le classifieur naif donne ~76% d'accuracy simplement en predisant `infeq50K` (gagne &lt;= 50K$) pour tout le monde. C'est trompeur car :
- Il classe correctement 100% de la classe majoritaire mais 0% de la classe minoritaire (`sup50K`).
- Tout modele qui ne depasse pas significativement 76% est essentiellement inutile.
- Avec des donnees desequilibrees (76% vs 24%), l'accuracy seule est trompeuse. Un modele a 78% n'ameliore que de 2 points la prediction la plus triviale possible.

**Explication :** La baseline etablit le seuil minimal de performance. Un modele utile devrait viser bien au-dessus de 82-85% pour justifier la complexite ajoutee.

---

## Exercice 2 : Arbre de decision manuel (4 feuilles)

### Concevoir un arbre binaire a 4 feuilles par intuition, puis l'evaluer.

**Reponse :**

Le fichier `arbre.txt` montre le format pour les regles manuelles :

```
racine=race White
no=sex Male yes=sup50K no=infeq50K
yes=native-country United-States yes=sup50K no=infeq50K
```

**Explication de la structure :**
- Ligne 1 : La racine demande "race = White ?"
- Ligne 2 : Branche "no" (pas White) → demande "sex = Male ?" → si oui : `sup50K`, si non : `infeq50K`
- Ligne 3 : Branche "yes" (White) → demande "native-country = United-States ?" → si oui : `sup50K`, si non : `infeq50K`

### Procedure pour construire et evaluer votre propre arbre

```bash
# 1. Creer votre fichier de regles (ex : mon_arbre.txt)
#    Exemple : essayer marital-status ou education comme racine
#    racine=marital-status Married-civ-spouse
#    no=education Bachelors yes=sup50K no=infeq50K
#    yes=hours-per-week 40 yes=sup50K no=infeq50K

# 2. Convertir au format BonzaiBoost
perl ../rules2tree.pl adult mon_arbre.txt

# 3. Evaluer sur les donnees d'entrainement
../bonzaiboost -S adult -C < adult.data > /dev/null

# 4. Evaluer sur les donnees de test
../bonzaiboost -S adult -C < adult.test > /dev/null
```

### Question 1 : Votre arbre manuel surpasse-t-il le classifieur naif ?

**Reponse :** Probablement pas, ou a peine. L'intuition humaine est rarement meilleure que les statistiques des donnees pour choisir les bons splits et les predictions des feuilles. L'arbre d'exemple dans `arbre.txt` utilise la race et la nationalite, qui sont de faibles predicteurs du revenu compare au niveau d'education ou au statut marital.

### Question 2 : Si on garde les regles mais change les decisions des feuilles pour correspondre aux statistiques d'entrainement, les resultats s'ameliorent-ils ?

**Reponse :** Oui, significativement. Les splits (questions posees) sont moins importants que les predictions des feuilles. Meme avec des splits sous-optimaux, si les feuilles predisent la classe majoritaire parmi les exemples d'entrainement qui les atteignent, le resultat s'ameliore. Cela demontre que l'accuracy d'un arbre de decision depend fortement de l'attribution correcte des feuilles.

---

## Exercice 3 : Construction automatique d'arbre

### 3a : Arbre a profondeur limitee (d=2, 4 feuilles)

```bash
# Construire un arbre de profondeur 2 (4 feuilles maximum)
../bonzaiboost -S adult -d 2

# Evaluer sur les donnees d'entrainement
../bonzaiboost -S adult -C < adult.data > /dev/null

# Evaluer sur les donnees de test
../bonzaiboost -S adult -C < adult.test > /dev/null

# Visualiser l'arbre
dot -Tpng adult.tree.dot > adult_d2.png
```

**Sortie attendue :**
- Accuracy entrainement : ~80-82%
- Accuracy test : ~79-81%
- Ecart train/test : ~1-2 points (peu d'overfitting)

### L'arbre automatique surpasse-t-il votre arbre manuel ? Interpretez-le : quelles features a-t-il choisies ? Pourquoi ?

**Reponse :**

L'arbre automatique de profondeur 2 est significativement meilleur que la baseline naive (+4-6 points) et surpasse presque certainement tout arbre manuel. Les features choisies automatiquement sont typiquement :

- **marital-status** (etre marie augmente significativement la probabilite de revenu eleve)
- **education-num** (plus d'annees d'etudes = revenu plus eleve)
- **age** (les 35-55 ans gagnent le plus)

Ces features sont choisies car elles maximisent le gain d'information. Le faible ecart train/test (~1-2 points) indique un **sous-apprentissage modere** : l'arbre est trop simple pour capturer tous les patterns.

### 3b : Critere d'arret MDLPC

MDLPC (Minimum Description Length Principle for Classification) determine automatiquement la taille optimale de l'arbre en se basant sur la theorie de l'information. Il arrete la croissance de l'arbre quand l'ajout d'un nouveau noeud n'est pas justifie par le gain d'information relativement a la complexite ajoutee.

```bash
# Construire l'arbre avec MDLPC
../bonzaiboost -S adult -mdlpc

# Evaluer sur les donnees d'entrainement
../bonzaiboost -S adult -C < adult.data > /dev/null

# Evaluer sur les donnees de test
../bonzaiboost -S adult -C < adult.test > /dev/null

# Visualiser
dot -Tpng adult.tree.dot > adult_mdlpc.png
```

**Sortie attendue :**
- Accuracy entrainement : ~83-85%
- Accuracy test : ~82-84%
- Ecart train/test : ~1-2 points

### Comment MDLPC se compare-t-il a la profondeur limitee ? Quel est l'ecart d'overfitting ?

**Reponse :**

MDLPC produit un arbre plus profond que d=2 mais pas aussi profond que Tmax. Les performances sont meilleures que l'arbre a profondeur limitee (+2-3 points). L'ecart train/test reste faible, indiquant un bon **compromis biais-variance**. MDLPC est un critere d'arret automatique base sur des principes solides qui evite a la fois le sous-apprentissage et le sur-apprentissage.

### 3c : Arbre complet (pas de critere d'arret)

```bash
# Construire l'arbre complet (mode verbose, pas d'arret)
../bonzaiboost -S adult -v

# Evaluer sur les donnees d'entrainement
../bonzaiboost -S adult -C < adult.data > /dev/null

# Evaluer sur les donnees de test
../bonzaiboost -S adult -C < adult.test > /dev/null
```

**Sortie attendue :**
- Accuracy entrainement : **~100%**
- Accuracy test : ~82-84%
- Ecart train/test : **~16-18 points** (overfitting severe)

### Comment les accuracies train et test se comparent-elles ? Quel phenomene se produit ?

**Reponse :**

L'arbre complet atteint une accuracy parfaite sur le train (100%) en memorisant chaque exemple d'entrainement. Cependant, l'accuracy test (~82-84%) n'est pas meilleure que l'arbre MDLPC. C'est la demonstration classique du **sur-apprentissage** : un modele trop complexe qui apprend le bruit des donnees d'entrainement au lieu de patterns generalisables. L'arbre a des centaines voire des milliers de noeuds, ce qui le rend aussi completement ininterpretable.

### Resume de l'exercice 3

| Critere d'arret | Acc. train | Acc. test | Ecart | Diagnostic |
|-----------------|-----------|----------|-------|-----------|
| Profondeur 2 (4 feuilles) | ~80-82% | ~79-81% | ~1-2% | Sous-apprentissage modere |
| MDLPC (automatique) | ~83-85% | ~82-84% | ~1-2% | **Bon compromis** |
| Aucun (arbre complet) | ~100% | ~82-84% | ~16-18% | **Sur-apprentissage severe** |

**Observation cle :** L'accuracy test de l'arbre complet n'est PAS meilleure que MDLPC malgre 100% sur le train. Le sur-apprentissage n'ameliore pas la generalisation.

---

## Exercice 4 : AdaBoost

### Question 5 : Comment les resultats du boosting se comparent-ils aux arbres simples ?

**Reponse :**

```bash
# Entrainer AdaBoost avec 100 iterations de stumps
../bonzaiboost -S adult -boost adamh -n 100

# Evaluer sur les donnees d'entrainement
../bonzaiboost -S adult -boost adamh -C < adult.data > /dev/null

# Evaluer sur les donnees de test
../bonzaiboost -S adult -boost adamh -C < adult.test > /dev/null
```

**Sortie attendue :**
- Accuracy entrainement : ~87-90%
- Accuracy test : **~85-87%**
- Ecart train/test : ~2-3 points

AdaBoost (85-87% test) surpasse significativement :
- Le classifieur naif (+10-11 points)
- L'arbre de profondeur 2 (+5-7 points)
- L'arbre MDLPC (+2-4 points)
- L'arbre complet (+2-4 points sur le test, malgre 100% train pour l'arbre complet)

**Explication :** Le boosting de 100 stumps (classifieurs tres faibles, a peine meilleurs que le hasard) produit un classifieur plus puissant que n'importe quel arbre complexe unique. C'est le principe fondamental du boosting : combiner des classifieurs faibles produit un classifieur fort.

### Question 6 : Analyse du taux d'erreur -- Analyser les courbes d'erreur train/test

```bash
# Generer un rapport HTML detaille avec les resultats iteration par iteration
../bonzaiboost -S adult -boost adamh -n 100 --info > adult.boost.log.html

# Ouvrir dans un navigateur pour voir les courbes
```

**Reponse :**

| Propriete de la courbe | Observation |
|------------------------|-------------|
| Erreur train | Diminue de maniere monotone (ou quasi-monotone) avec les iterations |
| Erreur test | Diminue rapidement (iterations 1-20), puis se stabilise ou diminue lentement |
| Overfitting | Leger : l'ecart train/test augmente avec les iterations mais reste modere |
| Convergence | L'essentiel du gain vient des 20-50 premieres iterations |
| Iterations optimales | ~50-100 (au-dela, gains marginaux) |

**Explication :** Contrairement a un arbre unique qui fait du sur-apprentissage severe quand la complexite augmente, le boosting montre un overfitting bien plus modere. L'erreur test continue a diminuer (ou se stabiliser) meme apres que l'erreur train atteint des valeurs tres basses. C'est une propriete remarquable d'AdaBoost, expliquee par l'augmentation progressive des marges de classification.

### Question 7 : Importance des features -- Quelles features sont les plus discriminantes pour predire un revenu > 50K ?

**Reponse :**

Le rapport HTML indique quelles features sont utilisees par les stumps a chaque iteration.

| Feature | Importance |
|---------|-----------|
| marital-status | Tres elevee -- "Married-civ-spouse" est le meilleur predicteur |
| education / education-num | Elevee -- plus d'education = revenu plus eleve |
| age | Elevee -- les 35-55 ans gagnent le plus |
| hours-per-week | Moyenne -- travailler > 40h/semaine augmente la probabilite |
| occupation | Moyenne -- "Exec-managerial" et "Prof-specialty" associes a >50K |
| workclass | Faible a moyenne |
| relationship | Correlee avec marital-status |

**Explication :** Les features selectionnees par le boosting correspondent a des facteurs socio-economiques intuitifs. Le statut marital domine car etre marie (surtout "Married-civ-spouse") est un fort indicateur du niveau de revenu du foyer et de la stabilite economique.

---

## Comparaison globale des modeles

| Modele | Acc. train | Acc. test | Ecart | Complexite |
|--------|-----------|----------|-------|-----------|
| Naif (majorite) | ~76% | ~76% | 0% | Aucune |
| Arbre manuel (4 feuilles) | Variable | Variable | Variable | Tres faible |
| Arbre auto d=2 | ~80-82% | ~79-81% | ~1-2% | Faible |
| Arbre MDLPC | ~83-85% | ~82-84% | ~1-2% | Moyenne |
| Arbre complet | ~100% | ~82-84% | ~16-18% | Tres elevee |
| **AdaBoost (n=100)** | ~87-90% | **~85-87%** | ~2-3% | Elevee (100 stumps) |

**Enseignements cles :**

1. **Toujours etablir une baseline.** Un modele a 78% sur un dataset avec 76% de classe majoritaire n'apporte presque rien.
2. **Overfitting = train >> test.** L'arbre complet a 100% train mais ~83% test. MDLPC a ~84% train et ~83% test : meilleure generalisation avec un modele beaucoup plus simple.
3. **MDLPC** est un bon critere d'arret automatique base sur le principe de longueur de description minimale.
4. **Le boosting surpasse les arbres simples.** 100 stumps combines battent n'importe quel arbre complexe unique. Le boosting reduit le biais (sous-apprentissage) tout en controlant la variance (sur-apprentissage).
5. **Rendements decroissants.** Passer de 1 a 20 stumps apporte beaucoup ; passer de 50 a 100 apporte peu.

---

## Formules AdaBoost (reference pour l'examen)

### Poids du classifieur faible t

```
alpha_t = (1/2) * ln((1 - epsilon_t) / epsilon_t)
```

- epsilon_t = erreur ponderee du classifieur faible t (entre 0 et 0.5 pour un classifieur utile)
- Si epsilon_t = 0.5 (pas mieux que le hasard), alpha_t = 0 (pas de contribution)
- Si epsilon_t est proche de 0, alpha_t est grand (classifieur tres fiable)

### Mise a jour des poids des exemples

```
w_i^(t+1) = w_i^(t) * exp(-alpha_t * y_i * h_t(x_i)) / Z_t
```

- y_i = vraie classe de l'exemple i (+1 ou -1)
- h_t(x_i) = prediction du classifieur faible t pour l'exemple i (+1 ou -1)
- Si prediction correcte (y_i * h_t(x_i) > 0) : le poids diminue
- Si prediction incorrecte (y_i * h_t(x_i) &lt; 0) : le poids augmente
- Z_t = facteur de normalisation

### Prediction finale (vote pondere)

```
H(x) = sign(sum_{t=1}^{T} alpha_t * h_t(x))
```

Sommer les votes ponderes des T classifieurs faibles. Le signe de la somme determine la classe predite.
