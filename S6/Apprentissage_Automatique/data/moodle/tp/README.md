# Apprentissage Automatique (Machine Learning) - Lab Solutions

This directory contains completed lab exercises for the Machine Learning course (Apprentissage Automatique) at INSA Rennes, 3rd year Computer Science.

## Course Overview
Topics covered: supervised learning (classification, regression), decision trees, Bayesian learning, neural networks, SVMs, ensemble methods (boosting), model evaluation.

## Lab Structure

### [TP1: Introduction to scikit-learn, Decision Trees, and Bayesian Learning](tp1_sklearn_decision_trees/)
**Topics**: Basic ML pipeline, kNN, decision trees, naive Bayes
**Datasets**: Iris, heart disease, weather data
**Key Concepts**:
- scikit-learn basics (train/test split, cross-validation)
- k-Nearest Neighbors classification
- Decision tree construction and pruning
- Cost complexity pruning (finding optimal alpha)
- Naive Bayes with categorical and continuous features
- Manual Bayesian probability calculations

**Files**:
- `TP1.ipynb`: Complete notebook with all exercises
- `heart.csv`, `weather.csv`, `weather.nominal.csv`: Datasets
- `practical_Q16.pdf`: Manual Bayesian calculation exercise

**Results**: kNN (97% on iris), Decision Tree (80% on heart), Naive Bayes (93% on weather)

---

### [TP2: Building a Complete ML Pipeline](tp2_ml_pipeline/)
**Topics**: Real-world classification, feature engineering, model comparison, hyperparameter tuning
**Dataset**: Medical appointment no-shows (110K records)
**Key Concepts**:
- End-to-end ML pipeline development
- Feature engineering (created AppointmentDelay feature)
- Data preprocessing (encoding, date handling)
- Model comparison (Random Forest, kNN, Naive Bayes, AdaBoost)
- Hyperparameter tuning with validation sets
- Feature importance analysis
- Handling mixed data types

**Models Implemented**:
1. Random Forest (baseline): 79.8% accuracy
2. k-Nearest Neighbors (best): 79.77% accuracy (k=60)
3. Naive Bayes (categorical): 79.76% accuracy
4. AdaBoost: ~80% accuracy

**Files**:
- `TP2_no_show.ipynb`: Complete pipeline implementation
- `no_show.csv`: Medical appointments dataset
- `Hugo TP2/`: Alternative work on music genre classification

**Key Finding**: Simple models (kNN) can outperform complex ensembles with proper feature engineering and hyperparameter tuning.

---

### [TP3: Decision Trees with BonzaiBoost](tp3_boosting/)
**Topics**: Decision tree learning, boosting, stopping criteria, model interpretation
**Dataset**: Adult income dataset (32K training, 16K test)
**Key Concepts**:
- BonzaiBoost toolkit for decision tree learning
- Naive baseline importance
- Manual vs automatic tree construction
- Stopping criteria comparison (depth limit, MDLPC, none)
- Overfitting detection (train vs test accuracy)
- AdaBoost ensemble learning
- Feature importance from boosting
- Tree visualization with Graphviz

**Exercises**:
1. Naive classifier baseline (~75%)
2. Manual 4-leaf tree design
3. Automatic trees with different stopping criteria
   - Depth-limited (d=2): 79-81%
   - MDLPC (automatic): 82-84%
   - Full tree: 100% train, 82-84% test (overfitting)
4. AdaBoost (n=100 stumps): 85-87% (best)

**Files**:
- `bonzaiboost`: Pre-compiled binary for tree learning
- `adult.data`, `adult.test`, `adult.names`: Census dataset
- `arbre.txt`: Example manual tree rules
- `rules2tree.pl`: Perl script for rule conversion
- `TP3_but_4.pdf`: Complete exercise instructions (French)

**Key Finding**: Boosting weak learners outperforms single complex trees, MDLPC provides good automatic stopping criterion.

---

### [TP4: Neural Networks and CNNs](tp4_neural_networks/)
**Topics**: Deep learning, convolutional neural networks, image classification
**Dataset**: CIFAR-10 (50K training images, 10K test, 10 classes)
**Key Concepts**:
- Multi-layer perceptron (MLP) architecture
- Convolutional neural networks (CNNs)
- Why CNNs excel at computer vision
- Conv2D layers, MaxPooling, Dropout
- TensorFlow/Keras functional API
- GPU memory management
- Spatial structure preservation
- Parameter sharing and efficiency

**Models**:
1. **Perceptron**: Flatten image → Dense(hidden) → Dense(10)
   - Accuracy: ~45-55% (depends on hidden size)
   - Treats image as unstructured vector
   
2. **CNN**: Conv layers → Pooling → Dense layers
   - Accuracy: ~75-80%
   - Architecture: 3 conv blocks (32→64→128 filters)
   - Dropout (0.37) for regularization
   - Dense head (10K neurons)

