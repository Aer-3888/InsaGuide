# CLP - Travaux Pratiques (Lab Exercises)

This directory contains completed lab solutions for the ARM Assembly programming section of the CLP course at INSA Rennes.

## Course Context

**Course**: CLP - Concepts de la logique a la programmation  
**Institution**: INSA Rennes, 3rd Year Computer Science  
**Topics**: Digital Logic Circuits and ARM Assembly Programming

## Lab Exercises Overview

### [TP1: Introduction to ARM Assembly](tp1/)
**Topics**: Basic ARM instructions, GCD algorithm, recursion, stack management
- `assembleur_TP1.s` - First assembly exercise (original version)
- `pgcd.s` - GCD (Greatest Common Divisor) computation using Euclid's algorithm

**Key Concepts**:
- ARM register usage (r0-r15)
- Stack operations (STMFD, LDMFD)
- Function calls and return addresses
- Frame pointer management
- Recursive function implementation

### [TP2: Matrix Operations](tp2/)
**Topics**: Multi-dimensional arrays, nested loops, memory addressing
- `matrix.s` - Matrix multiplication implementation
- `produitMatrices.s` - Alternative matrix product implementation

**Key Concepts**:
- Memory layout for 2D arrays
- Address calculation with offsets
- Nested loop structures
- Local variable management
- Multiply-accumulate (MLA) instruction

### [TP3: Graph Algorithms](tp3/)
**Topics**: Data structures, graph traversal, pointer manipulation
- `main.s` - Graph definition and program entry point
- `dfs.s` - Depth-First Search implementation
- `rechercheSommet.s` - Vertex search in graph
- `estPointEntree.s` - Entry point detection in graph

**Key Concepts**:
- Structure member access with offsets
- Graph representation in memory
- Recursive DFS traversal
- String operations (ASCII character comparison)
- Boolean marking arrays

### [TP4: Raspberry Pi GPIO](tp4/)
**Topics**: Hardware interaction, GPIO control, LED blinking
- `main.s` - Raspberry Pi LED control (ACT LED blink pattern)

**Key Concepts**:
- Memory-mapped I/O
- GPIO register manipulation
- Timing loops
- Bit manipulation for hardware control
- Morse code implementation (SOS pattern)

## ARM Assembly Reference

### Register Conventions
- **r0-r3**: Argument and return value registers
- **r4-r11**: General-purpose registers (callee-saved)
- **r12 (IP)**: Intra-procedure-call scratch register
- **r13 (SP)**: Stack pointer
- **r14 (LR)**: Link register (return address)
- **r15 (PC)**: Program counter
- **FP**: Frame pointer (typically r11)

### Common Instructions Used

**Data Movement**:
- `MOV` - Move data between registers
- `LDR` - Load word from memory to register
- `STR` - Store register to memory
- `LDRB/STRB` - Load/store byte

**Stack Operations**:
- `STMFD sp!, {regs}` - Push registers onto stack (Full Descending)
- `LDMFD sp!, {regs}` - Pop registers from stack
- `SUB sp, sp, #n` - Reserve local variable space
- `ADD sp, sp, #n` - Free local variable space

**Arithmetic**:
- `ADD/SUB` - Addition/subtraction
- `MUL` - Multiplication
- `MLA` - Multiply-accumulate (dst = src1 * src2 + src3)

**Control Flow**:
- `B` - Unconditional branch
- `BL` - Branch with link (function call)
- `BX lr` - Branch exchange (return from function)
- `Bcc` - Conditional branches (BEQ, BNE, BGT, BLT, etc.)

**Comparison**:
- `CMP` - Compare (sets flags)
- `TEQ` - Test equivalence

### Stack Frame Structure

Typical function stack layout:
```
High addresses
    +------------------+
    | Arguments (n+)   |  [fp, #16] and above
    +------------------+
    | Argument 3       |  [fp, #16]
    +------------------+
    | Argument 2       |  [fp, #12]
    +------------------+
    | Argument 1       |  [fp, #8]
    +------------------+
    | Return value     |  [fp, #8] (if used)
    +------------------+
    | Saved LR         |  [fp, #4]
    +------------------+
FP->| Saved FP         |  [fp, #0]
    +------------------+
    | Local var 1      |  [fp, #-4]
    +------------------+
    | Local var 2      |  [fp, #-8]
    +------------------+
    | Saved registers  |  Below local vars
    +------------------+
SP->|                  |
Low addresses
```

## Building and Running

### Prerequisites
- ARM cross-compiler toolchain (`arm-linux-gnueabi-gcc` or `arm-none-eabi-gcc`)
- QEMU ARM emulator (for testing without hardware)
- Raspberry Pi (for TP4 hardware exercises)

### Compilation

**Standard ARM executable**:
```bash
arm-linux-gnueabi-as -o program.o program.s
arm-linux-gnueabi-ld -o program program.o
```

**For Raspberry Pi bare metal**:
```bash
arm-none-eabi-as -o program.o program.s
arm-none-eabi-ld -Ttext=0x8000 -o program.elf program.o
arm-none-eabi-objcopy program.elf -O binary kernel.img
# Copy kernel.img to Raspberry Pi SD card
```

### Running with QEMU

```bash
qemu-arm ./program
```

### Debugging with GDB

```bash
arm-linux-gnueabi-gdb program
(gdb) break _start
(gdb) run
(gdb) stepi          # Step one instruction
(gdb) info registers # View register contents
(gdb) x/10x $sp      # Examine stack memory
```

## Study Tips

1. **Understand the calling convention**: Master how parameters are passed (stack), how return addresses are saved (LR), and how local variables are allocated.

2. **Trace stack operations**: Draw the stack frame for each function call to understand memory layout.

3. **Practice offset calculations**: For arrays and structures, manually calculate offsets to understand memory access patterns.

4. **Read condition codes**: Understand how CMP sets flags (N, Z, C, V) and how conditional branches use them.

5. **Follow register usage**: Track which registers hold what values through the program execution.

## Common Pitfalls

- Forgetting to save/restore LR before calling another function
- Incorrect stack pointer adjustment (must be word-aligned, 4-byte multiples)
- Wrong offset calculations for stack access
- Not preserving callee-saved registers (r4-r11)
- Mismatched STMFD/LDMFD pairs (stack imbalance)

## References

- ARM Architecture Reference Manual
- Course materials in `../cours/ARM/`
- ARM instruction set cheatsheet: `../cours/ARM/arm-cheatsheet.pdf`
- Past exams in `../annales/` for practice problems

## Original Files

Original (unmodified) files from lab sessions are preserved in the `_originals/` directory for reference.
