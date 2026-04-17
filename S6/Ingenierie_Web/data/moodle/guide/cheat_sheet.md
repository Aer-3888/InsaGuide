# Cheat Sheet -- Ingenierie Web 3INFO INSA Rennes

> Synthese pour le DS. Polycopes et notes de cours autorises.
> Duree : 1 heure (1h20 pour tiers-temps). Ecrire directement sur le sujet.

---

## Structure typique du DS (basee sur les annales 2017-2023)

| Exercice | Theme | Points | Ce qu'on vous demande |
|----------|-------|--------|----------------------|
| **1** | Questions de cours | ~8 pts | Definitions, vrai/faux, comparaisons |
| **2** | ORM / JPA | ~6 pts | Annotations JPA sur un diagramme UML |
| **3** | Routes REST | ~6 pts | Definir verbe + URI + body + reponse |
| **4** | Securite | ~2 pts | Authentification, sessions, droits |

---

## 1. Questions de cours -- Reponses types

### Architecture Web

| Question | Reponse |
|----------|---------|
| Page Web vs Application Web ? | Page = contenu statique. App = logiciel distribue client-serveur |
| Front-end vs Back-end ? | Front = interface navigateur. Back = serveur (donnees, calculs) |
| Full-stack ? | Personne capable de dev front ET back |
| npm vs maven ? | npm = front-end (JS/TS). maven = back-end (Java) |

### REST

| Question | Reponse |
|----------|---------|
| Qu'est-ce que REST ? | Style d'architecture client-serveur, stateless, sur HTTP |
| Lien REST et HTTP ? | REST utilise HTTP comme protocole de transport |
| URI vs URL ? | Une URL est une URI (URL = URI localisable) |
| Peut-on appeler directement une methode Java du back-end depuis le front ? | NON. On utilise des requetes REST (HTTP) |
| Pourquoi REST ? | CRUD, API explicite, asynchrone, multi-langage |
| Inconvenients REST ? | Asynchrone, verbeux, unidirectionnel (back -> front impossible) |

### TypeScript

| Question | Reponse |
|----------|---------|
| Pourquoi TypeScript vs JavaScript ? | TypeScript ajoute le typage statique = moins d'erreurs |
| Interface TS = schema JSON ? | OUI, une interface TS peut typer une structure JSON |
| == vs === ? | === compare sans conversion de type (TOUJOURS utiliser ===) |

### Formats de donnees

| Question | Reponse |
|----------|---------|
| Role d'un schema XML ? | Definir le vocabulaire et la structure valide d'un document |
| XML bien forme vs valide ? | Bien forme = syntaxe OK. Valide = bien forme + conforme au schema |
| JSON vs XML ? | JSON : cle-valeur, pas de schema. XML : balises, schemas possibles |

---

## 2. ORM / JPA -- Annotations essentielles

### Patron de base

```java
@Data              // Lombok : getters, setters, toString, equals, hashCode
@Entity            // Entite JPA (sera stockee en base)
public class Foo {
    @Id                  // Cle primaire
    @GeneratedValue      // Auto-incrementee
    private long id;

    private String name;
}
```

### Relations

```java
// UN Foo a PLUSIEURS Bars
@OneToMany(mappedBy = "foo", cascade = CascadeType.PERSIST, fetch = FetchType.LAZY)
private List<Bar> bars;

// PLUSIEURS Bars appartiennent a UN Foo
@ManyToOne
private Foo foo;

// PLUSIEURS Foo <-> PLUSIEURS Bar
@ManyToMany
private List<Bar> bars;
```

### Heritage

```java
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE) // ou TABLE_PER_CLASS, JOINED
public class Player { }

@Entity
public class BaseballPlayer extends Player {
    private int totalHomeRuns;
}
```

### Repository

```java
@Repository
public interface FooCrudRepository extends CrudRepository<Foo, Long> {
    // Methodes auto : save, delete, findById, findAll

    // Requete personnalisee
    @Query("select u from User u where u.name like %?1%")
    List<User> findUserNameContainsTxt(final String txt);
}
```

### Checklist ORM pour le DS

A partir d'un diagramme UML, pour chaque classe :
1. Ajouter `@Entity`
2. Ajouter `@Id` et `@GeneratedValue` sur l'identifiant
3. Pour chaque association :
   - Composition 1..* : `@OneToMany` + `@ManyToOne` cote inverse
   - Association * .. * : `@ManyToMany`
   - Precision : `mappedBy`, `cascade`, `fetch`
4. Pour l'heritage : `@Inheritance(strategy = ...)`
5. Definir un `Repository` par entite

---

## 3. Routes REST -- Syntaxe Spring Boot

### Annotations des routes

| Verbe | Annotation | Usage |
|-------|-----------|-------|
| GET | `@GetMapping` | Lire |
| POST | `@PostMapping` | Creer |
| PUT | `@PutMapping` | Remplacer |
| PATCH | `@PatchMapping` | Modifier partiellement |
| DELETE | `@DeleteMapping` | Supprimer |

### Squelette d'un controleur

