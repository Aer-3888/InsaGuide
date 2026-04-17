# Chapitre 3 : DOM et Evenements -- Interagir avec la page Web

## Table des matieres

1. [Qu'est-ce que le DOM ?](#1-quest-ce-que-le-dom)
2. [Selectionner des elements](#2-selectionner-des-elements)
3. [Modifier le DOM](#3-modifier-le-dom)
4. [Creer et supprimer des elements](#4-creer-et-supprimer-des-elements)
5. [Evenements : le systeme d'interaction](#5-evenements--le-systeme-dinteraction)
6. [Gestion des evenements](#6-gestion-des-evenements)
7. [L'objet Event](#7-lobjet-event)
8. [Propagation des evenements](#8-propagation-des-evenements)
9. [Interaction utilisateur avancee](#9-interaction-utilisateur-avancee)
10. [Architecture UI : MVC](#10-architecture-ui--mvc)
11. [Pieges courants](#11-pieges-courants)
12. [Recapitulatif](#12-recapitulatif)

---

## 1. Qu'est-ce que le DOM ?

Le DOM (Document Object Model) est la representation en memoire d'un document HTML sous forme d'arbre d'objets.

```
                   document
                      |
                    html
                   /    \
                head     body
                 |       /   \
               title    h1    div
                |        |     |
              "Page"   "Titre"  p
                              |
                         "Paragraphe"
```

Le navigateur construit cet arbre au chargement de la page. JavaScript peut ensuite :
- **Lire** le contenu du DOM (recuperer du texte, des attributs)
- **Modifier** le DOM (changer du texte, des styles, des classes)
- **Creer/supprimer** des elements (ajouter des balises dynamiquement)
- **Ecouter** des evenements (reagir aux clics, aux saisies)

### Relation HTML - DOM

```
HTML (fichier texte)           DOM (arbre en memoire)
                                
<div id="app">      --->     Element: div
  <p>Hello</p>               |-- id: "app"
</div>                        |-- enfant: Element p
                                   |-- texte: "Hello"
```

---

## 2. Selectionner des elements

### Methodes de selection

```javascript
// Par identifiant (retourne UN element ou null)
const header = document.getElementById("header");

// Par classe (retourne une HTMLCollection)
const cartes = document.getElementsByClassName("carte");

// Par balise (retourne une HTMLCollection)
const paragraphes = document.getElementsByTagName("p");

// Par selecteur CSS (retourne le PREMIER element correspondant)
const premier = document.querySelector(".carte");

// Par selecteur CSS (retourne TOUS les elements : NodeList)
const tous = document.querySelectorAll(".carte");
```

### querySelector vs getElementById

```javascript
// querySelector est plus flexible car il accepte tout selecteur CSS
document.querySelector("#header");           // par id
document.querySelector(".carte.active");     // multi-classe
document.querySelector("div > p:first-child"); // selecteur complexe
document.querySelector("[data-x='3']");      // par attribut

// Iterer sur les resultats de querySelectorAll
document.querySelectorAll(".carte").forEach(carte => {
    console.log(carte.textContent);
});
```

---

## 3. Modifier le DOM

### Modifier le contenu

```javascript
const element = document.getElementById("titre");

// Modifier le texte (securise : pas d'interpretation HTML)
element.textContent = "Nouveau titre";

// ATTENTION : element.innerHTML permet d'inserer du HTML
// mais c'est dangereux si le contenu vient d'un utilisateur (faille XSS)
// Privilegier textContent pour du texte brut
```

### Modifier les attributs

```javascript
const lien = document.querySelector("a");

// Lire / modifier un attribut
lien.getAttribute("href");          // lire
lien.setAttribute("href", "https://insa-rennes.fr");  // modifier
lien.removeAttribute("target");     // supprimer

// Attributs data-* personnalises
const div = document.querySelector("[data-x]");
div.getAttribute("data-x");         // lire
div.dataset.x;                      // raccourci pour data-x
div.dataset.playerName;             // pour data-player-name
```

### Modifier les styles et classes

```javascript
const element = document.querySelector(".carte");

// Modifier le style directement (a eviter si possible)
element.style.backgroundColor = "red";
element.style.fontSize = "20px";

// Gerer les classes CSS (methode preferee)
element.classList.add("active");       // ajouter une classe
element.classList.remove("active");    // retirer une classe
element.classList.toggle("active");    // ajouter/retirer
element.classList.contains("active");  // verifier la presence
```

---

## 4. Creer et supprimer des elements

### Creer des elements

```javascript
// Creer un nouvel element
const nouvelleCarte = document.createElement("div");
nouvelleCarte.className = "carte";
nouvelleCarte.textContent = "Nouvelle carte";
nouvelleCarte.setAttribute("data-id", "42");

// Ajouter au DOM
const conteneur = document.getElementById("liste");
conteneur.appendChild(nouvelleCarte);         // en dernier enfant
conteneur.prepend(nouvelleCarte);              // en premier enfant
conteneur.insertBefore(nouvelleCarte, autreElement); // avant un element
```

### Supprimer des elements

```javascript
// Supprimer un element
const element = document.getElementById("aSupprimer");
element.remove();

// Ou via le parent
element.parentNode.removeChild(element);
```

### Cloner des elements

```javascript
const original = document.querySelector(".carte");
const copie = original.cloneNode(true);  // true = clone profond (avec enfants)
document.body.appendChild(copie);
```

---

## 5. Evenements : le systeme d'interaction

### Concept

Les utilisateurs interagissent avec l'interface via des peripheriques (souris, clavier, ecran tactile). Ces interactions generent des **evenements** que JavaScript peut intercepter et traiter.

```
Utilisateur         Navigateur            JavaScript
    |                   |                      |
    |-- clic souris --> |                      |
    |                   |-- evenement "click"-->|
    |                   |                      |-- handler() -->
    |                   |                      |   traitement
    |                   |<-- mise a jour DOM --|
```

### Types d'evenements courants

| Categorie | Evenement | Description |
|-----------|-----------|-------------|
| **Souris** | `click` | Clic gauche |
| | `dblclick` | Double clic |
| | `mousedown` | Bouton enfonce |
| | `mouseup` | Bouton relache |
| | `mousemove` | Deplacement souris |
| | `mouseenter` | Entree dans l'element |
| | `mouseleave` | Sortie de l'element |
| **Clavier** | `keydown` | Touche enfoncee |
| | `keyup` | Touche relachee |
| | `keypress` | Touche pressee (obsolete) |
| **Formulaire** | `submit` | Soumission du formulaire |
| | `change` | Changement de valeur |
| | `input` | Saisie en cours |
| | `focus` | Element selectionne |
| | `blur` | Element deselectionne |
| **Document** | `DOMContentLoaded` | DOM charge |
| | `load` | Page completement chargee |
| | `scroll` | Defilement |
| | `resize` | Redimensionnement |

---

## 6. Gestion des evenements

### Trois manieres d'attacher un evenement

```html
<!-- 1. En ligne dans le HTML (a EVITER) -->
<button onclick="maFonction()">Cliquer</button>
```

```javascript
// 2. Via une propriete (un seul handler par evenement)
document.getElementById("btn").onclick = function() {
    console.log("clic !");
};

// 3. addEventListener (RECOMMANDE : plusieurs handlers possibles)
const bouton = document.getElementById("btn");

bouton.addEventListener("click", function(evt) {
    console.log("clic recu !");
});

// Avec arrow function
bouton.addEventListener("click", (evt) => {
    console.log("autre handler pour le meme clic !");
});
```

### addEventListener vs propriete onclick

| `addEventListener` | `onclick = ...` |
|--------------------|---------------------------|
| Plusieurs handlers pour le meme evenement | Un seul handler par type d'evenement |
| Plus flexible | Plus simple mais limite |
| Methode preferee | Le dernier handler ecrase le precedent |

### Retirer un event listener

```javascript
// Pour retirer un listener, il faut une reference a la fonction
function monHandler(evt) {
    console.log("clic !");
}

bouton.addEventListener("click", monHandler);
bouton.removeEventListener("click", monHandler);

// ATTENTION : ne fonctionne PAS avec une fonction anonyme
bouton.addEventListener("click", () => console.log("clic"));
// impossible de retirer ce listener !
```

---

## 7. L'objet Event

Chaque handler recoit un objet `Event` contenant les details de l'evenement.

### Proprietes communes

```javascript
element.addEventListener("click", function(evt) {
    evt.type;           // "click"
    evt.target;         // element qui a declenche l'evenement
    evt.currentTarget;  // element sur lequel le handler est attache

    evt.preventDefault();   // empecher le comportement par defaut
    evt.stopPropagation();  // arreter la propagation
});
```

### Evenement souris (MouseEvent)

```javascript
canvas.addEventListener("mousemove", function(evt) {
    evt.clientX;   // position X dans la fenetre
    evt.clientY;   // position Y dans la fenetre
    evt.offsetX;   // position X relative a l'element
    evt.offsetY;   // position Y relative a l'element
    evt.button;    // 0 = gauche, 1 = molette, 2 = droit
    evt.buttons;   // masque binaire des boutons enfonces
});

// Detecter un clic droit
element.addEventListener("mousedown", function(evt) {
    if (evt.button === 2) {
        console.log("clic droit !");
    }
});
```

### Evenement clavier (KeyboardEvent)

```javascript
document.addEventListener("keydown", function(evt) {
    evt.key;        // "a", "Enter", "ArrowUp", etc.
    evt.code;       // "KeyA", "Enter", "ArrowUp"
    evt.ctrlKey;    // true si Ctrl est enfonce
    evt.shiftKey;   // true si Shift est enfonce
    evt.altKey;     // true si Alt est enfonce

    // Exemple : detecter Ctrl+X
    if (evt.key === "x" && evt.ctrlKey) {
        console.log("Ctrl+X presse !");
    }
});
```

### Exemple concret (tire du TP1 Building Blocks)

```javascript
const canvas = document.getElementById("myCanvas");

// Dessiner en suivant la souris
let dessin = false;

canvas.addEventListener("mousedown", (evt) => {
    dessin = true;
});

canvas.addEventListener("mouseup", (evt) => {
    dessin = false;
});

canvas.addEventListener("mousemove", (evt) => {
    if (dessin) {
        const ctx = canvas.getContext("2d");
        ctx.fillRect(evt.offsetX, evt.offsetY, 5, 5);
    }
});
```

---

## 8. Propagation des evenements

Quand un evenement se produit, il traverse l'arbre DOM en trois phases :

```
         Phase 1: CAPTURE          Phase 3: BUBBLING
         (document -> cible)       (cible -> document)
              |                         ^
              v                         |
          document                  document
              |                         ^
              v                         |
            body                      body
              |                         ^
              v                         |
            div                       div
              |                         ^
              v                         |
         Phase 2: TARGET
           button  <-- evenement ici
```

```javascript
// Par defaut, addEventListener ecoute en phase BUBBLING
parent.addEventListener("click", () => console.log("parent"));
enfant.addEventListener("click", () => console.log("enfant"));
// Clic sur enfant affiche : "enfant" puis "parent"

// Pour ecouter en phase CAPTURE : 3eme argument = true
parent.addEventListener("click", () => console.log("parent capture"), true);

// Arreter la propagation
enfant.addEventListener("click", (evt) => {
    evt.stopPropagation();
    console.log("seulement enfant");
});
```

### Delegation d'evenements

```javascript
// Au lieu d'ajouter un listener sur chaque element enfant,
// on en met un seul sur le parent
const liste = document.getElementById("ma-liste");

liste.addEventListener("click", (evt) => {
    // evt.target = l'element reellement clique
    if (evt.target.tagName === "LI") {
        console.log("Element clique :", evt.target.textContent);
    }
});
```

---

## 9. Interaction utilisateur avancee

### Drag and Drop

Le Drag and Drop est un exemple d'interaction complexe composee de plusieurs evenements atomiques :

```
Drag and Drop = mousedown + mousemove(s) + mouseup

    mousedown      mousemove     mousemove     mouseup
        |              |              |            |
        v              v              v            v
    [pressed] ---> [moving] -----> [moving] --> [dropped]
```

### Machine a etats finis (FSM) pour les interactions

Comme vu en cours (front-end1.pdf), on peut modeliser les interactions utilisateur complexes avec des FSM :

```
Simple clic :
    idle --[press]--> pressed --[release]--> clicked

Double clic :
    idle --[click]--> clicked --[click (< 1s)]--> double_clicked
                          |--[timeout (> 1s)]--> cancelled

Drag and Drop :
    idle --[press]--> pressed --[move]--> moved --[release]--> dropped
              |                              |--[move]--> moved (boucle)
              |--[release]--> clicked
```

---

## 10. Architecture UI : MVC

### Le probleme : melanger donnees et affichage

```java
// MAUVAIS EXEMPLE (a NE PAS faire) :
// Classe qui melange donnees du modele et elements graphiques

public abstract class Figure implements Serializable, Drawable {
    // Donnees du modele
    protected float thickness;

    // Elements graphiques (MELANGE !)
    protected boolean isSelected;

    // Methodes du modele
    public double getRotationAngle() { /* ... */ }

    // Methodes de la vue (MELANGE !)
    public abstract void draw(Graphics2D g);
}
```

### Principe fondamental : separation modele / vue

```
+---------------------+          +---------------------+
|       MODELE        |          |         VUE         |
|                     |          |                     |
|  Donnees de         | <------> |  Representation     |
|  l'application      | (observe)|  graphique du       |
|                     |          |  modele              |
+---------------------+          +---------------------+
         ^                                |
         |                                |
         |        +---------------------+ |
         +--------|    CONTROLEUR       |<+
                   |                     |
                   |  Recoit les         |
                   |  evenements UI,     |
                   |  met a jour le      |
                   |  modele              |
                   +---------------------+
```

**Regles MVC** :
- Le **Modele** ne connait PAS la vue (pas de reference vers la vue)
- La **Vue** observe le modele (data binding, observer pattern)
- Le **Controleur** recoit les evenements et met a jour le modele

### Data Binding

Le data binding synchronise automatiquement les donnees entre le modele et la vue :

```
// En Angular, le data binding se fait dans le template HTML
// {{ }} = binding unidirectionnel (modele -> vue)
// [(ngModel)] = binding bidirectionnel (modele <-> vue)
```

---

## 11. Pieges courants

### Piege 1 : Selectionner un element avant son chargement
```javascript
// FAUX : le script s'execute avant que le DOM ne soit charge
// Si le script est dans le <head>, les elements n'existent pas encore

// CORRECT : attendre le chargement du DOM
document.addEventListener("DOMContentLoaded", () => {
    document.getElementById("btn").addEventListener("click", handler);
});

// Ou placer le script en fin de body (apres les elements)
```

### Piege 2 : Utilisation non securisee du HTML dynamique
```javascript
// DANGEREUX : si userInput contient du HTML/JS malveillant
// Ne jamais inserer du HTML provenant d'un utilisateur sans le nettoyer

// SECURISE : textContent n'interprete pas le HTML
element.textContent = userInput;
```

### Piege 3 : Confondre target et currentTarget
```javascript
// target : l'element qui a REELLEMENT declenche l'evenement
// currentTarget : l'element sur lequel le handler est ATTACHE

parent.addEventListener("click", (evt) => {
    evt.target;         // peut etre un enfant clique
    evt.currentTarget;  // toujours parent
});
```

### Piege 4 : Oublier removeEventListener
```javascript
// Chaque addEventListener sans removeEventListener = fuite memoire
// Surtout dans les boucles ou les composants recrees
```

### Piege 5 : Confondre les phases de propagation
```javascript
// Le bubbling (defaut) fait remonter les evenements vers les parents
// Si un parent et un enfant ont le meme handler, les deux se declenchent
// Solution : evt.stopPropagation() si necessaire
```

---

## 12. Recapitulatif

| Concept | A retenir |
|---------|-----------|
| DOM | Arbre d'objets representant le HTML en memoire |
| Selection | `querySelector` / `querySelectorAll` (preferee) |
| Modification | `textContent` (securise), `classList`, `style` |
| Creation | `createElement`, `appendChild`, `remove` |
| Evenements | `addEventListener` (preferee), objet `Event` |
| Souris | `click`, `mousedown`, `mouseup`, `mousemove` |
| Clavier | `keydown`, `keyup`, `evt.key`, `evt.ctrlKey` |
| Propagation | Capture -> Target -> Bubbling |
| Delegation | Un seul listener sur le parent, `evt.target` |
| MVC | Modele (donnees) / Vue (affichage) / Controleur (logique) |
| Data Binding | Synchronisation automatique modele <-> vue |

**Points cles pour le DS** :
- Savoir selectionner et modifier des elements du DOM
- Comprendre le systeme d'evenements (addEventListener)
- Connaitre les proprietes de MouseEvent et KeyboardEvent
- Comprendre la propagation (bubbling vs capture)
- Connaitre le pattern MVC et la separation modele/vue
