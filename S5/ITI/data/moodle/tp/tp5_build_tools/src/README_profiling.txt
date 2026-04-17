Profiling Workflow with Gprof
==============================

Step 1: Compile with Profiling
------------------------------
gcc -pg -o principal principal.c tableau.c

Step 2: Run Program
------------------
./principal

This generates 'gmon.out' containing profiling data.

Step 3: Analyze Profile
-----------------------
gprof principal gmon.out > analysis.txt
less analysis.txt

Reading Flat Profile:
--------------------
  %   cumulative   self              self     total
 time   seconds   seconds    calls  s/call   s/call  name
 44.5      0.44     0.44 1394467004   0.00     0.00  getValeur

% time         - Percentage of total execution time
cumulative     - Total time up to and including this function
self seconds   - Time spent in this function only
calls          - Number of times function was called
self s/call    - Time per call (this function only)
total s/call   - Time per call (including callees)
name           - Function name

Reading Call Graph:
------------------
[4]  58.5   10.85   3.43 1394467004           getValeur [4]
                    3.43 1394467004/1394625405     lireValeur [3]

Shows which functions call which, and time spent in each.

Optimization Strategy:
---------------------
1. Find functions with highest % time
2. Determine if optimization is worthwhile:
   - High self seconds = CPU-intensive function
   - High calls = frequently called function
3. Optimize algorithmic complexity first
4. Use compiler optimizations (-O2, -O3)
5. Re-profile to verify improvement

Comparing Optimization Levels:
-----------------------------
# Non-optimized
gcc -pg -O0 -o principal_O0 principal.c tableau.c
./principal_O0
gprof principal_O0 gmon.out > profile_O0.txt

# Optimized
gcc -pg -O3 -o principal_O3 principal.c tableau.c
./principal_O3
gprof principal_O3 gmon.out > profile_O3.txt

# Compare results
diff profile_O0.txt profile_O3.txt

Expected Observations:
---------------------
- getValeur and lireValeur are hotspots (most time spent)
- inverseValeurs has high total time but low self time
  (time is in callees, not the function itself)
- Optimization -O3 should reduce execution time significantly

Common Issues:
-------------
- "No profile data" - Forgot -pg flag or program didn't run
- "gmon.out not found" - Program didn't finish normally
- Profiling adds overhead - Don't profile profiled builds
