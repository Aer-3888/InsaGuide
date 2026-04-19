# SDD -- Preparation a l'examen

## Format de l'examen

L'examen SDD (DS) est un examen ecrit, typiquement de 2-3 heures. Base sur l'analyse des annales de 2013 a 2025, l'examen teste de maniere constante :

1. **Types Abstraits de Donnees (TAD)** -- specifications formelles avec SORTE, FONCTIONS, AXIOMES
2. **Arbres Binaires de Recherche** -- insertion, suppression, parcours, analyse de hauteur
3. **Implementation d'algorithmes** -- ecrire du code Java sur papier
4. **Analyse de complexite** -- prouver des O, comparer des structures
5. **Conception de structures** -- structures nouvelles combinant des primitives connues

## Frequence des sujets dans les annales

| Sujet | Frequence | Questions typiques |
|-------|-----------|-------------------|
| Arbres binaires / ABR | Tres haute | Insertion, suppression, parcours, hauteur, equilibre |
| Types Abstraits de Donnees | Tres haute | Definir un TAD avec axiomes, prouver des theoremes |
| Analyse de complexite | Haute | Prouver O/Theta, comparer des implementations |
| Listes chainees | Moyenne | Implementer des operations, navigation par curseur |
| Tables de hachage | Moyenne | Conception de fonctions de hachage, analyse de collisions |
| Tas | Moyenne | Operations HeapPQ, tracer heapify |
| Graphes / Dijkstra | Moyenne-Basse | Tracer l'algorithme, reconstruction de chemin |
| Structures avancees | Variable | Filtres de Bloom (2021), arbres de segments (2022), sommes d'intervalles |

## Strategie d'examen

### Repartition du temps (examen 2h)

1. **Lire l'examen entier d'abord** (5 min) -- identifier les questions faciles vs. difficiles
2. **Questions TAD / theorie** (30 min) -- rapide si on connait le formalisme
3. **Implementation arbre / ABR** (30 min) -- le plus frequent, le plus de points
4. **Analyse de complexite** (20 min) -- prouver les bornes soigneusement
5. **Questions d'implementation** (25 min) -- ecrire du code Java propre
6. **Relecture** (10 min) -- verifier les cas limites, erreurs de un

### Ecrire du Java sur papier

- Ecrire des **signatures de methodes claires** avec types de retour
- Gerer les **cas limites en premier** (null, vide, un seul element)
- Utiliser des **retours anticipes** pour reduire l'imbrication
- Dessiner des **schemas ASCII** avant et apres les operations
- **Indiquer la complexite** a cote de chaque methode

## Analyse des annales

### Examen 2020 -- Focus ABR

**Exercice 1 : TAD et ABR**
- Q1 : Distinguer axiome vs. theoreme dans une specification formelle
- Q2 : Definir le TAD Booleen avec les axiomes pour vrai/faux/non/et/ou
- Q3 : Prouver les lois de De Morgan a partir des axiomes (par analyse de cas)
- Q4 : Tracer l'insertion ABR de la sequence [7, 3, 10, 1, 6, 14, 4, 7]
- Q5 : Implementer `placer(int i)` -- insertion ABR
- Q6 : Expliquer la suppression avec 2 enfants (remplacer par le max du sous-arbre gauche)
- Q7 : Implementer `oterPlusGrandInf()` -- trouver et supprimer le max du sous-arbre gauche
- Q8 : Implementer `supprimerEc()` -- suppression ABR complete

**Point cle de la solution** : La suppression ABR avec 2 enfants necessite de trouver le noeud le plus a droite du sous-arbre gauche (le predecesseur dans le parcours infixe), pas n'importe quel noeud.

**Exercice 2 : Parcours d'arbre (Exercice 3 de l'examen)**
- Q9 : Etant donne un arbre, produire differents parcours et reconstruire a partir d'un parcours

### Examen 2021 -- Filtres de Bloom

**Structure nouvelle** : Filtre de Bloom (appartenance probabiliste a un ensemble)
- Utilise BitSet + plusieurs fonctions de hachage
- `add()` : mettre k bits a 1 en utilisant k fonctions de hachage
- `contains()` : verifier si tous les k bits sont a 1
- Faux positifs possibles, faux negatifs impossibles

### Examen 2022 -- Arbres de segments et sommes d'intervalles

**IntervalSum** : tableau de sommes prefixes pour des requetes O(1), mise a jour O(n)
**SegmentTree** : arbre binaire equilibre pour des requetes O(log n) ET mise a jour O(log n)

Methodes cles :
- `rsq(from, to)` -- requete de somme sur un intervalle
- `rMinQ(from, to)` -- requete de minimum sur un intervalle
- `update(i, value)` -- mise a jour ponctuelle

### Examens 2023-2025

Disponibles en PDF, continuant les schemas d'operations ABR, formalisme TAD et analyse de complexite.

## Exercices d'entrainement

