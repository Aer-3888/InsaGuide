# TP CPOO1 - Guide d'Exercices

Ce guide accompagne les TPs de CPOO1 (Conception et Programmation Orientées Objet). Le projet contient 6 exercices progressifs couvrant les concepts fondamentaux de la programmation orientée objet en Java et des tests unitaires avancés.

## Structure du Projet

```
tp-CPOO1-gitlab/
├── src/
│   ├── main/java/cpoo1/
│   │   ├── exo2/          # Exercice 2: Tests et mocking
│   │   ├── exo4/          # Exercice 3: Graphes de flot et classes d'équivalence
│   │   ├── exo5/          # Exercice 4: Tests paramétrés
│   │   ├── exo8/          # Exercice 5: Mocking de Random
│   │   ├── exo9/          # Exercice 6: Mutation testing
│   │   └── cours/         # Exemples du cours
│   └── test/java/cpoo1/   # Tests unitaires
├── pom.xml                # Configuration Maven
└── README.md              # Sujets des exercices
```

## Technologies Utilisées

- **Java 21** - Langage de programmation
- **Maven** - Gestion de dépendances et build
- **JUnit 5** - Framework de tests unitaires
- **Mockito** - Framework de mocking pour tests
- **JaCoCo** - Couverture de code
- **Pitest** - Mutation testing

## Prérequis et Installation

### IDE Recommandé
IntelliJ IDEA est fortement recommandé pour ce TP (meilleur support des tests et de la couverture de code que VSCode).

**Pour ouvrir le projet :**
1. Lancez IntelliJ IDEA
2. Sélectionnez "Open" et choisissez le dossier `tp-CPOO1-gitlab`
3. IntelliJ détectera automatiquement le projet Maven

### Vérification de l'Installation
```bash
# Compiler le projet
mvn clean compile

# Exécuter tous les tests
mvn test

# Générer le rapport de couverture (JaCoCo)
mvn test
# Ouvrir: target/site/jacoco/index.html

# Exécuter le mutation testing (Pitest)
mvn clean install test org.pitest:pitest-maven:mutationCoverage
# Ouvrir: target/pit-reports/index.html
```

## Vue d'Ensemble des Exercices

### Exercice 1 - Forêt (Non fourni)
**Concepts OOP :** Héritage, polymorphisme, encapsulation, classes abstraites

Cet exercice n'est pas fourni dans le dépôt. Il s'agit d'un exercice de modélisation et d'implémentation à réaliser entièrement. Vous devez créer :
- Une hiérarchie de classes pour modéliser des arbres (chênes et pins)
- Une classe `Foret` pour gérer une collection d'arbres
- Des tests unitaires complets

**À implémenter :**
- Classes : `Arbre` (abstraite), `Chene`, `Pin`, `Foret`
- Méthodes dans `Arbre` : `vieillir()`, `getPrix()`, `peutEtreCoupé()`
- Méthodes dans `Foret` : `planterArbre()`, `getPrixTotal()`, `couperArbre()`, `getNombreChene()`

Consultez le README.md pour les spécifications complètes.

### Exercice 2 - Tests et Validation d'IP
**Fichiers :** `src/main/java/cpoo1/exo2/`
**Concepts :** Tests unitaires, tests paramétrés, mocking, validation d'entrées

**Classe à tester :** `Exo2`
- Valide des adresses IP avec une regex
- Effectue un ping et une requête HTTP GET

**Objectifs :**
1. Écrire des tests unitaires classiques
2. Utiliser des tests paramétrés pour tester différentes adresses IP (valides et invalides)
3. Utiliser Mockito pour mocker l'objet `Network`
4. Vérifier que `sendGetHTTPQuery` est appelée avec la bonne adresse
5. Atteindre 100% de couverture de code

**Classes fournies :**
- `Exo2.java` - Classe à tester (complète)
- `Network.java` - Interface à mocker
- `NetworkException.java` - Exception métier
- `TestExo2.java` - Classe de test (à compléter)

**Points d'attention :**
- Configurer le mock pour retourner `true` lors du test de formats IP invalides
- Vérifier les appels de méthodes avec `verify()`

