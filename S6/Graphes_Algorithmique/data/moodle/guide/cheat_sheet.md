# Cheat Sheet -- Graphes et Algorithmique (S6)

> Resume ultra-condense pour reviser avant le DS. Chaque section tient en quelques lignes. Pour les explications detaillees, reporte-toi aux chapitres correspondants.

---

## Structure du DS (analyse des annales 2015-2024)

Les DS de graphes a l'INSA Rennes suivent generalement cette structure :

| Partie | Contenu typique | Poids approximatif |
|--------|----------------|-------------------|
| 1 | Definitions, proprietes de base, degres, representations | 15-20% |
| 2 | Connexite, composantes, parcours BFS/DFS | 10-15% |
| 3 | Cycles (Euler/Hamilton), arbres, proprietes | 15-20% |
| 4 | Coloration (nombre chromatique, algorithme glouton) | 10-15% |
| 5 | Arbre couvrant minimal (Kruskal ou Prim) | 10-15% |
| 6 | Plus courts chemins (Dijkstra et/ou Bellman-Ford) | 15-20% |
| 7 | Ordonnancement (dates, marges, chemin critique) | 10-15% |
| 8 | Flots (Ford-Fulkerson, coupe min) | 10-15% |

> **Tendance :** Les sujets recents insistent sur le deroulage d'algorithmes pas a pas (montrer les etapes), les preuves courtes, et l'interpretation des resultats.

---

## 1. Definitions de base -- [Chapitre complet](01_definitions_base.md)

### Formules cles

| Formule | Description |
|---------|-------------|
| Somme d(v) = 2m | Theoreme des poignees de main (non oriente) |
| Somme d+(v) = Somme d-(v) = m | Version orientee |
| Nb sommets de degre impair est pair | Consequence directe |
| K_n : m = n(n-1)/2 | Graphe complet |
| K_{p,q} : m = p*q | Biparti complet |
| n - m + f = 2 | Formule d'Euler (graphe planaire connexe) |
| m <= 3n - 6 | Graphe planaire simple (n >= 3) |

### Representations

| | Matrice adjacence | Liste adjacence |
|---|---|---|
| Espace | O(n^2) | O(n+m) |
| Adjacence u-v ? | O(1) | O(deg(u)) |
| Voisins de v | O(n) | O(deg(v)) |

### Types speciaux

- **Biparti** = pas de cycle impair = 2-colorable
- **Planaire** = dessinable sans croisement
- **k-regulier** = tous les sommets ont degre k

---

## 2. Connexite -- [Chapitre complet](02_connexite.md)

### Non oriente

- **Connexe** : chaine entre tout couple de sommets.
- **Composantes connexes** : BFS/DFS en O(n+m).
- **Point d'articulation** : sommet dont la suppression deconnecte.
- **Isthme** : arete dont la suppression deconnecte. N'appartient a aucun cycle.
- **k-connexe** : reste connexe apres suppression de k-1 sommets.

### Oriente

- **Fortement connexe** : chemin dans les DEUX sens entre tout couple.
- **CFC** : composantes fortement connexes (Tarjan, O(n+m)).
- **Graphe quotient des CFC** = toujours un DAG.

### Distances

- **d(u,v)** = longueur plus courte chaine (en aretes).
- **Excentricite** e(v) = max d(v,u). **Diametre** = max e(v). **Rayon** = min e(v).

---

## 3. Cycles et arbres -- [Chapitre complet](03_cycles_arbres.md)

### Euler (chaque ARETE une fois)

| Condition | Cycle eulerien | Chaine eulerienne |
|-----------|---------------|-------------------|
| Non oriente | Connexe + tous degres pairs | Connexe + 0 ou 2 sommets de degre impair |
| Oriente | Connexe + d+(v) = d-(v) pour tout v | -- |

Algorithme : **Hierholzer** en O(m).

### Hamilton (chaque SOMMET une fois)

- **NP-complet** : pas d'algorithme efficace.
- **Dirac** (suffisant) : d(v) >= n/2 pour tout v => cycle hamiltonien.
- **Ore** (suffisant) : d(u)+d(v) >= n pour tout couple non adjacent => cycle hamiltonien.

### Arbres (6 equivalences a connaitre)

Un graphe G a n sommets est un arbre ssi :
1. Connexe ET acyclique
2. Connexe ET n-1 aretes
3. Acyclique ET n-1 aretes
4. Chemin unique entre tout couple
5. Connexe ET supprimer toute arete deconnecte
6. Acyclique ET ajouter toute arete cree un cycle

**Foret** : graphe acyclique = union d'arbres. p composantes => n-p aretes.

