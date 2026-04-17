# Fact-Check Report -- Bases de Donnees Study Guide

> Generated: 2026-04-17
> Scope: 22 files across guide/, exercises/, exam-prep/
> Source: data/moodle/ (cours, td, tp) + data/annales/

---

## Summary

**Files reviewed:** 22 (8 guide chapters + 10 exercises + 3 exam-prep + 1 guide README)
**Issues found:** 5 (3 errors, 2 syntax issues)
**Issues fixed:** 5/5
**Overall accuracy:** High -- the vast majority of SQL, normalization, NoSQL, and relational algebra content is factually correct.

---

## Issues Found and Fixed

### ISSUE 1 -- FIXED: Duplicate DTD element name (td5-xml-xquery.md)

**Severity:** Error (invalid XML)
**Location:** `exercises/td5-xml-xquery.md`, Exercice 4 DTD
**Problem:** The DTD defined `<!ELEMENT cours (cours+)>` and `<!ELEMENT cours (sujet)>` -- the element `cours` was defined twice. This is invalid in XML DTD (each element can only be declared once). The XML used `<cours>` as both a wrapper and individual elements.
**Fix:** Renamed the wrapper element to `<listecours>` in both the DTD and the corresponding XML example.

### ISSUE 2 -- FIXED: Contradictory normal form analysis (td3-4-normalization.md)

**Severity:** Error (incorrect reasoning)
**Location:** `exercises/td3-4-normalization.md`, Exercice 7, section "2. Forme normale"
**Problem:** The analysis contradicted itself in three consecutive paragraphs:
1. First stated "A -> B viole la 3NF"
2. Then claimed "La relation est en 2NF"
3. Then reversed to "Donc la relation est en 1NF seulement"

The correct analysis: {A,C} is a candidate key. A -> B means B (a non-prime attribute) depends on A alone, which is a proper subset of the key {A,C}. This is a partial dependency, so the relation violates 2NF and is in 1NF only.
**Fix:** Replaced the contradictory paragraphs with a single clear analysis leading to the correct conclusion (1NF only).

### ISSUE 3 -- FIXED: SQL comment syntax in Cypher code blocks (07_nosql_databases.md)

**Severity:** Syntax error
**Location:** `guide/07_nosql_databases.md`, section 4 (Neo4j)
**Problem:** All comments inside the `cypher` code block used `--` (SQL comment syntax). Cypher uses `//` for single-line comments. Running these queries as-is in Neo4j would cause parse errors.
**Fix:** Changed all `--` comments to `//` inside the Cypher code block.

### ISSUE 4 -- FIXED: SQL comment in Cypher code block (td7-nosql.md)

**Severity:** Syntax error
**Location:** `exercises/td7-nosql.md`, Exercice 3 Cypher Q2
**Problem:** One comment used `-- Note :` inside a Cypher code block.
**Fix:** Changed to `// Note :`.

### ISSUE 5 -- FIXED: Missing subquery alias in SQL (td2-sql-queries-joins.md)

**Severity:** Error (SQL syntax)
**Location:** `exercises/td2-sql-queries-joins.md`, Exercice 2 Q6 Method 1
**Problem:** The derived table in `SELECT MAX(nb) FROM (SELECT ... GROUP BY etudId)` was missing an alias. In SQL, a subquery used as a derived table in the FROM clause requires an alias. Most SQL engines (PostgreSQL, MySQL, SQLite) would reject this query.
**Fix:** Added `AS sub` alias to the derived table.

### ISSUE 6 -- FIXED: Directed relationship for friendship traversal (07_nosql_databases.md)

**Severity:** Semantic error
**Location:** `guide/07_nosql_databases.md`, Cypher "Amis des amis d'Alice" query
**Problem:** The query used `[:AMI_DE*2]->` (directed traversal). Since AMI_DE edges are created unidirectionally (e.g., Alice->Bob, Bob->Charlie), a directed-only traversal at depth 2 would miss many friend-of-friend paths. The tp-neo4j.md exercises correctly use undirected `-[:AMI_DE*2]-` for the same query, plus a `WHERE fof <> alice` guard.
**Fix:** Changed to undirected traversal `[:AMI_DE*2]-` and added `WHERE fof <> a` filter.

---

## Verified Correct (No Issues)

### SQL Queries
- All SELECT/FROM/WHERE/JOIN queries are syntactically correct
- GROUP BY + HAVING usage is correct throughout
- Double NOT EXISTS pattern for relational division is correct in all 5 occurrences
- Set operations (UNION, INTERSECT, EXCEPT) are correctly described
- Execution order (FROM -> WHERE -> GROUP BY -> HAVING -> SELECT -> DISTINCT -> ORDER BY -> LIMIT) is correct
- WHERE vs HAVING distinction is accurately explained
- NULL handling warnings (IS NULL vs = NULL, NOT IN with NULL) are correct

### Normalization Theory
- Armstrong's axioms (reflexivity, augmentation, transitivity) are correctly stated
- Derived rules (union, decomposition, pseudo-transitivity) are correct
- Closure algorithm (X+) is correctly formulated and demonstrated
- Candidate key finding method (never-right-side attributes) is correct
- Minimal cover algorithm (decompose -> reduce -> eliminate) in correct order
- Normal form definitions (1NF through BCNF) are accurate
- 3NF synthesis (Bernstein) algorithm is correctly described
- BCNF decomposition algorithm is correct
- The distinction "3NF preserves FDs, BCNF may not" is correctly noted
- All worked examples in guide/05_normalization.md compute correctly