### Exercice 3 - Client et Services (Graphes de Flot)
**Fichiers :** `src/main/java/cpoo1/exo4/`
**Concepts :** Graphes de flot de contrôle, classes d'équivalence, opérateurs logiques

**Classe fournie :** `Client`
- Gère une liste de services
- Calcule la latence totale

**Objectifs :**
1. Comprendre la différence entre `&&`/`||` (court-circuit) et `&`/`|` (évaluation complète)
2. Construire la table de vérité de la condition ligne 23
3. Dessiner le graphe de flot de contrôle de `addService` et `getTotalLatency`
4. Identifier les classes d'équivalence du paramètre `s`
5. Écrire une classe de tests `ClientTest` avec 100% de couverture

**Classes fournies :**
- `Client.java` - Classe complète à analyser
- `Service.java` - Interface (à mocker dans les tests)

**Points d'attention :**
- La condition `if(s==null || services.contains(s))` utilise l'opérateur `||` (court-circuit)
- Les nœuds A, B, C, D, E sont commentés dans le code pour faciliter le graphe de flot

### Exercice 4 - Plateau de Jeu
**Fichiers :** `src/main/java/cpoo1/exo5/`
**Concepts :** Mot-clé `final`, tests paramétrés, immutabilité partielle

**Classe fournie :** `PlateauJeu`
- Plateau de jeu 5x5
- Gestion de pions avec coordonnées

**Objectifs :**
1. Comprendre la différence entre `final` sur un type primitif (`SIZE`) et un type complexe (`pions`)
2. Identifier les classes d'équivalence pour les coordonnées x et y
3. Dessiner le graphe de flot de contrôle de `isFree`
4. Tester `isOut` avec des tests paramétrés

**Classes fournies :**
- `PlateauJeu.java` - Classe complète
- `Pion.java` - Interface (à mocker dans les tests)

**Points d'attention :**
- `final List<Pion> pions` : la référence est finale, mais le contenu de la liste peut changer
- `Collections.unmodifiableList()` retourne une vue non-modifiable
- Tests paramétrés : `@ParameterizedTest` et `@ValueSource` ou `@CsvSource`

### Exercice 5 - Mocking de Random
**Fichiers :** `src/main/java/cpoo1/exo8/`
**Concepts :** Mocking avancé, construction mockée, méthodes statiques mockées

**Classe fournie :** `Exo8`
- Utilise `Random` instancié dans le constructeur
- Utilise `RandomGenerator.getDefault()` (méthode statique)

**Objectifs :**
1. Mocker une construction d'objet avec `Mockito.mockConstruction()`
2. Mocker une méthode statique avec `Mockito.mockStatic()`
3. Tester les deux méthodes avec des valeurs déterministes

**Classes fournies :**
- `Exo8.java` - Classe complète
- `Random.java` - Wrapper autour de `RandomGenerator`

**Documentation Mockito :**
- Mock construction : https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html#49
- Mock static : https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html#48

**Points d'attention :**
- Utilisez `try-with-resources` pour les mocks statiques
- Le mock de construction nécessite `mockConstruction()` avec configuration

### Exercice 6 - Mutation Testing
**Fichiers :** `src/main/java/cpoo1/exo9/`
**Concepts :** Mutation testing, qualité des tests, bugs logiques

**Classe fournie :** `Exo9`
- Gère une liste de chaînes de caractères
- Contient un bug intentionnel dans `contient()`

**Objectifs :**
1. Identifier les 3 problèmes dans `TestExo9`
2. Comprendre pourquoi les tests passent même en modifiant l'implémentation
3. Exécuter Pitest et analyser les résultats
4. Corriger les tests pour atteindre 100% de score de mutation
5. Corriger le bug dans `Exo9.contient()` (ligne 24 : `i <= taille` devrait être `i < taille`)

**Classes fournies :**
- `Exo9.java` - Classe avec bug
- `TestExo9.java` - Tests incomplets

**Commande Pitest :**
```bash
mvn clean install test org.pitest:pitest-maven:mutationCoverage
# Ouvrir: target/pit-reports/index.html
```

**Le Mutation Testing :**
Pitest modifie votre code (mutations) et vérifie si vos tests détectent les changements. Un bon test doit échouer quand le code est muté.

