# Chapitre 2 : JavaScript ES6+ -- Le langage du Web

## Table des matieres

1. [Introduction a JavaScript](#1-introduction-a-javascript)
2. [Variables et types](#2-variables-et-types)
3. [Fonctions](#3-fonctions)
4. [Objets et JSON](#4-objets-et-json)
5. [Tableaux et methodes fonctionnelles](#5-tableaux-et-methodes-fonctionnelles)
6. [Classes ES6](#6-classes-es6)
7. [Modules (import/export)](#7-modules-importexport)
8. [Programmation asynchrone](#8-programmation-asynchrone)
9. [TypeScript : le sur-ensemble type de JavaScript](#9-typescript--le-sur-ensemble-type-de-javascript)
10. [Pieges courants](#10-pieges-courants)
11. [Recapitulatif](#11-recapitulatif)

---

## 1. Introduction a JavaScript

### Qu'est-ce que JavaScript ?

JavaScript (JS) est le langage de programmation natif du Web. Il est execute par le navigateur.

```
+------------------+
|    Navigateur     |
|                  |
|  +------------+  |       JavaScript est :
|  | Moteur JS  |  |       - Faiblement type (pas de verification a la compilation)
|  | (V8, etc.) |  |       - Interprete (pas de compilation classique)
|  +------------+  |       - Oriente prototype (pas de classes classiques, avant ES6)
|                  |       - Mono-thread (mais asynchrone)
+------------------+
```

### Pourquoi TypeScript existe-t-il ?

JavaScript est faiblement type, ce qui est source d'erreurs. TypeScript ajoute un systeme de types statiques au-dessus de JavaScript. TypeScript est **compile** (transpile) en JavaScript avant execution.

```
TypeScript (.ts)  --->  Compilateur tsc  --->  JavaScript (.js)  --->  Navigateur
   (type)                                        (pas de type)
```

### Ou s'execute JavaScript ?

- **Dans le navigateur** : manipulation du DOM, interactions utilisateur
- **Cote serveur** : Node.js (hors programme de ce cours)

> **Astuce** : Utilisez TOUJOURS la console du navigateur (Ctrl+Shift+K sous Firefox, F12 sous Chrome) pour voir les erreurs JavaScript.

---

## 2. Variables et types

### Declaration de variables

```javascript
// var : portee de fonction (ancien, a eviter)
var x = 10;

// let : portee de bloc (a privilegier pour les variables mutables)
let compteur = 0;
compteur = 1;  // OK, on peut reassigner

// const : portee de bloc, non reassignable (a privilegier)
const PI = 3.14159;
// PI = 3; // ERREUR : Assignment to constant variable

// ATTENTION : const ne signifie pas immutable pour les objets
const tab = [1, 2, 3];
tab.push(4);  // OK ! On modifie le contenu, pas la reference
// tab = []; // ERREUR : on ne peut pas reassigner la reference
```

### Les types en JavaScript

JavaScript n'a que quelques types primitifs :

```javascript
// number (pas de distinction int/float)
let entier = 42;
let decimal = 3.14;

// string
let nom = "Alice";
let phrase = 'Bonjour';
let template = `Salut ${nom}`;  // template string (backticks)

// boolean
let actif = true;
let supprime = false;

// null et undefined
let vide = null;       // absence intentionnelle de valeur
let inconnu;           // undefined : variable declaree mais pas initialisee

// object (tout le reste : objets, tableaux, fonctions)
let obj = { cle: "valeur" };
let tab = [1, 2, 3];

// Verifier le type
typeof 42;          // "number"
typeof "hello";     // "string"
typeof true;        // "boolean"
typeof undefined;   // "undefined"
typeof null;        // "object"  <-- piege historique !
typeof [1, 2];      // "object"  <-- les tableaux sont des objets
```

### Comparaison : == vs ===

```javascript
// == : comparaison avec conversion de type (a EVITER)
0 == "";       // true  (les deux sont "falsy")
0 == false;    // true
"1" == 1;      // true  (conversion string -> number)
null == undefined; // true

// === : comparaison stricte, sans conversion (TOUJOURS utiliser)
0 === "";      // false
0 === false;   // false
"1" === 1;     // false
null === undefined; // false
```

> **Regle d'or** : Utilisez TOUJOURS `===` et `!==` en JavaScript et TypeScript.

### Valeurs "falsy" et "truthy"

```javascript
// Valeurs falsy (evaluees a false dans un contexte booleen) :
// false, 0, "", null, undefined, NaN

if ("") {
    // ce code ne s'execute PAS
}

if ("hello") {
    // ce code S'EXECUTE (string non vide = truthy)
}

// Raccourci courant :
let nom = utilisateur.nom || "Anonyme";
// Si utilisateur.nom est falsy, on utilise "Anonyme"
```

---

## 3. Fonctions

### Declaration classique

```javascript
// Declaration de fonction (hoisted : accessible avant sa declaration)
function addition(a, b) {
    return a + b;
}

// Expression de fonction (pas hoisted)
const soustraction = function(a, b) {
    return a - b;
};
```

### Fonctions flechees (arrow functions) -- ES6

```javascript
// Syntaxe complete
const multiplier = (a, b) => {
    return a * b;
};

// Syntaxe raccourcie (retour implicite sur une ligne)
const multiplier = (a, b) => a * b;

// Un seul parametre : parentheses optionnelles
const doubler = x => x * 2;

// Pas de parametre : parentheses obligatoires
const direBonjour = () => "Bonjour !";
```

### Differences entre function et arrow function

```javascript
// ATTENTION au 'this' dans les arrow functions !

const jeu = {
    points: 0,

    // Methode classique : this = l'objet jeu
    incrementer: function() {
        this.points++;   // OK : this = jeu
    },

    // Arrow function : this = contexte ENGLOBANT (PAS l'objet)
    incrementerArrow: () => {
        this.points++;   // BUG : this n'est PAS jeu ici !
    }
};
```

> **Regle** : Utilisez les arrow functions pour les callbacks et les fonctions courtes. Utilisez `function` pour les methodes d'objets qui ont besoin de `this`.

### Parametres par defaut et destructuration

```javascript
// Parametres par defaut
function saluer(nom = "Monde") {
    return `Bonjour ${nom} !`;
}
saluer();          // "Bonjour Monde !"
saluer("Alice");   // "Bonjour Alice !"

// Destructuration d'objet dans les parametres
function afficherUtilisateur({ nom, age, ville = "inconnu" }) {
    console.log(`${nom}, ${age} ans, ${ville}`);
}
afficherUtilisateur({ nom: "Alice", age: 22 });
// "Alice, 22 ans, inconnu"

// Operateur spread / rest
function somme(...nombres) {
    return nombres.reduce((acc, n) => acc + n, 0);
}
somme(1, 2, 3, 4);  // 10

const tab1 = [1, 2, 3];
const tab2 = [...tab1, 4, 5];  // [1, 2, 3, 4, 5] (spread)
```

---

## 4. Objets et JSON

### Objets JavaScript

```javascript
// Notation litterale
const personne = {
    nom: "Alice",
    age: 22,
    adresses: ["Rennes", "Paris"],
    saluer: function() {
        return `Bonjour, je suis ${this.nom}`;
    }
};

// Acces aux proprietes
console.log(personne.nom);           // "Alice"
console.log(personne["nom"]);        // "Alice" (notation crochet)
console.log(personne.adresses[0]);   // "Rennes"
personne.saluer();                   // "Bonjour, je suis Alice"

// Raccourci ES6 : proprietes calculees
const cle = "nom";
const obj = { [cle]: "Alice" };  // { nom: "Alice" }

// Raccourci ES6 : nom de propriete = nom de variable
const nom = "Alice";
const age = 22;
const personne2 = { nom, age };  // { nom: "Alice", age: 22 }
```

### JSON (JavaScript Object Notation)

JSON est le format d'echange de donnees principal en Web.

```javascript
// Structure JSON
const jsonExemple = {
    "idcard": 1843739,
    "name": "John Doe",
    "address": ["Adress 1", "Adress 2"],
    "phone": {
        "prefix": "+33",
        "number": "000000"
    },
    "siblings": null,
    "alive": false
};
```

**Regles JSON** :
- Les cles sont TOUJOURS entre guillemets doubles
- Valeurs possibles : string, number, boolean, null, array, object
- Pas de commentaires
- Pas de fonctions
- Pas de virgule finale (trailing comma)

```javascript
// Conversion objet <-> JSON
const texte = JSON.stringify(personne);     // objet -> texte JSON
const objet = JSON.parse(texte);            // texte JSON -> objet

// Gestion des erreurs de parsing
try {
    const data = JSON.parse("texte invalide");
} catch (err) {
    console.log("Erreur de parsing JSON");
}
```

---

## 5. Tableaux et methodes fonctionnelles

### Creation et manipulation

```javascript
// Creation
const nombres = [1, 2, 3, 4, 5];
const vide = [];

// Acces
nombres[0];       // 1
nombres.length;   // 5

// Ajout / Suppression
nombres.push(6);        // ajoute a la fin : [1,2,3,4,5,6]
nombres.pop();           // retire le dernier : [1,2,3,4,5]
nombres.unshift(0);      // ajoute au debut : [0,1,2,3,4,5]
nombres.shift();         // retire le premier : [1,2,3,4,5]
```

### Methodes fonctionnelles (tres utilisees en Web)

```javascript
const nombres = [1, 2, 3, 4, 5];

// forEach : parcourir sans creer de nouveau tableau
nombres.forEach(n => console.log(n));

// map : transformer chaque element (retourne un nouveau tableau)
const doubles = nombres.map(n => n * 2);
// [2, 4, 6, 8, 10]

// filter : garder les elements qui satisfont une condition
const pairs = nombres.filter(n => n % 2 === 0);
// [2, 4]

// find : trouver le premier element qui satisfait la condition
const premierPair = nombres.find(n => n % 2 === 0);
// 2

// reduce : accumuler une valeur
const somme = nombres.reduce((acc, n) => acc + n, 0);
// 15

// some : au moins un element satisfait la condition ?
nombres.some(n => n > 4);  // true

// every : tous les elements satisfont la condition ?
nombres.every(n => n > 0);  // true

// includes : le tableau contient-il cette valeur ?
nombres.includes(3);  // true
```

### Exemple combine

```javascript
const etudiants = [
    { nom: "Alice", note: 16 },
    { nom: "Bob", note: 8 },
    { nom: "Charlie", note: 14 },
    { nom: "Diana", note: 11 }
];

// Noms des etudiants ayant la moyenne (>= 10), tries par note
const reussite = etudiants
    .filter(e => e.note >= 10)        // garder les >= 10
    .sort((a, b) => b.note - a.note)  // trier par note decroissante
    .map(e => e.nom);                 // extraire les noms
// ["Alice", "Charlie", "Diana"]
```

---

## 6. Classes ES6

### Syntaxe de classe

```javascript
class Shape {
    // Constructeur
    constructor(color, linewidth) {
        this.color = color;
        this.linewidth = linewidth;
    }

    // Methode
    describe() {
        return `Shape de couleur ${this.color}`;
    }
}

// Heritage
class Rectangle extends Shape {
    constructor(color, linewidth, width, height) {
        super(color, linewidth);  // appel au constructeur parent
        this.width = width;
        this.height = height;
    }

    area() {
        return this.width * this.height;
    }

    // Surcharge
    describe() {
        return `Rectangle ${this.width}x${this.height}, ${super.describe()}`;
    }
}

// Utilisation
const rect = new Rectangle("red", 2, 100, 50);
console.log(rect.area());      // 5000
console.log(rect.describe());  // "Rectangle 100x50, Shape de couleur red"
```

### Export de classes (modules ES6)

```javascript
// model.js
export class Shape {
    constructor(color, linewidth) {
        this.color = color;
        this.linewidth = linewidth;
    }
}

export class Rectangle extends Shape {
    constructor(color, linewidth, width, height) {
        super(color, linewidth);
        this.width = width;
        this.height = height;
    }
}

// main.js
import { Shape, Rectangle } from './model.js';
```

---

## 7. Modules (import/export)

### Exports nommes

```javascript
// utils.js
export function addition(a, b) { return a + b; }
export function soustraction(a, b) { return a - b; }
export const PI = 3.14159;

// main.js
import { addition, soustraction, PI } from './utils.js';
addition(2, 3);  // 5
```

### Export par defaut

```javascript
// Calculatrice.js
export default class Calculatrice {
    addition(a, b) { return a + b; }
}

// main.js
import Calculatrice from './Calculatrice.js';
// Pas d'accolades pour le default
```

### Import complet

```javascript
// Importer tout sous un namespace
import * as utils from './utils.js';
utils.addition(2, 3);
utils.PI;
```

---

## 8. Programmation asynchrone

### Callbacks

```javascript
// Ancienne maniere (callback hell)
function chargerDonnees(url, callback) {
    fetch(url)
        .then(response => response.json())
        .then(data => callback(data));
}
```

### Promises

```javascript
// Une Promise represente une valeur future
const promesse = new Promise((resolve, reject) => {
    // Operation asynchrone
    setTimeout(() => {
        const succes = true;
        if (succes) {
            resolve("Donnees recues");    // succes
        } else {
            reject("Erreur reseau");      // echec
        }
    }, 1000);
});

// Utilisation
promesse
    .then(data => console.log(data))      // si resolve
    .catch(err => console.error(err));     // si reject
```

### async/await (ES2017)

```javascript
// Syntaxe plus lisible pour les Promises
async function chargerUtilisateur(id) {
    try {
        const response = await fetch(`/api/users/${id}`);
        const data = await response.json();
        return data;
    } catch (err) {
        console.error("Erreur:", err);
    }
}

// Appel
const user = await chargerUtilisateur(1);
```

### fetch API

```javascript
// GET
const response = await fetch('/api/data');
const data = await response.json();

// POST avec body JSON
const response = await fetch('/api/data', {
    method: 'POST',
    headers: {
        'Content-Type': 'application/json'
    },
    body: JSON.stringify({ nom: "Alice", age: 22 })
});
```

---

## 9. TypeScript : le sur-ensemble type de JavaScript

### Types de base

```typescript
// Types primitifs
let nom: string = "Alice";
let age: number = 22;
let actif: boolean = true;
let donnees: any = "peut etre n'importe quoi";  // a eviter

// Types speciaux
let vide: void = undefined;      // pour les fonctions sans retour
let inconnu: undefined = undefined;
let rien: null = null;

// Union de types
let valeur: string | number = "hello";
valeur = 42;  // OK

// Type optionnel (raccourci pour T | undefined)
let optionnel?: string;  // equivalent a string | undefined
```

### Interfaces TypeScript

```typescript
// Definition d'interface
export interface Data {
    attr1: string;
    attr2: string;
    foo(): number;            // methode
    bar: () => number;        // propriete de type fonction
}

// Les interfaces TypeScript peuvent typer du JSON
export interface Personne {
    nom: string;
    age: number;
    adresses: string[];
}

// Assigner du JSON a une interface (sans new !)
const alice: Personne = {
    nom: "Alice",
    age: 22,
    adresses: ["Rennes", "Paris"]
};
```

### Classes TypeScript

```typescript
export class MaClasse {
    // readonly : equivalent de final en Java
    readonly id: number;

    // private, public, protected comme en Java
    private donnees: string[];

    // Parametre avec visibilite dans le constructeur =
    // declaration automatique d'attribut
    constructor(private router: Router, public nom: string) {
        this.id = 42;
        this.donnees = [];
    }

    // Methode
    private traiter(param: number): void {
        // Iterer sur un tableau
        this.donnees.forEach(e => console.log(e));

        // Triple egal obligatoire
        if (this.nom === undefined) {
            console.log("pas de nom");
        }
    }
}
```

### Getter / Setter TypeScript

```typescript
export class Data {
    private _valeur: string;

    public set valeur(v: string) {
        this._valeur = v;
    }

    public get valeur(): string {
        return this._valeur;
    }
}

// Utilisation transparente (comme un attribut)
const d = new Data();
d.valeur = "hello";       // appelle le setter
console.log(d.valeur);    // appelle le getter
```

### Tableaux en TypeScript

```typescript
// Declaration
const liste: Array<string> = [];
// ou equivalemment :
const liste2: string[] = [];

// Methodes identiques a JavaScript
const resultat: string[] = liste.filter(e => e === 'bar');
const trouve: string | undefined = liste.find(e => e === 'bar');
liste.push('nouvel element');
liste.forEach(e => console.log(e));
```

---

## 10. Pieges courants

### Piege 1 : == au lieu de ===
```javascript
// FAUX : comparaison avec conversion
if (valeur == null) { }

// CORRECT : comparaison stricte
if (valeur === null) { }
if (valeur !== undefined) { }
```

### Piege 2 : this dans les arrow functions
```javascript
const objet = {
    valeur: 42,
    // BUG : this ne pointe PAS vers objet dans une arrow function
    getValeur: () => this.valeur,

    // CORRECT : utiliser function
    getValeur2: function() { return this.valeur; }
};
```

### Piege 3 : var au lieu de let/const
```javascript
// FAUX : var a une portee de fonction, pas de bloc
for (var i = 0; i < 5; i++) { }
console.log(i); // 5 (fuite de variable !)

// CORRECT : let a une portee de bloc
for (let j = 0; j < 5; j++) { }
// console.log(j); // ReferenceError
```

### Piege 4 : typeof null
```javascript
typeof null;  // "object" et NON "null" (bug historique de JS)

// Pour verifier null, utiliser ===
if (valeur === null) { }
```

### Piege 5 : Oublier async/await
```javascript
// FAUX : la fonction retourne une Promise, pas les donnees
function getData() {
    return fetch('/api/data').then(r => r.json());
}
const data = getData();  // data est une Promise, pas les donnees !

// CORRECT
async function getData() {
    return await fetch('/api/data').then(r => r.json());
}
const data = await getData();
```

### Piege 6 : JSON.stringify de fonctions
```javascript
const obj = { nom: "Alice", saluer: () => "Bonjour" };
JSON.stringify(obj);  // '{"nom":"Alice"}' -- la fonction a disparu !
```

---

## 11. Recapitulatif

| Concept | A retenir |
|---------|-----------|
| Variables | `const` par defaut, `let` si mutation, jamais `var` |
| Types | number, string, boolean, null, undefined, object |
| Comparaison | TOUJOURS `===` et `!==` |
| Fonctions | Arrow functions pour les callbacks, `function` pour les methodes |
| Objets | Notation litterale `{ cle: valeur }`, destructuration |
| JSON | Format d'echange texte, `JSON.stringify()` / `JSON.parse()` |
| Tableaux | `map`, `filter`, `find`, `reduce`, `forEach` |
| Classes | `class`, `extends`, `super`, `constructor` |
| Modules | `export` / `import { } from` |
| Async | `Promise`, `async/await`, `fetch` |
| TypeScript | Types statiques, interfaces, classes typees |

**Points cles pour le DS** :
- Difference entre `==` et `===`
- Savoir manipuler du JSON (parse, stringify)
- Comprendre les arrow functions et le probleme de `this`
- Connaitre les methodes de tableau (map, filter, find)
- Syntaxe TypeScript : interfaces, classes, types
