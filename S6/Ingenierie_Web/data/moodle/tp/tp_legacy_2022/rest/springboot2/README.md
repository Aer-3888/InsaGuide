# Spring Boot REST API

## Objective

Build a RESTful API using Spring Boot with security, versioning, content negotiation, and testing.

## Project Structure

```
springboot2/
├── src/main/java/fr/insarennes/demo/
│   ├── DemoApplication.java       # Spring Boot entry point
│   ├── restcontroller/            # REST endpoints
│   │   ├── AnimalController.java
│   │   ├── HelloControllerV1.java
│   │   ├── HelloControllerV2.java
│   │   ├── HelloControllerV3.java
│   │   ├── PublicUserController.java
│   │   └── PrivateUserController.java
│   ├── service/                   # Business logic
│   │   ├── AnimalService.java
│   │   ├── UserService.java
│   │   └── DataService.java
│   ├── model/                     # Domain models
│   │   ├── Animal.java
│   │   ├── AnimalBase.java
│   │   ├── Cat.java
│   │   ├── Dog.java
│   │   ├── User.java
│   │   └── Message.java
│   ├── dto/                       # Data Transfer Objects
│   │   └── UserDTO.java
│   └── auth/                      # Security configuration
│       └── SecurityConfig.java
├── src/test/java/                 # Unit tests
│   └── AnimalControllerTest.java
├── src/main/resources/
│   ├── application.properties
│   └── templates/api/private/user/
│       └── user.html
└── pom.xml
```

## Key Features

### 1. API Versioning

Three versioning strategies demonstrated:

**URL Path Versioning** (V1)
```java
@RestController
@RequestMapping("api/v1")
public class HelloControllerV1 {
    @GetMapping("hello")
    public Message hello() {
        return new Message("Hello V1");
    }
}
```

**Request Parameter Versioning** (V2)
```java
@RestController
@RequestMapping("api")
public class HelloControllerV2 {
    @GetMapping(value = "hello", params = "version=2")
    public Message hello() {
        return new Message("Hello V2");
    }
}
```

**Header Versioning** (V3)
```java
@RestController
@RequestMapping("api")
public class HelloControllerV3 {
    @GetMapping(value = "hello", headers = "X-API-VERSION=3")
    public Message hello() {
        return new Message("Hello V3");
    }
}
```

### 2. Content Negotiation

Support for both JSON and XML:

```java
@PostMapping(path = "",
    consumes = {MediaType.APPLICATION_JSON_VALUE,
                MediaType.APPLICATION_XML_VALUE})
public void newAnimal(@RequestBody Animal animal) {
    animalService.getAnimals().add(animal);
}

@GetMapping(path = "all", produces = MediaType.APPLICATION_JSON_VALUE)
public List<Animal> getAll() {
    return animalService.getAnimals();
}
```

### 3. Spring Security

Basic authentication with in-memory users:

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .authorizeRequests()
                .antMatchers("/api/public/**").permitAll()
                .antMatchers("/api/private/**").authenticated()
                .and()
            .httpBasic();
        return http.build();
    }
    
    @Bean
    public UserDetailsService users() {
        UserDetails user = User.builder()
            .username("user")
            .password(passwordEncoder().encode("password"))
            .roles("USER")
            .build();
        return new InMemoryUserDetailsManager(user);
    }
}
```

### 4. DTOs (Data Transfer Objects)

Separate internal models from API responses:

```java
public class UserDTO {
    private String username;
    private String email;
    // No password field exposed
    
    public static UserDTO fromUser(User user) {
        UserDTO dto = new UserDTO();
        dto.setUsername(user.getUsername());
        dto.setEmail(user.getEmail());
        return dto;
    }
}
```

### 5. Polymorphism in REST APIs

Abstract base class with concrete implementations:

```java
@JsonTypeInfo(use = JsonTypeInfo.Id.NAME, property = "type")
@JsonSubTypes({
    @JsonSubTypes.Type(value = Dog.class, name = "dog"),
    @JsonSubTypes.Type(value = Cat.class, name = "cat")
})
public abstract class AnimalBase {
    protected String name;
    protected int age;
}

public class Dog extends AnimalBase {
    private String breed;
}

public class Cat extends AnimalBase {
    private boolean indoor;
}
```

## REST Endpoints

### Public Endpoints (No Authentication)

**Versioned Hello**
```bash
# V1 - URL path
curl http://localhost:8080/api/v1/hello

# V2 - Query parameter
curl "http://localhost:8080/api/hello?version=2"

