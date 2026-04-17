# Web Engineering - Guide Complet

Ce guide accompagne les TPs et exemples du cours de BDWEB/Ingénierie Web. Le dépôt contient plusieurs sous-projets couvrant les technologies web modernes : REST APIs avec Spring Boot, manipulation de JSON/XML, ORM avec JPA, et développement JavaScript.

## Structure du Projet

```
WebEngineering-INSA-github/
├── tp-spring/              # TP principal : API REST Spring Boot (8 séances)
│   ├── src/
│   ├── tp7/                # TP 7 : Page web + JavaScript
│   └── pom.xml
├── rest/
│   ├── springboot2/        # Exemple de cours : API REST Spring Boot
│   └── jersey/             # Exemple avec Jersey (JAX-RS)
├── json/
│   ├── java/               # Manipulation JSON en Java
│   └── js/                 # Manipulation JSON en JavaScript
├── xml/                    # Manipulation XML en Java
├── orm/
│   └── jpa/                # Exemples JPA/Hibernate
├── js/                     # Exercices JavaScript
└── slides/                 # Slides du cours
```

## Technologies Utilisées

### Backend Java
- **Java 21** - Langage de programmation
- **Spring Boot 3** - Framework web
- **Spring Security** - Authentification et autorisation
- **Spring Data JPA** - ORM et accès aux données
- **Maven** - Gestion de dépendances
- **JUnit 5** - Tests unitaires
- **Mockito** - Mocking pour tests
- **H2 Database** - Base de données en mémoire (dev)
- **Lombok** - Génération automatique de code (getters/setters)

### APIs et Standards
- **OpenAPI 3.1** - Spécification d'API REST
- **Swagger Editor** - Documentation interactive d'API
- **JAX-RS / Jersey** - Alternative à Spring pour REST
- **JSON** - Format d'échange de données
- **XML** - Format d'échange de données (legacy)

### Frontend
- **HTML5** - Structure des pages
- **CSS3** - Mise en forme
- **JavaScript (ES6+)** - Interactivité côté client
- **DOM API** - Manipulation du document
- **XMLHttpRequest / Fetch** - Requêtes HTTP

### Outils
- **IntelliJ IDEA** - IDE recommandé
- **VSCode** - Alternative
- **Firefox / Chrome** - Navigateurs pour tests
- **curl** - Client HTTP en ligne de commande
- **Node.js + npm** - Pour les exercices JavaScript

## Prérequis

### Installation
```bash
# Vérifier Java 21
java -version

# Vérifier Maven 3
mvn -v

# Vérifier Node.js et npm (pour exercices JS)
node -v
npm -v

# Cloner le dépôt
git clone https://github.com/arnobl/WebEngineering-INSA.git
cd WebEngineering-INSA

# Mettre à jour si nécessaire
git fetch
git merge
```

### Configuration IDE

**IntelliJ IDEA :**
1. Installer le plugin Lombok
2. Ouvrir le projet : `Open` → sélectionner `tp-spring/pom.xml` → `Open as project` → `Trust Project`

**VSCode :**
1. Installer les extensions : Java Extension Pack, Spring Boot Extension Pack
2. Ouvrir le dossier `tp-spring`

### Swagger Editor
Utiliser l'instance en ligne : https://editor-next.swagger.io/

**Important :** Sauvegarder votre modèle OpenAPI à la fin de chaque séance !

## Projet Principal : tp-spring

Ce projet est au cœur des TPs. Il s'agit de créer un backend REST pour gérer des todos organisées en listes.

### Modèle de Données

```
TodoList
- id: long
- name: string
- owner: string
- todos: List<Todo>

Todo
- id: long
- title: string
- owner: string
- description: string
- categories: List<Category>
- list: TodoList

Category (enum)
- HIGH_PRIORITY
- LOW_PRIORITY
- WORK
- ENTERTAINMENT
```

### Lancement du Projet

```bash
# Depuis tp-spring/
# Option 1 : Via IDE
# Exécuter TpSpringApplication.java (méthode main)

# Option 2 : Ligne de commande
mvn spring-boot:run

# Le serveur démarre sur http://localhost:8080
```

### Tests
```bash
# Exécuter tous les tests
mvn test

# Exécuter un test spécifique
mvn test -Dtest=TestTodoServiceV2

# Avec couverture
mvn test jacoco:report
# Ouvrir target/site/jacoco/index.html
```

