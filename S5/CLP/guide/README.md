# CLP -- Conception Logique des Processeurs

## Vue d'ensemble du cours

CLP (Conception Logique des Processeurs) est un cours de 3e annee a l'INSA Rennes couvrant l'ensemble de la conception de systemes numeriques : de l'algebre de Boole et des portes logiques jusqu'a l'architecture des processeurs et la programmation en assembleur ARM. Le cours se divise en deux parties principales :

1. **Logique Numerique** -- conception de circuits combinatoires et sequentiels, machines a etats, chemin de donnees et unite de commande
2. **Assembleur ARM** -- jeu d'instructions ARM, gestion de la pile, appels de fonctions, structures de donnees en assembleur

---

## Navigation par chapitre

### Partie I -- Logique Numerique

| Chapitre | Fichier | Sujets cles |
|----------|---------|-------------|
| 1. Logique combinatoire | [combinational-logic.md](combinational-logic.md) | Portes logiques, algebre de Boole, tableaux de Karnaugh, transcodeurs, multiplexeurs, decodeurs |
| 2. Logique sequentielle | [sequential-logic.md](sequential-logic.md) | Bascules (D, T, JK, RS), registres, compteurs, machines a etats (Moore/Mealy) |
| 3. Architecture processeur | [processor-architecture.md](processor-architecture.md) | Unite de traitement (UT), Unite de commande (UC), UAL, microcode, sequenceur, memoire |
| 4. Circuits Logisim | [logisim-circuits.md](logisim-circuits.md) | Methodologie de conception de circuits, reference des fichiers Logisim, techniques de simulation |
| 5. PGCD / Circuits arithmetiques | [pgcd-arithmetic.md](pgcd-arithmetic.md) | Algorithme du PGCD en materiel, integration UC+UT, machine Fibonacci |

### Partie II -- Assembleur ARM

| Chapitre | Fichier | Sujets cles |
|----------|---------|-------------|
| 6. Langage assembleur ARM | [assembly-arm.md](assembly-arm.md) | Jeu d'instructions ARM, modes d'adressage, pile, procedures, structures de donnees, GPIO |

---

## Comment utiliser ce guide

1. **Premier passage** : Lire les chapitres 1 a 3 dans l'ordre -- ils s'appuient les uns sur les autres. La logique combinatoire alimente la logique sequentielle, qui alimente l'architecture processeur.
2. **Pratique** : Travailler les exercices dans `../exercises/` apres chaque chapitre. Les solutions de TD sont organisees par sujet.
3. **Assembleur** : Le chapitre 6 est autonome. Commencer par les instructions de base, puis aborder les appels de fonctions et la recursivite.
4. **Preparation aux examens** : Utiliser `../exam-prep/` pour des exercices chronometres et la methodologie.

---

## Structure des examens

Le cours CLP comporte **deux examens distincts** :

| Examen | Contenu | Format |
|--------|---------|--------|
| DS Logique | Logique combinatoire + sequentielle, machines a etats, UC/UT | Ecrit : conception de circuits, tables de verite, tableaux de Karnaugh |
| DS Assembleur | Programmation en assembleur ARM | Ecrit : lecture/ecriture de code, trace de pile |

---

## Ressources cles

- **Circuits Logisim** : Tous les fichiers `.circ` dans `../data/moodle/cours/` et `../data/moodle/td/Logique/`
- **Aide-memoire ARM** : `../data/moodle/cours/ARM/arm-cheatsheet.pdf`
- **Synthese du cours** : `../data/moodle/cours/CPL-Cours-2020-2021-synthese.pdf`
- **Diapositives assembleur ARM** : `../data/moodle/cours/AssembleurARM - 2023-2024 - version etudiant.pdf`
- **Annales** : `../data/annales/` (organisees par Assembleur et Logique)
