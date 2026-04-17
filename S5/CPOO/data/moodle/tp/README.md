# TP CPOO - Object-Oriented Design and Programming Labs

## Overview

This directory contains practical lab exercises (TPs) for the CPOO (Conception et Programmation Orientee Objet) course at INSA Rennes, 3rd year Computer Science. The labs focus on implementing object-oriented concepts in Java, including associations, inheritance, polymorphism, collections, and generics.

## Course Information

- **Institution**: INSA Rennes
- **Level**: 3rd Year Computer Science
- **Instructor**: Arnaud Blouin
- **Language**: Java 11+
- **Topics**: OOP, UML to Java, Design Patterns, Collections, Generics

## Lab Structure

```
tp/
├── tp1/                    # TP CPOO1 - UML to Java: Associations (Velo/Guidon)
│   ├── q1/                 # Simple unidirectional association
│   ├── q2/                 # Bidirectional association with referential integrity
│   ├── q3/                 # Unidirectional only (no back-reference)
│   ├── q4/                 # One-to-many association (Velo → Roue[*])
│   ├── q5/                 # Composition with bidirectional navigation
│   ├── q6/                 # Testing with Moodle test suite
│   └── README.md           # Detailed TP1 documentation
│
├── tp2/                    # TP CPOO1 - Exercise 2: Forest Management (Arbre/Foret)
│   ├── basic/              # Basic version: inheritance, polymorphism, collections
│   ├── advanced/           # Advanced version: generics, animals, fruits
│   └── README.md           # Detailed TP2 documentation
│
├── tp3_gitlab_exercises/   # GitLab-hosted exercises (Emploi du Temps)
│   ├── README.md           # Exercise description and guide
│   ├── GUIDE.md            # Detailed walkthrough
│   └── src/                # Java source code
│
└── README.md               # This file
```

## Lab Summaries

### TP1: UML to Java - Associations and Composition

**Objective**: Learn to convert UML class diagrams to Java code, implementing various types of associations between objects.

**Key Topics**:
- Simple associations (0..1, 1)
- Bidirectional associations
- Referential integrity
- Composition relationships
- Multiple associations (0..*)

**Classes**: `Velo`, `Guidon`, `Roue`

**See**: [tp1/README.md](tp1/README.md)

### TP2: Forest Management System

**Objective**: Design and implement a class hierarchy for managing a forest with different tree species.

**Key Topics**:
- Inheritance and abstract classes
- Polymorphism
- Collections (ArrayList)
- Runtime type checking (`instanceof`)
- Generics (advanced version)
- ConcurrentModificationException prevention

**Classes**: `Arbre`, `Chene`, `Pin`, `Foret`, `Fruit`, `Animal`

**See**: [tp2/README.md](tp2/README.md)

## Prerequisites

### Software Requirements
- **Java**: JDK 11 or higher
- **IDE**: IntelliJ IDEA (recommended) or Eclipse
- **Build Tool**: Maven or Gradle (optional)
- **Testing**: JUnit 5

### Installation

#### Java
```bash
# Verify Java installation
java -version  # Should show Java 11 or higher
javac -version

# Install Java on Ubuntu/Debian
sudo apt install openjdk-11-jdk

# Install Java on macOS (using Homebrew)
brew install openjdk@11
```

#### IntelliJ IDEA
Download from: https://www.jetbrains.com/idea/

Configure for Java 11:
1. File → Project Structure → Project SDK → Select Java 11
2. File → Project Structure → Language Level → Select "11 - Local variable syntax for lambda parameters"

## Compilation and Execution

### Option 1: Using IntelliJ IDEA
1. Open the tp directory as a project
2. Mark `src/main/java` as Sources Root
3. Mark `src/test/java` as Test Sources Root
4. Right-click on a class → Run

### Option 2: Command Line

#### Compile Single Exercise
```bash
# TP1 - Q1
cd tp1/q1/src
javac main/java/q1/*.java

# TP2 - Basic
cd tp2/basic/src
javac main/java/*.java
```