**Points d'attention :**
- Le bug : `i <= taille` cause une `IndexOutOfBoundsException`
- Les tests actuels ne testent pas tous les cas limites
- Les assertions doivent vérifier le comportement réel

## Concepts OOP Couverts

### 1. Héritage et Polymorphisme (Exercice 1)
- Classe abstraite `Arbre`
- Sous-classes concrètes `Chene` et `Pin`
- Redéfinition de méthodes
- Polymorphisme de substitution

### 2. Encapsulation et Immutabilité
- Modificateur `final` (Exercice 4)
- Collections non-modifiables (Exercice 4)
- Getters sans setters
- Principe d'immutabilité

### 3. Interfaces et Contrats
- Interface `Service` (Exercice 3)
- Interface `Pion` (Exercice 4)
- Dépendance sur abstraction vs. implémentation

### 4. Gestion d'Exceptions
- `NetworkException` (Exercice 2)
- `IllegalArgumentException` (Exercice 3)
- Bloc `try-catch`

## Concepts de Tests Couverts

### 1. Tests Unitaires Classiques (Tous les exercices)
- JUnit 5 : `@Test`, `@BeforeEach`
- Assertions : `assertEquals()`, `assertTrue()`, `assertFalse()`, `assertThrows()`
- Isolation des tests

### 2. Tests Paramétrés (Exercices 2, 4)
- `@ParameterizedTest`
- `@ValueSource`, `@CsvSource`, `@MethodSource`
- Réduction de duplication de code

### 3. Mocking avec Mockito (Exercices 2, 3, 4, 5)
- `@Mock`, `@InjectMocks`
- `when().thenReturn()`
- `verify()` pour vérifier les appels
- Mock construction (Exercice 5)
- Mock static (Exercice 5)

### 4. Couverture de Code (Tous les exercices)
- JaCoCo : mesure la couverture de lignes et de branches
- Objectif : 100% de couverture
- Rapport HTML : `target/site/jacoco/index.html`

### 5. Mutation Testing (Exercice 6)
- Pitest : teste la qualité des tests
- Mutations : modification du code source
- Score de mutation : % de mutations détectées
- Rapport HTML : `target/pit-reports/index.html`

### 6. Graphes de Flot de Contrôle (Exercice 3)
- Analyse des chemins d'exécution
- Noeuds et arcs
- Couverture de branches vs. couverture de chemins

### 7. Classes d'Équivalence (Exercices 3, 4)
- Partitionnement des entrées possibles
- Tests représentatifs de chaque classe
- Valeurs limites (boundary values)

## Commandes Maven Utiles

```bash
# Compiler le projet
mvn clean compile

# Exécuter tous les tests
mvn test

# Exécuter un test spécifique
mvn test -Dtest=TestExo2

# Exécuter les tests avec couverture JaCoCo
mvn clean test
# Ouvrir: target/site/jacoco/index.html

# Exécuter Pitest (mutation testing)
mvn clean install test org.pitest:pitest-maven:mutationCoverage
# Ouvrir: target/pit-reports/index.html

# Tout nettoyer
mvn clean

# Installer les dépendances
mvn dependency:resolve

# Afficher l'arbre des dépendances
mvn dependency:tree
```

## Utilisation dans IntelliJ

### Exécuter les Tests
1. Clic droit sur un fichier de test → Run 'NomTest'
2. Clic droit sur le dossier `test/` → Run 'All Tests'
3. Utiliser les raccourcis : Ctrl+Shift+F10 (Windows/Linux) ou Ctrl+Shift+R (macOS)

### Voir la Couverture
1. Run → Run with Coverage
2. Ou clic droit → Run 'NomTest' with Coverage
3. IntelliJ affichera la couverture ligne par ligne

### Déboguer les Tests
1. Clic droit sur un test → Debug 'NomTest'
2. Placer des breakpoints dans le code
3. Utiliser Step Over (F8), Step Into (F7), etc.

## Workflow de Développement TDD

Pour chaque exercice, suivez ce workflow :

1. **RED** - Écrire un test qui échoue
   ```java
   @Test
   void testMethodeQuiNexistePas() {
       // Ce test ne compile pas encore
       assertEquals(expectedValue, objetToTest.methode());
   }
   ```