### Exercice 1 : Trace d'insertion ABR

Inserer les valeurs suivantes dans un ABR vide : 15, 8, 23, 4, 12, 18, 30, 6

```
Solution:
           [15]
          /    \
        [8]    [23]
        / \    /  \
      [4] [12][18][30]
        \
        [6]
```

### Exercice 2 : Suppression ABR

Supprimer 15 de l'arbre ci-dessus (la racine a 2 enfants) :
1. Trouver le max dans le sous-arbre gauche : 12
2. Remplacer 15 par 12
3. Supprimer l'ancien noeud 12 (n'a pas d'enfants)

```
           [12]
          /    \
        [8]    [23]
        /      /  \
      [4]   [18] [30]
        \
        [6]
```

### Exercice 3 : Operations sur un tas

Tableau tas min donne : [2, 5, 3, 8, 7, 6, 4]

Dessiner l'arbre :
```
           [2]
          /   \
        [5]   [3]
        / \   / \
      [8] [7][6] [4]
```

Apres `poll()` (retirer 2) :
1. Remplacer la racine par le dernier : [4, 5, 3, 8, 7, 6]
2. ShiftDown 4 : comparer avec min(5,3)=3, echanger
3. [3, 5, 4, 8, 7, 6] : comparer 4 avec min(6)=6, 4 &lt; 6, termine

```
           [3]
          /   \
        [5]   [4]
        / \   /
      [8] [7][6]
```

Apres `add(1)` :
1. Placer a la fin : [3, 5, 4, 8, 7, 6, 1]
2. ShiftUp 1 : parent(6)=2, heap[2]=4 > 1, echanger
3. [3, 5, 1, 8, 7, 6, 4] : parent(2)=0, heap[0]=3 > 1, echanger
4. [1, 5, 3, 8, 7, 6, 4]

### Exercice 4 : Trace de Dijkstra

```
Graph:
  A --2--> B --3--> D
  |        |
  5        1
  |        |
  v        v
  C --4--> E

Dijkstra from A:

Step  PQ                          cost              prev
0     [(A,0)]                     {}                {}
1     [(B,2),(C,5)]               {A:0}             {A:null}
2     [(C,5),(E,3),(D,5)]         {A:0,B:2}         {A:null,B:A}
3     [(C,5),(D,5)]               {A:0,B:2,E:3}     {...,E:B}
4     [(D,5)]                     {A:0,B:2,E:3,C:5} {...,C:A}
5     []                          {...,D:5}          {...,D:B}

Plus court chemin A->E : A -> B -> E (cout 3)
Plus court chemin A->D : A -> B -> D (cout 5)
```

### Exercice 5 : Complexite

Prouver que la methode `size()` de ListeEngine est O(n) :

```java
public int size() {
    int ret = 0;
    for (Object k : this) ret++;
    return ret;
}
```

**Preuve** : La boucle for-each appelle `iterator()`, puis `hasNext()`/`next()` pour chaque element. Avec n elements dans la liste :
- `hasNext()` est O(1) (verifie estSorti)
- `next()` est O(1) (valec + succ)
- La boucle s'execute n fois
- Total : n * O(1) = O(n)

### Exercice 6 : TAD Booleen

Definir le TAD Booleen :
```
SORTE Boolean
UTILISE
FONCTIONS
    vrai : -> Boolean
    faux : -> Boolean
    non  : Boolean -> Boolean
    et   : Boolean x Boolean -> Boolean
    ou   : Boolean x Boolean -> Boolean
AXIOMES
    non(vrai) = faux
    non(faux) = vrai
    et(vrai, vrai) = vrai
    et(vrai, faux) = faux
    et(faux, vrai) = faux
    et(faux, faux) = faux
    ou(vrai, vrai) = vrai
    ou(vrai, faux) = vrai
    ou(faux, vrai) = vrai
    ou(faux, faux) = faux
```

Prouver De Morgan : non(et(x,y)) = ou(non(x), non(y))
Methode : enumerer les 4 cas (x,y) dans {vrai,faux}^2.

## Liste de revision

- [ ] Savoir dessiner un ABR apres une sequence d'insertions
- [ ] Savoir supprimer dans un ABR (cas 0, 1 et 2 enfants)
- [ ] Savoir ecrire des specifications TAD avec axiomes
- [ ] Savoir prouver des theoremes a partir d'axiomes par analyse de cas
- [ ] Savoir tracer Dijkstra etape par etape
- [ ] Savoir tracer add/poll du tas avec shiftUp/shiftDown
- [ ] Savoir calculer la complexite d'un code donne
- [ ] Savoir prouver O/Theta en utilisant la definition (trouver c, n0)
- [ ] Savoir implementer des operations de liste chainee sur papier
- [ ] Savoir concevoir des fonctions de hachage et analyser les collisions
- [ ] Connaitre la complexite de toutes les structures principales (voir tableau dans guide/README.md)
