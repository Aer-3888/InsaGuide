# Chapitre 4 : REST API et Spring Boot -- Le back-end Java

## Table des matieres

1. [Architecture d'une application Web](#1-architecture-dune-application-web)
2. [REST : concepts fondamentaux](#2-rest--concepts-fondamentaux)
3. [Les verbes HTTP (CRUD)](#3-les-verbes-http-crud)
4. [Spring Boot : demarrage rapide](#4-spring-boot--demarrage-rapide)
5. [Definir des routes REST avec Spring Boot](#5-definir-des-routes-rest-avec-spring-boot)
6. [Transmission des donnees](#6-transmission-des-donnees)
7. [Reponse HTTP et codes de retour](#7-reponse-http-et-codes-de-retour)
8. [DTO (Data Transfer Object)](#8-dto-data-transfer-object)
9. [Marshalling](#9-marshalling)
10. [OpenAPI : concevoir son API REST](#10-openapi--concevoir-son-api-rest)
11. [Services Spring](#11-services-spring)
12. [ORM : lier back-end et base de donnees](#12-orm--lier-back-end-et-base-de-donnees)
13. [Tester les routes REST](#13-tester-les-routes-rest)
14. [Securite des back-ends](#14-securite-des-back-ends)
15. [Langages de donnees : XML, JSON, YAML](#15-langages-de-donnees--xml-json-yaml)
16. [Pieges courants](#16-pieges-courants)
17. [Recapitulatif](#17-recapitulatif)

---

## 1. Architecture d'une application Web

### Vue d'ensemble

```
+-------------------+          +-------------------+          +-------------------+
|    FRONT-END      |  REST    |    BACK-END       |   ORM    |   BASE DE         |
|    (Angular)      |  HTTP    |    (Spring Boot)  |   JPA    |   DONNEES         |
|                   |          |                   |          |                   |
| TypeScript + HTML |<-------->| Java 17           |<-------->| H2 / PostgreSQL   |
| Serveur :8080     |  JSON    | Serveur :8080     |          |                   |
+-------------------+          +-------------------+          +-------------------+
```

### Vocabulaire essentiel

| Terme | Definition |
|-------|-----------|
| **Page Web** | Contenu HTML/CSS/JS basique et statique |
| **Application Web** | Logiciel accessible via Internet, separation client-serveur |
| **Front-end** | Partie client (interface graphique dans le navigateur) |
| **Back-end** | Partie serveur (services, base de donnees, calculs) |
| **Full-stack** | Personne capable de developper front-end ET back-end |
| **Stack** | Pile des technologies utilisees |
| **Back-office** | Back-end cote entreprise (administration, statistiques) |

---

## 2. REST : concepts fondamentaux

### Qu'est-ce que REST ?

REST (Representational State Transfer, 2000) est un **style d'architecture** pour les communications client-serveur.

```
Principes REST :
+---------------------------+
| 1. Separation client-     |
|    serveur                |
| 2. Requetes sans etat    |
|    (stateless)            |
| 3. Mise en cache possible |
|    (cacheable)            |
| 4. Interface uniforme     |
|    (API)                  |
+---------------------------+
```

REST utilise le protocole **HTTP** mais n'est pas limite a Java. Toute bibliotheque Web peut implementer REST (Angular, React, Spring, NestJS, etc.).

### Vocabulaire REST

| Terme | Definition | Exemple |
|-------|-----------|---------|
| **Ressource REST** | Classe Java qui definit des routes REST | `HelloControllerV1` |
| **Route REST** | Methode du back-end accessible via HTTP | `GET /api/v1/hello/world` |
| **URI** | Identifiant de la route | `api/v1/hello/world` |
| **Verbe/Action** | Type d'operation HTTP | GET, POST, PUT, DELETE, PATCH |
| **Body** | Corps de la requete HTTP (donnees) | `{ "nom": "Alice" }` |
| **Reponse HTTP** | Code + donnees retournees | 200 OK + JSON |

**Regle fondamentale** : Verbe + URI = tuple UNIQUE. Deux routes ne peuvent pas avoir le meme verbe ET la meme URI.

```
OK  : POST /api/foo  et  GET /api/foo    (verbes differents)
CONFLIT : GET /api/foo/{param1}  et  GET /api/foo/{param2}
          (les noms de parametres ne comptent pas)
```

### Avantages et inconvenients

| Avantages | Inconvenients |
|-----------|---------------|
| Operations CRUD + authentification | Asynchrone (latence) |
| Repose sur HTTP | Verbeux (header HTTP) |
| API explicite front-end / back-end | Unidirectionnel (back ne connait pas le front) |
| Supporte par toutes les bibliotheques | |

Alternative : **WebSockets** pour communication bidirectionnelle temps reel.

---

## 3. Les verbes HTTP (CRUD)

```
+--------+----------+--------------------------------------------------+
| Verbe  | Action   | Description                                      |
+--------+----------+--------------------------------------------------+
| POST   | Create   | Creer une nouvelle ressource                     |
|        |          | Donnees dans le body                             |
+--------+----------+--------------------------------------------------+
| GET    | Read     | Lire / recuperer une ressource                   |
|        |          | Lecture seule, pas de body                        |
+--------+----------+--------------------------------------------------+
| PUT    | Update   | Remplacer une ressource existante (objet complet)|
|        |          | En pratique, souvent utilise pour modifier        |
+--------+----------+--------------------------------------------------+
| PATCH  | Update   | Modifier partiellement une ressource              |
|        |          | (objet partiel, attributs non changes = null)    |
+--------+----------+--------------------------------------------------+
| DELETE | Delete   | Supprimer une ressource                          |
+--------+----------+--------------------------------------------------+
```

### Exemples avec curl

```bash
# POST : creer un element
curl -X POST "http://localhost:8080/api/public/v1/hello/txt" \
     -H "Content-Type: text/plain" -d "foo"

# POST avec JSON
curl -X POST "http://localhost:8080/api/public/v2/hello/txt" \
     -H "Content-Type: application/json" \
     -d '{ "text": "foo"}'

# GET : lire un element
curl -X GET "http://localhost:8080/api/public/v1/hello/world"

# DELETE : supprimer un element
curl -X DELETE "http://localhost:8080/api/public/v1/hello/txt/foo"

# PUT : remplacer un element
curl -X PUT "http://localhost:8080/api/public/v1/hello/user" \
     -H "Content-Type: application/json" \
     -d '{ "name": "aa", "id": "2", "address": "there"}'

# PATCH : modifier partiellement un element
curl -X PATCH "http://localhost:8080/api/public/v1/hello/user" \
     -H "Content-Type: application/json" \
     -d '{ "name": "aa"}'
```

---

## 4. Spring Boot : demarrage rapide

### Creation du projet

1. Aller sur https://start.spring.io
2. Choisir Java 17, Maven, Spring Boot 3.2+
3. Ajouter les dependances : `spring-boot-starter-web`, `lombok`, `jackson-dataformat-xml`, `spring-boot-starter-data-jpa`, `h2`

### Le Main (point d'entree)

```java
@SpringBootApplication
public class TpSpringApplication {
    public static void main(String[] args) {
        SpringApplication.run(TpSpringApplication.class, args);
    }
}
// Lancer le Main = demarrer le serveur back-end sur localhost:8080
```

### Structure du projet

```
src/main/java/fr/insarennes/
    |-- TpSpringApplication.java     (Main)
    |-- controller/                   (Ressources REST)
    |   |-- HelloControllerV1.java
    |-- service/                      (Logique metier)
    |   |-- DataService.java
    |-- model/                        (Classes de donnees)
    |   |-- User.java
    |-- dto/                          (Data Transfer Objects)
    |   |-- UserDTO.java
    |-- repository/                   (Acces base de donnees)
        |-- UserCrudRepository.java
```

---

## 5. Definir des routes REST avec Spring Boot

### Creer une ressource REST (controleur)

```java
@RestController                           // Marque comme ressource REST
@RequestMapping("api/public/v1/hello")    // URI de base de la ressource
public class HelloControllerV1 {
    // Les routes seront definies ici
}
```

### Route GET

```java
@GetMapping(path = "world", produces = MediaType.TEXT_PLAIN_VALUE)
public String helloWorld() {
    return "Hello world!";
}
// URL : GET http://localhost:8080/api/public/v1/hello/world
// Retourne : "Hello world!" en texte brut
```

```java
// Retour en JSON
@GetMapping(path = "world", produces = MediaType.APPLICATION_JSON_VALUE)
public Message helloWorld() {
    return new Message("Hello world!");
}

// record Java 17 : classe de donnees en lecture seule
record Message(String txt) {}
// Retourne : {"txt":"Hello world!"}
```

### Route POST

```java
// POST avec texte brut
@PostMapping(path = "txt", consumes = MediaType.TEXT_PLAIN_VALUE)
public void newTxt(@RequestBody final String txt) {
    txts.add(txt);
}

// POST avec JSON
@PostMapping(path = "txt", consumes = MediaType.APPLICATION_JSON_VALUE)
public void newTxt(@RequestBody final Message txt) {
    txts.add(txt.text());
}
```

### Route DELETE

```java
@DeleteMapping(path = "txt/{txtToRemove}")
public void removeTxt(@PathVariable("txtToRemove") final String txt) {
    txts.remove(txt);
}
// URL : DELETE http://localhost:8080/api/public/v1/hello/txt/foo
// {txtToRemove} dans l'URI = parametre capture par @PathVariable
```

### Route PUT

```java
// PUT : remplacement complet
@PutMapping(path = "user", consumes = MediaType.APPLICATION_JSON_VALUE)
public void replaceUser(@RequestBody final User patchedUser) {
    user = patchedUser;
}

// PUT en pratique : modification d'un attribut
@PutMapping(path = "rename/{newname}")
public void renameUser(@PathVariable("newname") String newname) {
    user.setName(newname);
}
```

### Route PATCH

```java
// PATCH : modification partielle (les attributs non envoyes = null)
@PatchMapping(path = "user", consumes = MediaType.APPLICATION_JSON_VALUE)
public void patchUser(@RequestBody final User patchedUser) {
    user.patch(patchedUser);
}

// Methode patch dans la classe User
public void patch(final User user) {
    if (user.address != null) { address = user.address; }
    if (user.name != null) { name = user.name; }
}
```

**Version amelioree avec Map** :

```java
@PatchMapping(path = "user/{id}", consumes = MediaType.APPLICATION_JSON_VALUE)
public void patchUser(@RequestBody Map<String, Object> partialUser,
                      @PathVariable("id") final long id) {
    userService.patchUser(partialUser, id);
}

// Dans le service :
public Optional<User> patchUser(Map<String, Object> partialUser, long id) {
    Optional<User> userOpt = findUser(id);
    if (userOpt.isEmpty()) return Optional.empty();
    objectMapper.updateValue(userOpt.get(), partialUser);
    return userOpt;
}
```

---

## 6. Transmission des donnees

Il existe **trois manieres** de transmettre des donnees dans une requete REST :

### 1. Dans le body de la requete (@RequestBody)

```java
@PatchMapping(path = "user", consumes = MediaType.APPLICATION_JSON_VALUE)
public void patchUser(@RequestBody User patchedUser) { }
```
- Avantages : donnees complexes, format JSON/XML, donnees moins visibles
- Inconvenients : plus complexe a utiliser

### 2. Dans l'URI de la route (@PathVariable)

```java
@PutMapping(path = "rename/{newname}")
public void renameUser(@PathVariable("newname") String newname) { }
// URL : /api/v1/hello/rename/NouveauNom
```
- Avantages : simple
- Inconvenients : pas pour les donnees complexes, visible dans l'URL

### 3. Dans les parametres de l'URI (@RequestParam)

```java
@PutMapping(path = "rename")
public void renameUser(@RequestParam("newname") String newname) { }
// URL : /api/v1/hello/rename?newname=NouveauNom
```
- Avantages : simple, optionnel
- Inconvenients : visible dans l'URL

---

## 7. Reponse HTTP et codes de retour

### Le back-end retourne TOUJOURS une reponse HTTP

Meme si la methode retourne `void`, Spring retourne une reponse HTTP (code 204 No Content par defaut).

### Codes de retour importants

| Code | Nom | Signification |
|------|-----|---------------|
| **200** | OK | Requete reussie |
| **201** | Created | Ressource creee |
| **204** | No Content | Requete OK, pas de body en retour |
| **400** | Bad Request | Requete mal formee |
| **404** | Not Found | Ressource non trouvee |
| **405** | Method Not Allowed | Mauvais verbe HTTP |
| **500** | Internal Server Error | Erreur dans le back-end |

### Utiliser ResponseEntity

```java
// Retourner un code specifique SANS body
@PostMapping(path = "txt", consumes = MediaType.APPLICATION_JSON_VALUE)
public ResponseEntity<Void> newTxt(@RequestBody final Message txt) {
    if (txts.add(txt.text())) {
        return ResponseEntity.ok().build();          // 200 OK
    }
    return ResponseEntity.badRequest().build();      // 400 Bad Request
}

// Retourner un code specifique AVEC body
@GetMapping(path = "you", produces = MediaType.APPLICATION_JSON_VALUE)
public ResponseEntity<Message> helloYou() {
    return ResponseEntity.ok(new Message("Hello you!"));  // 200 + JSON
}

// Retourner une liste
@GetMapping(path = "txts", produces = MediaType.APPLICATION_JSON_VALUE)
public ResponseEntity<Set<String>> getAllTxts() {
    return ResponseEntity.ok(txts);  // 200 + ["bar","foo"]
}
```

### Gestion des erreurs

```java
// MAUVAISE PRATIQUE : lancer une exception non geree (retourne 500)
throw new IllegalArgumentException("erreur");

// BONNE PRATIQUE : utiliser ResponseStatusException
throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "The ID is not the same");
// Retourne : 400 Bad Request + message
```

---

## 8. DTO (Data Transfer Object)

### Pourquoi utiliser des DTO ?

```java
// PROBLEME : la classe User contient des donnees confidentielles
public class User {
    private String name;
    private String address;
    private String id;
    private String pwd;   // MOT DE PASSE !
}

// Si on retourne directement User :
@GetMapping("user")
public User getUser() { return user; }
// Resultat : {"name":"Foo","address":"here","id":"1","pwd":"p1"}
// On a expose le mot de passe !
```

### Solution : creer un DTO

```java
// DTO : ne contient que les donnees a transmettre
@Getter @Setter @NoArgsConstructor  // annotations Lombok
public class UserDTO {
    private String name;
    private String address;
    private String id;
    // PAS de pwd !

    // Constructeur a partir de l'entite User
    public UserDTO(final User user) {
        this.name = user.getName();
        this.address = user.getAddress();
        this.id = user.getId();
    }

    // Methode pour appliquer un patch a un User
    public void patch(final User user) {
        if (address != null) { user.setAddress(address); }
        if (name != null) { user.setName(name); }
    }
}

// Utilisation dans la route
@GetMapping(path = "user", produces = MediaType.APPLICATION_JSON_VALUE)
public UserDTO getUser() {
    return new UserDTO(user);  // {"name":"Foo","address":"here","id":"1"}
}
```

### Quand creer des DTO differents

- **UserDTO** : pour les GET (sans mot de passe)
- **UserNoIdDTO** : pour les POST (sans id, qui sera genere par le serveur)
- **UserPatchDTO** : pour les PATCH (tous les attributs optionnels)

---

## 9. Marshalling

### Definition

```
Marshalling    : Objet Java --> JSON/XML (texte)
Demarshalling  : JSON/XML (texte) --> Objet Java

Exemple :
  User("Alice", "Rennes")  -->  {"name":"Alice","address":"Rennes"}
  {"name":"Bob"}            -->  User("Bob", null)
```

Spring utilise la bibliotheque **Jackson** pour le marshalling automatique.

### Annotations de marshalling

```java
// Ignorer un attribut lors du marshalling
@Getter @Setter
public class Cat {
    @JsonIgnore
    private int notToMarshall;   // ne sera PAS dans le JSON
    private String name;
}

// Gerer le polymorphisme (heritage)
@JsonSubTypes({
    @JsonSubTypes.Type(value = Cat.class, name = "cat"),
    @JsonSubTypes.Type(value = Dog.class, name = "dog")
})
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME,
              include = JsonTypeInfo.As.PROPERTY,
              property = "type")
public interface Animal { }
// JSON : { "type": "cat", "name": "Minou", "age": 3 }
```

**Point important** : Un attribut est marshalle uniquement s'il possede un getter et un setter.

---

## 10. OpenAPI : concevoir son API REST

OpenAPI permet de modeliser (decrire) une API REST **avant** de l'implementer.

### Structure de base (YAML)

```yaml
openapi: 3.0.3
info:
  title: Mon API REST
  description: Description de l'API
  version: 1.0.0
servers:
  - url: https://api.example.com/api/v1

tags:
  - name: player
    description: Les joueurs

paths:
  /player/{playerID}:
    get:
      tags:
        - player
      summary: Retourne un joueur existant
      operationId: getPlayer
      parameters:
        - name: playerID
          in: path
          required: true
          schema:
            type: integer
            format: int64
      responses:
        '200':
          description: Succes
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PlayerDTO'
        '400':
          description: ID invalide

  /player:
    post:
      tags:
        - player
      summary: Ajoute un nouveau joueur
      requestBody:
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/PlayerNoIdDTO'
        required: true
      responses:
        '200':
          description: Succes
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/PlayerDTO'

components:
  schemas:
    PlayerDTO:
      type: object
      properties:
        id:
          type: integer
          format: int64
        name:
          type: string
    PlayerNoIdDTO:
      type: object
      properties:
        name:
          type: string
```

### Types de routes a definir

| Type | Description | Exemple |
|------|-------------|---------|
| **Route CRUD** | Operations de base Create/Read/Update/Delete | POST /player, GET /player/{id} |
| **Route orientee application** | Optimisee pour les besoins du front-end | GET /albumsSummary |

---

## 11. Services Spring

### Pourquoi des services ?

Separation des responsabilites : le controleur gere les routes, le **service** gere la logique metier et les donnees.

```java
// Service (dans un package 'service')
@Getter @Setter
@Service                      // Annotation qui marque un service Spring
public class DataService {
    private final Set<String> txts;
    private User user;

    public DataService() {
        txts = new HashSet<>();
        txts.add("foo");
        user = new User("Foo", "here", "1", "p1");
    }
}

// Controleur utilisant le service (injection par constructeur)
@RestController
@RequestMapping("api/public/v3/hello")
public class HelloControllerV3 {
    private final DataService dataService;

    // Injection de dependance via le constructeur
    public HelloControllerV3(final DataService dataService) {
        this.dataService = dataService;
    }

    @PatchMapping(path = "user", consumes = MediaType.APPLICATION_JSON_VALUE)
    public void patchUser(@RequestBody final UserDTO patchedUser) {
        patchedUser.patch(dataService.getUser());
    }
}
```

---

## 12. ORM : lier back-end et base de donnees

### Le probleme

```
Base de donnees (relationnelle)     Back-end (oriente objet)
  Tables, colonnes                    Classes, objets
  Cles primaires/etrangeres           References, heritage
  Pas d'heritage                      Heritage possible
```

L'ORM (Object-Relational Mapping) fait le pont entre les deux mondes.

### JPA (Jakarta Persistence API)

#### @Entity et @Id

```java
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;

@Data        // Lombok : genere getters, setters, toString, etc.
@Entity      // Cette classe sera stockee en base de donnees
public class Foo {
    @Id                  // Cle primaire
    @GeneratedValue      // Valeur auto-generee et auto-incrementee
    private long id;

    private String txt;
}
```

#### Relations entre entites

```java
// ONE TO MANY : Un Foo a plusieurs Bars
@Data @Entity
public class Foo {
    @Id @GeneratedValue
    private long id;
    private String txt;

    @OneToMany(mappedBy = "foo",
               cascade = CascadeType.PERSIST,   // operations en cascade
               fetch = FetchType.LAZY)           // chargement a la demande
    private List<Bar> bars;
}

// MANY TO ONE : Plusieurs Bars appartiennent a un Foo
@Data @Entity
public class Bar {
    @Id @GeneratedValue
    private long id;

    @ManyToOne
    private Foo foo;
}
```

#### Autres relations

```java
// MANY TO MANY
@ManyToMany
private List<Bar> bars;

// Heritage
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
// Strategies : SINGLE_TABLE, TABLE_PER_CLASS, JOINED
public class Player { }

@Entity
public class BaseballPlayer extends Player {
    private int totalHomeRuns;
}
```

#### Strategies d'heritage

| Strategie | Description | Table(s) |
|-----------|-------------|----------|
| `SINGLE_TABLE` | Une seule table pour toute la hierarchie + colonne DTYPE | 1 table |
| `TABLE_PER_CLASS` | Une table par classe (colonnes dupliquees) | N tables |
| `JOINED` | Une table par classe, colonnes factorisees (cles etrangeres) | N tables liees |

### Repository

```java
// Interface de repository (stockage)
@Repository
public interface FooCrudRepository extends CrudRepository<Foo, Long> {
    // Methodes de base fournies : save, delete, findById, findAll

    // Requete personnalisee
    @Query("select u from User u where u.name like %?1%")
    List<User> findUserNameContainsTxt(final String nameTxt);
}

// Utilisation dans un service
@Service
public class FooService {
    @Autowired
    private FooCrudRepository fooRepo;

    public Foo createNewFoo() {
        Foo foo = new Foo();
        foo.setTxt("hello");
        fooRepo.save(foo);     // sauvegarde en base
        return foo;
    }
}
```

**Methodes de base d'un repository** :

```java
fooRepo.save(foo);           // Enregistrer / mettre a jour
fooRepo.delete(foo);         // Supprimer
fooRepo.findById(id);        // Trouver par cle (retourne Optional)
fooRepo.findAll();           // Retourner tout (Iterable)
```

---

## 13. Tester les routes REST

### Configuration du test

```java
@SpringBootTest                    // Lance le back-end en mode test
@AutoConfigureMockMvc              // Configure les controleurs
class AnimalControllerTest {
    @Autowired
    private MockMvc mvc;           // Simule les requetes HTTP

    @Autowired
    private AnimalService animalService;
}
```

### Test GET

```java
@Test
void getAll() throws Exception {
    mvc.perform(get("/api/public/v1/animal/all"))
        .andExpect(status().isOk())                              // code 200
        .andExpect(content()
            .contentTypeCompatibleWith(MediaType.APPLICATION_JSON)) // JSON
        .andDo(MockMvcResultHandlers.print())                    // afficher
        .andExpect(jsonPath("$", hasSize(2)))                    // 2 elements
        .andExpect(jsonPath("$[0].name", equalTo("foo")))        // verifier
        .andExpect(jsonPath("$[1].age", is(2)));
}
```

### Test POST

```java
@Test
void postAnimal() throws Exception {
    Animal cat = new Cat(20, "c");
    mvc.perform(
        post("/api/public/v1/animal")
            .contentType(MediaType.APPLICATION_JSON)
            .content(new ObjectMapper().writeValueAsString(cat))  // marshalling
    )
    .andExpect(status().isOk())
    .andExpect(content().string(""));
}
```

### Test de resilience

```java
@Test
void postBadAnimalNoType() throws Exception {
    mvc.perform(
        post("/api/public/v1/animal")
            .contentType(MediaType.APPLICATION_JSON)
            .content("""
                { "age":2,"name":"bar" }""")    // pas de "type" !
    )
    .andExpect(status().isBadRequest());         // 400 attendu
}
```

---

## 14. Securite des back-ends

### Configuration de base

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig extends WebSecurityConfigurerAdapter {
    @Override
    protected void configure(final HttpSecurity http) throws Exception {
        http.authorizeRequests()
            .antMatchers("/api/public/**").permitAll()    // routes publiques
            .anyRequest().authenticated()                  // le reste = auth requise
            .and()
            .csrf().disable();     // desactive CSRF pour la demo
    }
}
```

### Creation de compte et connexion

```java
// Route publique : creation de compte
@PostMapping(value = "new", consumes = MediaType.APPLICATION_JSON_VALUE)
public void newAccount(@RequestBody final UserDTO user) {
    userService.newAccount(user.login(), user.pwd());
}

// Route publique : connexion
@PostMapping(value = "login", consumes = MediaType.APPLICATION_JSON_VALUE)
public void login(@RequestBody final UserDTO user) {
    boolean logged = userService.login(user.login(), user.pwd());
    // Retourne un cookie JSESSIONID pour les requetes suivantes
}
```

### Session et cookies

```
1. Connexion :
   Client --POST login--> Serveur
   Client <--Set-Cookie: JSESSIONID=xxx-- Serveur

2. Requetes suivantes :
   Client --GET /api/private + Cookie: JSESSIONID=xxx--> Serveur
   Serveur verifie le JSESSIONID et autorise (ou pas)
```

### Proteger les donnees utilisateur

```java
// Route privee : utilise Principal pour identifier l'utilisateur connecte
@DeleteMapping(path = "todo/{id}")
public void deleteTodo(@PathVariable("id") final long id,
                       final Principal user) {
    // Verifier que le todo appartient bien a l'utilisateur connecte
    if (!todoService.removeTodo(id, user.getName())) {
        throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Not possible");
    }
}
```

---

## 15. Langages de donnees : XML, JSON, YAML

### XML (eXtensible Markup Language)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<carteDeVisite>
    <prenom>Jean</prenom>
    <nom>Dupont</nom>
    <adresse>
        <numero>33</numero>
        <voie type="boulevard">des capucines</voie>
    </adresse>
</carteDeVisite>
```

**Regles XML** :
- Balises ouvrantes/fermantes obligatoires
- Sensible a la casse
- Un seul element racine
- **Bien forme** (well-formed) : syntaxe correcte
- **Valide** : bien forme + conforme a un schema (DTD, XMLSchema)

### JSON (JavaScript Object Notation)

```json
{
    "idcard": 1843739,
    "name": "John Doe",
    "address": ["Adress 1", "Adress 2"],
    "phone": { "prefix": "+33", "number": "000000" },
    "siblings": null,
    "alive": false
}
```

**Types JSON** : string, number, boolean, null, array, object
**Pas de schema** par defaut (mais TypeScript peut servir de schema).

### YAML (Yet Another Markup Language)

```yaml
persons:
  - idcard: 1843739
    name: John Doe
    address:
      - Address 1
      - Address 2
    alive: false
```

**Avantages YAML** : plus lisible, supporte les commentaires, indentation = structure.

---

## 16. Pieges courants

### Piege 1 : Conflit de routes
```java
// CONFLIT : meme verbe + meme structure d'URI
@GetMapping("user/{id}")
@GetMapping("user/{name}")
// Les noms de PathVariable ne comptent pas pour le routage !
```

### Piege 2 : Oublier les annotations
```java
// OUBLI : pas de @RestController = la classe n'est pas detectee
// OUBLI : pas de @RequestMapping = pas d'URI de base
// OUBLI : pas de @Entity/@Id = ORM ne fonctionne pas
```

### Piege 3 : Retourner le modele sans DTO
```java
// DANGEREUX : expose des donnees confidentielles (mot de passe, etc.)
@GetMapping("user")
public User getUser() { return user; }

// CORRECT : utiliser un DTO
@GetMapping("user")
public UserDTO getUser() { return new UserDTO(user); }
```

### Piege 4 : Ignorer les codes HTTP
```java
// MAUVAIS : toujours retourner 200
// BON : 200 en cas de succes, 400 pour les erreurs client, 500 pour les erreurs serveur
```

### Piege 5 : Erreur 500 non geree
```java
// MAUVAIS : laisser les exceptions remonter en 500
throw new IllegalArgumentException();

// BON : intercepter et retourner un code adapte
throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Message clair");
```

### Piege 6 : ORM sans @Id/@GeneratedValue
```java
// Sans @Id, Spring ne sait pas quelle colonne est la cle primaire
// Sans @GeneratedValue, vous devez gerer vous-meme les IDs
```

---

## 17. Recapitulatif

| Concept | A retenir |
|---------|-----------|
| REST | Architecture client-serveur, verbes HTTP, URI uniques |
| Verbes | POST (creer), GET (lire), PUT (remplacer), PATCH (modifier), DELETE |
| Spring Boot | @RestController, @RequestMapping, @GetMapping, etc. |
| Donnees | @RequestBody (body), @PathVariable (URI), @RequestParam (query) |
| Reponse | ResponseEntity, codes HTTP (200, 400, 404, 500) |
| DTO | Classe de transfert, ne pas exposer le modele directement |
| Marshalling | Java <-> JSON/XML, Jackson, @JsonIgnore, @JsonSubTypes |
| OpenAPI | Specification YAML/JSON pour decrire l'API avant implementation |
| Service | @Service, separation des responsabilites |
| ORM/JPA | @Entity, @Id, @GeneratedValue, @OneToMany, @ManyToOne |
| Repository | CrudRepository, save, findById, delete, findAll |
| Tests | MockMvc, perform, andExpect, jsonPath |
| Securite | @EnableWebSecurity, session, cookie, Principal |

**Points cles pour le DS** :
- Savoir ecrire des routes REST avec annotations Spring Boot
- Savoir definir les annotations ORM/JPA pour un diagramme UML
- Savoir creer des DTO et expliquer pourquoi
- Connaitre les codes HTTP et savoir les utiliser
- Savoir definir des Repository et des Service
- Comprendre la securite (authentification, sessions, droits d'acces)
