# ITI Fact-Check Report

**Date**: 2026-04-17
**Scope**: All 23 generated files in guide/, exercises/, exam-prep/
**Sources checked**: data/moodle/tp/ source files, data/moodle/cours/ PDFs and session pages, data/annales/

---

## Summary

- **Files reviewed**: 23 (10 guide, 12 exercises, 1 exam-prep)
- **Source files compared**: 12 TP source files, 5+ README files, 2 reference TXT files
- **Issues found**: 6 errors, 4 inaccuracies, 3 minor discrepancies
- **Issues fixed**: 5 (E1, E2, E3, E4, I1)
- **Issues remaining**: 2 errors (E5, E6-source-only), 3 inaccuracies, 3 minor discrepancies

Overall quality: HIGH. The generated content is technically accurate for the vast majority of commands, code, and explanations. The issues found and fixes applied are detailed below.

---

## ERRORS (factually incorrect, could cause wrong answers on exam)

### E1. tag_formatter.rb Before/After example is wrong

**File**: `exercises/tp-regex.md` lines 78-88
**Claim**: The regex `$_.gsub!(/>([^<>]+)</, ">\n<")` transforms:
```
<ul><li>item1</li><li>item2</li></ul>
```
into:
```
<ul>
<li>item1</li>
<li>item2</li>
</ul>
```

**Actual behavior**: The regex replaces text content between `>` and `<` with a newline. The actual output is:
```
<ul><li>
</li><li>
</li></ul>
```
The text "item1" and "item2" are **destroyed** because they match `[^<>]+` (characters between `>` and `<`). This error exists in both the guide and the source code's intent description. The regex works correctly for its actual purpose (splitting adjacent tags like `></` into separate lines), but the Before/After example misleads students about what it does.

**Status**: FIXED -- Corrected the Before/After example to show accurate regex behavior and added a caveat explaining the content-destructive nature of the regex.

---

### E2. hello_world.sh content mismatch

**File**: `exercises/tp-shell-basics.md` lines 36-39
**Claim**: The solution for `hello_world.sh` was:
```bash
#!/bin/bash
echo "Hello, World!"
```

**Source** (`data/moodle/tp/tp1_shell_basics/src/hello_world.sh`):
```bash
#!/bin/bash
message="Bonjour le monde !"
echo $message
```

**Issue**: The guide had different content from the actual source file. The real `hello_world.sh` uses a variable and prints in French.

**Status**: FIXED -- Updated to match source file content.

---

### E3. simple_variable.sh misplaced in tp-shell-basics.md

**File**: `exercises/tp-shell-basics.md` lines 42-49
**Claim**: `simple_variable.sh` was presented as part of TP1 (Shell Basics).

**Source**: `simple_variable.sh` is located in `data/moodle/tp/tp2_shell_advanced/src/`, not in `tp1_shell_basics/`. This file belongs to TP2 (Advanced Shell Scripting), not TP1.

**Status**: FIXED -- Removed the separate simple_variable.sh section; its content is now merged with the corrected hello_world.sh solution which covers the same variable concepts.

---

### E4. EAN13 checksum walkthrough has wrong final conclusion

**File**: `exercises/tp-web-scraping.md` lines 163-173
**Claim**: The walkthrough for barcode `3333329930413` computes the checksum and states the result is ambiguous: "Valid: 1 != 3 => INVALID (or adjust based on actual code)".

**Verification**:
- Odd positions sum: 3+3+3+9+3+4 = 25
- Even positions sum: 3+3+2+9+0+1 = 18
- Total: 25 + 18*3 = 79
- Checksum: (10 - 79%10) % 10 = 1
- Actual check digit: 3
- Result: **INVALID** (1 != 3)

The computation is correct but the original wording "(or adjust based on actual code)" was confusing and suggested uncertainty about the algorithm. The algorithm is correct; the barcode `3333329930413` simply fails validation.

**Status**: FIXED -- Replaced ambiguous wording with definitive "INVALID barcode".

---