```java
@RestController
@RequestMapping("api/public/v1/exam")
public class ExamController {
    private final ExamService examService;

    public ExamController(final ExamService examService) {
        this.examService = examService;
    }

    // GET : lire tous les examens
    @GetMapping(path = "all", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<List<ExamDTO>> getAllExams() {
        return ResponseEntity.ok(examService.getAllExams());
    }

    // GET : lire un examen par ID
    @GetMapping(path = "{id}", produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ExamDTO> getExam(@PathVariable("id") final long id) {
        Optional<ExamDTO> opt = examService.getExam(id);
        if (opt.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.NOT_FOUND, "Exam not found");
        }
        return ResponseEntity.ok(opt.get());
    }

    // POST : creer un examen
    @PostMapping(path = "", consumes = MediaType.APPLICATION_JSON_VALUE,
                           produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ExamDTO> createExam(@RequestBody final ExamNoIdDTO dto) {
        return ResponseEntity.ok(examService.createExam(dto));
    }

    // PATCH : modifier un examen
    @PatchMapping(path = "{id}", consumes = MediaType.APPLICATION_JSON_VALUE,
                                 produces = MediaType.APPLICATION_JSON_VALUE)
    public ResponseEntity<ExamDTO> patchExam(@PathVariable("id") final long id,
                                              @RequestBody final ExamDTO dto) {
        Optional<ExamDTO> opt = examService.patchExam(id, dto);
        if (opt.isEmpty()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Invalid");
        }
        return ResponseEntity.ok(opt.get());
    }

    // DELETE : supprimer un examen
    @DeleteMapping(path = "{id}")
    public ResponseEntity<Void> deleteExam(@PathVariable("id") final long id) {
        if (!examService.deleteExam(id)) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Cannot delete");
        }
        return ResponseEntity.ok().build();
    }
}
```

### Transmission des donnees

| Methode | Annotation | Exemple URL |
|---------|-----------|-------------|
| Body | `@RequestBody` | POST /api/exam (body : JSON) |
| URI variable | `@PathVariable("id")` | GET /api/exam/{id} |
| Query param | `@RequestParam("name")` | GET /api/exam?name=foo |

### Codes HTTP de retour

| Code | Nom | Quand l'utiliser |
|------|-----|-----------------|
| 200 | OK | Succes |
| 201 | Created | Ressource creee (POST) |
| 204 | No Content | OK mais rien a retourner |
| 400 | Bad Request | Donnees invalides |
| 404 | Not Found | Ressource inexistante |
| 405 | Method Not Allowed | Mauvais verbe HTTP |
| 500 | Internal Server Error | Bug dans le back-end |

### Checklist routes REST pour le DS

Pour chaque route demandee :
1. **Verbe** : POST/GET/PUT/PATCH/DELETE
2. **URI** : `api/resource/{param}`
3. **Body requete** : quel DTO en entree (si POST/PUT/PATCH)
4. **Body reponse** : quel DTO en sortie, quel code HTTP
5. **DTO** : dessiner le diagramme UML du DTO si demande

---

## 4. DTO -- Patron de conception

```java
// Entite (modele) : contient TOUTES les donnees
@Entity
public class User {
    @Id @GeneratedValue private long id;
    private String name;
    private String address;
    private String password;   // CONFIDENTIEL
}

// DTO pour GET : sans mot de passe
public class UserDTO {
    private long id;
    private String name;
    private String address;
    // PAS de password
    public UserDTO(User u) { id = u.getId(); name = u.getName(); address = u.getAddress(); }
}

// DTO pour POST : sans id (sera genere)
public class UserNoIdDTO {
    private String name;
    private String address;
}
```

---

## 5. Securite -- Points cles

```
1. Routes publiques : /api/public/** --> permitAll()
2. Routes privees  : tout le reste  --> authenticated()
3. Connexion       : POST /login    --> retourne Set-Cookie: JSESSIONID=xxx
4. Requetes privees: Cookie: JSESSIONID=xxx --> le serveur identifie l'utilisateur
5. Verification    : Principal user --> user.getName() pour obtenir le login
6. Protection      : verifier que la donnee demandee appartient a l'utilisateur
```

### Questions frequentes en DS

| Question | Reponse |
|----------|---------|
| Comment proteger des routes ? | `antMatchers("/api/private/**").authenticated()` |
| Qu'est-ce qu'un cookie de session ? | Identifiant JSESSIONID stocke cote client |
| Comment verifier les droits d'un utilisateur ? | Injecter `Principal user`, verifier avec `user.getName()` |
| Qu'est-ce que CSRF ? | Cross-Site Request Forgery : forcer un navigateur a envoyer une requete non voulue |

---

## 6. Syntaxe rapide TypeScript / Angular

### TypeScript

```typescript
// Classe
export class Foo {
    readonly id: number;
    private data: string[];
    constructor(private router: Router, public name: string) { }
}

// Interface (peut typer du JSON)
export interface Bar { attr1: string; attr2: number; }
const b: Bar = { attr1: "hello", attr2: 42 };

// Array
const list: Array<string> = [];
list.push("a"); list.filter(e => e === "a"); list.find(e => e === "a");
list.forEach(e => console.log(e)); list.map(e => e.toUpperCase());

// Getter / Setter
public get val(): string { return this._val; }
public set val(v: string) { this._val = v; }
```

