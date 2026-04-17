# TPs Propositions et Prédicats

Ce dossier contient les TPs (travaux pratiques) pour le cours de Logique Propositionnelle et des Prédicats.

## Contenu Disponible

### Assignments Moodle
- `DSAssignment.md` - Devoir surveillé (assignment actif)
- `DS 2021Assignment.md` - Devoir surveillé 2021 (historique)

Ces fichiers proviennent de Moodle mais ne contiennent que les métadonnées. Pour accéder aux sujets complets, consulter directement Moodle :
- https://moodleng.insa-rennes.fr/mod/assign/view.php?id=24854
- https://moodleng.insa-rennes.fr/mod/assign/view.php?id=31496

## Ressources Complémentaires

### Cours (`../cours/`)
Le dossier cours contient les slides et documents pédagogiques :
- `logique.pdf` - Support de cours principal
- `CM annoté prof.pdf` - Cours magistral avec annotations
- `ExoCours.pdf` - Exercices de cours
- `Fiche prédicats.pdf` - Fiche récapitulative sur les prédicats

### Annales (`../annales/`)
Le dossier annales contient 24 examens passés et devoirs surveillés :
- DS 2016, 2017, 2018, 2021... (disponibles aussi dans `cours/`)
- Examens des années précédentes avec corrections
- Très utiles pour la préparation aux évaluations

## Sujets Couverts

Le cours de Propositions et Prédicats aborde les thèmes suivants :

### 1. Logique Propositionnelle
- **Syntaxe** : propositions atomiques, connecteurs logiques (¬, ∧, ∨, →, ↔)
- **Sémantique** : tables de vérité, tautologies, contradictions
- **Équivalence logique** : lois de De Morgan, distributivité, etc.
- **Formes normales** : FNC (forme normale conjonctive), FND (forme normale disjonctive)

### 2. Déduction Naturelle
- **Règles d'introduction et d'élimination** pour chaque connecteur
- **Construction de preuves** formelles
- **Théorèmes** : validité, correction, complétude
- **Stratégies de démonstration**

### 3. Logique des Prédicats (Logique du Premier Ordre)
- **Syntaxe** : quantificateurs (∀, ∃), variables, constantes, fonctions, prédicats
- **Sémantique** : domaines, interprétations, modèles
- **Substitution** : variable libre, variable liée, substitution correcte
- **Équivalences** : déplacement des quantificateurs, négation

### 4. Raisonnement Automatisé
- **Unification** : algorithme d'unification, substituant le plus général
- **Résolution** : clauses, résolvante, réfutation
- **Skolémisation** : élimination des quantificateurs existentiels
- **Forme clausale** : conversion en clauses de Horn
- **Algorithme de résolution** : stratégies de sélection de clauses

### 5. Programmation Logique (Fondements)
- **Prolog** : langage de programmation logique
- **Clauses de Horn** : faits, règles, requêtes
- **Unification en Prolog**
- **Mécanisme d'inférence** : chaînage arrière

## Comment Travailler

### Préparation aux DS/Examens

1. **Maîtriser le cours** : 
   - Lire `logique.pdf` et comprendre tous les concepts
   - Faire les `ExoCours.pdf`

2. **Pratiquer la déduction naturelle** :
   - S'entraîner à construire des preuves formelles
   - Connaître toutes les règles d'introduction/élimination par cœur

3. **S'exercer sur les annales** :
   - Faire les DS des années précédentes (2016, 2017, 2018, 2021...)
   - Comparer avec les corrections si disponibles
   - Identifier les types de questions récurrentes

4. **Comprendre la logique des prédicats** :
   - Pratiquer la manipulation des quantificateurs
   - Maîtriser les substitutions et l'unification
   - Comprendre la conversion en forme clausale

5. **S'entraîner à la résolution** :
   - Appliquer l'algorithme de résolution sur des exercices
   - Comprendre les stratégies (linéaire, en ensemble de support, etc.)

