-- TP: Evaluation de Requetes
-- Section 7.2.3: Understanding Query Execution Time and Optimization
-- Database: facture (invoice) and customer tables with 1M+ rows each

-- Table Schema:
-- CREATE TABLE facture (factureId INTEGER, customerId TEXT, amount REAL);
-- CREATE TABLE customer (customerId TEXT, name TEXT);
--
-- Business Context:
-- - A company stores invoices (factures) and customer information
-- - Each customer may have multiple invoices
-- - We want to find customers who have at least one invoice > 999 euros

-- ========================================
-- QUERY COMPARISON: Find customers with invoices > 999 euros
-- ========================================

-- Q7: Four different SQL approaches to the same problem
-- Predicted execution time order: Query 2 > Query 1 > Query 4 > Query 3

-- Query 1: JOIN with WHERE clause
-- Execution time: ~200 seconds
-- Strategy: Join all rows, then filter by amount
-- Complexity: O(n*m) where n=customers, m=invoices
SELECT c.name
FROM customer c, facture f
WHERE f.customerId=c.customerId AND f.amount>999;

-- Query 2: Subquery with IN operator
-- Execution time: ~0.996 seconds (FASTEST!)
-- Strategy: First find qualifying customerIds in facture, then filter customers
-- Complexity: O(n+m) - two sequential scans
-- Why fast: Subquery executes once, returns set of IDs for efficient lookup
SELECT name
FROM customer
WHERE customerId IN (
    SELECT f.customerId
    FROM facture f
    WHERE amount>999
);

-- Query 3: NATURAL JOIN with WHERE clause
-- Execution time: ~283 seconds (SLOWEST!)
-- Strategy: Implicit join on matching column names, then filter
-- Complexity: O(n*m) with additional overhead for natural join resolution
-- Why slow: Natural join must examine all column names + full cartesian filtering
SELECT name
FROM (customer NATURAL JOIN facture)
WHERE amount>999;

-- Query 4: Subquery with IN and explicit join
-- Execution time: ~219 seconds
-- Strategy: Filter customers by subquery, then join with facture
-- Complexity: O(n*m) - still requires full join after subquery
-- Why slower than Query 2: Join operation after IN clause adds overhead
SELECT name
FROM customer
WHERE customerId IN (
    SELECT c.customerId
    FROM customer c, facture f
    WHERE c.customerId=f.customerId AND f.amount>999
);

-- ========================================
-- Q8: Automatic Index Analysis
-- ========================================

-- Enable automatic index statistics
PRAGMA automatic_index = 0;

-- Measure execution times with automatic indexing disabled
-- Results show true query performance without SQLite's optimization help

-- ========================================
-- Q9: EXPLAIN QUERY PLAN Analysis
-- ========================================

-- Query 1 Plan: Scan both tables (2-dimensional search)
EXPLAIN QUERY PLAN
SELECT c.name FROM customer c, facture f
WHERE f.customerId=c.customerId AND f.amount>999;
-- Output: SCAN facture, SCAN customer (nested loop join)

-- Query 2 Plan: Scan facture for subquery, then scan customer (linear)
EXPLAIN QUERY PLAN
SELECT name FROM customer
WHERE customerId IN (SELECT f.customerId FROM facture f WHERE amount>999);
-- Output: SCAN facture (subquery), SCAN customer with IN lookup

-- Query 3 Plan: Scan both tables for natural join (2-dimensional)
EXPLAIN QUERY PLAN
SELECT name FROM (customer NATURAL JOIN facture) WHERE amount>999;
-- Output: SCAN facture, SCAN customer (implicit join)

-- Query 4 Plan: Subquery with 2D join, then scan customer (2-dimensional)
EXPLAIN QUERY PLAN
SELECT name FROM customer
WHERE customerId IN (
    SELECT c.customerId FROM customer c, facture f
    WHERE c.customerId=f.customerId AND f.amount>999
);
-- Output: SCAN facture and customer in subquery, then SCAN customer again

-- ========================================
-- Q10: Index Optimization
-- ========================================

-- Create composite index on facture(customerId, amount)
-- This index supports both JOIN operations and WHERE filtering
CREATE INDEX IamSpeeed ON facture(customerId, amount);

-- Re-measure execution times with index:
-- Query 1: 200s -> 3s      (67x faster)
-- Query 2: 0.996s -> 787ms (1.3x faster, already optimal)
-- Query 3: 283s -> 4.5s    (63x faster)
-- Query 4: 219s -> 5.3s    (41x faster)

-- Key Takeaways:
-- 1. Query structure matters: Subquery with IN (Query 2) is inherently more efficient
-- 2. Indexes dramatically improve JOIN performance but can't fix poor query structure
-- 3. NATURAL JOIN has overhead from column name resolution - use explicit JOINs
-- 4. EXPLAIN QUERY PLAN helps identify full table scans vs. index usage
-- 5. Composite indexes can optimize multiple conditions simultaneously
