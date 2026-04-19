# Diagrammes UML

## Theorie

UML (Unified Modeling Language) est un langage visuel standardise pour specifier, construire et documenter des systemes logiciels. L'examen CPOO demande systematiquement de dessiner des diagrammes de classes et, occasionnellement, des diagrammes de cas d'utilisation et de sequences.

---

## 1. Diagrammes de classes

### Notation de base des classes

```
+-------------------+
|    ClassName       |       <<abstract>>  or <<interface>>
+-------------------+
| - privateField    |       Visibility:
| # protectedField  |         - private
| + publicField     |         # protected
| ~ packageField    |         + public
+-------------------+         ~ package
| + publicMethod()  |
| # protectedMethod()|
| + abstractMethod()*|      * italic or {abstract}
+-------------------+
```

### Relations

**Heritage (generalisation)** : trait plein avec triangle creux pointe vers le parent.
```
     Arbre              (parent)
       ^
       |                solid line + hollow triangle
       |
     Chene              (child: Chene extends Arbre)
```

**Implementation d'interface (realisation)** : trait pointille avec triangle creux.
```
  <<interface>>
    Network             (interface)
       ^
       :                dashed line + hollow triangle
       :
  NetworkImpl           (class implements Network)
```

**Association** : trait plein, optionnellement avec fleche pour la direction de navigation.
```
  Velo ---------> Guidon         unidirectional (Velo knows Guidon)
        guidon
        0..1

  Velo <--------> Guidon         bidirectional (both know each other)
        guidon     velo
        0..1       0..1
```

**Agregation** ("a-un" faible) : trait plein avec losange creux du cote du "tout".
```
  Foret <>------> Arbre          Foret has Arbres
          arbres
          0..*
```

**Composition** ("a-un" fort) : trait plein avec losange plein. La partie ne peut pas exister sans le tout.
```
  Velo <*>------> Roue           Roue cannot exist without Velo
          roues
          0..*
```

**Dependance** : fleche pointillee. Une classe utilise une autre temporairement (ex. comme parametre).
```
  Client - - - -> Service        Client depends on Service
```

### Multiplicite

| Notation | Signification |
|----------|--------------|
| `1` | Exactement un |
| `0..1` | Zero ou un (optionnel) |
| `0..*` ou `*` | Zero ou plusieurs |
| `1..*` | Un ou plusieurs |
| `2` | Exactement deux |

### Classes abstraites et interfaces en UML

```
+-------------------+           +-------------------+
|   <<abstract>>    |           |   <<interface>>   |
|      Arbre        |           |     Service       |
+-------------------+           +-------------------+
| # age: double     |           | + getLatency(): int|
| # volume: double  |           +-------------------+
+-------------------+
| + vieillir()      |
| + getPrix(): double|
| + getPrixM3()*    |     * = abstract method
+-------------------+
```

### Enumerations en UML

```
+-------------------+
|   <<enumeration>> |
|   UniteDeMesure   |
+-------------------+
|   ML              |
|   M2              |
|   U               |
+-------------------+
```

---

## 2. Exemple detaille : Systeme forestier (TP2)

D'apres le texte du cours :

```
                      +-------------------+
                      |   <<abstract>>    |
                      |   Arbre<F>        |
                      +-------------------+
                      | # age: double     |
                      | # volume: double  |
                      +-------------------+
                      | + vieillir()      |
                      | + getPrix(): double|
                      | + peutEtreCoupe() |
                      | + produireFruit():F|
                      | # getPrixM3()*    |
                      | + getAgeMinCoupe()*|
                      +-------------------+
                            ^         ^
                            |         |
              +-------------+    +------------+
              |                               |
    +-------------------+          +-------------------+
    |   Chene<Gland>    |          |    Pin<Cone>      |
    +-------------------+          +-------------------+
    | + getPrixM3()     |          | + getPrixM3()     |
    | + getAgeMinCoupe()|          | + getAgeMinCoupe()|
    | + produireFruit() |          | + produireFruit() |
    +-------------------+          +-------------------+
              |                               |
           produces                        produces
              |                               |
    +-------------------+          +-------------------+
    |      Gland        |          |      Cone         |
    +-------------------+          +-------------------+
    (extends Fruit)                (extends Fruit)

    +-------------------+
    |      Foret        |
    +-------------------+
    | - arbres: List<Arbre>        |
    | - arbres_coupes: List<Arbre> |
    +-------------------+
    | + planterArbre()  |
    | + couperArbre()   |
    | + getPrixTotal()  |
    | + getNombreChenes()|
    +-------------------+
           <>
           | arbres 0..*
           v
         Arbre
```

