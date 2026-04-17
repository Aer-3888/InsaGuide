# Chapitre 5 : Angular et TypeScript -- Le front-end moderne

## Table des matieres

1. [Introduction a Angular](#1-introduction-a-angular)
2. [Architecture d'une application Angular](#2-architecture-dune-application-angular)
3. [Composants Angular](#3-composants-angular)
4. [Cycle de vie d'un composant](#4-cycle-de-vie-dun-composant)
5. [Injection de dependances](#5-injection-de-dependances)
6. [Data binding](#6-data-binding)
7. [Directives structurelles](#7-directives-structurelles)
8. [Gestion des evenements](#8-gestion-des-evenements)
9. [Templates HTML avances](#9-templates-html-avances)
10. [Acceder aux elements HTML](#10-acceder-aux-elements-html)
11. [Requetes REST (HttpClient)](#11-requetes-rest-httpclient)
12. [Routes Angular](#12-routes-angular)
13. [Pieges courants](#13-pieges-courants)
14. [Recapitulatif](#14-recapitulatif)

---

## 1. Introduction a Angular

### Qu'est-ce qu'Angular ?

Angular est un framework front-end developpe par **Google**, base sur **TypeScript**.

```
Angular en bref :
+----------------------------------+
| Langage    : TypeScript          |
| Editeur    : Google              |
| Type       : Framework front-end |
| Architecture : Model-View-       |
|               Component (MVC)    |
| Data binding : oui               |
| Injection de dependances : oui   |
| UIDL : HTML + data binding       |
+----------------------------------+
```

### Installation et lancement

```bash
# Installer Node.js et npm
# Installer Angular CLI
sudo npm install -g @angular/cli

# Dans le dossier front-end du projet
npm install          # installer les dependances
ng serve             # lancer le serveur de dev (localhost:4200)

# Sur les machines du departement INSA
npm run ng -- serve --open

# Builder pour la production
ng build --prod --build-optimizer
```

### Communication front-end / back-end

```
Front-end (Angular)              Back-end (Spring Boot)
localhost:4200                    localhost:8080
     |                                |
     |-- requete REST /game/* ------->|
     |<-- reponse JSON --------------|
     |                                |

Configuration du proxy (proxy.conf.json) :
{
    "/game/*": {
        "target": "http://localhost:4444",
        "secure": false,
        "changeOrigin": true
    }
}
```

---

## 2. Architecture d'une application Angular

### Structure des fichiers

```
src/app/
  |-- app.component.ts       (composant racine)
  |-- app.component.html      (vue du composant racine)
  |-- app.component.css       (styles du composant racine)
  |-- app.module.ts           (module principal)
  |-- app-routing.module.ts   (routes de l'application)
  |
  |-- component/
  |   |-- map/
  |   |   |-- map.component.ts
  |   |   |-- map.component.html
  |   |   |-- map.component.css
  |   |   |-- map.component.spec.ts   (tests)
  |   |-- menu/
  |       |-- menu.component.ts
  |       |-- ...
  |
  |-- model/
  |   |-- player.ts
  |   |-- game.ts
  |
  |-- service/
      |-- game.service.ts
```

### Commandes ng generate

```bash
# Nouveau composant
ng generate component component/myname

# Nouvelle classe
ng generate class model/foo

# Nouvelle interface
ng generate interface model/bar

# Nouveau service
ng generate service service/foofoo
```

---

## 3. Composants Angular

### Un composant = un dossier

```
mycomponent/
  |-- mycomponent.component.ts      (code TypeScript)
  |-- mycomponent.component.html    (template HTML)
  |-- mycomponent.component.css     (styles CSS)
  |-- mycomponent.component.spec.ts (tests)
```

### Le fichier TypeScript du composant

```typescript
import { Component } from '@angular/core';

@Component({
    selector: 'app-root',                     // nom de la balise HTML
    templateUrl: './app.component.html',       // lien vers le template
    styleUrls: ['./app.component.css']         // lien vers les styles
})
export class AppComponent {
    // Attributs du composant (accessibles dans le template)
    thetitle = 'app';
    score: number = 0;
    joueurs: Array<string> = [];

    // Methodes du composant
    incrementer(): void {
        this.score++;
    }
}
```

### Le template HTML du composant

```html
<main>
    <!-- {{ }} est un data binding : reference un attribut du composant -->
    <h1>{{thetitle}}</h1>
    <p>Score : {{score}}</p>

    <!-- Integrer un sous-composant -->
    <app-mycomponent></app-mycomponent>

    <!-- Pour une app multi-pages (routes) -->
    <router-outlet></router-outlet>
</main>
```

> **Regle importante** : Les proprietes et methodes utilisees dans le template HTML doivent etre **public**.

---

## 4. Cycle de vie d'un composant

Angular gere automatiquement le cycle de vie des composants. Plusieurs "hooks" sont disponibles :

```
Creation du composant
        |
        v
   constructor()      <-- injection de dependances
        |
        v
   ngOnInit()         <-- initialisation du composant
        |
        v
   ngAfterViewInit()  <-- la vue est initialisee (DOM disponible)
        |
        v
   [ vie du composant : detection de changements, etc. ]
        |
        v
   ngOnDestroy()      <-- composant detruit
```

```typescript
import { Component, OnInit, AfterViewInit } from '@angular/core';

export class MyComponent implements OnInit, AfterViewInit {
    constructor() {
        // Injection de dependances ici
    }

    ngOnInit(): void {
        // Initialisation : charger des donnees, etc.
    }

    ngAfterViewInit(): void {
        // La vue HTML est prete
        // Equivalent du "initialize" de JavaFX
        // On peut acceder aux elements HTML ici
    }
}
```

---

## 5. Injection de dependances

### Principe

Angular cree et fournit automatiquement les instances des services et modules necessaires.

```typescript
// Service injectable
@Injectable({
    providedIn: 'root'   // disponible dans toute l'application
})
export class GameService {
    private currentGame: Game;

    constructor() {
        this.currentGame = new Game();
    }

    public getCurrentGame(): Game {
        return this.currentGame;
    }
}
```

```typescript
// Composant qui utilise le service
export class FooComponent implements OnInit {
    ok: boolean;

    // Injection via le constructeur
    // private = declaration automatique d'attribut
    constructor(
        private http: HttpClient,        // module HTTP Angular
        private router: Router,          // module de routing
        private gameService: GameService // notre service
    ) {
        this.ok = false;
    }

    ngOnInit(): void {
        // Utilisation du service injecte
        const game = this.gameService.getCurrentGame();
    }
}
```

### Configuration dans le module

```typescript
@NgModule({
    imports: [
        BrowserModule,
        HttpClientModule,   // pour HttpClient
        RouterModule        // pour Router
    ],
    providers: [],
    // ...
})
export class AppModule { }
```

---

## 6. Data binding

### Types de data binding

```
+-----------------------------------------------+
| Type              | Syntaxe     | Direction   |
|-------------------|-------------|-------------|
| Interpolation     | {{ expr }}  | TS -> HTML  |
| Property binding  | [prop]      | TS -> HTML  |
| Event binding     | (event)     | HTML -> TS  |
| Two-way binding   | [(ngModel)] | TS <-> HTML |
+-----------------------------------------------+
```

### Interpolation : {{ }}

```html
<!-- Afficher un attribut du composant -->
<p>{{gameService.getCurrentGame().playerName}}</p>

<!-- Appeler une methode du composant -->
<p>Score : {{calculerScore()}}</p>
```

### Property binding : [ ]

```html
<!-- Lier un attribut HTML a une valeur du composant -->
<img [src]="player.avatarUrl"/>
<div [style.background-color]="player.color"></div>
<button [disabled]="!isReady">Jouer</button>
```

### Event binding : ( )

```html
<!-- Lier un evenement a une methode du composant -->
<button (click)="saveGame()">Sauvegarder</button>
<button (click)="ok = !ok">Basculer</button>

<!-- Acceder a l'objet evenement avec $event -->
<div (mousedown)="rightClick($event)">Zone cliquable</div>
```

```typescript
// Dans le composant
public rightClick(event: MouseEvent): void {
    // Recuperer l'element HTML source
    const element = event.currentTarget as Element;
    const x = element.getAttribute('data-x');
}
```

---

## 7. Directives structurelles

Les directives structurelles modifient la structure du DOM.

### *ngIf : affichage conditionnel

```html
<!-- Afficher uniquement si la condition est vraie -->
<p *ngIf="ok">Ce texte s'affiche si ok est true</p>

<!-- Avec une methode -->
<p *ngIf="isOk()">Resultat d'une methode</p>

<!-- Affichage du joueur courant si la partie n'est pas finie -->
<font [color]="getCurrentPlayer().color.code" *ngIf="!getVictoryPlayer()">
    Player {{getCurrentPlayer().name}}
    <b *ngIf="isComputerPlayer()">[computer]</b>
</font>
```

### *ngFor : boucle

```html
<!-- Creer 7 div (une par element du tableau) -->
<div *ngFor="let x of [0,1,2,3,4,5,6]">{{x}}</div>

<!-- Iterer sur un attribut du composant -->
<div *ngFor="let joueur of listeJoueurs">
    {{joueur.nom}} - {{joueur.score}}
</div>

<!-- Boucles imbriquees avec ng-container -->
<ng-container *ngFor="let y of [0,1,2,3,4,5,6]">
    <ng-container *ngFor="let x of [0,1,2,3,4,5,6]">
        <div>{{x}}, {{y}}</div>
    </ng-container>
</ng-container>
```

> **ng-container** : conteneur Angular non graphique (pas d'element dans le DOM). Utile pour les boucles imbriquees sans creer de balises HTML supplementaires.

### Attributs dynamiques

```html
<!-- Creer des attributs data-* dynamiques -->
<div class='aclass' *ngFor="let x of [0,1,2,3,4,5,6]"
     [attr.data-x]="x">
</div>

<!-- Recuperer data-x dans le TypeScript -->
<!-- (event.currentTarget as Element).getAttribute('data-x') -->
```

---

## 8. Gestion des evenements

### Syntaxe Angular

```html
<!-- Clic -->
<button (click)="setOk()">OK</button>

<!-- Clic avec modification directe -->
<button (click)="ok = !ok">Basculer</button>

<!-- Evenement souris avec objet $event -->
<div (mousedown)="rightClick($event)"></div>
```

```typescript
// Dans le composant
public rightClick(event: MouseEvent): void {
    const element = event.currentTarget as Element;
    const x = element.getAttribute('data-x');
    console.log(`Clic droit en x=${x}`);
}
```

### Equivalence avec JavaScript natif

| JavaScript natif | Angular |
|-----------------|---------|
| `element.addEventListener("click", handler)` | `(click)="handler()"` |
| `element.addEventListener("mousedown", handler)` | `(mousedown)="handler($event)"` |
| `element.addEventListener("keydown", handler)` | `(keydown)="handler($event)"` |

---

## 9. Templates HTML avances

### Exemple : grille de jeu

```html
<div class="map">
    <ng-container *ngFor="let y of [0,1,2,3,4,5,6,7,8,9]">
        <ng-container *ngFor="let x of [0,1,2,3,4,5,6,7,8,9]">
            <img class='tile' src='assets/tree.svg'
                 [attr.data-x]="x" [attr.data-y]="y"
                 (click)="onTileClick($event)"/>
        </ng-container>
    </ng-container>
</div>
```

### CSS associe avec variables

```css
div {
    --size-cell: 58px;
    --nb-cell: 10;
}

.map {
    line-height: 0;
    position: absolute;
    width: calc(var(--size-cell) * var(--nb-cell));
}

.tile {
    user-select: none;
    margin: 0;
    width: var(--size-cell);
    height: var(--size-cell);
}
```

---

## 10. Acceder aux elements HTML

### @ViewChildren et @ViewChild

```html
<!-- Dans le template : #myobjects est un identifiant de reference -->
<div #myobjects *ngFor="let x of [0,1,2,3,4,5,6]"></div>
```

```typescript
import { ViewChildren, ViewChild, QueryList, ElementRef, AfterViewInit } from '@angular/core';

export class MyComponent implements AfterViewInit {

    // Reference a PLUSIEURS elements (liste)
    @ViewChildren('myobjects')
    private myobjects: QueryList<ElementRef<HTMLDivElement>>;

    // Reference a UN SEUL element
    // @ViewChild('mysingleObject')
    // private obj: ElementRef<HTMLDivElement>;

    ngAfterViewInit(): void {
        // IMPORTANT : ne pas acceder avant ngAfterViewInit !
        this.myobjects.forEach(myobject => {
            console.log(myobject.nativeElement);
            // nativeElement = l'element HTML reel
        });
    }
}
```

---

## 11. Requetes REST (HttpClient)

### Configuration

```typescript
// Dans app.module.ts
import { HttpClientModule } from '@angular/common/http';

@NgModule({
    imports: [
        HttpClientModule   // activer HttpClient
    ]
})
```

### GET

```typescript
export class MyComponent {
    names: Array<string>;

    constructor(private http: HttpClient) {
        this.names = [];
    }

    chargerNoms(): void {
        this.http
            // get est generique : specifie le type de retour attendu
            .get<Array<string>>('game/myapi/names')
            // subscribe = s'abonner au resultat (programmation reactive)
            .subscribe(returnedData => this.names = returnedData);
    }
}
```

### GET avec un objet type

```typescript
export interface Foo {
    attr1: string;
    attr2: Array<number>;
}

chargerFoo(value: string): void {
    this.http
        .get<Foo>(`game/myapi/foo/${value}`)
        // Si l'interface n'a pas de methodes, le JSON retourne
        // est directement assignable a une variable de type Foo
        .subscribe(data => this.foo = data);
}
```

### POST

```typescript
// Envoyer un objet
envoyerFoo(): void {
    this.http
        .post('game/myapi/foo/', JSON.stringify(this.foo), {})
        .subscribe(returnedData => { });
}

// Envoyer du JSON directement
envoyerData(): void {
    this.http
        .post('game/myapi/bar/', {
            myAttr1: '1',
            myAttr2: ['a', 'b']
        }, {})
        .subscribe(returnedData => { });
}
```

### PUT et DELETE

```typescript
// PUT
rightClick(event: MouseEvent): void {
    const x = (event.currentTarget as Element).getAttribute('data-x');
    this.http
        .put(`game/myapi/${x}`, {}, {})
        .subscribe(data => console.log(data));
}

// DELETE
supprimer(id: number): void {
    this.http
        .delete(`game/myapi/${id}`)
        .subscribe(() => console.log('supprime'));
}
```

### Promises (alternative a subscribe)

```typescript
// Retourner une Promise au lieu de subscribe
async chargerFoo(name: string): Promise<Foo> {
    return this.http
        .get<Foo>(`game/myapi/foo/${name}`)
        .toPromise();
}

// Utilisation avec await
const foo = await this.chargerFoo("test");
```

**Regle importante** : `subscribe` est obligatoire. Sans subscribe, la requete n'est PAS envoyee.

---

## 12. Routes Angular

### Principe

Chaque composant peut correspondre a une "page" (route) de l'application.

```
URL /         -->  AppComponent
URL /game     -->  GameComponent
URL /menu     -->  MenuComponent
```

### Configuration

```typescript
// app-routing.module.ts
const routes: Routes = [
    { path: '', component: AppComponent },
    { path: 'game', component: GameComponent },
    { path: 'menu', component: MenuComponent }
];

@NgModule({
    imports: [RouterModule.forRoot(routes)],
    exports: [RouterModule]
})
export class AppRoutingModule { }
```

### Navigation

```html
<!-- Dans le template : router-outlet affiche le composant de la route -->
<router-outlet></router-outlet>

<!-- Liens de navigation -->
<a routerLink="/game">Jouer</a>
<a routerLink="/menu">Menu</a>
```

```typescript
// Navigation programmatique
constructor(private router: Router) { }

naviguerVersJeu(): void {
    this.router.navigate(['/game']);
}
```

---

## 13. Pieges courants

### Piege 1 : Oublier subscribe
```typescript
// FAUX : la requete n'est PAS envoyee !
this.http.get('game/myapi/data');

// CORRECT : subscribe declenche la requete
this.http.get('game/myapi/data').subscribe(data => { });
```

### Piege 2 : Acceder au DOM avant ngAfterViewInit
```typescript
// FAUX : la vue n'est pas encore prete
constructor() {
    this.myobjects.forEach(...);  // ERREUR
}

// CORRECT : attendre ngAfterViewInit
ngAfterViewInit(): void {
    this.myobjects.forEach(...);  // OK
}
```

### Piege 3 : Proprietes privees dans le template
```typescript
// FAUX : les proprietes privees ne sont PAS accessibles dans le HTML
private score: number = 0;
// <p>{{score}}</p>  --> erreur de compilation

// CORRECT : public (ou sans modificateur)
score: number = 0;
// <p>{{score}}</p>  --> OK
```

### Piege 4 : this dans les arrow functions
```typescript
// Rappel : dans une arrow function assignee a une propriete d'objet,
// this ne pointe PAS vers l'objet
const game = {
    points: 0,
    increase: () => { this.points++; }  // BUG : this n'est pas game
};
```

### Piege 5 : Confondre nativeElement et ElementRef
```typescript
// ElementRef est un wrapper Angular
// nativeElement est l'element HTML reel
this.myobjects.forEach(ref => {
    // ref = ElementRef
    // ref.nativeElement = HTMLDivElement
    ref.nativeElement.style.color = 'red';
});
```

### Piege 6 : Route nommee comme le proxy back-end
```typescript
// FAUX : si le proxy redirige /game/* vers le back-end,
// ne pas creer une route Angular nommee 'game'
{ path: 'game', component: GameComponent }
// Les requetes seront redirigees vers le back-end !

// CORRECT : utiliser un nom different
{ path: 'play', component: GameComponent }
```

---

## 14. Recapitulatif

| Concept | A retenir |
|---------|-----------|
| Angular | Framework front-end Google, TypeScript, composants |
| Composant | .ts + .html + .css + .spec.ts, @Component |
| Cycle de vie | constructor -> ngOnInit -> ngAfterViewInit -> ngOnDestroy |
| Injection | @Injectable, constructeur avec `private service: Service` |
| Data binding | `{{ }}` interpolation, `[prop]` property, `(event)` event |
| *ngIf | Affichage conditionnel |
| *ngFor | Boucle sur un tableau |
| ng-container | Conteneur Angular invisible (pas de balise HTML) |
| @ViewChildren | Reference aux elements HTML (#identifiant) |
| HttpClient | GET, POST, PUT, DELETE, subscribe obligatoire |
| Routes | RouterModule, router-outlet, routerLink |

**Points cles pour le DS** :
- Savoir ecrire un composant Angular (TypeScript + HTML)
- Comprendre le data binding ({{ }}, [ ], ( ))
- Utiliser *ngIf et *ngFor
- Savoir faire des requetes REST avec HttpClient + subscribe
- Comprendre l'injection de dependances
- Connaitre le cycle de vie (ngOnInit, ngAfterViewInit)