## Progression des TPs

### TP 1 - Premiers Pas avec REST (2h)

**Objectifs :**
- Découvrir Spring Boot et les contrôleurs REST
- Créer des routes GET et POST basiques
- Utiliser Swagger Editor pour documenter et tester

**Concepts :**
- Contrôleurs REST (`@RestController`, `@RequestMapping`)
- Routes HTTP (`@GetMapping`, `@PostMapping`)
- Paramètres d'URI (`@PathVariable`)
- Request body (`@RequestBody`)
- Marshalling/Unmarshalling JSON automatique

**Travail à faire :**
1. Tester la route fournie : `GET /api/v1/public/hello/helloworld`
2. Créer `TodoControllerV1` avec une Map pour stocker les todos
3. Implémenter `GET /v1/public/todo/todo/{id}` - Récupérer un todo
4. Implémenter `POST /v1/public/todo/todo` - Créer un todo
5. Documenter dans Swagger Editor

**Points clés :**
- Une Map plutôt qu'une List pour recherche O(1) au lieu de O(n)
- Long plutôt qu'Integer pour permettre plus d'IDs
- Pour l'instant, l'ID est géré manuellement (pas optimal)

### TP 2 - CRUD Complet (2h)

**Objectifs :**
- Implémenter toutes les opérations CRUD
- Gérer les erreurs et codes HTTP appropriés
- Comprendre les différences entre PUT et PATCH

**Concepts :**
- HTTP status codes (200, 400, 404, etc.)
- DELETE, PUT, PATCH
- Gestion d'erreurs avec `ResponseStatusException`

**Travail à faire :**
1. Améliorer POST pour générer automatiquement les IDs (compteur)
2. Implémenter `DELETE /v1/public/todo/todo/{id}`
3. Améliorer GET pour retourner 400 si ID invalide
4. Implémenter `PUT /v1/public/todo/todo` - Remplacer un todo complet
5. Implémenter `PATCH /v1/public/todo/todo` - Modifier partiellement un todo

**Problèmes identifiés :**
- Stockage dans le contrôleur (pas propre)
- Gestion manuelle des IDs (pas robuste)
- Pas de séparation des responsabilités
- Marshalling direct des entités (pas optimal)
- Pas de sécurité

### TP 3 - Services et Repositories (3h)

**Objectifs :**
- Séparer la logique métier du contrôleur
- Utiliser Spring Data JPA et les repositories
- Comprendre l'injection de dépendances

**Concepts :**
- Services (`@Service`)
- Repositories (`@Repository`, `CrudRepository`)
- Injection de dépendances (`@Autowired`)
- JPA annotations (`@Entity`, `@Id`, `@GeneratedValue`)

**Travail à faire :**
1. Créer `TodoControllerV2` (copie de V1)
2. Créer `TodoServiceV1` et déplacer la logique CRUD dedans
3. Injecter le service dans le contrôleur avec `@Autowired`
4. Créer `TodoCrudRepository extends CrudRepository<Todo, Long>`
5. Créer `TodoServiceV2` qui utilise le repository
6. Ajouter annotations JPA à `Todo` (`@Entity`, `@Id`, `@GeneratedValue`)
7. Tester avec Swagger

**Avantages :**
- Contrôleur léger, focalisé sur HTTP
- Service réutilisable, testable indépendamment
- Repository gère automatiquement la persistance
- Plus besoin de gérer les IDs manuellement

### TP 4 - Relations JPA et TodoList (2h)

**Objectifs :**
- Gérer les relations entre entités JPA
- Comprendre le marshalling avec héritage
- Créer le CRUD pour TodoList

**Concepts :**
- Relations JPA (`@OneToMany`, `@ManyToOne`)
- Héritage JPA (`@JsonTypeInfo`, `@JsonSubTypes`)
- `ResponseEntity` pour contrôle fin des réponses
- Gestion des boucles infinies (`@JsonIgnore`)

**Travail à faire :**
1. Créer `TodoListController`, `TodoListService`, `TodoListCrudRepository`
2. Implémenter POST pour créer une TodoList vide
3. Ajouter annotations JPA pour la relation Todo ↔ TodoList
4. Tester l'héritage avec `SpecificTodo` (annotations pour polymorphisme JSON)

