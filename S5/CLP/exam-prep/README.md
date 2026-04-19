# Preparation aux examens CLP

## Structure des examens

CLP comporte **deux examens distincts** :

### DS Logique (Examen de logique numerique)

| Aspect | Details |
|--------|---------|
| Duree | ~2 heures |
| Sujets | Logique combinatoire, logique sequentielle, machines a etats, conception UC/UT |
| Format | Ecrit : tables de verite, tableaux de Karnaugh, diagrammes d'etats, conception de circuits |
| Outils autorises | Generalement aucun (pas de calculatrice) |

**Types de questions courants** :
1. Simplification d'algebre de Boole (15-20 min)
2. Simplification par tableau de Karnaugh (15-20 min)
3. Conception de machine a etats a partir d'un cahier des charges (30-40 min)
4. Conception ou analyse UC/UT (30-40 min)

### DS Assembleur (Examen d'assembleur)

| Aspect | Details |
|--------|---------|
| Duree | ~2 heures |
| Sujets | Assembleur ARM : lecture d'instructions, ecriture de code, trace de pile |
| Format | Ecrit : lire du code, ecrire du code, tracer l'execution |
| Outils autorises | Aide-memoire ARM generalement fourni |

**Types de questions courants** :
1. Lire et expliquer du code assembleur existant (20-30 min)
2. Ecrire une fonction en assembleur ARM (30-40 min)
3. Tracer la pile/les registres a travers les appels de fonctions (20-30 min)
4. Manipulation de structures de donnees en assembleur (20-30 min)

---

## Strategie de revision

### Pour le DS Logique

**Semaine 1** : Reviser les fondamentaux de la logique combinatoire
- Pratiquer les simplifications d'algebre de Boole (au moins 10 exercices)
- Maitriser les tableaux de Karnaugh pour 3 et 4 variables
- Reviser les systemes de numeration (binaire, hexadecimal, complement a deux)

**Semaine 2** : Se concentrer sur la logique sequentielle
- Pratiquer la conception de machines a etats a partir de zero
- Convertir entre les types de bascules
- Dessiner des chronogrammes a partir des tables d'etats

**Semaine 3** : Architecture des processeurs
- Comprendre la decomposition UC/UT
- Pratiquer la microprogrammation (ecriture de mots de microcode)
- Revoir les machines PGCD et Fibonacci de bout en bout

### Pour le DS Assembleur

**Semaine 1** : Maitrise du jeu d'instructions
- Memoriser les 15 instructions les plus courantes
- Pratiquer la lecture d'extraits de code et la prediction de la sortie
- Comprendre les modes d'adressage (immediat, registre, indexe, a echelle)

**Semaine 2** : Convention d'appel de fonctions
- Dessiner les cadres de pile de memoire
- Pratiquer l'ecriture de fonctions completes (prologue + corps + epilogue)
- Tracer les appels recursifs pas a pas

**Semaine 3** : Structures de donnees et annales
- Pratiquer l'acces aux tableaux et structures en assembleur
- Travailler toutes les annales en conditions chronometrees
- Se concentrer sur les patrons courants : boucles, traitement de chaines, acces aux structures

---

## Gestion du temps pendant l'examen

### DS Logique (2 heures)

| Phase | Temps | Activite |
|-------|-------|----------|
| Lecture | 10 min | Lire TOUTES les questions d'abord. Identifier les gains faciles. |
| Questions faciles | 30 min | Algebre de Boole, conversions, tables de verite simples |
| Questions moyennes | 40 min | Tableaux de Karnaugh, circuits a bascules |
| Questions difficiles | 30 min | Conception de machine a etats, integration UC/UT |
| Relecture | 10 min | Verifier toutes les tables de verite, valider les regroupements Karnaugh |

### DS Assembleur (2 heures)

| Phase | Temps | Activite |
|-------|-------|----------|
| Lecture | 10 min | Lire TOUTES les questions. Identifier les structures de donnees utilisees. |
| Lecture de code | 30 min | Annoter le code donne, tracer l'execution |
| Ecriture de code | 40 min | Ecrire les fonctions demandees avec prologue/epilogue complets |
| Trace de pile | 20 min | Dessiner les schemas de pile, tracer les valeurs des registres |
| Relecture | 20 min | Verifier l'equilibrage de pile, valider les offsets, revoir les cas limites |

---

## Erreurs courantes a eviter

### DS Logique

1. **Ordre des colonnes du tableau de Karnaugh** : 00, 01, 11, 10 (code de Gray), PAS 00, 01, 10, 11
2. **Transitions d'etat manquantes** : Chaque etat doit definir ce qui se passe pour CHAQUE entree
3. **Oublier de verifier les etats redondants** : Minimiser avant d'implementer
4. **Mauvais ordre des bits de microcode** : Bien verifier quel bit commande quelle commande

### DS Assembleur

1. **Ne pas sauvegarder LR avant BL** : Crash garanti ou mauvais retour
2. **Mauvais offsets de pile** : Dessiner le cadre, compter les octets depuis FP
3. **Confondre LDR et LDRB** : Mot (4 octets) vs octet (1 octet)
4. **Oublier .align apres .ascii** : Cause des erreurs de desalignement
5. **Nettoyage de pile manquant** : Chaque SUB sp doit avoir un ADD sp correspondant

---

## Index des annales

### Examens d'assembleur

| Annee | Materiel disponible | Sujets cles |
|-------|---------------------|-------------|
| 2017 | Sujet PDF, 2 solutions (.s + .pdf) | Traitement de chaines, comptage de caracteres |
| 2018 | Sujet PDF, 2 solutions (.s + .pdf) | Structures (droites/vecteurs), vecteurs directeurs, colinearite |
| 2019 | Sujet PDF, 2 solutions (.s + .pdf) | Structures (ingredients), comptage, analyse de nombres |
| 2022 | Sujet PDF | -- |
| 2023 | Sujet PDF | -- |
| 2024 | Sujet PDF | -- |

### Examens de logique

| Annee | Materiel disponible |
|-------|---------------------|
| 2008-2016 | Plusieurs PDF d'examens de logique (ancien format) |
| 2021 | DS CLP Logique PDF |
| 2022 | DS CLP Logique PDF |
| 2023 | DS CLP Logique PDF + exam_clp_logique_23.pdf |

---

## Corriges detailles

Voir les corriges detailles :
- [exam-assembly-walkthrough.md](exam-assembly-walkthrough.md) -- Analyse pas a pas des examens d'assembleur 2017, 2018, 2019
