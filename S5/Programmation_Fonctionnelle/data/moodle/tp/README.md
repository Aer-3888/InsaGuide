# OCaml Lab Exercises (TP1-TP9)

## Overview

Complete solutions and documentation for the Programmation Fonctionnelle (Functional Programming) lab exercises at INSA Rennes, 3rd year Computer Science.

## Structure

Each TP directory contains:
- `README.md`: Exercise descriptions, concepts, and expected results
- `src/tpN.ml`: Clean, well-documented OCaml solution with OCamlDoc comments

## Labs Summary

### TP1 - Introduction to OCaml
Basic functions, conditionals, tuples, higher-order functions, recursion
- Arithmetic operations
- Pattern matching
- Primality testing

### TP2 - Advanced Recursion and Numerical Methods
Mutual recursion, higher-order accumulation, numerical integration
- Mutual recursion (even/odd)
- Generalized summation functions
- Rectangle method for integration
- Ternary search optimization

### TP3 - Card Game with Types and Graphics
Custom algebraic data types, pattern matching, graphics
- Variant types for cards
- Record types
- Solitaire game logic
- Graphics library (optional)

### TP4 - List Algorithms and Partitions
Sorting algorithms, fixed points, combinatorics
- Quicksort implementation
- Bubble sort with fixed points
- Integer partition generation

### TP5 - List Operations
Fundamental list manipulation functions
- Length, membership, indexing
- Option types for safe operations
- Sublist search and replacement
- Pattern matching on lists

### TP6 - Binary Trees
Binary tree data structures and algorithms
- Tree construction and traversal
- Node counting
- Binary search trees
- Tree positioning for graphics

### TP7 - N-ary Trees
Trees with arbitrary number of children
- N-ary tree construction
- Path enumeration
- Tree equality
- Subtree replacement

### TP8 - Card Game (Graphics Variant)
Alternative implementation with enhanced graphics
- Tuple variants vs records
- Interactive graphics display
- Event loop and keyboard input
- Game state management

### TP9 - Propositional Logic and Parsing
Logic system with parser combinators
- Formula parsing and evaluation
- Tautology checking
- CNF conversion
- Knights and Knaves puzzles

## OCaml Concepts Covered

### Basic
- Functions and expressions
- Pattern matching
- Recursion
- Conditionals

### Intermediate
- Higher-order functions
- Algebraic data types (variants, records)
- Option types
- Mutual recursion
- List operations

### Advanced
- Parser combinators
- Tree algorithms
- Fixed points
- Accumulator patterns
- Graphics programming

## Running the Labs

### Using OCaml Toplevel
```bash
ocaml
# #use "tpN/src/tpN.ml";;
```

### For Graphics (TP3, TP8)
```bash
ocaml
# #use "topfind";;
# #require "graphics";;
# #use "tpN/src/tpN.ml";;
```

### Compiling
```bash
ocamlc -o tpN tpN/src/tpN.ml
./tpN
```

## Other Files

- [assignments/](assignments/) - Moodle assignment descriptions, exam files, and graded TP solutions

## Original Sources

Original solutions are archived in `_originals/` directory for reference.

## Resources

- [OCaml Manual](https://ocaml.org/manual/)
- [Real World OCaml](https://dev.realworldocaml.org/)
- [OCaml Graphics Documentation](https://ocaml.org/api/Graphics.html)

## Notes

- All code includes OCamlDoc comments for documentation generation
- Test cases are included inline with expected results
- Solutions emphasize functional programming style and immutability
- Graphics functions require the Graphics library to be installed