**Piège à éviter :**
- Boucle infinie JSON : Todo → TodoList → Todos → TodoList...
- Solution : `@JsonIgnore` sur un côté de la relation

### TP 5 - DTO et Queries (2-3h)

**Objectifs :**
- Utiliser des DTO pour optimiser les transferts
- Écrire des requêtes JPA custom
- Améliorer le PATCH

**Concepts :**
- Data Transfer Objects (DTO)
- Records Java (classes de données immuables)
- `@Query` pour requêtes JPQL/SQL custom
- JSON Patch pour modifications partielles

**Travail à faire :**
1. Créer `NamedDTO` (record avec nom et description)
2. Modifier POST TodoList pour accepter juste le DTO au lieu de l'entité complète
3. Implémenter ajout de Todo à une TodoList
4. Améliorer PATCH avec approche propre (JsonPatch)
5. Ajouter une query custom : trouver todos par titre
6. Documenter dans Swagger

**Bonnes pratiques :**
- DTO uniquement dans les contrôleurs (pas dans services)
- Ne pas exposer directement les entités JPA
- Mapper DTO ↔ Entité dans le contrôleur

### TP 6 - Tests Unitaires (3h)

**Objectifs :**
- Tester le service et le contrôleur
- Atteindre 100% de couverture de branches
- Utiliser Mockito pour isoler les tests

**Concepts :**
- Tests unitaires avec JUnit 5
- Mocking avec Mockito (`@Mock`, `@InjectMocks`)
- `when().thenReturn()` pour simuler comportements
- `verify()` pour vérifier les appels
- Couverture de code avec JaCoCo

**Travail à faire :**
1. Compléter `TestTodoServiceV2` - Tests du service avec repository mocké
2. Compléter `TestTodoControllerV2` - Tests du contrôleur avec service mocké
3. Viser 100% de couverture de branches

**Structure d'un test :**
```java
@Test
void testAddTodo() {
    // Arrange : préparer les données et les mocks
    Todo todo = new Todo(...);
    when(repository.save(any())).thenReturn(todo);
    
    // Act : exécuter la méthode testée
    Todo result = service.addTodo(todo);
    
    // Assert : vérifier le résultat
    assertEquals(todo.getId(), result.getId());
    verify(repository).save(any());
}
```

### TP 7 - Page Web et JavaScript (2h)

**Objectifs :**
- Comprendre le fonctionnement d'une page web
- Manipuler le DOM avec JavaScript
- Faire des requêtes AJAX vers le backend

**Concepts :**
- DOM (Document Object Model)
- HTML : structure (`body`, `div`, `h1`)
- CSS : mise en forme (`.class`, `#id`)
- JavaScript : interactivité
- XMLHttpRequest / Fetch API
- Événements DOM

**Fichiers :**
- `tp7/index.html` - Page HTML
- `tp7/style.css` - Styles
- `tp7/script.js` - Code JavaScript

**Travail à faire :**
1. Comprendre le code fourni (`getHelloWorld()`)
2. Créer `getTodo(id)` qui récupère un todo via GET
3. Afficher le todo dans le DOM en utilisant des méthodes sûres

**Exemple XMLHttpRequest :**
```javascript
function getTodo(id) {
    const xhr = new XMLHttpRequest();
    xhr.open("GET", `http://localhost:8080/api/v2/public/todo/todo/${id}`);
    xhr.onload = () => {
        if (xhr.status === 200) {
            const todo = JSON.parse(xhr.responseText);
            // SÉCURITÉ : Utiliser textContent au lieu de innerHTML
            document.getElementById("todoTitle").textContent = todo.title;
            document.getElementById("todoDesc").textContent = todo.description;
        }
    };
    xhr.send();
}
```

**Note sécurité :**
Le TP mentionne innerHTML à des fins pédagogiques, mais c'est dangereux (XSS). En production, utiliser `textContent` pour du texte ou des frameworks (React, Vue) qui échappent automatiquement le contenu.

### TP 8 - Sécurité et Authentification (3h)

**Objectifs :**
- Implémenter authentification par session
- Séparer routes publiques et privées
- Associer les todos aux utilisateurs

**Concepts :**
- Spring Security
- Sessions et cookies (`JSESSIONID`)
- `Principal` pour l'utilisateur authentifié
- Routes publiques vs privées
- Gestion des permissions

**Travail à faire :**
1. Comprendre `SecurityConfig` : règles d'accès
2. Passer les contrôleurs Todo et TodoList en mode privé (`/api/v2/private/...`)
3. Créer `PublicUserController` : routes pour signup et login
4. Créer `PrivateUserController` : routes authentifiées
5. Ajouter `Principal` aux routes Todo pour associer au user
6. Vérifier que seul le propriétaire peut modifier/supprimer ses todos

**Routes utilisateur :**
```java
// Public - Créer compte
@PostMapping("signup")
public ResponseEntity<String> signup(@RequestBody UserDTO user) { ... }

