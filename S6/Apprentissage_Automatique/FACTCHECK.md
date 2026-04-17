# Fact-Check Report -- Apprentissage Automatique (Machine Learning)

**Date:** 2026-04-17
**Files checked:** 17 generated files (9 guide chapters, 5 exercises, 2 exam-prep, 1 exercises README)
**Source materials:** Moodle course guides (6 chapters + cheat sheet), TP notebooks (TP1-TP4), Python source files (tp_nn.py, tp_nn_squelette.py, pedagogicTree.py), annales PDFs

---

## Summary

**Overall assessment: PASS -- all content is mathematically and factually sound, with minor issues corrected.**

The generated study guide is accurate, well-structured, and faithful to the INSA Rennes course materials. All major formulas, algorithm descriptions, and code examples were verified against source materials and standard ML references. Three issues were found and fixed directly.

---

## Issues Found and Fixed

### ISSUE 1 -- CNN Architecture Mismatch (FIXED)
- **Files:** `guide/06_neural_networks.md`, `exercises/tp4_neural_networks.md`
- **Problem:** The source file `tp_nn.py` contains a bug where Conv2D layers 2 and 3 connect to `entree` instead of `layer`, creating a non-sequential architecture. The source also has 3 Conv2D layers (32, 64, 128 filters). The generated guide simplified this to 2 Conv2D layers with a properly sequential architecture, but did not note the discrepancy.
- **Fix:** Added a note in both files explaining that the source code has this bug, and that the guide presents a corrected sequential version with 2 Conv2D layers.
- **Severity:** Low (pedagogically the guide version is better; students should be aware the original has a bug)

### ISSUE 2 -- Deprecated sklearn RMSE API (FIXED)
- **File:** `guide/02_linear_regression.md`
- **Problem:** Used `mean_squared_error(y_test, y_pred, squared=False)` for RMSE. The `squared` parameter was removed in recent sklearn versions.
- **Fix:** Replaced with `root_mean_squared_error(y_test, y_pred)` from `sklearn.metrics`.
- **Severity:** Medium (code would throw an error on current sklearn)

### ISSUE 3 -- CNN source vs guide layer count (FIXED)
- **File:** `exercises/tp4_neural_networks.md`
- **Problem:** Same as Issue 1, but specifically in the TP4 exercises file. The table showing layer dimensions was correct for the 2-layer version presented, but lacked explanation of why it differed from the source.
- **Fix:** Added explanatory note about the source bug.

---

## Verified Correct (No Issues)

### ML Formulas

| Formula | File | Status |
|---------|------|--------|
| Bias-variance decomposition: Error = Bias^2 + Variance + Noise | `guide/01` | CORRECT |
| Shannon entropy: H(S) = -sum(p_i * log2(p_i)) | `guide/04` | CORRECT |
| Information gain: Gain(S,A) = H(S) - sum(|Sv|/|S| * H(Sv)) | `guide/04` | CORRECT |
| Gini index: Gini(S) = 1 - sum(p_i^2) | `guide/04` | CORRECT |
| OLS solution: w* = (X^T X)^{-1} X^T y | `guide/02` | CORRECT |
| MSE gradient: -(1/n) X^T (y - Xw) | `guide/02` | CORRECT |
| Ridge solution: w* = (X^T X + alpha I)^{-1} X^T y | `guide/02` | CORRECT |
| Lasso/Ridge/ElasticNet penalty formulas | `guide/02` | CORRECT |
| Sigmoid: sigma(z) = 1/(1+e^{-z}) | `guide/03` | CORRECT |
| Sigmoid derivative: sigma'(z) = sigma(z)(1-sigma(z)) | `guide/03` | CORRECT |
| Log-loss (binary cross-entropy) | `guide/03` | CORRECT |
| Softmax formula | `guide/03` | CORRECT |
| SVM margin: 2/||w|| | `guide/05` | CORRECT |
| SVM optimization: min 1/2 ||w||^2 s.c. yi(w^T xi + b) >= 1 | `guide/05` | CORRECT |
| Soft margin SVM with slack variables | `guide/05` | CORRECT |
| Kernel formulas (linear, polynomial, RBF, sigmoid) | `guide/05` | CORRECT |
| Perceptron update rule: w = w + eta*(y-y_hat)*x | `guide/06` | CORRECT |
| R^2 = 1 - SS_res/SS_tot | `guide/02` | CORRECT |
| Standardization: z = (x - mu) / sigma | `guide/01, 09` | CORRECT |
| MinMax: (x - x_min) / (x_max - x_min) | `guide/09` | CORRECT |
| K-means inertia formula | `guide/07` | CORRECT |
| Silhouette score formula | `guide/07` | CORRECT |
| PCA covariance matrix: C = 1/(n-1) X_c^T X_c | `guide/07` | CORRECT |
| Accuracy, Precision, Recall, F1, Specificity | `guide/08` | CORRECT |
| ROC: TPR vs FPR | `guide/08` | CORRECT |

