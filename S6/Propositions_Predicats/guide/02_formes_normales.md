# Chapitre 2 -- Formes normales

> FNC (forme normale conjonctive), FND (forme normale disjonctive), algorithmes de conversion, satisfiabilite.

---

## 1. Vocabulaire

### Litteral

Un **litteral** est une variable ou sa negation : p, ¬p, q, ¬q.

### Clause (pour la FNC)

Une **clause** est une disjonction (∨) de litteraux.
- Exemple : p ∨ q ∨ ¬r

### Monome (pour la FND)

Un **monome** est une conjonction (∧) de litteraux.
- Exemple : p ∧ q ∧ ¬r

---

## 2. Forme Normale Conjonctive (FNC)

### Definition

Une formule est en **FNC** si elle est une **conjonction de clauses** (ET de OU).

```
FNC = (clause1) ∧ (clause2) ∧ ... ∧ (clausen)
    = (l1 ∨ l2 ∨ ...) ∧ (l3 ∨ l4 ∨ ...) ∧ ...
```

### Exemples

| Formule | FNC ? | Pourquoi |
|---------|-------|----------|
| (p ∨ q) ∧ (¬p ∨ r) | Oui | ET de deux clauses |
| p ∧ q ∧ r | Oui | Chaque variable est une clause a 1 litteral |
| (p ∧ q) ∨ r | **Non** | OU contenant un ET |

La FNC est la forme requise pour la **methode de resolution** et les **solveurs SAT**.

---

## 3. Forme Normale Disjonctive (FND)

### Definition

Une formule est en **FND** si elle est une **disjonction de monomes** (OU de ET).

```
FND = (monome1) ∨ (monome2) ∨ ... ∨ (monomen)
    = (l1 ∧ l2 ∧ ...) ∨ (l3 ∧ l4 ∧ ...) ∨ ...
```

La FND permet de **lire directement** les cas ou la formule est vraie.

### Astuce mnemotechnique

- **FNC** = **C**onjonctive = connecteur principal **∧** = ET de OU
- **FND** = **D**isjonctive = connecteur principal **∨** = OU de ET

---

## 4. Methode de mise en FNC (4 etapes)

### Etape 1 : Eliminer les equivalences
```
A ↔ B  →  (A → B) ∧ (B → A)
```

### Etape 2 : Eliminer les implications
```
A → B  →  ¬A ∨ B
```

### Etape 3 : Descendre les negations (De Morgan + double negation)
```
¬(A ∧ B)  →  ¬A ∨ ¬B
¬(A ∨ B)  →  ¬A ∧ ¬B
¬¬A       →  A
```
Repeter jusqu'a ce que chaque ¬ ne porte que sur une variable.

### Etape 4 : Distribuer ∨ sur ∧
```
A ∨ (B ∧ C)  →  (A ∨ B) ∧ (A ∨ C)
```

---

## 5. Methode de mise en FND

Etapes 1-3 identiques a la FNC. Seule l'etape 4 change :

### Etape 4 : Distribuer ∧ sur ∨
```
A ∧ (B ∨ C)  →  (A ∧ B) ∨ (A ∧ C)
```

---

## 6. Exemples resolus

### Exemple 1 : FNC de p → (q ∧ r)

**Etape 1 :** Pas d'equivalence.

**Etape 2 :** Eliminer →.
```
¬p ∨ (q ∧ r)
```

**Etape 3 :** Rien a descendre.

**Etape 4 :** Distribuer ∨ sur ∧.
```
(¬p ∨ q) ∧ (¬p ∨ r)
```

**FNC = (¬p ∨ q) ∧ (¬p ∨ r)**

### Exemple 2 : FNC de ¬(p → q) ∨ (r ↔ p)

**Etape 1 :** Eliminer ↔.
```
¬(p → q) ∨ ((r → p) ∧ (p → r))
```

**Etape 2 :** Eliminer →.
```
¬(¬p ∨ q) ∨ ((¬r ∨ p) ∧ (¬p ∨ r))
```

**Etape 3 :** Descendre les negations.
```
¬(¬p ∨ q) = ¬¬p ∧ ¬q = p ∧ ¬q
```
Donc :
```
(p ∧ ¬q) ∨ ((¬r ∨ p) ∧ (¬p ∨ r))
```

**Etape 4 :** Distribuer ∨ sur ∧.

Posons A = p ∧ ¬q, B = ¬r ∨ p, C = ¬p ∨ r.

A ∨ (B ∧ C) = (A ∨ B) ∧ (A ∨ C)

(A ∨ B) = (p ∧ ¬q) ∨ (¬r ∨ p) = (p ∨ ¬r ∨ p) ∧ (¬q ∨ ¬r ∨ p) = (p ∨ ¬r) ∧ (¬q ∨ ¬r ∨ p)