2. **GREEN** - Écrire le code minimal pour faire passer le test
   ```java
   public ReturnType methode() {
       return expectedValue; // Implémentation minimale
   }
   ```

3. **REFACTOR** - Améliorer le code sans changer le comportement
   - Éliminer la duplication
   - Améliorer les noms
   - Simplifier la logique

4. **COVERAGE** - Vérifier la couverture et ajouter des tests si nécessaire

## Bonnes Pratiques

### Tests
- Un test = un cas d'utilisation ou un scénario
- Noms de tests descriptifs : `testAddServiceWithNullServiceThrowsException()`
- Arrange-Act-Assert (AAA) : préparation, exécution, vérification
- Tests indépendants : pas de dépendance entre tests
- Tests déterministes : pas de random, pas de temps système

### Code
- Noms explicites : pas de `a`, `b`, `tmp`
- Méthodes courtes : < 50 lignes
- Responsabilité unique : une classe = une responsabilité
- Éviter la duplication : DRY (Don't Repeat Yourself)
- Gestion des erreurs : exceptions explicites

### Maven
- Toujours faire `mvn clean` avant un build complet
- Vérifier les dépendances avec `mvn dependency:tree`
- Mettre à jour les dépendances régulièrement

## Ressources

### Documentation
- [JUnit 5 User Guide](https://junit.org/junit5/docs/current/user-guide/)
- [Mockito Documentation](https://javadoc.io/doc/org.mockito/mockito-core/latest/org/mockito/Mockito.html)
- [Maven Surefire Plugin](https://maven.apache.org/surefire/maven-surefire-plugin/)
- [JaCoCo Documentation](https://www.jacoco.org/jacoco/trunk/doc/)
- [Pitest](https://pitest.org/)

### Cours
- Consulter les slides sur Moodle
- Annales disponibles : https://moodleng.insa-rennes.fr/mod/folder/view.php?id=63250

## Progression Recommandée

1. **Exercice 1** (Forêt) - 2-3h
   - Modélisation UML
   - Implémentation complète
   - Tests unitaires complets

2. **Exercice 2** (Tests et IP) - 1h
   - Tests unitaires
   - Tests paramétrés
   - Mocking basique

3. **Exercice 3** (Client/Services) - 1h
   - Analyse de graphes
   - Classes d'équivalence
   - Tests avec mocking

4. **Exercice 4** (Plateau de Jeu) - 45min
   - Tests paramétrés avancés
   - Compréhension de `final`

5. **Exercice 5** (Mocking Random) - 45min
   - Mocking avancé
   - Construction mockée
   - Méthodes statiques mockées

6. **Exercice 6** (Mutation Testing) - 1h
   - Analyse de qualité de tests
   - Correction de bugs
   - Optimisation des tests

## Troubleshooting

### Le projet ne compile pas
```bash
mvn clean compile
# Si erreur de dépendances :
mvn dependency:resolve
```

### Les tests ne s'exécutent pas
- Vérifier que JUnit 5 est bien configuré dans `pom.xml`
- Vérifier que les classes de test se terminent par `Test` ou commencent par `Test`
- Vérifier que les méthodes de test sont annotées `@Test`

### Couverture JaCoCo à 0%
- S'assurer d'exécuter `mvn test` (pas juste `mvn compile`)
- Vérifier que le plugin JaCoCo est configuré dans `pom.xml`
- Ouvrir `target/site/jacoco/index.html` après `mvn test`

### Pitest ne génère pas de rapport
- Exécuter la commande complète : `mvn clean install test org.pitest:pitest-maven:mutationCoverage`
- Vérifier que des tests existent et passent
- Chercher le rapport dans `target/pit-reports/`

### Erreurs avec Mockito
- Vérifier les imports : `import static org.mockito.Mockito.*;`
- Utiliser `@ExtendWith(MockitoExtension.class)` sur la classe de test
- Pour mock static/construction, utiliser `try-with-resources`

## Support

Pour toute question :
- Consultez le README.md pour les sujets détaillés
- Relisez les slides du cours
- Consultez les annales sur Moodle
- Demandez de l'aide pendant les séances de TP