### AdaBoost Formulas

| Formula | Status | Notes |
|---------|--------|-------|
| alpha_t = (1/2) ln((1-epsilon)/epsilon) | CORRECT | Matches source `05_ensemble_boosting.md` |
| Weight update: w_i * exp(-alpha * y_i * h_t(x_i)) / Z_t | CORRECT | Matches source and TP3 implementation |
| Z_t = 2*sqrt(epsilon*(1-epsilon)) | CORRECT | Valid closed-form normalization constant for binary AdaBoost |
| Prediction: H(x) = sign(sum alpha_t * h_t(x)) | CORRECT | Matches source |

### Numerical Examples

| Example | File | Status |
|---------|------|--------|
| Entropy for 5/8 oui, 3/8 non = 0.954 | `guide/04` | CORRECT (verified: 0.9544) |
| Entropy 50/50 = 1.0 | `guide/04` | CORRECT |
| Entropy 75/25 = 0.811 | `guide/04` | CORRECT |
| Gain(devoirs) = 0.049 | `guide/04` | CORRECT (source says 0.05, both are correct at different precisions) |
| F1 example: P=71.4%, R=83.3% -> F1=76.9% | `exam-prep` | CORRECT (verified: 2*0.714*0.833/(0.714+0.833) = 0.7692) |
| AdaBoost iteration: epsilon=1/3, alpha=0.347 | `exam-prep` | CORRECT (ln(2)/2 = 0.3466) |
| Naive Bayes weather: P(no play) = 67.2% | `exercises/tp1` | CORRECT (matches TP1 notebook output: 0.672) |
| Naive Bayes exam: P(non) = 79.5% | `exam-prep` | CORRECT (verified calculation) |
| -p*log2(p) lookup table | `exam-prep` | CORRECT (all 15 values verified) |

### Algorithm Descriptions

| Algorithm | Status | Notes |
|-----------|--------|-------|
| ID3 tree construction (pseudo-code) | CORRECT | Matches source `02_arbres_decision.md` |
| C4.5 vs CART comparison table | CORRECT | |
| KNN algorithm | CORRECT | Matches source `04_knn.md` |
| Naive Bayes classification | CORRECT | Matches source `03_methodes_bayesiennes.md` |
| AdaBoost algorithm (detailed steps) | CORRECT | Matches source `05_ensemble_boosting.md` and TP3 implementation |
| Decision stump implementation | CORRECT | Matches source TP3 boosting materials |
| Cost Complexity Pruning (CCP) | CORRECT | Matches source and TP1 notebook |
| K-means algorithm | CORRECT | |
| Backpropagation (chain rule) | CORRECT | |
| Gradient descent variants (batch, SGD, mini-batch) | CORRECT | |

### Scikit-learn API