---

## 3. Exemple detaille : Examen 2024-2025 (Systeme de devis)

Texte : "Un devis concerne un client et possede une date. Un client a un nom et une adresse. Un client peut etre une entreprise (avec un numero). Une tache a une designation, quantite, prix unitaire, et unite de mesure. Une tache fait reference a du materiel (au moins un). Un materiel est fourni par un ou plusieurs fournisseurs."

```
  +-------------------+     1    +-------------------+
  |      Devis        |--------->|     Client        |
  +-------------------+          +-------------------+
  | - date: String    |          | - nom: String     |
  +-------------------+          | - adresse: String |
         |                       +-------------------+
         | taches 1..*                    ^
         v                                |
  +-------------------+          +-------------------+
  |      Tache        |          |   Entreprise      |
  +-------------------+          +-------------------+
  | - designation: String|       | - numero: String  |
  | - quantite: double  |       +-------------------+
  | - prixUnitaire: double|
  +-------------------+
  | - unite: UniteDeMesure |
  +-------------------+
         |
         | materiels 1..*
         v
  +-------------------+     *     +-------------------+
  |     Materiel      |<--------->|   Fournisseur     |
  +-------------------+   1..*   +-------------------+
  | - designation: String|       | - nom: String     |
  +-------------------+          +-------------------+

  +-------------------+
  | <<enumeration>>   |
  |  UniteDeMesure    |
  +-------------------+
  |   ML              |
  |   M2              |
  |   U               |
  +-------------------+
```

---

## 4. Exemple detaille : Examen 2020-2021 (Formule arithmetique)

Le texte decrit une formule comme un arbre : le noeud racine est un operateur, les operandes peuvent etre des valeurs, des references a des constantes, ou d'autres operateurs.

```
  +-------------------+          +-------------------+
  | FormuleArithmetique|-------->| <<interface>>     |
  +-------------------+ racine  |   Calculable      |
  | - constantes: Map  | 1      +-------------------+
  +-------------------+         | + calculer(): double|
  | + calculer(): double|       +-------------------+
  +-------------------+              ^    ^    ^
                                     |    |    |
                    +----------------+    |    +----------------+
                    |                     |                     |
          +-------------------+ +-------------------+ +-------------------+
          |     Valeur        | |  RefConstante     | |   <<abstract>>    |
          +-------------------+ +-------------------+ |   Operateur       |
          | - nombre: double  | | - ref: Constante  | +-------------------+
          +-------------------+ +-------------------+ | - gauche: Calculable|
          | + calculer()      | | + calculer()      | | - droite: Calculable|
          +-------------------+ +-------------------+ +-------------------+
                                                      | + calculer()      |
                                                      +-------------------+
                                                           ^         ^
                                                           |         |
                                                 +-----------+ +-----------+
                                                 |  Addition  | |Soustraction|
                                                 +-----------+ +-----------+

  +-------------------+
  |    Constante      |
  +-------------------+
  | - nom: String     |
  | - valeur: double  |
  +-------------------+
```

---

## 5. Diagrammes de cas d'utilisation

Les diagrammes de cas d'utilisation montrent les acteurs (bonhommes batons) et les cas d'utilisation (ovales) avec lesquels ils interagissent.

### Relations dans les diagrammes de cas d'utilisation

