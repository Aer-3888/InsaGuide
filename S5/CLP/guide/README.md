# CLP -- Conception Logique des Processeurs (Processor Logic Design)

## Course Overview

CLP (Conception Logique des Processeurs) is a 3rd-year course at INSA Rennes covering the full stack of digital system design: from Boolean algebra and logic gates all the way up to processor architecture and ARM assembly programming. The course is split into two major parts:

1. **Digital Logic** (Logique) -- combinational and sequential circuit design, state machines, processor datapath and control unit
2. **ARM Assembly** (Assembleur) -- ARM instruction set, stack management, function calls, data structures in assembly

---

## Chapter Navigation

### Part I -- Digital Logic

| Chapter | File | Key Topics |
|---------|------|------------|
| 1. Combinational Logic | [combinational-logic.md](combinational-logic.md) | Logic gates, Boolean algebra, Karnaugh maps, transcoders, multiplexers, decoders |
| 2. Sequential Logic | [sequential-logic.md](sequential-logic.md) | Flip-flops (D, T, JK, RS), registers, counters, state machines (Moore/Mealy) |
| 3. Processor Architecture | [processor-architecture.md](processor-architecture.md) | Datapath (UT), Control Unit (UC), ALU, microcode, sequencer, memory |
| 4. Logisim Circuits | [logisim-circuits.md](logisim-circuits.md) | Circuit design methodology, Logisim file reference, simulation techniques |
| 5. PGCD / Arithmetic Circuits | [pgcd-arithmetic.md](pgcd-arithmetic.md) | GCD algorithm in hardware, UC+UT integration, Fibonacci machine |

### Part II -- ARM Assembly

| Chapter | File | Key Topics |
|---------|------|------------|
| 6. ARM Assembly Language | [assembly-arm.md](assembly-arm.md) | ARM instruction set, addressing modes, stack, procedures, data structures, GPIO |

---

## How to Use This Guide

1. **First pass**: Read chapters 1-3 in order -- they build on each other. Combinational logic feeds into sequential logic, which feeds into processor architecture.
2. **Practice**: Work through the exercises in `../exercises/` after each chapter. The TD solutions are organized by topic.
3. **Assembly**: Chapter 6 is self-contained. Start with basic instructions, then tackle function calls and recursion.
4. **Exam prep**: Use `../exam-prep/` for timed practice and methodology.

---

## Exam Structure

The CLP course has **two separate exams**:

| Exam | Content | Format |
|------|---------|--------|
| DS Logique | Combinational + Sequential logic, state machines, UC/UT | Written, circuit design, truth tables, Karnaugh maps |
| DS Assembleur | ARM assembly programming | Written, code reading/writing, stack tracing |

---

## Key Resources

- **Logisim circuits**: All `.circ` files in `../data/moodle/cours/` and `../data/moodle/td/Logique/`
- **ARM cheatsheet**: `../data/moodle/cours/ARM/arm-cheatsheet.pdf`
- **Course synthesis**: `../data/moodle/cours/CPL-Cours-2020-2021-synthese.pdf`
- **ARM lecture slides**: `../data/moodle/cours/AssembleurARM - 2023-2024 - version etudiant.pdf`
- **Past exams**: `../data/annales/` (organized by Assembleur and Logique)