# V3 - Custom header
curl -H "X-API-VERSION: 3" http://localhost:8080/api/hello
```

**Animal Management**
```bash
# Create animal (JSON)
curl -X POST http://localhost:8080/api/public/v1/animal \
     -H "Content-Type: application/json" \
     -d '{"type":"dog", "name":"Rex", "age":3, "breed":"Labrador"}'

# Get all animals
curl http://localhost:8080/api/public/v1/animal/all
```

### Private Endpoints (Authentication Required)

**User Management**
```bash
# Get user (requires authentication)
curl -u user:password http://localhost:8080/api/private/user/{id}

# List all users
curl -u user:password http://localhost:8080/api/private/user/all
```

## Testing

### Unit Tests with Spring Boot Test

```java
@SpringBootTest
@AutoConfigureMockMvc
public class AnimalControllerTest {
    
    @Autowired
    private MockMvc mockMvc;
    
    @Test
    public void testGetAllAnimals() throws Exception {
        mockMvc.perform(get("/api/public/v1/animal/all"))
               .andExpect(status().isOk())
               .andExpect(content().contentType(MediaType.APPLICATION_JSON));
    }
    
    @Test
    public void testCreateAnimal() throws Exception {
        String animalJson = "{\"type\":\"dog\",\"name\":\"Rex\",\"age\":3}";
        
        mockMvc.perform(post("/api/public/v1/animal")
               .contentType(MediaType.APPLICATION_JSON)
               .content(animalJson))
               .andExpect(status().isOk());
    }
}
```

## Running the Application

```bash
# Build with Maven
mvn clean package

# Run Spring Boot application
mvn spring-boot:run

# Or run JAR directly
java -jar target/demo-0.0.1-SNAPSHOT.jar

# Server starts on http://localhost:8080
```

## Configuration

**application.properties**
```properties
# Server port
server.port=8080

# Security
spring.security.user.name=user
spring.security.user.password=password

# Jackson XML support
spring.jackson.dataformat.xml.indent-output=true

# Logging
logging.level.org.springframework=INFO
logging.level.fr.insarennes=DEBUG
```

## Technologies Used

- **Spring Boot 2.x** - Application framework
- **Spring Web** - REST controllers
- **Spring Security** - Authentication/authorization
- **Jackson** - JSON/XML serialization
- **Maven** - Dependency management
- **JUnit 5** - Unit testing
- **MockMvc** - Controller testing

## Learning Outcomes

### Spring Boot Fundamentals
- Application bootstrapping with `@SpringBootApplication`
- Dependency injection with `@Autowired`
- Component scanning
- Auto-configuration

### REST Best Practices
- HTTP method semantics (GET, POST, PUT, DELETE)
- Status codes (200, 201, 404, 401, 403)
- Content negotiation (JSON/XML)
- API versioning strategies
- DTOs for decoupling

### Spring Annotations
- `@RestController` - REST endpoint class
- `@RequestMapping` - Base path
- `@GetMapping`, `@PostMapping` - HTTP method mapping
- `@RequestBody` - Deserialize request body
- `@PathVariable` - Extract URL parameters
- `@RequestParam` - Extract query parameters

### Security
- Basic authentication
- In-memory user store
- Role-based access control (RBAC)
- Public vs. private endpoints
- Password encoding

### Testing
- Unit tests with JUnit 5
- MockMvc for controller testing
- Test assertions
- Test data setup

## Common Issues

**Circular Dependency**
```bash
# Use constructor injection instead of field injection
public class MyController {
    private final MyService service;
    
    public MyController(MyService service) {  // Constructor injection
        this.service = service;
    }
}
```

**CORS Errors**
```java
@Configuration
public class WebConfig implements WebMvcConfigurer {
    @Override
    public void addCorsMappings(CorsRegistry registry) {
        registry.addMapping("/api/**")
                .allowedOrigins("http://localhost:3000")
                .allowedMethods("GET", "POST", "PUT", "DELETE");
    }
}
```

**JSON Serialization Issues**
```java
// Use @JsonIgnore to exclude fields
@JsonIgnore
private String password;

// Use @JsonProperty for custom field names
@JsonProperty("user_id")
private Long id;
```

## Extensions

Potential improvements:
- Add database persistence (JPA/Hibernate)
- Implement JWT authentication
- Add Swagger/OpenAPI documentation
- Implement pagination
- Add validation with `@Valid`
- Add exception handling with `@ExceptionHandler`
- Implement HATEOAS
- Add caching with `@Cacheable`