### Exercices Types

**Logique propositionnelle :**
- Construire des tables de vérité
- Démontrer des tautologies
- Convertir en formes normales (FNC, FND)
- Démontrer par déduction naturelle

**Logique des prédicats :**
- Traduire des phrases en formules logiques
- Appliquer des règles de déduction avec quantificateurs
- Effectuer des substitutions
- Déterminer la validité dans un modèle

**Résolution :**
- Convertir une formule en forme clausale
- Appliquer l'algorithme de résolution
- Démontrer par réfutation

## Outils et Ressources

### Prouveurs Automatiques
Plusieurs outils existent pour vérifier des preuves ou expérimenter :
- **Coq** : assistant de preuve formel
- **Lean** : assistant de preuve moderne
- **Prolog** : pour la programmation logique
- **Z3** : solveur SMT (Satisfiability Modulo Theories)

### Ressources en Ligne
- **Logic Matters** : https://www.logicmatters.net/
- **Natural Deduction Proof Editor** : https://proofs.openlogicproject.org/
- **SEP Logic** : https://plato.stanford.edu/entries/logic-classical/
- **Cours OpenClassrooms Logique** : diverses ressources gratuites

### Livres de Référence
- *A Mathematical Introduction to Logic* - Herbert Enderton
- *Logic for Computer Science* - Steve Reeves, Michael Clarke
- *Introduction to Mathematical Logic* - Elliott Mendelson

## Types d'Évaluations

### Devoirs Surveillés (DS)
- Durée : généralement 1h30 à 2h
- Sans documents (formules et règles fournies)
- Exercices de démonstration
- Questions de cours
- Problèmes d'application (résolution, unification)

### Examens
- Format similaire aux DS
- Peut inclure des questions de synthèse
- Partie théorique + partie pratique

## Conseils

### Pour Réussir
1. **Pratiquer régulièrement** : la logique formelle demande de la pratique
2. **Être rigoureux** : chaque étape de preuve doit être justifiée
3. **Connaître les règles** : mémoriser les règles de déduction
4. **Faire les annales** : excellent entraînement
5. **Travailler en groupe** : discuter des preuves aide à comprendre

### Erreurs à Éviter
- Oublier des cas dans les preuves par cas
- Mal gérer les variables liées/libres
- Confondre → (implication) et ↔ (équivalence)
- Ne pas vérifier les conditions de substitution
- Mal appliquer les règles de quantificateurs

### Notation
Les points sont généralement attribués pour :
- La correction de la démarche (même si le résultat est faux)
- La justification de chaque étape
- La clarté de la présentation
- La complétude de la réponse

## Liens Moodle

Accès aux assignments et ressources complémentaires :
- Assignment DS : https://moodleng.insa-rennes.fr/mod/assign/view.php?id=24854
- Assignment DS 2021 : https://moodleng.insa-rennes.fr/mod/assign/view.php?id=31496
- Page du cours : https://moodleng.insa-rennes.fr/course/view.php?id=XXXX

## Structure du Dépôt

```
Propositions_Predicats/
├── tp/                         # Ce dossier
│   ├── README.md              # Ce fichier
│   ├── DSAssignment.md        # Métadonnées assignment actuel
│   └── DS 2021Assignment.md   # Métadonnées assignment 2021
├── cours/                     # Cours et supports pédagogiques
│   ├── logique.pdf
│   ├── CM annoté prof.pdf
│   ├── ExoCours.pdf
│   └── Fiche prédicats.pdf
├── annales/                   # 24 examens et DS des années précédentes
├── td/                        # Travaux dirigés
├── fiches/                    # Fiches de révision
└── README.md                  # Description générale du cours
```

## Support

Pour toute question :
- Consulter les supports de cours dans `../cours/`
- Consulter les annales dans `../annales/`
- Poser des questions pendant les TD
- Utiliser le forum Moodle du cours
