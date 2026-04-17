# SDD (Structures de Donnees) - Lab Exercises

INSA Rennes - 3rd Year Computer Science  
Course: Data Structures and Algorithms

## Overview

This directory contains 8 lab exercises (TPs) covering fundamental data structures in Java, plus a final project.

## Lab Index

| TP | Directory | Topic | Key Concepts |
|----|-----------|-------|--------------|
| TP1 | [tp1_linked_lists](tp1_linked_lists/) | Linked Lists | Simple and doubly-linked lists, cursors |
| TP2 | [tp2_iterators](tp2_iterators/) | Lists with Iterators | Separation of list and iterator concerns, array-based and linked implementations |
| TP3 | [tp3_geographic_db](tp3_geographic_db/) | Geographic Database | Applying lists and iterators to real-world data |
| TP4 | [tp4_scheduling](tp4_scheduling/) | Time Scheduling | Hash tables for timetable management |
| TP5 | [tp5_hash_tables](tp5_hash_tables/) | Hash Tables | Dictionary implementation with collision handling |
| TP6 | [tp6_binary_trees](tp6_binary_trees/) | Binary Trees | Expression trees, evaluation, simplification |
| TP7 | [tp7_quadtrees](tp7_quadtrees/) | QuadTrees | Hierarchical image compression using quadtrees |
| TP8 | [tp8_heaps_dijkstra](tp8_heaps_dijkstra/) | Priority Queues & Heaps | Heap-based priority queues, Dijkstra's algorithm, Seam Carving |
| Final | [tp_final_project](tp_final_project/) | Final Project | GitLab-hosted group project |

## Other Files

- [assignments/](assignments/) - Moodle assignment descriptions (group submission links)

## Structure

Each TP directory contains:
- `README.md` - Detailed walkthrough with theory, exercises, and usage instructions
- `src/` - Cleaned, well-commented Java implementations
- Original PDFs and specifications (where available)
- Build configuration (Maven `pom.xml` or `.iml` files for IntelliJ)

## Prerequisites

- Java 8 or higher
- Maven (for TP08 which uses Maven build system)
- IntelliJ IDEA or Eclipse (project files included)

## Compilation & Execution

### IntelliJ IDEA Projects (TP01-TP07)
```bash
# Open the TP directory in IntelliJ
# Run tests: Right-click on test class > Run

# Or compile manually:
cd tp1_linked_lists/src
javac main/*.java
java main.MainClass
```

### Maven Project (TP08)
```bash
cd tp8_heaps_dijkstra
mvn test
mvn package
mvn exec:java -Dexec.mainClass="fr.insa_rennes.sdd.dijkstra.LeCompteEstBonSolver"
```

## Learning Path

### Beginner
1. Start with **TP1** (Linked Lists) - fundamental structure
2. Progress to **TP2** (Iterators) - design patterns
3. Apply knowledge in **TP3** (Geographic Database)

### Intermediate
4. **TP4** (Scheduling) - hash tables introduction
5. **TP5** (Dictionary) - hash table deep dive
6. **TP6** (Binary Trees) - tree structures and recursion

### Advanced
7. **TP7** (QuadTrees) - hierarchical structures, image processing
8. **TP8** (Heaps & Dijkstra) - priority queues, graph algorithms, real applications

## Key Concepts Covered

### Data Structures
- **Linear**: Arrays, Singly/Doubly Linked Lists, Stacks, Queues
- **Hash-Based**: Hash Tables, Collision Resolution (Chaining)
- **Trees**: Binary Trees, QuadTrees, Heaps
- **Graphs**: Adjacency Lists, Shortest Path

### Algorithms
- **Traversal**: Iterative and recursive tree/graph traversal
- **Search**: Linear search, binary search (in sorted structures)
- **Sorting**: Heap sort (implicit in priority queue)
- **Graph**: Dijkstra's shortest path algorithm
- **Dynamic Programming**: Seam carving

### Design Patterns
- **Iterator Pattern**: Separating traversal from collection
- **Factory Pattern**: Creating priority queue implementations
- **Comparator Pattern**: Custom ordering in priority queues

## Resources

### Course Materials
- Lecture notes in `/cours` directory
- TD exercises in `/td` directory
- Past exams in `/annales` directory

### External References
- [Algorithms 4th Edition](https://algs4.cs.princeton.edu/) - Sedgewick & Wayne
- [Data Structures Visualizations](https://www.cs.usfca.edu/~galles/visualization/)

## License

Educational material for INSA Rennes students. Use for learning purposes only.