(A ∨ C) = (p ∧ ¬q) ∨ (¬p ∨ r) = (p ∨ ¬p ∨ r) ∧ (¬q ∨ ¬p ∨ r) = V ∧ (¬p ∨ ¬q ∨ r) = ¬p ∨ ¬q ∨ r

**FNC = (p ∨ ¬r) ∧ (p ∨ ¬q ∨ ¬r) ∧ (¬p ∨ ¬q ∨ r)**

### Exemple 3 : FND de (p ∨ q) ∧ r

Etapes 1-3 : rien a faire.

Etape 4 : distribuer ∧ sur ∨.
```
(p ∨ q) ∧ r = (p ∧ r) ∨ (q ∧ r)
```

**FND = (p ∧ r) ∨ (q ∧ r)**

### Exemple 4 : FNC et FND de (p ↔ q) → r

**Etape 1 :** (p ↔ q) → r = ((p → q) ∧ (q → p)) → r

**Etape 2 :** = ¬((¬p ∨ q) ∧ (¬q ∨ p)) ∨ r

**Etape 3 :** = (¬(¬p ∨ q) ∨ ¬(¬q ∨ p)) ∨ r = ((p ∧ ¬q) ∨ (q ∧ ¬p)) ∨ r

**FND = (p ∧ ¬q) ∨ (q ∧ ¬p) ∨ r** (deja un OU de monomes)

Pour la **FNC**, on part de (p ∧ ¬q) ∨ (q ∧ ¬p) ∨ r et on distribue :

(p ∧ ¬q) ∨ (q ∧ ¬p) = (p ∨ q) ∧ (p ∨ ¬p) ∧ (¬q ∨ q) ∧ (¬q ∨ ¬p) = (p ∨ q) ∧ (¬p ∨ ¬q)

Puis ((p ∨ q) ∧ (¬p ∨ ¬q)) ∨ r = (p ∨ q ∨ r) ∧ (¬p ∨ ¬q ∨ r)

**FNC = (p ∨ q ∨ r) ∧ (¬p ∨ ¬q ∨ r)**

---

## 7. Methode par la table de verite

### FND a partir de la table

Pour chaque ligne ou F vaut **V** : construire un monome (variable si V, ¬variable si F), relier par ∨.

### FNC a partir de la table

Pour chaque ligne ou F vaut **F** : construire une clause (¬variable si V, variable si F), relier par ∧.

### Exemple : p → q

| p | q | p → q |
|---|---|-------|
| V | V | **V** |
| V | F | **F** |
| F | V | **V** |
| F | F | **V** |

**FND :** Lignes V (1, 3, 4) :
- Ligne 1 : p ∧ q
- Ligne 3 : ¬p ∧ q
- Ligne 4 : ¬p ∧ ¬q

FND = (p ∧ q) ∨ (¬p ∧ q) ∨ (¬p ∧ ¬q)

Simplification : = q ∨ (¬p ∧ ¬q) = (q ∨ ¬p) ∧ (q ∨ ¬q) = ¬p ∨ q

**FNC :** Ligne F (2 seulement) :
- Ligne 2 (p=V, q=F) : ¬p ∨ q

FNC = ¬p ∨ q

---

## 8. Simplification

### Regles utiles
```
Idempotence :     A ∨ A = A        A ∧ A = A
Absorption :      A ∨ (A ∧ B) = A  A ∧ (A ∨ B) = A
Complement :      A ∨ ¬A = V       A ∧ ¬A = F
Element neutre :  A ∨ F = A        A ∧ V = A
Absorbant :       A ∨ V = V        A ∧ F = F
```

---

## 9. Recapitulatif

| | FNC | FND |
|---|-----|-----|
| **Structure** | ET de OU | OU de ET |
| **Briques** | Clauses | Monomes |
| **Connecteur principal** | ∧ | ∨ |
| **Etape 4** | Distribuer ∨ sur ∧ | Distribuer ∧ sur ∨ |
| **Via table** | Lignes F → clauses | Lignes V → monomes |
| **Utilite** | Resolution, SAT | Lire les cas vrais |

---

## 10. Pieges classiques

| Piege | Erreur | Correction |
|-------|--------|------------|
| Confondre FNC/FND | "ET de ET" = FNC | FNC = ET de **OU** |
| Sauter des etapes | Distribuer avant d'eliminer → | Ordre : ↔, →, ¬, distribution |
| Mauvaise distribution | A ∨ (B ∧ C) = (A ∨ B) ∧ C | C'est (A ∨ B) ∧ **(A ∨ C)** |
| Table de verite FNC | Prendre les lignes V pour FNC | FNC utilise les lignes **F** |
