# INSA Rennes 3A Informatique - Study Guide

Complete study resource for INSA Rennes 3rd-year Computer Science (3A INFO).
Covers all 20 courses from Semester 5 and Semester 6 with detailed guides, exercise solutions following teacher instructions step-by-step, and exam preparation materials.

---

## Quick Start

### Studying a new chapter
1. Go to `S5/CourseName/guide/` or `S6/CourseName/guide/` and read the topic file
2. Review the **CHEAT SHEET** at the bottom of each guide
3. Work through exercises in `CourseName/exercises/`

### Preparing for an exam
1. Start with `CourseName/exam-prep/README.md` for strategy
2. Review all cheat sheets in `CourseName/guide/`
3. Work through past exam walkthroughs in `exam-prep/`
4. Time yourself on untouched past exams

### Quick reference
Each guide file ends with a condensed cheat sheet containing formulas, syntax, and key facts.

---

## Repository Structure

```
S5/                          # Semester 5 (9 courses)
S6/                          # Semester 6 (11 courses)
```

Each course follows this layout:

```
CourseName/
  data/
    moodle/                  # Raw course materials (lectures, TPs, TDs)
      cours/                 # Lecture slides and notes
      tp/                    # TP instructions and starter code
      td/                    # TD exercise sheets
      forum/                 # Moodle forum posts (tips, fixes)
    annales/                 # Past exams and tests
  guide/                     # Detailed study guides with cheat sheets
    README.md                # Course overview and chapter navigation
    topic-name.md            # One file per major topic
  exercises/                 # TP/TD solutions following teacher instructions
  exam-prep/                 # Exam strategy and past exam walkthroughs
    README.md                # Exam format, time management, priorities
```

---

## Semester 5

| Course | Full Name | Topics | Guide | Exercises | Exam Prep |
|--------|-----------|--------|-------|-----------|-----------|
| [ADFD](S5/ADFD/) | Analyse et Fouille de Donnees | PCA, Clustering, Data Mining, Pandas | [Guide](S5/ADFD/guide/) | [Solutions](S5/ADFD/exercises/) | [Exam Prep](S5/ADFD/exam-prep/) |
| [CLP](S5/CLP/) | Conception Logique des Processeurs | Logic gates, Sequential circuits, ARM Assembly, Processor design | [Guide](S5/CLP/guide/) | [Solutions](S5/CLP/exercises/) | [Exam Prep](S5/CLP/exam-prep/) |
| [CPOO](S5/CPOO/) | Conception et Programmation OO | OOP, Design Patterns, UML, Java, JUnit/Mockito | [Guide](S5/CPOO/guide/) | [Solutions](S5/CPOO/exercises/) | [Exam Prep](S5/CPOO/exam-prep/) |
| [ITI](S5/ITI/) | Introduction Techniques de l'Ingenieur | Shell, Regex, Git, Python, SQL, Qt, Web Scraping | [Guide](S5/ITI/guide/) | [Solutions](S5/ITI/exercises/) | [Exam Prep](S5/ITI/exam-prep/) |
| [Langage_C](S5/Langage_C/) | Langage C | Pointers, Memory, Structs, File I/O, Makefiles, Custom allocator | [Guide](S5/Langage_C/guide/) | [Solutions](S5/Langage_C/exercises/) | [Exam Prep](S5/Langage_C/exam-prep/) |
| [Probabilites](S5/Probabilites/) | Probabilites | Distributions, Random variables, Limit theorems, R | [Guide](S5/Probabilites/guide/) | [Solutions](S5/Probabilites/exercises/) | [Exam Prep](S5/Probabilites/exam-prep/) |
| [Programmation_Fonctionnelle](S5/Programmation_Fonctionnelle/) | Programmation Fonctionnelle | OCaml, Pattern matching, Recursion, Higher-order functions, Trees | [Guide](S5/Programmation_Fonctionnelle/guide/) | [Solutions](S5/Programmation_Fonctionnelle/exercises/) | [Exam Prep](S5/Programmation_Fonctionnelle/exam-prep/) |
| [Programmation_Logique](S5/Programmation_Logique/) | Programmation Logique | Prolog, Unification, Backtracking, Lists, Constraint programming | [Guide](S5/Programmation_Logique/guide/) | [Solutions](S5/Programmation_Logique/exercises/) | [Exam Prep](S5/Programmation_Logique/exam-prep/) |
| [SDD](S5/SDD/) | Structures de Donnees | Linked lists, Trees, Hash tables, Graphs, Heaps, Dijkstra, QuadTrees | [Guide](S5/SDD/guide/) | [Solutions](S5/SDD/exercises/) | [Exam Prep](S5/SDD/exam-prep/) |

