# Guide d'Ingenierie Web -- S6 INSA Rennes

## Presentation du cours

Ce cours couvre les fondamentaux de l'ingenierie Web moderne, de la creation de pages HTML/CSS jusqu'au developpement d'applications Web completes avec front-end Angular et back-end Java Spring Boot.

**Enseignant** : Arnaud Blouin (arnaud.blouin@irisa.fr)

**Competences visees** :
- Savoir fabriquer un back-end REST en Java (Spring Boot)
- Savoir definir, tester et securiser des routes REST
- Savoir utiliser du marshalling et des DTO
- Savoir lier un back-end avec une base de donnees via un ORM (JPA)
- Savoir concevoir une API REST avec OpenAPI
- Connaitre les concepts et technologies du Web actuel
- Maitriser les bases de TypeScript et Angular

## Parcours d'apprentissage

```
Semaine 1-2          Semaine 3-4          Semaine 5-6          Semaine 7-8
+-----------+        +-----------+        +-----------+        +-----------+
| HTML/CSS  |------->| JavaScript|------->| REST API  |------->| Angular   |
| bases du  |        | ES6+ et   |        | Spring    |        | TypeScript|
| Web       |        | DOM       |        | Boot, ORM |        | Front-end |
+-----------+        +-----------+        +-----------+        +-----------+
```

## Plan du guide

| # | Chapitre | Fichier | Description |
|---|----------|---------|-------------|
| 1 | HTML et CSS | [01_html_css.md](01_html_css.md) | Structure HTML, balises, CSS, selecteurs, mise en page |
| 2 | JavaScript ES6+ | [02_javascript_es6.md](02_javascript_es6.md) | Types, fonctions, classes, modules, promesses |
| 3 | DOM et evenements | [03_dom_evenements.md](03_dom_evenements.md) | Manipulation du DOM, event listeners, interaction utilisateur |
| 4 | REST API et Spring Boot | [04_rest_api.md](04_rest_api.md) | Architecture REST, verbes HTTP, Spring Boot, DTO, ORM, securite |
| 5 | Angular et TypeScript | [05_angular.md](05_angular.md) | Composants, data binding, directives, services, HttpClient |
| - | Cheat Sheet | [cheat_sheet.md](cheat_sheet.md) | Synthese pour le DS : patterns, syntaxe, pieges |

## Correspondance avec les materiaux

| Chapitre du guide | Cours source | TP associe |
|--------------------|-------------|------------|
| 01 HTML/CSS | Poly 2022.pdf (intro) | TP1 (Building Blocks) |
| 02 JavaScript ES6+ | Poly 2022.pdf, TP-intro-JS.pdf | TP1 (First Step, ES6 Babel) |
| 03 DOM et evenements | front-end1.pdf (events) | TP1 (Building Blocks) |
| 04 REST API | Web-3INFO.pdf, Poly 2022.pdf | TP2 (Jersey Calendar API) |
| 05 Angular | front-end2.pdf | TP5 (Angular) |

## Comment utiliser ce guide

1. **Lecture lineaire** : Les chapitres sont ordonnes du plus fondamental au plus avance
2. **Reference rapide** : Utilisez la cheat sheet pour reviser avant le DS
3. **Pratique** : Chaque chapitre contient des exemples de code a tester
4. **Preparation DS** : La cheat sheet recapitule les patterns d'examen recurrents (2017-2023)

## Structure d'un chapitre

Chaque chapitre suit la meme progression :
1. Concept explique simplement
2. Schema (Mermaid) pour visualiser
3. Explication progressive avec exemples
4. Code commente (JS/HTML/CSS/Java)
5. Pieges courants a eviter
6. Recapitulatif du chapitre

## Architecture d'une application Web

```
+-------------------+          +-------------------+          +-------------------+
|    FRONT-END      |  REST    |    BACK-END       |   ORM    |   BASE DE         |
|                   |  HTTP    |                   |   JPA    |   DONNEES         |
|  HTML + CSS       |<-------->|  Spring Boot      |<-------->|                   |
|  TypeScript       |  JSON    |  Java 17          |          |  H2 / PostgreSQL  |
|  Angular          |          |  Controllers      |          |                   |
|                   |          |  Services          |          |                   |
+-------------------+          +-------------------+          +-------------------+
     Navigateur                   Serveur (localhost:8080)        Stockage
```

## Annales disponibles (2017-2023)

Les sujets d'examen couvrent systematiquement :
- **Exercice 1** : Questions de cours (REST, XML/JSON, TypeScript, architecture)
- **Exercice 2** : ORM / JPA (annotations @Entity, @Id, @OneToMany, etc.)
- **Exercice 3** : Routes REST (definition, implementation Spring Boot, DTO)
- **Exercice 4** : Securite (authentification, sessions, droits d'acces)
