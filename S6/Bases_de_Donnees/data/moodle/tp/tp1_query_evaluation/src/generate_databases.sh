#!/bin/bash
# Generate test databases for TP Query Evaluation
# Usage: ./generate_databases.sh [size]
# Default size: 1,000,000 rows

# Set default size
SIZE=${1:-1000000}

echo "======================================"
echo "Database Generator for TP Query Evaluation"
echo "======================================"
echo "Generating databases with $SIZE rows..."
echo ""

# Compile Java files
echo "[1/5] Compiling Java generators..."
javac DBgenerator.java DBgenerator1.java

if [ $? -ne 0 ]; then
    echo "ERROR: Compilation failed!"
    exit 1
fi

echo "      Compilation successful!"
echo ""

# Set CLASSPATH
export CLASSPATH=.:$CLASSPATH

# Generate database.sql (demo table)
echo "[2/5] Generating database.sql (demo table)..."
java DBgenerator $SIZE

if [ $? -ne 0 ]; then
    echo "ERROR: DBgenerator failed!"
    exit 1
fi

echo "      Generated database.sql with $SIZE rows"
echo ""

# Generate database1.sql (facture/customer tables)
echo "[3/5] Generating database1.sql (facture/customer tables)..."
java DBgenerator1 $SIZE

if [ $? -ne 0 ]; then
    echo "ERROR: DBgenerator1 failed!"
    exit 1
fi

echo "      Generated database1.sql with $SIZE customer-invoice pairs"
echo ""

# Create SQLite databases
echo "[4/5] Creating SQLite database files..."

# Remove old databases if they exist
rm -f test_demo.db test_facture.db

# Create databases from SQL files
echo "      Creating test_demo.db..."
sqlite3 test_demo.db < database.sql

echo "      Creating test_facture.db..."
sqlite3 test_facture.db < database1.sql

echo "      Database files created successfully!"
echo ""

# Verify database creation
echo "[5/5] Verifying databases..."

echo "      test_demo.db:"
sqlite3 test_demo.db "SELECT COUNT(*) as row_count FROM demo;"

echo "      test_facture.db:"
sqlite3 test_facture.db "SELECT COUNT(*) as facture_count FROM facture;"
sqlite3 test_facture.db "SELECT COUNT(*) as customer_count FROM customer;"

echo ""
echo "======================================"
echo "SUCCESS! Databases generated."
echo "======================================"
echo ""
echo "Generated files:"
echo "  - database.sql (SQL script, demo table)"
echo "  - database1.sql (SQL script, facture/customer tables)"
echo "  - test_demo.db (SQLite database)"
echo "  - test_facture.db (SQLite database)"
echo ""
echo "To run queries with timing:"
echo "  sqlite3 test_demo.db"
echo "  .timer ON"
echo "  SELECT * FROM demo WHERE code=12345;"
echo ""