// Public - Se connecter
@PostMapping("login")
public ResponseEntity<String> login(@RequestBody UserDTO user) { ... }

// Privé - Obtenir info user connecté
@GetMapping()
public String hello(Principal user) {
    return user.getName();  // login
}
```

**Tester avec curl :**
```bash
# Se connecter
curl -X POST http://localhost:8080/api/v2/public/user/login \
  -H "Content-Type: application/json" \
  -d '{"login":"john","pwd":"secret"}' \
  -c cookies.txt

# Utiliser le JSESSIONID pour une route privée
curl http://localhost:8080/api/v2/private/todo/todo/1 \
  -b cookies.txt
```

## Exemples du Cours

### rest/springboot2

Exemple complet d'API REST Spring Boot présenté en cours.

**Structure :**
- Contrôleurs publics et privés
- Service avec logique métier
- Repository JPA
- Configuration Spring Security
- Tests unitaires

**Lancer :**
```bash
cd rest/springboot2
mvn spring-boot:run
```

### rest/jersey

Exemple d'API REST avec Jersey (implémentation de référence de JAX-RS).

Alternative à Spring pour créer des APIs REST en Java.

**Lancer :**
```bash
cd rest/jersey/example
mvn jetty:run
```

### json/java

Manipulation de JSON en Java avec Jackson et Gson.

**Exemples :**
- Parser JSON → objets Java
- Sérialiser objets Java → JSON
- Gérer tableaux et objets imbriqués
- Annotations Jackson

```bash
cd json/java/web.json
mvn compile exec:java
```

### json/js

Manipulation de JSON en JavaScript.

**Exemples :**
- `JSON.parse()` - JSON string → objet JS
- `JSON.stringify()` - objet JS → JSON string
- Manipulation d'objets et tableaux

```bash
cd json/js
npm install
npm run all
```

### xml

Manipulation de XML en Java (SAX, DOM, JAXB).

**Exemples :**
- Parser XML avec SAX (événementiel)
- Parser XML avec DOM (arbre en mémoire)
- Binding XML ↔ Java avec JAXB

```bash
cd xml
# Voir les exemples de code dans src/
```

### orm/jpa

Exemples JPA/Hibernate pour la persistance.

**Concepts :**
- Entités (`@Entity`)
- Relations (`@OneToMany`, `@ManyToOne`, `@ManyToMany`)
- Queries JPQL
- EntityManager

```bash
cd orm/jpa/example
mvn compile exec:java
```

### js

Exercices JavaScript (syntaxe ES6+, manipulation de données).

```bash
cd js
npm install
npm run all
```

## Concepts Clés

### Architecture REST

**Principes :**
- Client-serveur : séparation des préoccupations
- Sans état (stateless) : chaque requête contient toutes les infos nécessaires
- Cacheable : réponses indiquent si elles peuvent être mises en cache
- Interface uniforme : ressources identifiées par URI, manipulation via représentations
- Système en couches : architecture modulaire

**Verbes HTTP :**
- `GET` : Lire une ressource (idempotent, safe)
- `POST` : Créer une ressource (non idempotent)
- `PUT` : Remplacer une ressource complète (idempotent)
- `PATCH` : Modifier partiellement une ressource
- `DELETE` : Supprimer une ressource (idempotent)

**Codes de statut :**
- `200 OK` : Succès
- `201 Created` : Ressource créée (POST)
- `204 No Content` : Succès sans corps de réponse (DELETE)
- `400 Bad Request` : Requête malformée
- `401 Unauthorized` : Authentification requise
- `403 Forbidden` : Accès interdit
- `404 Not Found` : Ressource inexistante
- `500 Internal Server Error` : Erreur serveur

### Spring Boot

**Annotations contrôleur :**
```java
@RestController                     // Contrôleur REST
@RequestMapping("/api/v1/todo")    // Base URI
@CrossOrigin                        // Autoriser CORS