### E5. Makefile profile target discrepancy

**File**: `guide/build-tools.md` lines 185-187
**Claim**: The complete Makefile template includes `profile: LDFLAGS += -pg` alongside `profile: CFLAGS += -pg`.

**Source** (`data/moodle/tp/tp5_build_tools/src/Makefile`): Only has `CFLAGS += -pg`, not `LDFLAGS += -pg`.

**Assessment**: Adding `-pg` to LDFLAGS is technically the correct practice for gprof to work properly (profiling needs to be enabled at both compile and link time). However, since `$(CC)` is used for linking and CFLAGS are typically passed to the compiler during linking too in simple Makefiles, the source version works in practice. The guide adds something not present in the source. This is an improvement over the source rather than an error, but it creates a discrepancy if students compare with course materials.

**Status**: NOT FIXED (minor -- guide is arguably more correct than source)

---

### E6. GDB custom command uses $arg0 vs $arg1 inconsistency in source

**File**: `exercises/tp-debugging.md` lines 126-131, `guide/debugging.md` lines 125-131

The **guide** files correctly use `$arg0` for the first argument in GDB custom commands:
```gdb
define print_array
    set $i = 0
    while $i < $arg0
```

The **source** (`data/moodle/tp/tp6_debugging/README.md` line 37) uses `$arg1`, which is the second argument (undefined when calling `print_array 10`).

**Assessment**: The guide is CORRECT here. The source README has a bug using `$arg1` instead of `$arg0`. In GDB, `$arg0` is the first argument passed to a user-defined command. No fix needed in the guide.

**Status**: Guide is correct; source has the bug.

---

## INACCURACIES (technically imprecise or misleading)

### I1. QImage pixel manipulation strips alpha channel

**Files**: `guide/qt-gui.md` lines 222-239, `exercises/tp-qt-gui.md` lines 285-294

**Issue**: The pixel manipulation code extracts RGB but discards the alpha channel:
```python
rgb = image.pixel(x, y)
r = (rgb >> 16) & 0xFF
g = (rgb >> 8) & 0xFF
b = rgb & 0xFF
# Reconstruction:
new_rgb = (r << 16) | (g << 8) | b  # Alpha is 0x00!
```

For `QImage.Format_RGB32`, the alpha byte is always 0xFF and is ignored by Qt, so this works in practice. However, for `Format_ARGB32` images, this would make all modified pixels fully transparent. The guide should either note this limitation or use `qRgba()` / include the alpha channel.

**Status**: FIXED -- Added note about alpha channel and Format_ARGB32 to `guide/qt-gui.md`.

---

### I2. Regex guide claims \b is a standard grep feature

**File**: `guide/regex.md` line 15

**Issue**: `\b` (word boundary) is listed as a basic anchor. However, `\b` is not supported in basic POSIX regex (BRE). It works in extended regex (`grep -E`) and Perl-compatible regex (`grep -P`), but not in plain `grep` on all systems. For the exam context where students use `grep` without flags, this could be misleading.

**Severity**: Low (most Linux systems support it in grep).

---

### I3. Guide description of Ruby -n flag slightly imprecise

**File**: `guide/regex.md` lines 228-232

**Claim**: "-n: Wraps code in while-gets loop, does NOT auto-print"

**More precise**: Ruby `-n` wraps the code in `while gets; ... end`, which reads each line into `$_`. The description is correct but does not mention that `$_` is automatically set to each input line, which is why `print if /pattern/` works without explicit variable reference.

**Severity**: Very low (functionally correct, just could be more explicit).

---

### I4. Course name terminology mixing

**Files**: Multiple guide and exercise files

**Issue**: The guide inconsistently refers to "FUS exam" (older course name) and "ITI exam" (current name as of 2025-26). The README.md correctly notes both names, but some files like `guide/shell-bash.md` line 5 say "FUS exam" and `guide/regex.md` line 5 says "FUS exam" when the current course is "ITI". The exam-prep README correctly identifies both names and the transition.

