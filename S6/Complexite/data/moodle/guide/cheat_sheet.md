# Cheat Sheet -- Complexite (S6 INSA Rennes)

> **A utiliser** la veille du DS pour reviser rapidement les concepts cles et les pieges recurrents.

---

## 1. Structure typique du DS

D'apres l'analyse des annales 2017-2024, le DS suit generalement cette structure :

| Partie | Points | Contenu | Duree conseillee |
|--------|--------|---------|------------------|
| **Exercice 1** | 6 pts | Equations de recurrence (eq. caract. + series generatrices) | 30 min |
| **Exercice 2** | 4-6 pts | Questions de calcul de complexite / DPR / Glouton / B&B | 20-30 min |
| **Probleme** | 10-14 pts | Programmation dynamique (formule, algo naif, elimination redondances, algo iteratif) | 60-70 min |

**Remarque :** Le DS 2024 inclut aussi des questions sur l'evaluation de performance (gprof, metriques, loi d'Amdahl) issues du cours de Peva.

---

## 2. Complexites a connaitre par coeur

### Hierarchie des complexites

```
O(1) < O(log n) < O(sqrt(n)) < O(n) < O(n log n) < O(n^2) < O(n^3) < O(2^n) < O(n!)
```

### Complexites des algorithmes classiques

| Algorithme | Complexite | Paradigme |
|-----------|-----------|-----------|
| Recherche sequentielle | O(n) | Force brute |
| Recherche dichotomique | O(log n) | DPR |
| Tri par insertion | O(n^2) pire, O(n) meilleur | Incremental |
| Tri par selection | O(n^2) toujours | Incremental |
| Tri par fusion | O(n log n) toujours | DPR |
| Tri rapide (Quicksort) | O(n log n) moyen, O(n^2) pire | DPR |
| Fibonacci recursif naif | O(2^n) | Recursion |
| Fibonacci prog. dynamique | O(n) | Prog. dyn. |
| Kruskal (MST) | O(E log E) | Glouton |
| Prim (MST) | O(E log V) | Glouton |
| Dijkstra | O(V^2) ou O((V+E) log V) | Glouton |
| Karatsuba (multiplication) | O(n^1.585) | DPR |
| Strassen (matrices) | O(n^2.807) | DPR |
| Distance d'edition | O(n*m) | Prog. dyn. |
| Mult. n matrices (parenthesage) | O(n^3) | Prog. dyn. |

### Theoreme maitre : T(n) = a*T(n/b) + c*n

```
a < b  =>  O(n)
a = b  =>  O(n log n)
a > b  =>  O(n^(log_b(a)))
```

---

## 3. Memento : equations de recurrence

### Equation caracteristique : methode express

```
1. Ecrire l'eq. homogene  =>  r^k - a1*r^(k-1) - ... - ak = 0
2. Trouver les racines r1, r2, ...
3. Solution homogene :
   - racines distinctes : C1*r1^n + C2*r2^n + ...
   - racine r de multiplicite m : (C1 + C2*n + ... + Cm*n^(m-1))*r^n
4. Solution particuliere :
   - g(n) = c*alpha^n et alpha PAS racine : essayer A*alpha^n
   - g(n) = c*alpha^n et alpha racine de multiplicite m : essayer A*n^m*alpha^n
   - g(n) = polynome de degre d : essayer polynome de degre d
5. Solution generale = homogene + particuliere
6. Conditions initiales pour trouver les constantes
```

### Series generatrices : formules cles

```
F(x) = somme(n>=0) un * x^n

1/(1-x) = somme x^n
1/(1-ax) = somme a^n * x^n
1/(1-x)^2 = somme (n+1) * x^n
x/(1-x)^2 = somme n * x^n
```

### Sommes utiles

```
1 + 2 + ... + n = n(n+1)/2
1 + 2 + 4 + ... + 2^k = 2^(k+1) - 1
somme(i=0 a k) a^i = (a^(k+1) - 1) / (a - 1)    si a != 1
```

---

## 4. Memento : programmation dynamique

### Les 4 etapes

```
1. Identifier la formule de recurrence
2. Montrer : sous-structure optimale + sous-problemes chevauches
3. Remplir la table (bottom-up) ou memoiser (top-down)
4. (Optionnel) Reconstituer la solution
```

### Patron recurrent en DS

Le probleme de prog. dyn. en DS suit presque toujours ce schema :

```
Question 1 : Comprendre le probleme (exemple numerique)
Question 2 : Justifier la formule de recurrence
Question 3 : Ecrire l'algorithme recursif naif
Question 4 : Montrer les calculs redondants (arbre des appels)
Question 5 : Donner la complexite de l'algo naif (exponentielle)
Question 6 : Proposer un algo de prog. dynamique + complexite
Question 7 : (Bonus) Reconstituer la solution optimale
```

### Formules recurrentes des DS

**Triangulation de polygone (DS 2017, 2021) :**

```
t[i,j] = 0                                         si i = j
t[i,j] = min(k=i..j-1) {t[i,k] + t[k+1,j] + W(v_{i-1}, v_k, v_j)}  si i < j
Valeur optimale : t[1, n-1]
```

**Impression equilibree (DS 2023) :**

```
C(i) = 0                                            si mots i a n tiennent sur une ligne
C(i) = min(j) { f(i,j)^3 + C(j+1) }               sinon
  ou f(i,j) = M - (j-i) - somme(k=i..j) l_k
```

**Raccordement d'images (DS 2020) :** Prog. dyn. sur une grille.

**Sac a dos (DS 2020) :** Branch & Bound, pas prog. dyn. directe.

---

## 5. Memento : glouton vs prog. dynamique