### Tri topologique (DAG seulement)

- DFS post-order inverse OU algorithme de Kahn (degres entrants). O(n+m).

---

## 4. Coloration -- [Chapitre complet](04_coloration.md)

### Bornes du nombre chromatique chi(G)

```
omega(G) <= chi(G) <= Delta(G) + 1
```

- omega(G) = taille plus grande clique.
- Delta(G) = degre maximal.

### Theoremes

| Theoreme | Enonce |
|----------|--------|
| Brooks | chi(G) <= Delta(G), sauf K_n et cycles impairs |
| 4 couleurs | Tout graphe planaire : chi <= 4 |
| Vizing (aretes) | Delta <= chi'(G) <= Delta + 1 |

### Valeurs courantes

| Graphe | chi |
|--------|-----|
| Arbre (n>=2) | 2 |
| Biparti | 2 |
| Cycle pair | 2 |
| Cycle impair | 3 |
| K_n | n |

### Algorithme glouton

Parcourir les sommets dans un ordre choisi. Attribuer la plus petite couleur non utilisee par les voisins. Resultat depend de l'ordre. **DSatur** : choisir le sommet de plus grande saturation.

---

## 5. Arbres couvrants minimaux -- [Chapitre complet](05_arbres_couvrants.md)

### Propriete de coupe

> L'arete la plus legere traversant toute coupe appartient a un ACM.

### Kruskal

```
1. Trier les aretes par poids croissant
2. Pour chaque arete : ajouter si pas de cycle (Union-Find)
3. S'arreter quand n-1 aretes ajoutees
```
**Complexite :** O(m log m). Bon pour graphes creux.

### Prim

```
1. Partir d'un sommet quelconque
2. A chaque etape : ajouter l'arete la plus legere
   reliant l'arbre a un nouveau sommet
3. S'arreter quand tous les sommets sont dans l'arbre
```
**Complexite :** O(m log n) avec tas. Bon pour graphes denses.

### Verification

- L'ACM a exactement **n-1 aretes**.
- L'ACM est **unique** si tous les poids sont distincts.

---

## 6. Plus courts chemins -- [Chapitre complet](06_plus_courts_chemins.md)

### Tableau de choix

| Situation | Algorithme | Complexite |
|-----------|-----------|-----------|
| Poids >= 0, source unique | **Dijkstra** | O(m log n) |
| Poids quelconques, source unique | **Bellman-Ford** | O(nm) |
| Tous les couples | **Floyd-Warshall** | O(n^3) |
| DAG, source unique | Tri topo + relaxation | O(n+m) |
| Non pondere | **BFS** | O(n+m) |

### Dijkstra (a derouler en DS)

```
1. dist(s) = 0, dist(v) = inf pour v != s
2. Repeter n fois :
   a. u = sommet non visite de dist minimale
   b. Marquer u comme visite
   c. Pour chaque voisin v de u :
      Si dist(u) + w(u,v) < dist(v) : mettre a jour
```

### Bellman-Ford

```
1. dist(s) = 0, dist(v) = inf
2. Repeter n-1 fois : relaxer TOUS les arcs
3. n-eme iteration : si amelioration => circuit negatif
```

### Floyd-Warshall

```
Pour k de 1 a n :        // INTERMEDIAIRE = BOUCLE EXTERNE
  Pour i de 1 a n :
    Pour j de 1 a n :
      dist[i][j] = min(dist[i][j], dist[i][k] + dist[k][j])
```

---

## 7. Ordonnancement -- [Chapitre complet](07_ordonnancement.md)

### Methode MPM en 4 etapes

| Etape | Calcul | Direction | Operation |
|-------|--------|-----------|-----------|
| 1. Graphe | Sommets = taches, arcs = precedences | -- | Construire le DAG |
| 2. ES | Date debut au plus tot | Avant (topo) | **MAX** des predecesseurs |
| 3. LS | Date debut au plus tard | Arriere (topo inverse) | **MIN** des successeurs |
| 4. Marges | MT = LS - ES | -- | MT = 0 => critique |

### Formules

```
ES(T) = max { ES(P) + duree(P) } pour tout predecesseur P
LS(T) = min { LS(S) } - duree(T) pour tout successeur S
MT(T) = LS(T) - ES(T)
ML(T) = min { ES(S) } - ES(T) - duree(T) pour tout successeur S
```

### Chemin critique

- Plus long chemin dans le DAG = duree minimale du projet.
- Taches avec MT = 0.
- Peut y avoir plusieurs chemins critiques.

---

## 8. Flots -- [Chapitre complet](08_flots.md)

### Ford-Fulkerson / Edmonds-Karp