**Severity**: Very low (students will understand both names).

---

## MINOR DISCREPANCIES (style or precision issues, unlikely to affect learning)

### D1. cat_simulator.sh not covered

The source TP1 includes `cat_simulator.sh` (demonstrates a fake cat program), but neither the guide nor exercises mention it. This is a minor omission -- the script is trivial (a single `echo` line) and not essential.

---

### D2. Sorting algorithms merge sort uses < vs <=

**File**: `guide/python-basics.md` line 313 uses `if left[i] < right[j]` in the merge function.
**File**: `exercises/tp-python-basics.md` line 143 uses `if left[i] <= right[j]` in the merge function.

Both produce correct sorted output, but `<=` preserves stability (equal elements maintain relative order). The exercise version is more correct for a stable merge sort. The guide version works but is technically an unstable merge sort.

---

### D3. profiling comparison tip

**File**: `exercises/tp-build-tools.md` line 262

**Claim**: "Profiling a debug build: Combine -pg with -O2, not -O0, for realistic results"

This is listed as a "common mistake" but is actually good advice. The tip is correct -- profiling with -O0 gives misleading results because the compiler doesn't optimize. However, the note is slightly misleading because gprof instrumentation (`-pg`) can interact with optimizations and sometimes give inaccurate call counts at -O3.

---

## VERIFIED CORRECT (notable items explicitly checked)

The following items were specifically verified and found to be correct:

1. **All GCC flags and compilation pipeline** -- `-c`, `-E`, `-S`, `-o`, `-g`, `-Wall`, `-pg`, `-O0`/`-O2`/`-O3`, `-MM`, `-DNAME` all accurately described
2. **Makefile syntax** -- TAB requirement, automatic variables (`$@`, `$<`, `$^`, `$?`), pattern rules (`%.o: %.c`), `.PHONY`, variable substitution (`$(SOURCES:.c=.o)`)
3. **All GDB commands** -- `run`, `break`, `continue`, `next`, `step`, `finish`, `print`, `backtrace`, `info locals`, `watch`, `rwatch`, `awatch`, conditional breakpoints, TUI mode
4. **All Valgrind commands and error types** -- `--leak-check=full`, `--track-origins=yes`, `--show-leak-kinds=all`, invalid read/write, uninitialized memory, memory leak, double free
5. **Gprof workflow** -- Compile with `-pg`, run to generate `gmon.out`, analyze with `gprof program gmon.out`
6. **Shell commands** -- All `grep`, `sed`, `awk`, `sort`, `uniq`, `wc`, `cut`, `tr` flags and behaviors verified
7. **Pipe examples** -- `ls -l | grep "^-" | wc -l` correctly counts files; `ls -l | grep "^d" | wc -l` correctly counts directories
8. **Shell variables and tests** -- `$#`, `$@`, `$*`, `$?`, `$$`, `$0`, `$1`; `-f`, `-d`, `-e`, `-r`, `-w`, `-x`, `-s`, `-z`, `-n`; `-eq`, `-ne`, `-lt`, `-le`, `-gt`, `-ge`
9. **Python sorting algorithms** -- Selection sort, insertion sort, quicksort, merge sort all have correct implementations with accurate complexity annotations
10. **Selection sort trace** (`[64,25,12,22,11]`) -- verified step by step, correct
11. **Insertion sort trace** (`[12,11,13,5,6]`) -- verified step by step, correct
12. **Quicksort trace** (`[3,6,8,10,1,2,1]`) -- verified step by step, correct
13. **Python OOP syntax** -- `__init__`, `self`, `__str__`, class definition, method calls all correct
14. **SQL syntax** -- CREATE TABLE, INSERT, SELECT, UPDATE, DELETE, JOIN, GROUP BY, HAVING, aggregate functions, parameterized queries with `?` placeholders
15. **Git commands** -- `init`, `clone`, `add`, `commit`, `push`, `pull`, `fetch`, `branch`, `checkout`, `merge`, `rebase`, `stash`, `reset` (soft/mixed/hard), `revert` all accurate
16. **Reset types table** -- `--soft` (unchanged/unchanged/removed), `--mixed` (unchanged/reset/removed), `--hard` (reset/reset/removed) is correct
17. **PyQt5 signals/slots** -- `clicked.connect()`, `valueChanged.connect()`, `textChanged.connect()`, custom signals with `pyqtSignal()` all correct
18. **BeautifulSoup API** -- `find()`, `find_all()`, `select()`, `get_text()`, attribute access, CSS selectors all accurate
19. **EAN13 algorithm** -- Odd/even position sums, multiply even by 3, `(10 - total%10) % 10` formula is correct
20. **GEDCOM format** -- Level/tag/value structure, `@ID@` references, tag types (INDI, FAM, NAME, SEX, BIRT, DEAT, MARR, HUSB, WIFE, CHIL, FAMS, FAMC, DATE, PLAC) all match source
21. **GEDCOM converter** -- Stack-based parsing logic, tag closing when level decreases, five line classes all match source implementation
22. **Ruby regex** -- `=~` operator, `$1`/`$2` captures, named captures `(?<name>...)`, `sub`/`gsub`/`sub!`/`gsub!`, `-n`/`-p` flags all correct
23. **sed case-insensitive flag** -- `sed 's/old/new/gi'` works in GNU sed (verified)
24. **POSIX `=` vs `==`** -- Guide correctly warns that `==` does not work in POSIX `[ ]` (verified: `sh` fails with `==`)
25. **Exam archive inventory** -- All years and exam types match the actual files in `data/annales/`