**Files**:
- `tp_nn.py`: Complete implementation (perceptron + CNN)

**Key Finding**: CNNs dramatically outperform perceptrons for images by preserving spatial structure and using local connectivity.

**Note**: Bug in original code (lines 30-32 use `entree` instead of `layer`), causes disconnected architecture.

---

## Directory Structure
```
tp/
├── README.md                           # This file
├── tp1_sklearn_decision_trees/
│   ├── README.md                       # Detailed TP1 walkthrough
│   ├── TP1_complete.ipynb              # Cleaned notebook
│   └── *.csv, *.pdf                    # Datasets and exercises
├── tp2_ml_pipeline/
│   ├── README.md                       # Detailed TP2 walkthrough
│   ├── TP2_complete.ipynb              # Cleaned notebook
│   └── no_show.csv                     # Dataset
├── tp3_boosting/
│   ├── README.md                       # Detailed TP3 walkthrough
│   ├── bonzaiboost                     # Pre-compiled binary
│   └── adult/                          # Census dataset
└── tp4_neural_networks/
    ├── README.md                       # Detailed TP4 walkthrough
    └── tp_nn.py                        # Neural network code
```

## Running the Labs

### Prerequisites
```bash
# Install Python dependencies
pip install scikit-learn pandas numpy matplotlib seaborn jupyter

# For TP1 visualization (optional)
pip install graphviz dtreeviz

# For TP4
pip install tensorflow

# System packages (Ubuntu/Debian)
sudo apt-get install graphviz  # For tree visualization
```

### Launching Notebooks
```bash
cd tp1_sklearn_decision_trees/
jupyter notebook TP1_complete.ipynb

cd tp2_ml_pipeline/
jupyter notebook TP2_complete.ipynb
```

### Running Python Scripts
```bash
cd tp4_neural_networks/
python tp_nn.py
```

### BonzaiBoost (TP3)
```bash
cd tp3_boosting/adult/
../bonzaiboost -S adult -d 2                      # Build depth-2 tree
../bonzaiboost -S adult -boost adamh -n 100       # AdaBoost with 100 iterations
```

## Key Learning Outcomes

### Model Selection
- **kNN**: Simple, effective baseline, good for small datasets
- **Decision Trees**: Interpretable, handles non-linear relationships
- **Random Forest**: Robust, provides feature importance
- **Naive Bayes**: Fast, works well with proper feature engineering
- **Boosting**: Combines weak learners for strong performance
- **Neural Networks**: Powerful for complex patterns, requires more data
- **CNNs**: State-of-art for images, exploits spatial structure

### Best Practices
1. **Always establish baseline**: Naive classifier, simple models first
2. **Feature engineering matters**: Domain knowledge improves all models
3. **Hyperparameter tuning**: Grid search with validation set
4. **Visualize validation curves**: Detect overfitting, find optimal parameters
5. **Use cross-validation**: Better estimate of generalization
6. **Compare train/test error**: Identify over/underfitting
7. **Interpret models**: Feature importance, tree visualization
8. **Preprocess consistently**: Same transformations for train/val/test

### Common Pitfalls
- Training on test set (information leakage)
- Ignoring class imbalance
- Overfitting (train >> test accuracy)
- Underfitting (high bias, low model capacity)
- Not normalizing features (especially for distance-based methods)
- Inconsistent data splits across experiments

## Performance Summary

| TP | Dataset | Best Model | Accuracy | Key Insight |
|----|---------|------------|----------|-------------|
| TP1 | Iris | kNN | 97% | Simple datasets work with simple models |
| TP1 | Heart | Decision Tree (pruned) | 80% | Pruning prevents overfitting |
| TP2 | No-show | kNN (k=60) | 79.77% | Feature engineering > complex models |
| TP3 | Adult | AdaBoost (n=100) | 85-87% | Boosting outperforms single trees |
| TP4 | CIFAR-10 | CNN | 75-80% | CNNs dominate computer vision |

## Additional Resources

### Course Materials
- `../cours/`: Lecture slides (PDFs)
- `../annales/`: Past exams and solutions

### Online Documentation
- [scikit-learn](https://scikit-learn.org/): Main ML library
- [TensorFlow/Keras](https://www.tensorflow.org/): Deep learning
- [BonzaiBoost](http://bonzaiboost.gforge.inria.fr/): Decision tree toolkit

### Further Reading
- Decision Trees: CART, C4.5, ID3 algorithms
- Pruning: Cost complexity, reduced error, pessimistic error
- Boosting: AdaBoost, Gradient Boosting, XGBoost
- Neural Networks: Backpropagation, activation functions
- CNNs: LeNet, AlexNet, VGG, ResNet architectures

## Authors
- Hugo Lamoureux (original lab work)
- Cleaned and documented for course archival

## License
Educational use only - INSA Rennes coursework

## Last Updated
April 2026