#### Run Tests
```bash
# Compile tests
javac -cp .:junit-platform-console-standalone.jar test/java/*.java

# Run tests
java -cp .:junit-platform-console-standalone.jar \
  org.junit.platform.console.ConsoleLauncher --scan-classpath
```

## Core OOP Concepts Covered

### 1. Associations
- **Definition**: Relationships between classes representing "uses" or "has" connections
- **Types**: Unidirectional, bidirectional, composition, aggregation
- **Multiplicity**: 0..1, 1, 0..*, 1..*
- **Example**: A Velo has a Guidon (0..1 association)

### 2. Inheritance
- **Definition**: Mechanism for creating a new class based on an existing class
- **Keywords**: `extends`, `super`, `abstract`
- **Purpose**: Code reuse, polymorphism, hierarchy modeling
- **Example**: `Chene extends Arbre`, `Pin extends Arbre`

### 3. Polymorphism
- **Definition**: Ability of objects to take multiple forms
- **Types**: Method overriding, interface implementation
- **Runtime Behavior**: Method dispatch based on actual object type
- **Example**: `List<Arbre>` can contain both `Chene` and `Pin` objects

### 4. Encapsulation
- **Definition**: Bundling data and methods that operate on the data
- **Access Modifiers**: `private`, `protected`, `public`
- **Best Practice**: Private fields, public getters/setters
- **Example**: `private List<Arbre> arbres` with `public List<Arbre> getArbres()`

### 5. Abstraction
- **Definition**: Hiding implementation details, showing only essential features
- **Mechanisms**: Abstract classes, interfaces
- **Keywords**: `abstract class`, `interface`
- **Example**: `abstract class Arbre` with `abstract double getPrixM3()`

### 6. Composition
- **Definition**: Strong form of aggregation where child cannot exist without parent
- **Lifetime**: Child object's lifecycle depends on parent
- **Ownership**: Parent has exclusive ownership
- **Example**: Velo "composes" Roue (wheels belong to bicycle)

### 7. Collections
- **Definition**: Data structures for storing groups of objects
- **Types**: List, Set, Map
- **Implementations**: ArrayList, HashSet, HashMap
- **Example**: `List<Arbre> arbres = new ArrayList<>()`

### 8. Generics
- **Definition**: Type parameters for classes, interfaces, and methods
- **Purpose**: Compile-time type safety, eliminate casts
- **Syntax**: `<T>`, `<E extends Type>`
- **Example**: `Arbre<F extends Fruit>`, `Animal<F extends Fruit>`

## Common Issues and Solutions

### Issue 1: ConcurrentModificationException
**Problem**: Modifying a collection while iterating with foreach loop.

**Wrong**:
```java
for (Arbre arbre : arbres) {
    if (condition) {
        arbres.remove(arbre);  // ConcurrentModificationException!
    }
}
```

**Correct**:
```java
Iterator<Arbre> iterator = arbres.iterator();
while (iterator.hasNext()) {
    Arbre arbre = iterator.next();
    if (condition) {
        iterator.remove();  // Safe removal
    }
}
```

### Issue 2: Referential Integrity
**Problem**: Forgetting to update both sides of a bidirectional association.

**Wrong**:
```java
velo.setGuidon(guidon);  // guidon.velo is still null!
```

**Correct**:
```java
public void setGuidon(Guidon gd) {
    this.guidon = gd;
    if (gd != null) {
        gd.setVelo(this);  // Update both sides
    }
}
```

### Issue 3: Null Pointer Exception
**Problem**: Not initializing collections or not checking for null.

**Wrong**:
```java
private List<Arbre> arbres;  // Never initialized!

public void planterArbre(Arbre arbre) {
    arbres.add(arbre);  // NullPointerException!
}
```

**Correct**:
```java
private List<Arbre> arbres;

public Foret() {
    this.arbres = new ArrayList<>();  // Initialize in constructor
}

public void planterArbre(Arbre arbre) {
    if (arbre != null) {  // Check for null
        arbres.add(arbre);
    }
}
```

### Issue 4: Infinite Recursion
**Problem**: Bidirectional associations calling each other indefinitely.