@GetMapping("/todo/{id}")          // Route GET
@PostMapping("/todo")              // Route POST
@PutMapping("/todo")               // Route PUT
@PatchMapping("/todo")             // Route PATCH
@DeleteMapping("/todo/{id}")       // Route DELETE

@PathVariable("id") long id        // Paramètre d'URI
@RequestBody Todo todo             // Corps de requête (JSON → objet)
Principal user                     // Utilisateur authentifié
```

**Annotations service et repository :**
```java
@Service                           // Service métier
@Repository                        // Repository de données
@Autowired                         // Injection de dépendances
```

**Annotations JPA :**
```java
@Entity                            // Entité persistante
@Id                                // Clé primaire
@GeneratedValue                    // Auto-incrémentation
@OneToMany                         // Relation 1-N
@ManyToOne                         // Relation N-1
@JsonIgnore                        // Ignorer lors du marshalling
```

### OpenAPI / Swagger

**Structure de base :**
```yaml
openapi: 3.1.0
info:
  title: Mon API
  version: 1.0.0
servers:
  - url: http://localhost:8080/api

paths:
  /todo/{id}:
    get:
      summary: Récupérer un todo
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: integer
      responses:
        '200':
          description: Succès
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Todo'

components:
  schemas:
    Todo:
      type: object
      properties:
        id:
          type: integer
        title:
          type: string
```

### JPA / Hibernate

**Repository :**
```java
@Repository
public interface TodoRepository extends CrudRepository<Todo, Long> {
    // Méthodes automatiques : save, findById, findAll, deleteById, etc.
    
    // Query custom
    @Query("SELECT t FROM Todo t WHERE t.title LIKE %:title%")
    List<Todo> findByTitleContaining(@Param("title") String title);
}
```

**Entité :**
```java
@Entity
public class Todo {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;
    
    private String title;
    
    @ManyToOne
    @JsonIgnore  // Éviter boucle infinie
    private TodoList list;
}
```

### Tests Unitaires

**Structure :**
```java
@ExtendWith(MockitoExtension.class)
class TestTodoService {
    @Mock
    private TodoRepository repository;
    
    @InjectMocks
    private TodoService service;
    
    @Test
    void testFindTodo() {
        // Arrange
        Todo todo = new Todo(1L, "Test");
        when(repository.findById(1L)).thenReturn(Optional.of(todo));
        
        // Act
        Optional<Todo> result = service.findTodo(1L);
        
        // Assert
        assertTrue(result.isPresent());
        assertEquals("Test", result.get().getTitle());
        verify(repository).findById(1L);
    }
}
```

## Commandes Utiles

### Maven
```bash
# Compiler
mvn compile

# Lancer l'application
mvn spring-boot:run

# Tests
mvn test
mvn test -Dtest=TestTodoService

# Couverture
mvn test jacoco:report

# Nettoyer
mvn clean

# Package (créer JAR)
mvn package

# Tout nettoyer et recompiler
mvn clean install
```

### Curl
```bash
# GET
curl http://localhost:8080/api/v1/public/todo/todo/1

# POST avec JSON
curl -X POST http://localhost:8080/api/v1/public/todo/todo \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","description":"Description"}'

# PUT
curl -X PUT http://localhost:8080/api/v1/public/todo/todo \
  -H "Content-Type: application/json" \
  -d '{"id":1,"title":"Updated"}'

# DELETE
curl -X DELETE http://localhost:8080/api/v1/public/todo/todo/1

# Avec authentification (cookie)
curl http://localhost:8080/api/v2/private/todo/todo/1 \
  --cookie "JSESSIONID=ABC123..."
```

### npm (JavaScript)
```bash
# Installer dépendances
npm install

# Linter
npm run lint

# Tests
npm run test

# Couverture
npm run coverage