### Angular

```typescript
// Composant
@Component({ selector: 'app-foo', templateUrl: './foo.html', styleUrls: ['./foo.css'] })
export class FooComponent implements OnInit, AfterViewInit {
    constructor(private http: HttpClient, private gameService: GameService) { }
    ngOnInit(): void { }
    ngAfterViewInit(): void { }
}

// Service
@Injectable({ providedIn: 'root' })
export class GameService { }

// HTTP
this.http.get<Foo>('api/foo').subscribe(data => this.foo = data);
this.http.post('api/foo', JSON.stringify(obj), {}).subscribe(() => { });
this.http.put('api/foo', {}, {}).subscribe(data => { });
this.http.delete('api/foo/1').subscribe(() => { });
```

```html
<!-- Template -->
{{attribut}}
<p *ngIf="condition">conditionnel</p>
<div *ngFor="let x of liste">{{x}}</div>
<button (click)="methode()">clic</button>
<div [attr.data-x]="x" (mousedown)="handler($event)"></div>
<ng-container *ngFor="let y of lignes">...</ng-container>
```

---

## 7. XML/JSON -- Rappels rapides

### XML

```xml
<?xml version="1.0" encoding="UTF-8"?>
<person idcard="123">         <!-- attribut -->
    <name>John</name>         <!-- element -->
    <address>Paris</address>
</person>
```

Schema DTD : `<!ELEMENT person (name,address*)>`
Schema XMLSchema : `<xs:element name="person">...`

### JSON

```json
{ "name": "John", "age": 22, "addresses": ["Paris"], "alive": true, "data": null }
```

Types : string, number, boolean, null, array, object. Pas de commentaires. Cles entre guillemets doubles.

### YAML

```yaml
name: John
age: 22
addresses:
  - Paris
alive: true
```

Indentation = structure. Supporte les commentaires (#).

---

## 8. Patterns d'examen recurrents (2017-2023)

### Pattern 1 : "Donnez les annotations JPA"

On vous donne un diagramme UML et on demande le code Java avec annotations.

**Methode** :
1. `@Entity` sur chaque classe
2. `@Id` + `@GeneratedValue` sur l'identifiant
3. `@OneToMany(mappedBy="...")` cote "un"
4. `@ManyToOne` cote "plusieurs"
5. `@ManyToMany` si association N-N

### Pattern 2 : "Definissez une route REST pour..."

On vous demande verbe, URI, body, reponse.

**Methode** :
1. Identifier l'action (creer = POST, lire = GET, modifier = PATCH/PUT, supprimer = DELETE)
2. URI logique : `api/resource/{param}`
3. Body : quel DTO ? (POST/PATCH = DTO en entree, GET = DTO en sortie)
4. Codes HTTP possibles (200, 400, 404)
5. Ecrire le prototype Java avec annotations

### Pattern 3 : "Donnez le code Java de la route"

On vous demande le prototype complet avec annotations Spring.

**Methode** :
```java
@VerbMapping(path = "uri/{param}",
             consumes = MediaType.APPLICATION_JSON_VALUE,  // si body en entree
             produces = MediaType.APPLICATION_JSON_VALUE)   // si body en sortie
public ResponseEntity<TypeRetour> nomMethode(
        @RequestBody final TypeDTO body,          // si body
        @PathVariable("param") final long param,  // si param URI
        final Principal user) {                   // si auth requise
    // logique
    return ResponseEntity.ok(resultat);
}
```

### Pattern 4 : "Quels codes HTTP possibles ?"

Pour chaque route, lister :
- **200** : succes normal
- **400** : donnees invalides, operation impossible
- **404** : ressource non trouvee
- **405** : si le verbe est mal utilise

### Pattern 5 : "Ajoutez l'authentification"

**Methode** :
1. Routes publiques vs privees (SecurityConfig)
2. Creation de compte (route publique POST)
3. Connexion (route publique POST, retourne JSESSIONID)
4. Routes privees : injecter `Principal user`
5. Verifier que les donnees appartiennent a l'utilisateur connecte

---

## 9. Erreurs frequentes au DS

| Erreur | Correction |
|--------|-----------|
| Oublier `@Entity` | Chaque classe persistee doit avoir `@Entity` |
| Oublier `@Id` + `@GeneratedValue` | Sans ca, pas de cle primaire |
| Confondre `@OneToMany` et `@ManyToOne` | OneToMany = cote "un" (a la collection), ManyToOne = cote "plusieurs" |
| Retourner le modele sans DTO | Risque d'exposer des donnees confidentielles |
| Confondre PUT et PATCH | PUT = remplacement complet, PATCH = modification partielle |
| Oublier `mappedBy` | Sans mappedBy sur @OneToMany, JPA cree une table intermediaire |
| Ne pas gerer les codes HTTP | Toujours utiliser ResponseEntity avec le bon code |
| Confondre `@PathVariable` et `@RequestParam` | PathVariable = dans l'URI (/foo/{id}), RequestParam = query string (?id=42) |