---

## CROSS-REFERENCE WITH SOURCE FILES

| Generated File | Source File(s) | Match Quality |
|---------------|---------------|---------------|
| exercises/tp-shell-basics.md | tp1_shell_basics/src/*.sh | Good (E2, E3 noted) |
| exercises/tp-shell-advanced.md | tp2_shell_advanced/src/*.sh | Excellent |
| exercises/tp-regex.md | tp3_regex/src/*.rb | Good (E1 noted) |
| exercises/tp-gedcom.md | tp4_gedcom/src/ged2xml.rb | Excellent |
| exercises/tp-build-tools.md | tp5_build_tools/src/Makefile | Excellent |
| exercises/tp-debugging.md | tp5/README_gdb.txt, tp6/README.md | Excellent |
| exercises/tp-git.md | cours/Cours INFO3 ITI - Git.pdf, session pages | Good |
| exercises/tp-python-basics.md | (no source code, based on course PDFs) | Good |
| exercises/tp-qt-gui.md | (no source code, based on course PDFs) | Good (I1 noted) |
| exercises/tp-sqlite.md | (no source code, based on course PDFs) | Good |
| exercises/tp-web-scraping.md | (no source code, based on course PDFs) | Good (E4 noted) |
| exercises/tp-automation.md | (no source code, based on course PDFs) | Good |
| exam-prep/README.md | data/annales/ directory listing | Excellent |

---

## RECOMMENDATIONS

### Applied fixes:
1. **E1 FIXED**: Corrected the Before/After example in `exercises/tp-regex.md` and added caveat about content-destructive behavior.
2. **E2 FIXED**: Updated `hello_world.sh` solution to match the actual source file (variable + French message).
3. **E3 FIXED**: Removed separate `simple_variable.sh` section; its content is covered by the corrected `hello_world.sh`.
4. **E4 FIXED**: Replaced ambiguous EAN13 walkthrough conclusion with definitive "INVALID barcode".
5. **I1 FIXED**: Added alpha channel note to QImage pixel manipulation in `guide/qt-gui.md`.

### Remaining items for manual review:
6. **Consider E5**: Either note the `LDFLAGS += -pg` addition as an improvement over the source, or remove it from `guide/build-tools.md` to match source exactly.
7. **Consider I4**: Standardize terminology -- decide whether to use "FUS exam" or "ITI exam" throughout (current course name is ITI as of 2025-26).