# Tout exécuter
npm run all
```

## Debugging et Troubleshooting

### Le serveur ne démarre pas

**Problème : Port 8080 déjà utilisé**
```bash
# Trouver le processus
lsof -i :8080

# Tuer le processus
kill -9 <PID>

# Ou changer de port dans application.properties
server.port=8081
```

**Problème : Erreur de dépendances Maven**
```bash
mvn clean install -U
```

### Tests échouent

**Vérifier les mocks :**
```java
// S'assurer que les mocks sont initialisés
@ExtendWith(MockitoExtension.class)

// Configurer le comportement
when(repository.findById(1L)).thenReturn(Optional.of(todo));

// Vérifier les appels
verify(repository, times(1)).findById(1L);
```

### Erreur JPA

**`No identifier specified for entity`**
```java
// Ajouter @Id sur la clé primaire
@Entity
public class Todo {
    @Id
    @GeneratedValue
    private Long id;
}
```

**Boucle infinie JSON**
```java
// Ajouter @JsonIgnore sur un côté de la relation
@ManyToOne
@JsonIgnore
private TodoList list;
```

### Swagger Editor

**La route ne fonctionne pas :**
- Vérifier l'URL du serveur dans Swagger
- Vérifier que le backend est démarré
- Vérifier l'indentation YAML (très importante !)
- Pas de `/` à la fin des URIs

**CORS bloque les requêtes :**
```java
// Ajouter @CrossOrigin sur le contrôleur
@RestController
@CrossOrigin
@RequestMapping("/api/v1/todo")
public class TodoController { ... }
```

### JavaScript

**XMLHttpRequest ne fonctionne pas :**
- Vérifier l'URL
- Vérifier que le backend est démarré
- Ouvrir la console du navigateur (F12) pour voir les erreurs
- Vérifier la configuration CORS

**JSON.parse échoue :**
```javascript
try {
    const data = JSON.parse(xhr.responseText);
} catch (e) {
    console.error("Invalid JSON:", xhr.responseText);
}
```

## Bonnes Pratiques

### Architecture
- **Séparation des responsabilités** : Contrôleur → Service → Repository
- **DTO** : Ne pas exposer directement les entités JPA
- **Validation** : Valider les entrées dans le contrôleur
- **Gestion d'erreurs** : Retourner des codes HTTP appropriés

### Sécurité
- **Authentification** : Toujours vérifier l'identité
- **Autorisation** : Vérifier que l'user peut faire l'action
- **Validation** : Ne jamais faire confiance aux entrées
- **XSS** : Utiliser textContent au lieu de méthodes non sûres avec données non sanitizées
- **SQL Injection** : Utiliser JPA avec paramètres (pas de concaténation)

### Tests
- **100% de couverture** : Tester tous les cas et branches
- **Tests isolés** : Utiliser des mocks
- **AAA** : Arrange, Act, Assert
- **Noms explicites** : `testAddTodoWithValidData()`

### Code
- **Noms clairs** : `findTodoById` plutôt que `getTodo`
- **Méthodes courtes** : < 50 lignes
- **Commentaires** : Expliquer le pourquoi, pas le comment
- **Lombok** : Réduire le boilerplate (`@Data`, `@Builder`)

## Ressources

### Documentation Officielle
- Spring Boot : https://spring.io/projects/spring-boot
- Spring Data JPA : https://spring.io/projects/spring-data-jpa
- Spring Security : https://spring.io/projects/spring-security
- OpenAPI : https://swagger.io/specification/
- MDN Web Docs : https://developer.mozilla.org/

### Tutoriels
- Spring Guides : https://spring.io/guides
- Baeldung : https://www.baeldung.com/
- REST API Best Practices : https://restfulapi.net/

### Outils
- Swagger Editor : https://editor-next.swagger.io/
- JSON Formatter : https://jsonformatter.org/
- Postman : https://www.postman.com/ (alternative à Swagger)
- curl documentation : https://curl.se/docs/

### Sécurité
- OWASP Top 10 : https://owasp.org/www-project-top-ten/
- OWASP Cheat Sheets : https://cheatsheetseries.owasp.org/

## Support

- Consultez les slides dans `slides/`
- Étudiez l'exemple complet dans `rest/springboot2/`
- Posez des questions pendant les séances de TP
- Utilisez les ressources en ligne mentionnées ci-dessus
