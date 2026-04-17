-- TP: Evaluation de Requetes
-- Section 7.2.2: Index Analysis
-- Demonstrates the impact of indexing on query performance

-- Q1: Query with existing code (EXISTS in database)
-- Measures execution time when searching for an existing value
-- Without index: Full table scan required
-- Result: ~0.1-0.2 seconds for 1M rows
SELECT *
FROM demo
WHERE code=62518937;  -- This code exists in the database

-- Q2: Query with non-existing code (NOT EXISTS in database)
-- Measures execution time when searching for a non-existing value
-- Without index: Full table scan required, but may terminate early with optimizations
-- Result: ~0.05-0.08 seconds
SELECT *
FROM demo
WHERE code=99999999;  -- This code does not exist

-- Q3: Query with non-existing code and impossible condition
-- The empty result set doesn't prevent full table scan without index
-- Result: ~5-7 seconds (slower due to more complex WHERE clause)
SELECT *
FROM demo
WHERE code>999999999;  -- No codes exist above this value

-- Q4: Analyze query execution plan before creating index
-- EXPLAIN QUERY PLAN shows how SQLite will execute the query
EXPLAIN QUERY PLAN SELECT * FROM demo WHERE code=62518937;
-- Result: "SCAN TABLE demo" (full table scan - inefficient)

EXPLAIN QUERY PLAN SELECT * FROM demo WHERE code=99999999;
-- Result: "SCAN TABLE demo" (full table scan)

EXPLAIN QUERY PLAN SELECT * FROM demo WHERE code>999999999;
-- Result: "SCAN TABLE demo" (full table scan)

-- Q5: Create index on the 'code' column
-- B+ tree index dramatically improves search performance
CREATE INDEX demoIDX ON demo(code);

-- Q6: Re-measure execution times with index
SELECT * FROM demo WHERE code=62518937;
-- Result: ~0.0001 seconds (1000x faster!)

SELECT * FROM demo WHERE code=99999999;
-- Result: ~0.0001 seconds (800x faster!)

SELECT * FROM demo WHERE code>999999999;
-- Result: ~0.0004 seconds (15000x faster!)

-- Analyze query execution plan after creating index
EXPLAIN QUERY PLAN SELECT * FROM demo WHERE code=62518937;
-- Result: "SEARCH TABLE demo USING COVERING INDEX demoIDX (code=?)"

EXPLAIN QUERY PLAN SELECT * FROM demo WHERE code=99999999;
-- Result: "SEARCH TABLE demo USING COVERING INDEX demoIDX (code=?)"

EXPLAIN QUERY PLAN SELECT * FROM demo WHERE code>999999999;
-- Result: "SEARCH TABLE demo USING COVERING INDEX demoIDX (code>?)"

-- Key Observations:
-- 1. Index changes query plan from SCAN (O(n)) to SEARCH (O(log n))
-- 2. "COVERING INDEX" means all required data is in the index itself
-- 3. Equality searches (=) and range searches (>) both benefit from indexing
-- 4. Performance improvement: 800x to 15000x faster with index