### Transaction & Concurrency
- ACID properties correctly defined
- Dirty read, non-repeatable read, phantom read descriptions are accurate
- Isolation level table matches SQL standard exactly
- 2PL protocol (growing/shrinking phases) correctly described
- Lock compatibility matrix (S/X) is correct
- WAL (Write-Ahead Logging) principle correctly explained
- ARIES simplified to Analysis/Redo/Undo -- correct
- ACID vs BASE comparison is accurate

### Relational Algebra
- All operations (selection, projection, cartesian product, join, union, difference, intersection, division) are correctly defined
- Notation is consistent and standard
- SQL equivalences are correct
- Optimization properties (commutativity, cascade, push-down) are accurate

### NoSQL
- CAP theorem correctly stated (choose 2 of 3 during partition)
- System classifications (CP: MongoDB/Neo4j, AP: Cassandra, CA: PostgreSQL) match standard references
- Cassandra CQL syntax is valid throughout (CREATE KEYSPACE, CREATE TABLE, partition/clustering key syntax)
- Cassandra design rules (model by query, denormalize, no JOIN, partition key in WHERE) are correct
- MongoDB find() and aggregate() syntax is valid throughout
- MongoDB operators ($gt, $lt, $eq, $in, $exists, $regex, $elemMatch, etc.) are correct
- MongoDB aggregation stages ($match, $group, $sort, $project, $unwind, $limit) are correctly mapped to SQL equivalents
- Neo4j Cypher CREATE/MATCH/RETURN syntax is correct (excluding the comment issue fixed above)
- Neo4j shortestPath() usage is correct

### XML/XQuery
- DTD syntax (ELEMENT, ATTLIST, ID/IDREF, cardinality symbols +, *, ?) is correct
- XPath expressions are all valid and correctly mapped to expected results
- XQuery FLWOR syntax is correct (for/let/where/order by/return)
- Use of text() and { } for expression evaluation is correctly noted

### Index & Performance
- B-tree characteristics (O(log n), supports equality + range + sort) are correct
- Hash index characteristics (O(1) average, equality only) are correct
- Left-prefix rule for composite indexes correctly stated
- Performance data in tp-query-evaluation.md matches source SQL files exactly
- Index names (demoIDX, IamSpeeed) match the source
- Query timing values match the source SQL file comments

### OLAP
- Star schema concepts (fact table, dimensions, measures, hierarchies) are correct
- ROLLUP vs CUBE comparison table is accurate (ROLLUP = n+1 levels, CUBE = 2^n levels)
- GROUPING() function explained correctly
- OLAP operations (roll-up, drill-down, slice, dice, pivot) correctly defined
- OLTP vs OLAP comparison is accurate

### Exam Preparation
- Cheat sheet formulas and algorithms match the guide content
- Annales analysis structure is reasonable (cannot verify exact percentages without PDF access)
- Error frequency table aligns with common student mistakes in database courses

---

## Cross-Reference Verification

### TP1 (Query Evaluation) vs Source SQL Files
| Item | Source | Generated | Match |
|------|--------|-----------|-------|
| Schema (etudiant, professeur, etc.) | 02_create_tables.sql | tp-query-evaluation.md | Exact |
| Basic queries 5(a), 5(b), 5(c) | 01_basic_queries.sql | tp-query-evaluation.md | Exact |
| Index name | 03_index_analysis.sql: demoIDX | tp-query-evaluation.md: demoIDX | Exact |
| Timing data (no index) | 03_index_analysis.sql comments | tp-query-evaluation.md | Exact |
| Timing data (with index) | 03_index_analysis.sql comments | tp-query-evaluation.md | Exact |
| 4 query approaches | 04_query_optimization.sql | tp-query-evaluation.md | Exact |
| Composite index name | 04_query_optimization.sql: IamSpeeed | tp-query-evaluation.md: IamSpeeed | Exact |
| Index timing improvements | 04_query_optimization.sql comments | tp-query-evaluation.md | Exact |

### Guide Chapter Consistency
- Normalization rules in guide/05 match exercises in td3-4-normalization.md
- SQL patterns in guide/02 and guide/03 match exercises in td1 and td2
- NoSQL content in guide/07 is consistent with td7, tp-cassandra, tp-neo4j, tp-mongodb
- OLAP content in guide (referenced in td6) is consistent with td6-olap.md
- Cheat sheet content matches all 8 guide chapters

---

## Final Assessment

The study guide is **factually accurate** with minor issues now corrected. The 5 fixes were:
1. 1 invalid DTD (duplicate element name)
2. 1 incorrect normalization analysis (contradictory conclusions)
3. 2 wrong comment syntax in Cypher blocks (-- instead of //)
4. 1 missing SQL alias for derived table
5. 1 directed vs undirected graph traversal mismatch

All SQL queries, normalization algorithms, Armstrong's axioms, relational algebra notation, transaction isolation levels, NoSQL syntax (Cassandra CQL, Neo4j Cypher, MongoDB queries), and index descriptions are verified correct.