## Semester 6

| Course | Full Name | Topics | Guide | Exercises | Exam Prep |
|--------|-----------|--------|-------|-----------|-----------|
| [Apprentissage_Automatique](S6/Apprentissage_Automatique/) | Apprentissage Automatique | Decision Trees, sklearn, Boosting, Neural Networks, Keras | [Guide](S6/Apprentissage_Automatique/guide/) | [Solutions](S6/Apprentissage_Automatique/exercises/) | [Exam Prep](S6/Apprentissage_Automatique/exam-prep/) |
| [Bases_de_Donnees](S6/Bases_de_Donnees/) | Bases de Donnees | SQL, Normalization, Cassandra, Neo4j, MongoDB | [Guide](S6/Bases_de_Donnees/guide/) | [Solutions](S6/Bases_de_Donnees/exercises/) | [Exam Prep](S6/Bases_de_Donnees/exam-prep/) |
| [Complexite](S6/Complexite/) | Complexite | Recurrences, DP, Greedy, NP-Completeness, Generating functions | [Guide](S6/Complexite/guide/) | [Solutions](S6/Complexite/exercises/) | [Exam Prep](S6/Complexite/exam-prep/) |
| [Graphes_Algorithmique](S6/Graphes_Algorithmique/) | Graphes et Algorithmique | Shortest paths, MST, Network flow, Coloring, Scheduling | [Guide](S6/Graphes_Algorithmique/guide/) | [Solutions](S6/Graphes_Algorithmique/exercises/) | [Exam Prep](S6/Graphes_Algorithmique/exam-prep/) |
| [Ingenierie_Web](S6/Ingenierie_Web/) | Ingenierie Web | JavaScript, REST, Jersey, JPA, Angular, Spring Boot (8-part TP) | [Guide](S6/Ingenierie_Web/guide/) | [Solutions](S6/Ingenierie_Web/exercises/) | [Exam Prep](S6/Ingenierie_Web/exam-prep/) |
| [Parallelisme](S6/Parallelisme/) | Parallelisme | OpenMP, MPI, Amdahl's law, Heat equation, Matrix-vector | [Guide](S6/Parallelisme/guide/) | [Solutions](S6/Parallelisme/exercises/) | [Exam Prep](S6/Parallelisme/exam-prep/) |
| [Propositions_Predicats](S6/Propositions_Predicats/) | Propositions et Predicats | Propositional logic, Predicate logic, Natural deduction, Resolution | [Guide](S6/Propositions_Predicats/guide/) | [Solutions](S6/Propositions_Predicats/exercises/) | [Exam Prep](S6/Propositions_Predicats/exam-prep/) |
| [Reseaux](S6/Reseaux/) | Reseaux | OSI model, TCP/IP, Java/C Socket programming, Multicast | [Guide](S6/Reseaux/guide/) | [Solutions](S6/Reseaux/exercises/) | [Exam Prep](S6/Reseaux/exam-prep/) |
| [Statistiques_Descriptives](S6/Statistiques_Descriptives/) | Statistiques Descriptives | Estimation, Hypothesis testing, ANOVA, Regression, R | [Guide](S6/Statistiques_Descriptives/guide/) | [Solutions](S6/Statistiques_Descriptives/exercises/) | [Exam Prep](S6/Statistiques_Descriptives/exam-prep/) |
| [TAL](S6/TAL/) | Traitement Automatique du Langage | Viterbi, CKY, N-grams, Naive Bayes, TF-IDF, Parsing | [Guide](S6/TAL/guide/) | [Solutions](S6/TAL/exercises/) | [Exam Prep](S6/TAL/exam-prep/) |
| [Vulnerabilites](S6/Vulnerabilites/) | Vulnerabilites | SQL Injection, XSS, CSRF, Protocol analysis, CVSS | [Guide](S6/Vulnerabilites/guide/) | [Solutions](S6/Vulnerabilites/exercises/) | [Exam Prep](S6/Vulnerabilites/exam-prep/) |

