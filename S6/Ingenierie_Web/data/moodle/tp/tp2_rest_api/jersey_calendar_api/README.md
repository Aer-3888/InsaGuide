# Jersey REST API - Calendar/Agenda Management

## Objective

Build a RESTful API using Jersey (JAX-RS) for managing an academic calendar with courses, teachers, and subjects.

## Project Structure

```
tpWeb-etd/
├── src/main/
│   ├── java/fr/insarennes/
│   │   ├── Main.java                 # Jersey server bootstrap
│   │   ├── model/                    # Domain models
│   │   │   ├── Agenda.java          # Calendar aggregator
│   │   │   ├── CalendarElement.java # Base class
│   │   │   ├── Cours.java           # Course interface
│   │   │   ├── CM.java              # Lecture (Cours Magistral)
│   │   │   ├── TD.java              # Tutorial (Travaux Dirigés)
│   │   │   ├── Enseignant.java     # Teacher
│   │   │   └── Matiere.java        # Subject
│   │   ├── resource/                # REST endpoints
│   │   │   ├── CalendarResource.java
│   │   │   ├── LocalDateTimeXmlAdapter.java
│   │   │   └── DurationXmlAdapter.java
│   │   └── utils/
│   │       └── MyExceptionMapper.java
│   ├── webapp/
│   │   ├── index.html              # API documentation
│   │   ├── calendar.html           # Calendar UI
│   │   ├── swag/                   # Swagger UI
│   │   └── WEB-INF/web.xml
│   └── resources/
│       └── META-INF/persistence.xml
└── pom.xml                         # Maven configuration
```

## Domain Model

### Agenda
Central repository managing:
- Courses (CM, TD)
- Teachers (Enseignant)
- Subjects (Matiere)

### Course Hierarchy
```
CalendarElement (base)
    └── Agenda
    └── Cours (interface)
        ├── CM (Cours Magistral - Lecture)
        └── TD (Travaux Dirigés - Tutorial)
```

### Key Entities

**Enseignant (Teacher)**
- `id`: Unique identifier
- `name`: Teacher name

**Matiere (Subject)**
- `id`: Unique identifier
- `name`: Subject name
- `annee`: Year level (1, 2, 3...)

**Cours (Course)**
- `matiere`: Subject reference
- `dateTime`: Start time (LocalDateTime)
- `enseignant`: Teacher reference
- `duration`: Course duration

## REST API Endpoints

### Teacher Management

**Create Teacher**
```bash
curl -X POST "http://localhost:8080/calendar/ens/Blouin"
```

### Subject Management

**Create Subject**
```bash
curl -X POST "http://localhost:8080/calendar/mat/3/Web"
```

**Get Subject**
```bash
curl -X GET "http://localhost:8080/calendar/mat/{id}"
```

**Update Subject**
```bash
curl -X PUT "http://localhost:8080/calendar/mat/{id}/NewName"
```

**Delete Subject**
```bash
curl -X DELETE "http://localhost:8080/calendar/mat/{id}"
```

### Course Management

**Create Course**
```bash
curl -X POST "http://localhost:8080/calendar/cours/new" \
     -H "Content-Type: application/xml" \
     -d '<td>...</td>'
```

## Key Features

### 1. Jersey (JAX-RS) Annotations

```java
@Singleton
@Path("calendar")
@Api(value = "calendar")
public class CalendarResource {
    
    @POST
    @Path("ens/{name}")
    public Response postEnseignant(@PathParam("name") String name) {
        Enseignant ens = new Enseignant(name);
        agenda.addEnseignant(ens);
        return Response.status(Response.Status.OK).entity(ens).build();
    }
    
    @GET
    @Path("mat/{id}")
    public Response getMatiere(@PathParam("id") int id) {
        Matiere mat = agenda.getMatiere(id);
        if (mat == null) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        return Response.status(Response.Status.OK).entity(mat).build();
    }
    
    @DELETE
    @Path("mat/{id}")
    public Response delMatiere(@PathParam("id") int id) {
        boolean success = agenda.delMatiere(id);
        return Response.status(success ? Status.OK : Status.NOT_FOUND).build();
    }
}
```

### 2. XML Serialization with JAXB

```java
@XmlRootElement
public class Matiere extends CalendarElement {
    @XmlAttribute
    private String name;
    
    @XmlAttribute
    private int annee;
    
    // Getters/setters...
}
```

### 3. Custom XML Adapters

For Java 8 types not supported by JAXB:

```java
public class LocalDateTimeXmlAdapter extends XmlAdapter<String, LocalDateTime> {
    @Override
    public LocalDateTime unmarshal(String v) throws Exception {
        return LocalDateTime.parse(v, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }
    
    @Override
    public String marshal(LocalDateTime v) throws Exception {
        return v.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    }
}
```

### 4. Error Handling

```java
try {
    agenda.addEnseignant(ens);
} catch(IllegalArgumentException ex) {
    throw new WebApplicationException(
        Response.status(HttpURLConnection.HTTP_BAD_REQUEST, ex.getMessage())
                .build()
    );
}
```

### 5. Business Logic Validation

```java
public void addMatiere(Matiere mat) throws IllegalArgumentException {
    // Prevent duplicate subject names in same year
    if(matieres.stream().anyMatch(m -> 
        m.getName().equals(mat.getName()) && 
        m.getAnnee() == mat.getAnnee())) {
        throw new IllegalArgumentException(
            "Two subjects of the same year cannot have the same name"
        );
    }
    matieres.add(mat);
}
```

## Technologies Used

- **Jersey** - JAX-RS reference implementation
- **JAXB** - XML binding
- **Swagger** - API documentation
- **JPA** - Persistence (configured but not actively used)
- **Maven** - Dependency management
- **Grizzly** - Embedded HTTP server

## Running the Application

```bash
# Build project
mvn clean package

# Run server
mvn exec:java -Dexec.mainClass="fr.insarennes.Main"

# Server starts on http://localhost:8080
```

## Testing

```bash
# Run tests
mvn test

# Example test
curl -X POST "http://localhost:8080/calendar/ens/Blouin"
curl -X POST "http://localhost:8080/calendar/mat/3/Web"
curl -X GET "http://localhost:8080/calendar/mat/1"
```

## API Documentation

- **Swagger UI**: http://localhost:8080/swag/
- **Interactive testing**: Use Swagger UI to test endpoints
- **Manual docs**: `/calendar.html`

## Learning Outcomes

### JAX-RS (Jersey)
- Resource classes with `@Path`
- HTTP method annotations (`@GET`, `@POST`, `@PUT`, `@DELETE`)
- Path parameters (`@PathParam`)
- Response building with status codes

### REST Principles
- Resource-based URLs
- HTTP verbs for CRUD operations
- Status codes (200, 404, 400)
- Content negotiation (XML/JSON)

### Java Web Development
- Maven project structure
- Dependency injection with `@Singleton`
- XML serialization with JAXB
- Custom type adapters
- Exception mapping

### Business Logic
- Domain model design
- Validation rules
- Error handling
- Resource lifecycle management

## Common Issues

**Port Already in Use**
```bash
# Find process using port 8080
lsof -i :8080
# Kill process
kill -9 <PID>
```

**JAXB Not Found (Java 9+)**
- Add JAXB dependencies to pom.xml (already configured)

**XML Parsing Errors**
- Check XML format in POST requests
- Ensure Content-Type header is set

## Extensions

Potential improvements:
- Add pagination to list endpoints
- Implement filtering/search
- Add JSON support alongside XML
- Implement JWT authentication
- Add database persistence (JPA configured)
- Add course conflict detection
- Implement calendar export (iCal format)