```
1. Flot initial = 0 partout
2. Tant qu'il existe un chemin augmentant s->t dans le graphe residuel :
   a. Trouver la capacite residuelle min du chemin
   b. Augmenter le flot le long du chemin
   c. Mettre a jour le graphe residuel
3. Flot max atteint quand plus de chemin augmentant
```

### Graphe residuel

Pour chaque arc (u,v) avec capacite c et flot f :
- **Arc avant** u->v : capacite residuelle = c - f (si > 0)
- **Arc arriere** v->u : capacite residuelle = f (si > 0)

### Theoreme flot max = coupe min

```
max |f| = min c(S,T)
```

Coupe (S,T) : s dans S, t dans T. Capacite = somme des arcs **S -> T seulement**.

Pour trouver la coupe min : sommets accessibles depuis s dans le graphe residuel final = S.

---

## Algorithmes : complexites a retenir

| Algorithme | Complexite | Utilisation |
|-----------|-----------|-------------|
| BFS / DFS | O(n+m) | Parcours, composantes |
| Tarjan (CFC) | O(n+m) | Composantes fortement connexes |
| Tri topologique | O(n+m) | Ordre sur un DAG |
| Hierholzer | O(m) | Cycle eulerien |
| Kruskal | O(m log m) | ACM (graphe creux) |
| Prim (tas) | O(m log n) | ACM (graphe dense) |
| Dijkstra (tas) | O(m log n) | Plus court chemin (poids >= 0) |
| Bellman-Ford | O(nm) | Plus court chemin (poids quelconques) |
| Floyd-Warshall | O(n^3) | Tous les plus courts chemins |
| Edmonds-Karp | O(nm^2) | Flot maximal |

---

## Top 10 des pieges en DS

| # | Piege | Comment l'eviter |
|---|-------|-----------------|
| 1 | Dijkstra avec poids negatifs | Verifier les poids. Negatifs => Bellman-Ford. |
| 2 | Confondre eulerien (aretes) et hamiltonien (sommets) | Euler = Each EDGE. Hamilton = Each NODE. |
| 3 | Oublier les arcs arriere dans Ford-Fulkerson | Toujours construire le graphe residuel complet (avant + arriere). |
| 4 | Prendre le MIN au lieu du MAX pour les dates au plus tot | ES = MAX (la tache attend que TOUS ses prerequis soient finis). |
| 5 | Boucle k en position interne dans Floyd-Warshall | k (intermediaire) = boucle EXTERNE. Ordre : k, i, j. |
| 6 | Oublier que l'ACM a n-1 aretes | Verifier systematiquement apres Kruskal ou Prim. |
| 7 | Appliquer Brooks a K_n ou aux cycles impairs | Brooks ne s'applique PAS a ces exceptions (chi = Delta + 1). |
| 8 | Compter les arcs T->S dans une coupe | Coupe = arcs S->T seulement. Les arcs T->S ne comptent pas. |
| 9 | Confondre chaine (non oriente) et chemin (oriente) | Verifier le type de graphe. Le vocabulaire est note en DS. |
| 10 | Oublier la verification du circuit negatif (Bellman-Ford) | La n-eme iteration est obligatoire pour conclure. |

---

## Proprietes recurrentes en DS

| Propriete | A savoir |
|-----------|---------|
| Biparti ssi pas de cycle impair | Test par BFS (2-coloration). |
| Arbre = connexe + acyclique = n-1 aretes + connexe | Plusieurs equivalences utiles. |
| Nb sommets de degre impair est pair | Consequence des poignees de main. |
| Tout arbre (n>=2) a au moins 2 feuilles | Preuve par le plus long chemin. |
| Planaire : m <= 3n-6 | Utile pour prouver la non-planarite (K5, K3,3). |
| Flot max = coupe min | Theoreme central des flots. |
| Sous-structure optimale des plus courts chemins | Sous-chemin d'un PCC est un PCC. |
| Graphe quotient des CFC est un DAG | Pas de cycle entre les CFC. |

---

## Methode pour derouler un algorithme en DS

1. **Lire l'enonce** : quel graphe ? oriente ? pondere ? Quel algorithme demande ?
2. **Dessiner le graphe** clairement avec les poids.
3. **Initialiser** : tableau de distances, file, pile, Union-Find, etc.
4. **Montrer CHAQUE etape** : quel sommet/arete est traite, quelles valeurs changent.
5. **Presenter les resultats** dans un tableau propre.
6. **Verifier** : nombre d'aretes de l'ACM = n-1, conservation du flot, etc.
7. **Conclure** : repondre a la question posee (cout, chemin, duree...).