**Question piege classique en DS :** "L'algorithme glouton donne-t-il l'optimum ?"

| Indice | Reponse probable |
|--------|-----------------|
| Le probleme a une structure de "choix definitif a chaque etape" | Potentiellement glouton |
| Le sujet demande ensuite la prog. dyn. | Le glouton n'est PAS optimal |
| Le sujet demande de prouver l'optimalite | Le glouton EST optimal |

**Regle d'or :** Si le sujet pose la question du glouton PUIS enchaine sur la prog. dyn., c'est que le glouton ne marche pas. Il faut donner un **contre-exemple**.

---

## 6. Memento : exploration et Branch & Bound

### Schema du Branch & Bound

```
1. Solution initiale (souvent par glouton) => nbopt
2. Pour chaque noeud N :
   - Calculer epd(N) = e(N) + d(N)  (cout actuel + heuristique)
   - Si epd(N) >= nbopt : COUPER (elaguer)
   - Sinon : explorer les enfants
3. Si feuille trouvee avec cout < nbopt : mettre a jour nbopt
```

### Points cles pour le DS

- L'heuristique doit etre un **minorant** (pour minimisation)
- Plus l'heuristique est precise, plus on elague
- Toujours initialiser nbopt avec une solution gloutonne

---

## 7. Evaluation de performance (cours Peva - DS 2024)

### Metriques, facteurs, charge de travail

```
Metriques : ce qu'on mesure (debit, latence, utilisation CPU)
Facteurs : ce qu'on fait varier (nombre de threads, taille des donnees)
Charge de travail : les operations qu'on envoie au systeme
```

### Loi d'Amdahl

```
Speedup = 1 / ((1 - p) + p/S)

ou :
  p = fraction du code amelioree
  S = facteur d'acceleration de cette fraction
```

**Application (DS 2024) :** Comparer deux optimisations :
- Optimisation A : func1 (17% du temps) 10x plus rapide
  - Speedup = 1 / ((1 - 0.17) + 0.17/10) = 1 / (0.83 + 0.017) = 1.18
- Optimisation B : func2 (70% du temps) 1.25x plus rapide
  - Speedup = 1 / ((1 - 0.70) + 0.70/1.25) = 1 / (0.30 + 0.56) = 1.16

=> Choisir l'optimisation A (speedup 1.18 > 1.16).

### Profiling avec gprof

```
% time : pourcentage du temps total passe dans la fonction
cumulative seconds : temps cumule
self seconds : temps passe dans la fonction elle-meme
calls : nombre d'appels
```

---

## 8. Questions recurrentes des DS (par theme)

### Recurrences (presque tous les ans)

- Resoudre par equation caracteristique (toujours)
- Resoudre par series generatrices (toujours)
- Attention aux racines multiples et aux cas ou alpha est racine

### Calcul de complexite (frequemment)

- Boucles imbriquees (dependantes ou non)
- Identifier un algorithme de tri a partir de sa trace
- Complexite d'un algorithme recursif

### Programmation dynamique (toujours)

- Justifier la formule de recurrence
- Ecrire l'algo naif
- Montrer les calculs redondants
- Proposer la version dynamique
- Donner la complexite (souvent O(n^2) ou O(n^3))

### Branch & Bound (parfois)

- Dessiner l'arbre de recherche
- Appliquer l'elagage avec une heuristique
- Le probleme du sac a dos est un classique

---

## 9. Pieges les plus frequents

```
[x] Oublier de verifier si alpha est racine de l'eq. caracteristique
    => Solution particuliere fausse

[x] Confondre O et Theta
    => O est une borne sup, Theta est un encadrement exact

[x] Dire "le glouton est optimal" sans preuve
    => Il faut prouver par echange ou contradiction

[x] Oublier l'initialisation de la table en prog. dyn.
    => Les cas de base doivent etre remplis

[x] Compter la complexite d'une boucle dependante comme n^2/2
    => C'est O(n^2), les constantes disparaissent

[x] Confondre sous-problemes independants (DPR) et chevauches (prog. dyn.)
    => DPR : pas de redondance / Prog. dyn. : redondance

[x] En Branch & Bound, oublier d'initialiser la borne avec le glouton
    => Pas d'elagage au debut

[x] Oublier que le theoreme maitre suppose des sous-problemes de meme taille
    => Ne s'applique pas au pire cas du tri rapide
```

---

## 10. Formules express

### Logarithmes

```
log_b(a) = ln(a) / ln(b)
log_2(8) = 3
log_2(1024) = 10
log_2(10^6) ~ 20
log_2(10^9) ~ 30
```

### Factorielles

```
n! ~ sqrt(2*pi*n) * (n/e)^n    (formule de Stirling)
10! = 3628800
20! ~ 2.4 * 10^18
```

### Puissances de 2

```
2^10 = 1024 ~ 10^3
2^20 ~ 10^6
2^30 ~ 10^9
2^40 ~ 10^12
```

---

## 11. Checklist avant le DS

```
[ ] Je sais resoudre une recurrence par equation caracteristique
[ ] Je sais utiliser les series generatrices (au moins la mise en equation)
[ ] Je connais le theoreme maitre et ses 3 cas
[ ] Je sais ecrire un algo de prog. dynamique (top-down et bottom-up)
[ ] Je sais montrer les calculs redondants dans un arbre d'appels
[ ] Je sais quand le glouton est optimal et quand il ne l'est pas
[ ] Je sais appliquer Branch & Bound avec une heuristique
[ ] Je connais les complexites des tris classiques
[ ] Je sais calculer la complexite de boucles imbriquees
[ ] (2024+) Je connais les bases de l'evaluation de performance (Amdahl, gprof)
```