| API Element | Status | Notes |
|-------------|--------|-------|
| `train_test_split(X, y, test_size, stratify, random_state)` | CORRECT | |
| `cross_val_score(clf, X, y, cv, scoring)` | CORRECT | |
| `GridSearchCV(estimator, param_grid, cv, scoring, n_jobs)` | CORRECT | |
| `RandomizedSearchCV(pipe, param_dist, n_iter, cv)` | CORRECT | |
| `DecisionTreeClassifier(criterion, max_depth, ccp_alpha)` | CORRECT | |
| `cost_complexity_pruning_path(X_train, y_train)` | CORRECT | |
| `RandomForestClassifier(n_estimators, max_features)` | CORRECT | |
| `AdaBoostClassifier(estimator=..., n_estimators)` | CORRECT | Uses current `estimator` param (not deprecated `base_estimator`) |
| `KNeighborsClassifier(n_neighbors)` | CORRECT | |
| `LogisticRegression(C, penalty, solver, max_iter, multi_class)` | CORRECT | |
| `SVC(kernel, C, gamma)` | CORRECT | |
| `LinearSVC(C, max_iter)` | CORRECT | |
| `MLPClassifier(hidden_layer_sizes, activation, solver)` | CORRECT | |
| `StandardScaler().fit_transform / .transform` | CORRECT | |
| `OneHotEncoder(sparse_output=False)` | CORRECT | Uses current param name |
| `Pipeline([...])` | CORRECT | |
| `ColumnTransformer([...])` | CORRECT | |
| `CountVectorizer(binary, max_df, min_df)` | CORRECT | |
| `TfidfVectorizer(ngram_range, max_df, min_df)` | CORRECT | |
| `PCA(n_components)` | CORRECT | |
| `KMeans(n_clusters, n_init)` | CORRECT | |
| `silhouette_score(X, labels)` | CORRECT | |
| `confusion_matrix, classification_report` | CORRECT | |
| `roc_curve, roc_auc_score` | CORRECT | |
| `precision_recall_curve, average_precision_score` | CORRECT | |
| `f1_score(average='macro'/'weighted'/'micro')` | CORRECT | |
| `Ridge(alpha), Lasso(alpha), RidgeCV, LassoCV` | CORRECT | |
| `PolynomialFeatures(degree, include_bias)` | CORRECT | |
| `LinearRegression, SGDRegressor` | CORRECT | |
| `CategoricalNB, GaussianNB, MultinomialNB` | CORRECT | |
| `learning_curve(clf, X, y, cv, train_sizes)` | CORRECT | |
| `AgglomerativeClustering(n_clusters, linkage)` | CORRECT | |
| `TSNE(n_components, perplexity)` | CORRECT | |
| `joblib.dump / joblib.load` | CORRECT | |

### TP Solutions vs Source

| TP | Status | Notes |
|----|--------|-------|
| TP1 -- Iris, KNN, Heart, Weather NB | CORRECT | All answers match TP1_complete.ipynb. Q&A responses verified. CCP alpha ~0.02 confirmed. Train=86.3%, Val=80.2% matches notebook output. |
| TP2 -- No-Show Pipeline | CORRECT | Feature importance values, model accuracy results (~78-80%), and conclusions align with source materials. |
| TP3 -- AdaBoost Implementation | CORRECT | Decision stump class, Adaboost class, weight update logic all match source guide `05_ensemble_boosting.md`. |
| TP4 -- Neural Networks | CORRECT (with note) | Perceptron matches tp_nn.py. CNN corrected for source bug (see Issue 1). |

### Exam Patterns vs Annales

| Pattern | Status | Notes |
|---------|--------|-------|
| Frequency table (arbres, evaluation, NB, KNN by year) | PLAUSIBLE | Cannot fully verify all PDFs but consistent with visible exam filenames and course structure |
| Time allocation advice | REASONABLE | Standard for 2h exam format |
| Question types (5 types identified) | CORRECT | Aligns with visible exam structure from annales |
| Walkthrough calculations | CORRECT | All numerical examples verified |

---

## Content Not in Source (Generated Additions)

The following topics appear in the generated guide but are NOT part of the INSA course materials:

| Topic | File | Assessment |
|-------|------|-----------|
| Linear Regression (detailed) | `guide/02` | CORRECT content, but the course covers this only briefly via KNN regression. The detailed OLS/gradient descent treatment is supplementary. |
| Logistic Regression (detailed) | `guide/03` | CORRECT content, but the course focuses on Naive Bayes for classification, not logistic regression. This is supplementary. |
| SVM (detailed) | `guide/05` | CORRECT content, but SVMs are NOT a primary topic in the INSA course materials. This is supplementary. |
| Unsupervised learning (K-means, PCA) | `guide/07` | CORRECT content, but the INSA course is primarily supervised learning. This is supplementary. |

These additions are mathematically correct and useful for a broader ML education, but students should be aware they may not be directly examined. The core exam topics (based on annales) are: decision trees, Naive Bayes, KNN, evaluation metrics, AdaBoost, and inference grammaticale.

**Notable omission:** The course includes a chapter on **Inference Grammaticale** (grammatical inference, automata learning) which is covered in the source guide (`06_inference_grammaticale.md`) but has no corresponding chapter in the generated study guide. This topic appears in some exam years.

---

## Conclusion

The study guide is **accurate and reliable** for exam preparation. All formulas are mathematically correct, all sklearn code uses current API signatures, and all TP solutions match the source notebooks. The three issues found (CNN architecture discrepancy, deprecated RMSE API, missing source bug note) have been fixed directly in the files.

Students should note that chapters 02 (Linear Regression), 03 (Logistic Regression), 05 (SVM), and 07 (Unsupervised) go beyond the INSA course scope and are supplementary material. The core exam-relevant content is in chapters 01, 04, 06, 08, 09 and the exercises/exam-prep files.