| Relation | Notation | Signification |
|----------|----------|--------------|
| Association | Trait plein | L'acteur participe au cas d'utilisation |
| Include | Fleche pointillee `<<include>>` | Le cas d'utilisation inclut toujours un autre |
| Extend | Fleche pointillee `<<extend>>` | Le cas d'utilisation etend optionnellement un autre |
| Generalisation | Fleche pleine avec triangle | Cas d'utilisation specialise / heritage d'acteur |

### Exemple detaille : Restaurant (Examen 2020-2021)

```
   Client            Serveur           Cuisinier          Caissier
     |                  |                  |                  |
     +-- Passer --+     |                  |                  |
     |  commande  |-----+                  |                  |
     |            |     |                  |                  |
     | Commander  |     +-- Servir plat ---+                  |
     |   du vin --+     |                  |                  |
     | (specializes     +-- Servir vin     |                  |
     |  commande)       | (specializes     |                  |
     |                  |  servir plat)    |                  |
     |                  |                  +-- Cuisiner plat  |
     |                  |                  | <<include>>      |
     |                  |                  | passer commande  |
     |                  |                                     |
     +----------------------------------------- Encaisser ---+
                                             <<include>>
                                             passer commande
```

Note : "Serveur peut etre Caissier" = generalisation d'acteur (Serveur herite de Caissier ou inversement).

---

## 6. Diagrammes de sequences

Les diagrammes de sequences montrent l'ordre des appels de methodes entre objets au fil du temps.

### Exemple detaille : Addition.calculer()

```
  :Client         :Addition        :gauche           :droite
     |                |               |                  |
     | calculer()     |               |                  |
     |--------------->|               |                  |
     |                | calculer()    |                  |
     |                |-------------->|                  |
     |                |    valG       |                  |
     |                |<------------- |                  |
     |                |               | calculer()       |
     |                |---------------|----------------->|
     |                |               |     valD         |
     |                |<--------------|------------------|
     |                |               |                  |
     |  valG + valD   |               |                  |
     |<---------------|               |                  |
```

---

## Pieges courants

1. **Confondre agregation et composition** : la composition signifie que la partie ne peut pas exister sans le tout (losange plein). L'agregation est plus faible (losange creux).
2. **Multiplicite manquante** : chaque association doit montrer la multiplicite aux deux extremites.
3. **Oublier la notation abstraite** : marquer les classes abstraites avec `<<abstract>>` ou mettre le nom en italique.
4. **Mauvais sens de la fleche** : la fleche pointe DU dependant VERS la dependance. Un `Velo` qui connait son `Guidon` a la fleche DE Velo VERS Guidon.
5. **Confondre `<<include>>` et `<<extend>>`** : include est obligatoire ; extend est optionnel/conditionnel.

---

## CHEAT SHEET

```
CLASS DIAGRAM RELATIONSHIPS
  Inheritance:     solid line + hollow triangle pointing to parent
  Implementation:  dashed line + hollow triangle pointing to interface
  Association:     solid line (+ arrowhead for direction)
  Aggregation:     hollow diamond on "whole" side
  Composition:     filled diamond on "whole" side
  Dependency:      dashed arrow

MULTIPLICITY
  1     exactly one
  0..1  optional (zero or one)
  0..*  zero or more
  1..*  one or more

CLASS NOTATION
  + public   # protected   - private   ~ package
  <<abstract>>   <<interface>>   <<enumeration>>
  abstract method: italic or marked with {abstract}

USE CASE DIAGRAM
  Actor:          stick figure
  Use Case:       oval
  <<include>>:    dashed arrow, mandatory sub-behavior
  <<extend>>:     dashed arrow, optional sub-behavior
  Generalization: solid arrow + triangle (actor or use case inheritance)

SEQUENCE DIAGRAM
  Object:         box at top with lifeline (dashed vertical)
  Message:        solid arrow (synchronous) or dashed arrow (return)
  Activation:     thin rectangle on lifeline
  Self-call:      arrow looping back to same lifeline
```
