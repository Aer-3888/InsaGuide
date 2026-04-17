# Chapitre 1 : HTML et CSS -- Les fondations du Web

## Table des matieres

1. [Introduction](#1-introduction)
2. [HTML : structure d'une page Web](#2-html--structure-dune-page-web)
3. [Balises HTML essentielles](#3-balises-html-essentielles)
4. [Formulaires HTML](#4-formulaires-html)
5. [CSS : mise en forme](#5-css--mise-en-forme)
6. [Selecteurs CSS](#6-selecteurs-css)
7. [Le modele de boite (Box Model)](#7-le-modele-de-boite-box-model)
8. [Mise en page : Flexbox et Grid](#8-mise-en-page--flexbox-et-grid)
9. [Variables CSS](#9-variables-css)
10. [Pieges courants](#10-pieges-courants)
11. [Recapitulatif](#11-recapitulatif)

---

## 1. Introduction

### Qu'est-ce qu'une page Web ?

Une page Web est un document affiche par un navigateur. Elle repose sur trois piliers :

```
+------------------+     +------------------+     +------------------+
|       HTML       |     |       CSS        |     |    JavaScript    |
|                  |     |                  |     |                  |
|   Structure      |     |   Presentation   |     |   Comportement   |
|   (le squelette) |     |   (l'apparence)  |     |   (l'interactif) |
+------------------+     +------------------+     +------------------+
```

- **HTML** (HyperText Markup Language) : definit la structure et le contenu
- **CSS** (Cascading Style Sheets) : definit la mise en forme visuelle
- **JavaScript** : definit le comportement interactif

### Page Web vs Application Web

| Page Web | Application Web |
|----------|-----------------|
| Contenu statique (HTML/CSS/JS basique) | Logiciel accessible via Internet |
| Pas d'interaction complexe | Separation client-serveur |
| Exemple : blog personnel | Exemple : Netflix, Gmail |

> **Point cle** : Souvent, une "page Web" est en fait une application Web simple. Inspectez le code source (Ctrl+U sous Firefox) pour voir la difference.

---

## 2. HTML : structure d'une page Web

### Document HTML minimal

```html
<!DOCTYPE html>
<html lang="fr">
<head>
    <!-- Metadonnees : non affichees directement -->
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ma premiere page</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <!-- Contenu visible de la page -->
    <h1>Bienvenue</h1>
    <p>Mon premier paragraphe.</p>
    <script src="main.js"></script>
</body>
</html>
```

### Anatomie d'une balise HTML

```
   balise ouvrante          contenu          balise fermante
        |                     |                    |
        v                     v                    v
    <a href="url" class="lien">Cliquez ici</a>
        ^                                      ^
    attributs                            element complet
```

**Regles fondamentales** :
- Toute balise ouverte doit etre fermee : `<p>...</p>`
- Les balises auto-fermantes n'ont pas de contenu : `<br/>`, `<img/>`, `<input/>`
- L'imbrication doit etre correcte : `<p><strong>OK</strong></p>` et non `<p><strong>FAUX</p></strong>`

---

## 3. Balises HTML essentielles

### Titres et texte

```html
<h1>Titre principal (un seul par page idealement)</h1>
<h2>Sous-titre de niveau 2</h2>
<h3>Sous-titre de niveau 3</h3>
<!-- ... jusqu'a h6 -->

<p>Un paragraphe de texte.</p>
<strong>Texte en gras (importance semantique)</strong>
<em>Texte en italique (emphase)</em>
<br/> <!-- Saut de ligne -->
```

### Listes

```html
<!-- Liste non ordonnee (a puces) -->
<ul>
    <li>Premier element</li>
    <li>Deuxieme element</li>
</ul>

<!-- Liste ordonnee (numerotee) -->
<ol>
    <li>Etape 1</li>
    <li>Etape 2</li>
</ol>
```

### Liens et images

```html
<!-- Lien hypertexte -->
<a href="https://www.insa-rennes.fr" target="_blank">INSA Rennes</a>

<!-- Image -->
<img src="images/photo.jpg" alt="Description de l'image" width="300"/>
```

### Conteneurs structurels

```html
<!-- Conteneurs semantiques (HTML5) -->
<header>En-tete de page</header>
<nav>Navigation</nav>
<main>Contenu principal</main>
<section>Section thematique</section>
<article>Article independant</article>
<aside>Contenu lateral</aside>
<footer>Pied de page</footer>

<!-- Conteneurs generiques -->
<div>Bloc generique (display: block)</div>
<span>Contenu en ligne (display: inline)</span>
```

### Tableaux

```html
<table>
    <thead>
        <tr>
            <th>Nom</th>
            <th>Note</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>Alice</td>
            <td>16</td>
        </tr>
        <tr>
            <td>Bob</td>
            <td>14</td>
        </tr>
    </tbody>
</table>
```

---

## 4. Formulaires HTML

```html
<form action="/api/submit" method="POST">
    <!-- Champ texte -->
    <label for="nom">Nom :</label>
    <input type="text" id="nom" name="nom" placeholder="Votre nom" required/>

    <!-- Champ email -->
    <input type="email" name="email" placeholder="email@exemple.fr"/>

    <!-- Champ mot de passe -->
    <input type="password" name="mdp"/>

    <!-- Case a cocher -->
    <input type="checkbox" name="accepte" id="accepte"/>
    <label for="accepte">J'accepte les conditions</label>

    <!-- Bouton radio -->
    <input type="radio" name="genre" value="h"/> Homme
    <input type="radio" name="genre" value="f"/> Femme

    <!-- Liste deroulante -->
    <select name="pays">
        <option value="fr">France</option>
        <option value="de">Allemagne</option>
    </select>

    <!-- Zone de texte multiligne -->
    <textarea name="message" rows="4" cols="50"></textarea>

    <!-- Bouton de soumission -->
    <button type="submit">Envoyer</button>
</form>
```

---

## 5. CSS : mise en forme

### Trois manieres d'appliquer du CSS

```html
<!-- 1. CSS en ligne (a eviter) -->
<p style="color: red;">Texte rouge</p>

<!-- 2. CSS interne (dans le head) -->
<head>
    <style>
        p { color: blue; }
    </style>
</head>

<!-- 3. CSS externe (recommande) -->
<head>
    <link rel="stylesheet" href="style.css"/>
</head>
```

### Syntaxe CSS

```css
/* selecteur { propriete: valeur; } */
h1 {
    color: #333333;           /* couleur du texte */
    font-size: 24px;          /* taille de police */
    font-family: Arial, sans-serif;  /* police */
    text-align: center;       /* alignement */
    margin-bottom: 20px;      /* marge exterieure basse */
}

p {
    line-height: 1.6;         /* hauteur de ligne */
    color: #666;              /* gris */
}
```

### Proprietes CSS les plus utilisees

| Propriete | Description | Exemple |
|-----------|-------------|---------|
| `color` | Couleur du texte | `color: red;` |
| `background-color` | Couleur de fond | `background-color: #f0f0f0;` |
| `font-size` | Taille de police | `font-size: 16px;` |
| `font-weight` | Graisse de police | `font-weight: bold;` |
| `margin` | Marge exterieure | `margin: 10px 20px;` |
| `padding` | Marge interieure | `padding: 15px;` |
| `border` | Bordure | `border: 1px solid black;` |
| `width` / `height` | Dimensions | `width: 100%;` |
| `display` | Mode d'affichage | `display: flex;` |
| `position` | Positionnement | `position: relative;` |

---

## 6. Selecteurs CSS

### Les selecteurs de base

```css
/* Selecteur de balise */
p { color: blue; }

/* Selecteur de classe (.) -- reutilisable */
.important { font-weight: bold; }

/* Selecteur d'identifiant (#) -- unique */
#header { background-color: navy; }

/* Selecteur universel */
* { margin: 0; padding: 0; }
```

### Combinaisons de selecteurs

```css
/* Descendant : tout <p> dans un <div> */
div p { color: green; }

/* Enfant direct : <p> enfant direct de <div> */
div > p { color: red; }

/* Classe sur element : <p> avec class="note" */
p.note { font-style: italic; }

/* Multi-classe : element avec les DEUX classes */
.card.active { border: 2px solid blue; }

/* Selecteur d'attribut */
input[type="text"] { border: 1px solid gray; }

/* Pseudo-classes */
a:hover { color: red; }           /* au survol */
li:first-child { font-weight: bold; }  /* premier enfant */
input:focus { outline: 2px solid blue; }  /* au focus */
```

### Specificite CSS (priorite)

```
Priorite croissante :
  balise (p, div, h1)         -->  0,0,1
  classe (.maclasse)          -->  0,1,0
  identifiant (#monid)        -->  1,0,0
  style en ligne (style="")   -->  1,0,0,0
  !important                  -->  surpasse tout (a eviter)
```

> **Regle** : En cas de conflit entre deux regles, c'est la plus specifique qui gagne. A specificite egale, c'est la derniere declaree qui gagne.

---

## 7. Le modele de boite (Box Model)

Tout element HTML est une "boite" composee de 4 couches :

```
+-----------------------------------------------+
|                   MARGIN                       |
|   +---------------------------------------+   |
|   |              BORDER                   |   |
|   |   +-------------------------------+   |   |
|   |   |           PADDING             |   |   |
|   |   |   +-----------------------+   |   |   |
|   |   |   |                       |   |   |   |
|   |   |   |       CONTENT         |   |   |   |
|   |   |   |                       |   |   |   |
|   |   |   +-----------------------+   |   |   |
|   |   +-------------------------------+   |   |
|   +---------------------------------------+   |
+-----------------------------------------------+
```

```css
.boite {
    /* Contenu */
    width: 200px;
    height: 100px;

    /* Marge interieure (entre contenu et bordure) */
    padding: 10px;

    /* Bordure */
    border: 2px solid black;

    /* Marge exterieure (entre bordure et elements voisins) */
    margin: 20px;
}
```

### box-sizing : border-box

Par defaut, `width` et `height` definissent la taille du **contenu seul**. Avec `border-box`, ils incluent padding et border :

```css
/* Bonne pratique : appliquer a tous les elements */
* {
    box-sizing: border-box;
}
```

**Exemple concret** :
- Sans `border-box` : `width: 200px` + `padding: 10px` + `border: 2px` = 224px de large
- Avec `border-box` : `width: 200px` inclut tout = 200px de large

---

## 8. Mise en page : Flexbox et Grid

### Flexbox (disposition en ligne ou colonne)

```css
.conteneur {
    display: flex;
    flex-direction: row;       /* row (defaut) | column */
    justify-content: center;   /* alignement axe principal */
    align-items: center;       /* alignement axe secondaire */
    gap: 10px;                 /* espacement entre elements */
    flex-wrap: wrap;           /* retour a la ligne si necessaire */
}

.element {
    flex: 1;                   /* prend l'espace disponible */
}
```

**Valeurs de justify-content** :
```
flex-start   : |XXX            |  (debut)
center       : |     XXX       |  (centre)
flex-end     : |            XXX|  (fin)
space-between: |X     X      X|  (espace entre)
space-around : |  X    X    X  |  (espace autour)
```

### CSS Grid (grille 2D)

```css
.grille {
    display: grid;
    grid-template-columns: repeat(3, 1fr);  /* 3 colonnes egales */
    grid-template-rows: auto;
    gap: 10px;
}
```

### Exemple pratique : carte de TP (grille isometrique)

Tire du TP Angular, voici comment creer une grille avec CSS :

```css
div {
    --size-cell: 120px;
    --border-cell: 5px;
}

.aclass {
    box-sizing: border-box;
    border: var(--border-cell) solid;
    background-color: blue;
    width: var(--size-cell);
    height: var(--size-cell);
    float: left;
    padding: 0;
    margin: 0;
}
```

---

## 9. Variables CSS

Les variables CSS (custom properties) permettent de centraliser les valeurs :

```css
:root {
    /* Declaration des variables */
    --couleur-primaire: #3498db;
    --couleur-secondaire: #2ecc71;
    --taille-police: 16px;
    --espacement: 10px;
}

.bouton {
    /* Utilisation avec var() */
    background-color: var(--couleur-primaire);
    font-size: var(--taille-police);
    padding: var(--espacement);
}

.carte {
    border: 1px solid var(--couleur-secondaire);
    margin: var(--espacement);
}
```

---

## 10. Pieges courants

### Piege 1 : Oublier le DOCTYPE
```html
<!-- FAUX : pas de DOCTYPE -->
<html>...</html>

<!-- CORRECT -->
<!DOCTYPE html>
<html>...</html>
```
Sans DOCTYPE, le navigateur passe en mode "quirks" et le rendu est imprevisible.

### Piege 2 : Confondre id et class
```html
<!-- id : UNIQUE dans la page -->
<div id="menu-principal">...</div>

<!-- class : REUTILISABLE -->
<div class="carte">...</div>
<div class="carte">...</div>
```

### Piege 3 : Mauvaise imbrication
```html
<!-- FAUX -->
<p>Texte <strong>en gras</p></strong>

<!-- CORRECT -->
<p>Texte <strong>en gras</strong></p>
```

### Piege 4 : Oublier box-sizing
Sans `box-sizing: border-box`, les dimensions calculees incluent uniquement le contenu, pas le padding ni la bordure. Cela cause des debordements inattendus.

### Piege 5 : Confondre display block et inline
- `block` : prend toute la largeur, accepte width/height (`div`, `p`, `h1`)
- `inline` : ne prend que la largeur du contenu, ignore width/height (`span`, `a`, `strong`)
- `inline-block` : en ligne mais accepte width/height

---

## 11. Recapitulatif

| Concept | A retenir |
|---------|-----------|
| HTML | Structure du document, balises semantiques (header, main, footer) |
| CSS | Selecteurs (balise, .classe, #id), specificite, cascade |
| Box Model | content + padding + border + margin, utiliser border-box |
| Flexbox | display: flex, justify-content, align-items, gap |
| Grid | display: grid, grid-template-columns, gap |
| Variables CSS | `--nom: valeur;` et `var(--nom)` |
| Formulaires | input types, label, required, form action/method |

**Points cles pour le DS** :
- Savoir ecrire une structure HTML valide
- Connaitre les selecteurs CSS et leur specificite
- Comprendre le Box Model et border-box
- Utiliser Flexbox pour la mise en page
