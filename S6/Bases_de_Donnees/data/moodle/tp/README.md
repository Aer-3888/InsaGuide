# Travaux Pratiques - Bases de Donnees

**Course**: Bases de Donnees (Databases)  
**Institution**: INSA Rennes, 3rd year Computer Science  
**Academic Year**: 2017-2018

## Overview

This directory contains completed lab exercises (TP) for the Databases course. The course covers fundamental database concepts including relational algebra, SQL, normalization theory, transactions, and database design.

## Course Topics

- **Relational Algebra**: Selection, projection, joins, set operations
- **SQL**: DDL, DML, queries, subqueries, aggregations, views
- **Normalization**: Functional dependencies (DF), normal forms (1NF, 2NF, 3NF, BCNF)
- **Transactions**: ACID properties, concurrency control, isolation levels
- **Entity-Relationship Modeling**: ER diagrams, cardinalities, weak entities
- **Query Optimization**: Indexes, execution plans, performance tuning

## Lab Index

| TP | Directory | Topic |
|----|-----------|-------|
| TP1 | [tp1_query_evaluation](tp1_query_evaluation/) | SQL query performance, indexing, optimization |
| TP2 | [tp2_cassandra](tp2_cassandra/) | Apache Cassandra NoSQL database |
| TP3 | [tp3_neo4j](tp3_neo4j/) | Neo4j graph database |
| TP4 | [tp4_mongodb](tp4_mongodb/) | MongoDB document database |

## Lab Details

### TP1: Evaluation de Requetes (Query Evaluation)
**Directory**: `tp1_query_evaluation/`

**Focus**: SQL query performance analysis, indexing strategies, and query optimization

**Key Topics**:
- SQLite command-line interface and operations
- Measuring query execution time with `.timer ON`
- Creating and analyzing B+ tree indexes
- Understanding query execution plans with `EXPLAIN QUERY PLAN`
- Comparing different SQL query structures (JOINs vs subqueries)
- Composite indexes and optimization strategies

**Performance Highlights**:
- Index impact: 800-15000x speedup on 1M row table
- Query structure: Subquery with IN is 200x faster than JOIN for certain problems
- Execution plan analysis: SCAN (O(n)) vs SEARCH (O(log n))

**Technologies**: SQLite, Java (database generators)

**See**: [tp1_query_evaluation/README.md](tp1_query_evaluation/README.md) for detailed walkthrough

### TP2: Apache Cassandra
**Directory**: `tp2_cassandra/`

**Focus**: Cassandra NoSQL database, data modeling, CQL queries

**Subject**: `sujet.pdf`

### TP3: Neo4j Graph Database
**Directory**: `tp3_neo4j/`

**Focus**: Graph databases, Cypher query language, graph traversal

**Subject**: `sujet.pdf`

### TP4: MongoDB
**Directory**: `tp4_mongodb/`

**Focus**: Document databases, MongoDB queries, aggregation framework

**Subject**: `sujet.pdf`

## Repository Structure

```
tp/
├── README.md                           # This file - overview of all TPs
├── tp1_query_evaluation/               # SQL query optimization lab
│   ├── README.md                      # Detailed walkthrough and analysis
│   └── src/                           # Cleaned, commented source code
├── tp2_cassandra/                      # Cassandra NoSQL lab
│   └── sujet.pdf                      # Exercise instructions
├── tp3_neo4j/                          # Neo4j graph database lab
│   └── sujet.pdf                      # Exercise instructions
└── tp4_mongodb/                        # MongoDB document database lab
    └── sujet.pdf                      # Exercise instructions
```

## Key Concepts Demonstrated

### 1. Indexing Fundamentals
- **Without Index**: Full table scan - O(n) complexity
- **With Index**: B+ tree search - O(log n) complexity
- **Performance**: 800-15000x improvement on large datasets

### 2. Query Optimization Strategies
- Subqueries can be faster than JOINs when filtering significantly reduces result set
- Execution complexity: O(n+m) vs O(n*m)
- NATURAL JOIN has overhead - prefer explicit JOINs