**Wrong**:
```java
// Velo.java
public void setGuidon(Guidon gd) {
    this.guidon = gd;
    gd.setVelo(this);  // Calls Guidon.setVelo()
}

// Guidon.java
public void setVelo(Velo vl) {
    this.velo = vl;
    vl.setGuidon(this);  // Calls Velo.setGuidon() → infinite loop!
}
```

**Correct**:
```java
// Velo.java
public void setGuidon(Guidon gd) {
    if (gd != this.guidon) {  // Check if change is needed
        this.guidon = gd;
        if (gd != null) {
            gd.setVelo(this);
        }
    }
}

// Guidon.java
public void setVelo(Velo vl) {
    if (vl != this.velo) {  // Check if change is needed
        this.velo = vl;
    }
}
```

## Testing Strategy

### 1. Unit Testing
Test individual methods in isolation:
```java
@Test
void testVieillir() {
    Arbre arbre = new Chene(5, 2.0);
    arbre.vieillir();
    assertEquals(6, arbre.getAge());
}
```

### 2. Integration Testing
Test interactions between classes:
```java
@Test
void testForestManagement() {
    Foret forest = new Foret();
    Arbre oak = new Chene(15, 2.5);
    forest.planterArbre(oak);
    assertTrue(forest.couperArbre());
    assertEquals(1, forest.getArbres_coupes().size());
}
```

### 3. Edge Case Testing
Test boundary conditions:
```java
@Test
void testNullHandling() {
    Velo bike = new Velo();
    assertFalse(bike.addRoue(null));  // Should handle null gracefully
}
```

### 4. Type Safety Testing (Generics)
Verify compile-time type safety:
```java
@Test
void testTypeSafety() {
    Chene oak = new Chene(15, 2.5);
    Gland acorn = oak.produireFruit();  // No casting needed
    Cochon pig = new Cochon();
    pig.manger(acorn);  // Type-safe feeding
}
```

## Development Tools

### IntelliJ IDEA Shortcuts
- **Alt+Enter**: Quick fix / import class
- **Ctrl+Space**: Code completion
- **Ctrl+Shift+F10**: Run current class
- **Ctrl+B**: Go to declaration
- **Alt+Insert**: Generate code (constructor, getters, etc.)

### Useful Plugins
- **SonarLint**: Code quality analysis
- **CheckStyle**: Coding standards enforcement
- **JUnit**: Test framework integration

## Resources

### Official Documentation
- [Java SE Documentation](https://docs.oracle.com/en/java/)
- [Java Tutorials](https://docs.oracle.com/javase/tutorial/)
- [JUnit 5 User Guide](https://junit.org/junit5/docs/current/user-guide/)

### UML and Design
- [UML Class Diagrams](https://www.uml-diagrams.org/class-diagrams-overview.html)
- [Java Design Patterns](https://java-design-patterns.com/)

### Books
- "Effective Java" by Joshua Bloch
- "Head First Design Patterns" by Freeman & Freeman
- "Clean Code" by Robert C. Martin

## Course Structure

These labs are part of a larger CPOO course covering:
1. **Week 1-2**: Introduction to OOP, classes, objects
2. **Week 3-4**: Associations and UML (TP1)
3. **Week 5-6**: Inheritance and polymorphism (TP2)
4. **Week 7-8**: Collections and generics
5. **Week 9-10**: Design patterns
6. **Week 11-12**: Advanced topics (reflection, annotations)

## Grading Criteria

- **Code Correctness**: 40% - Does the code work as specified?
- **Code Quality**: 30% - Is the code clean, readable, well-documented?
- **OOP Principles**: 20% - Proper use of inheritance, encapsulation, etc.?
- **Testing**: 10% - Comprehensive test coverage?

## Contact and Support

- **Instructor**: Arnaud Blouin
- **Course Page**: INSA Rennes Moodle
- **Office Hours**: Check course schedule
- **Forum**: Use Moodle discussion forum for questions

## License

These materials are for educational use within INSA Rennes CPOO course.

---

**Last Updated**: April 2026  
**Version**: 1.0  
**Maintained by**: INSA Rennes CS Department
