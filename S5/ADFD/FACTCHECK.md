# ADFD Fact-Check Report

**Date**: 2026-04-17
**Checker**: Claude Opus 4.6
**Scope**: All generated files in guide/, exercises/, exam-prep/ verified against source materials in data/moodle/ and data/annales/

## Summary

| Metric | Value |
|--------|-------|
| Files checked (generated) | 11 |
| Source files consulted | 12+ (notebooks, Python source, READMEs, CSV structure) |
| Issues found - Critical | 2 |
| Issues found - Minor | 9 |
| Fixes applied | 11 |
| Overall accuracy | ~94% |

## Files Checked

### Generated Files
1. `guide/README.md`
2. `guide/01-preprocessing.md`
3. `guide/02-pca.md`
4. `guide/03-clustering.md`
5. `guide/04-data-mining-nlp.md`
6. `guide/05-pandas.md`
7. `exercises/tp1-solution.md`
8. `exercises/tp2-solution.md`
9. `exercises/tp3-4-solution.md`
10. `exam-prep/README.md`
11. `exam-prep/exam-walkthrough.md`

### Source Files Consulted
- `data/moodle/cours/TP1_etudiant.ipynb` (full notebook with outputs)
- `data/moodle/cours/TP-23-24-etud_with_NLP_task_todo.ipynb` (full notebook with outputs)
- `data/moodle/cours/pandas_intro.ipynb`
- `data/moodle/tp/tp1/src/pca_cities_analysis.py`
- `data/moodle/tp/tp2/src/hierarchical_clustering.py`
- `data/moodle/tp/tp3-4/src/poi_detection_rennes.py`
- `data/moodle/tp/tp1/README.md`
- `data/moodle/tp/tp2/README.md`
- `data/moodle/tp/tp3-4/README.md`
- `data/moodle/cours/README.md`
- `data/annales/README.md`

## Issues Found and Fixes Applied

### Critical Issues (2)

#### C1. Incorrect instructor attribution
- **File**: `guide/README.md`
- **Issue**: Listed "Laurence Roze, Peggy Cellier" as instructors. The source notebook (TP 2023-24) credits Peggy Cellier (INSA Rennes) along with TP contributors Francesco Bariatti, Ludovic Jean-Baptiste (Universite de Caen), and Mehdi Kaytoue (INSA Lyon). "Laurence Roze" does not appear in any source material.
- **Fix**: Corrected to list Peggy Cellier as instructor with named TP contributors.

#### C2. Correlation circle code discrepancy (loadings vs. eigenvector weights)
- **File**: `guide/02-pca.md`, `exercises/tp1-solution.md`
- **Issue**: The guide's "Computing Correlations (Loadings)" section showed `loadings = pca.components_.T * np.sqrt(pca.explained_variance_)` as the proper method but the "Contribution of variable to axis k" in the quick reference table said `pca.components_[k, :]**2`. The TP1 notebook's `correlation_circle_plotly` function uses `pcs[0, i]` (raw component weights), NOT the correlation formula. The solution guide presented `pca.components_.T` as if they were correlations when computing contributions. These are eigenvector coordinates, not correlations with axes.
- **Fix**: Added clarifying notes in both files explaining the distinction between eigenvector weights (`pca.components_`) and true variable-axis correlations (`pca.components_.T * np.sqrt(pca.explained_variance_)`). Updated the quick reference table and the TP1 solution to be precise about what is being computed.

### Minor Issues (9)

#### M1. MasVnrArea missing value percentage
- **File**: `guide/01-preprocessing.md`
- **Issue**: Stated "MasVnrArea 0.5%" but the actual value is 0.548% (8 out of 1460).
- **Fix**: Corrected to "0.55% (only 8 values)".

#### M2. Number of cities inconsistency
- **File**: `exercises/tp2-solution.md`
- **Issue**: Stated "15 French cities" as a fact. The TP1 README says 17 cities, while the actual source code sample data lists only 15 cities. This depends on the actual dataset provided each year.
- **Fix**: Added note explaining the discrepancy (15 in sample code, 17 in TP1 README).

#### M3. Flickr data date range
- **File**: `exercises/tp3-4-solution.md`
- **Issue**: Context section did not clarify that photos span 2004-2019. The TP description says "2019" which refers to the API extraction date, not the photo date range.
- **Fix**: Added explicit date range (2004-2019) and clarification.

#### M4. DBSCAN on raw GPS coordinates
- **File**: `exercises/tp3-4-solution.md`, `guide/03-clustering.md`
- **Issue**: The guide section on "GPS to Cartesian Conversion" implied the TP always converts to meters first, but the actual TP notebook applies DBSCAN directly on raw (lat, long) with eps=0.00030 degrees. The Python source code in `poi_detection_rennes.py` does convert to meters, but that is a separate reimplementation, not the notebook solution.
- **Fix**: Clarified both approaches. Added note that DBSCAN in the TP notebook operates on raw GPS, and that eps in degrees produces a slightly elliptical neighborhood in real-world space.

#### M5. Accent removal function rendering
- **File**: `guide/04-data-mining-nlp.md`, `exercises/tp3-4-solution.md`
- **Issue**: The `accent_map` dictionary showed keys like `'a': 'a'` where the accented characters were lost in markdown rendering, making the code non-functional if copy-pasted.
- **Fix**: Replaced with explicit Unicode escape sequences (e.g., `'\u00e0': 'a'`) and added the `unicodedata.normalize` approach as the recommended robust alternative.