---

## Course Dependencies

```
S5                                    S6
──────────────────────────────────────────────────────────
Probabilites ────────────────────────> Statistiques_Descriptives
ADFD ────────────────────────────────> Apprentissage_Automatique
SDD ─────────────────────────────────> Complexite, Graphes_Algorithmique
Langage_C ───────────────────────────> Parallelisme, Reseaux
CPOO ────────────────────────────────> Ingenierie_Web, Bases_de_Donnees
Programmation_Logique ───────────────> Propositions_Predicats
Programmation_Fonctionnelle ─────────> TAL (formal grammars)
CLP ─────────────────────────────────> (elective: hardware/embedded)
ITI ─────────────────────────────────> (foundational for all S6 courses)
```

## S6 Course Clusters

### Algorithms and Theory
- **Complexite** + **Graphes_Algorithmique** -- Study together, heavy overlap in graph algorithms
- **Propositions_Predicats** -- Standalone logic course, builds on S5/Programmation_Logique

### Systems and Networks
- **Reseaux** + **Parallelisme** -- Both use C, cover distributed systems concepts
- **Vulnerabilites** -- Security perspective on systems and networks

### Data and AI
- **Apprentissage_Automatique** + **Statistiques_Descriptives** -- Strong statistical foundations overlap
- **TAL** -- Applies ML to natural language

### Software Engineering
- **Bases_de_Donnees** + **Ingenierie_Web** -- Backend stack (SQL + web frameworks)

---

## Languages and Tools

| Language | Courses |
|----------|---------|
| **Java** | CPOO, SDD, Ingenierie_Web (Spring Boot, Jersey, JPA), Reseaux |
| **C** | Langage_C, SDD, Parallelisme (OpenMP/MPI), Reseaux, Vulnerabilites |
| **Python** | ADFD, ITI, Apprentissage_Automatique (sklearn, Keras), TAL |
| **R** | Probabilites, Statistiques_Descriptives |
| **OCaml** | Programmation_Fonctionnelle |
| **Prolog** | Programmation_Logique |
| **SQL** | ITI, Bases_de_Donnees, Vulnerabilites |
| **JavaScript/TypeScript** | ITI, Ingenierie_Web (Angular) |
| **ARM Assembly** | CLP |
| **Cypher** | Bases_de_Donnees (Neo4j) |
| **CQL** | Bases_de_Donnees (Cassandra) |
| **Shell/Bash** | ITI, Vulnerabilites |

---

## Exercise Format

All TP/exercise solutions follow the teacher's actual instructions step-by-step:

```markdown
# TP Name - Full Title

> Following teacher instructions from: data/moodle/tp/tpN/README.md

## Question Q1.1

### [Exact teacher question text in original language]

**Answer:**
[Complete code solution]

**Expected output / How to test:**
[Commands and expected results]
```

Each exercise file:
- Uses the **exact question numbering** from the teacher's README/PDF (Q1.1, Q1.2, etc.)
- Shows **complete, compilable/runnable code** at each step
- Follows the teacher's **progressive build-up** (each question builds on previous ones)
- Preserves the teacher's **original language** (French instructions, English code)

---

## Data Sources

- **Moodle**: Course materials from INSA Rennes Moodle (lectures, TPs, TDs, forums)
- **Annales**: Past exams from Google Drive and course archives
- **TP Git Repos**: Teacher-provided GitHub/GitLab repositories with starter code

Binary files (PDFs, images, datasets, notebooks) are excluded from this repository via `.gitignore`.
The `data/` directories contain only text-based source materials (READMEs, source code, forum posts).

---

## Contributing

This repository is a personal study resource. If you find errors:
1. Check the `FACTCHECK.md` file in each course directory for known issues and corrections
2. Compare against the original course materials in `data/moodle/`
3. Open an issue or PR with the correction

All study guides, exercise solutions, and exam prep materials are meant to complement (not replace) attending lectures and doing the work yourself.