### 3. Analysis Tools
- `EXPLAIN QUERY PLAN` reveals execution strategy
- `.timer ON` measures actual query performance
- Query plans show SCAN vs SEARCH with index usage

### 4. Database Design
- Proper schema design with foreign keys
- Junction tables for many-to-many relationships
- Composite indexes for multi-column queries

## SQLite Quick Reference

### Essential Commands
```bash
sqlite3 database.db                 # Open database
.timer ON                           # Enable timing
.read file.sql                      # Execute SQL file
.schema table                       # Show table structure
.tables                             # List tables
.indexes                            # List indexes
EXPLAIN QUERY PLAN SELECT ...;      # Show execution plan
```

### Performance Commands
```sql
PRAGMA page_size;                   -- Check page size
CREATE INDEX idx ON table(column);  -- Create index
PRAGMA automatic_index = 0;         -- Disable auto-indexing
BEGIN TRANSACTION;                  -- Start transaction
COMMIT;                             -- Commit transaction
```

## Learning Outcomes

After completing these labs, you will be able to:

1. Design relational database schemas with proper normalization
2. Write complex SQL queries with joins, subqueries, and aggregations
3. Analyze query performance using execution plans
4. Create appropriate indexes to optimize query performance
5. Compare different SQL approaches and choose the most efficient one
6. Generate large test datasets for performance benchmarking
7. Understand the trade-offs between different query structures

## Performance Best Practices

1. **Always create indexes on**:
   - JOIN columns
   - WHERE clause columns
   - ORDER BY columns

2. **Use transactions for bulk operations**:
   ```sql
   BEGIN TRANSACTION;
   -- Multiple INSERT/UPDATE/DELETE statements
   COMMIT;
   ```

3. **Prefer filtering before joining**:
   - Use subqueries to reduce dataset size
   - Filter early to minimize join complexity

4. **Analyze execution plans**:
   - Look for "SEARCH" instead of "SCAN"
   - Verify index usage with "USING INDEX"

5. **Avoid**:
   - NATURAL JOIN (has overhead)
   - SELECT * (retrieve only needed columns)
   - Nested loops without indexes

## Testing and Verification

All SQL scripts have been tested with SQLite and include:
- Detailed comments explaining each query
- Expected results and performance metrics
- Execution plan analysis
- Optimization recommendations

Java generators have been verified to:
- Generate valid SQL syntax
- Create databases of configurable size
- Use transactions for performance
- Produce realistic test data

## Additional Resources

### Course Materials
- `../cours/` - Lecture slides (PDF)
- `../td/` - Tutorial exercises with solutions
- `../annales/` - Past exam questions

### External Documentation
- [SQLite Documentation](https://www.sqlite.org/docs.html)
- [SQLite Query Planner](https://www.sqlite.org/queryplanner.html)
- [Database Normalization](https://en.wikipedia.org/wiki/Database_normalization)
- [SQL Performance Tuning](https://use-the-index-luke.com/)

## Running the Labs

### Quick Start
```bash
cd tp1_query_evaluation/src/

# Generate test databases (1 million rows)
./generate_databases.sh 1000000

# Run queries with timing
sqlite3 test_demo.db
> .timer ON
> .read 03_index_analysis.sql
```

### Custom Database Size
```bash
# Generate smaller database for quick testing
java DBgenerator 10000

# Generate large database for realistic benchmarking
java DBgenerator 10000000
```

## Notes

- Original files preserved in `_originals/` directory
- All SQL scripts include detailed comments in English
- Performance metrics based on typical modern hardware (varies by system)
- Java generators require JDK 8 or higher
- SQLite version 3.x recommended

## Academic Integrity

These solutions are provided for learning purposes. The exercises have been completed and documented to demonstrate understanding of database concepts. Use them as reference material to:
- Understand SQL query optimization techniques
- Learn indexing strategies
- Study query execution plans
- Practice performance analysis

Always attempt exercises independently before consulting solutions.

## Contact

For questions about these materials, consult:
- Course instructors (see `../cours/` for contact information)
- INSA Rennes CS department
- Original lab materials (if available)