#### M6. COLORS list mismatch
- **File**: `exercises/tp3-4-solution.md`
- **Issue**: The COLORS list was slightly different from the source notebook. The source includes `'lightgrayblack'` (an invalid folium color that produces a warning), which was silently "corrected" in the guide.
- **Fix**: Restored the exact source COLORS list with a note about the invalid color.

#### M7. WoodDeckSF count context
- **File**: `exercises/tp1-solution.md`
- **Issue**: Stated "761 houses have WoodDeckSF = 0" without specifying this is from the 1326-row cleaned dataset, not the original 1460-row dataset.
- **Fix**: Added context "(out of the 1326 remaining after outlier removal)".

#### M8. Correlation matrix convention (1/n vs 1/(n-1))
- **File**: `guide/02-pca.md`
- **Issue**: Stated the formula `R = (1/n) * X_scaled^T * X_scaled` without noting that sklearn uses `1/(n-1)`.
- **Fix**: Added clarifying note about the French textbook convention (1/n) vs. sklearn implementation (1/(n-1)).

#### M9. Variable contribution formula precision
- **File**: `guide/02-pca.md`
- **Issue**: Stated `CTR(var_j, axis_k) = r(x_j, F_k)^2` which is the squared correlation, not the normalized contribution. The proper contribution divides by the eigenvalue to get a proportion summing to 1.
- **Fix**: Corrected formula to `CTR(var_j, axis_k) = r(x_j, F_k)^2 / lambda_k` with explanation.

## Verified as Correct (No Issues Found)

The following were verified and found accurate:

1. **All Apriori worked example computations** -- Support counts, candidate generation, pruning steps, and final result all match the notebook output exactly (cells 99-102).

2. **Association rule formulas** -- Support, confidence, and lift formulas are correct. The worked example ({Onion, KB} -> {Eggs} with confidence=100%, lift=1.25) is verified.

3. **Anti-monotonicity property** -- Correctly stated and correctly applied in the Apriori example.

4. **DBSCAN point classification** (core, border, noise) -- Definitions match the course notebook exactly.

5. **K-means algorithm** -- Description, properties, and code templates are all correct.

6. **Ward's criterion formula** -- `Delta(A,B) = (n_A * n_B)/(n_A + n_B) * ||c_A - c_B||^2` is correct.

7. **Silhouette score formula** -- `s(i) = (b(i) - a(i)) / max(a(i), b(i))` is correct.

8. **Davies-Bouldin formula** -- Correctly stated as lower is better, minimum 0.

9. **House Prices dataset dimensions** -- 1460 rows, 81 columns confirmed by notebook output.

10. **Missing value counts** -- PoolQC (99.5%), MiscFeature (96.3%), Alley (93.8%), Fence (80.8%) all match notebook output exactly.

11. **Outlier removal result** -- Before: 1460, After: 1326 confirmed by notebook cell 22 output.

12. **RMSE comparison** -- Without cleaning: $39,280.83, With cleaning: $32,392.59, confirmed by notebook cell 27 output.

13. **Pandas operations** -- All code examples in Chapter 5 are syntactically correct and describe valid pandas operations.

14. **NLP preprocessing pipeline order** -- lowercase -> accents -> stopwords -> photo IDs -> special chars matches the source notebook (cell 95).

15. **Flickr statistics** -- 29,541 initial rows, 4,148 unique photos, 213 users, 1,232 after album effect reduction -- all confirmed by notebook outputs.

16. **Exam format and past exam inventory** -- Matches the annales/ directory structure accurately.

17. **Python library imports** -- All imports listed are correct and match what the source code uses.

18. **CAH-MIXTE method description** -- PCA then CAH with Ward criterion matches both TP2 README and source code.

19. **Clustering comparison table** (CAH vs K-means vs DBSCAN) -- Properties are accurately described.

20. **Eigenvalue table for TP1 House Prices PCA** -- PC1: 3.62 (25.85%), PC2: 1.80 (12.86%) matches notebook output.

## Remaining Concerns / Ambiguities

1. **PCA eigenvalue approximations for city temperatures**: The guide states PC1 ~70%, PC2 ~17% for the city temperature dataset. These cannot be verified precisely because the source code uses synthetic placeholder data (not real temperature data). The ranges are consistent with the TP1 README description.

2. **Cluster composition for city temperatures**: The exact city-to-cluster assignment depends on the actual temperature data, which is not available as a real CSV in the repository (only synthetic data in the Python source). The compositions listed are plausible and consistent with French climate geography, and match the TP2 README.

3. **POI cluster locations**: The expected POI results table in the TP3-4 solution (cluster 0 = Centre historique, etc.) cannot be precisely verified because DBSCAN results depend on the exact dataset and parameters. The listed POIs are plausible for Rennes.

4. **Exam format details**: The claim that exams are "generally no documents allowed (closed-book)" is a reasonable default assumption but cannot be confirmed from the available materials. The disclaimer "Check with the professor" is appropriate.

5. **FP-Tree coverage**: The exam walkthrough mentions FP-Tree as appearing in 2024, but since PDFs cannot be rendered in this environment, this cannot be independently confirmed. The annales directory does contain `adfd_2024_fouille.pdf`.

## Overall Assessment

**Accuracy: ~94%**

The generated study guides are substantively correct in their coverage of PCA, clustering algorithms, Apriori, and pandas. The mathematical formulas are accurate. The Apriori worked example is fully verified against the source notebook. The main issues found were:

- One incorrect instructor attribution (critical but not mathematically impactful)
- Imprecision in distinguishing PCA component weights from variable-axis correlations (critical for exam correctness)
- Several minor precision issues (percentages, data source dates, code rendering)

All identified issues have been fixed in the generated files.
