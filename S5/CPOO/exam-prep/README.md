# Preparation a l'examen CPOO

## Format de l'examen

- **Duree** : 2 heures (2h40 pour les etudiants avec tiers-temps)
- **Documents autorises** : notes de cours imprimees et notes manuscrites
- **Format** : ecrit sur papier, reponses ecrites directement sur la feuille d'examen
- **Longueur** : typiquement 6 pages, 3-5 exercices
- **Points** : ~20 points au total sur l'ensemble des exercices

**Regle critique** : tout texte rature ou illisible entraine une penalite. Utiliser d'abord le brouillon, puis recopier la reponse propre sur la feuille d'examen.

## Structure de l'examen (basee sur 5 ans d'annales)

Chaque examen CPOO de 2019 a 2025 suit la meme structure a trois piliers :

| Pilier | Poids | Sujets |
|--------|-------|--------|
| **Tests unitaires** | ~5-8 pts | Ecrire des classes de test, corriger des assertions, mocking, couverture, flot de controle |
| **Diagrammes UML** | ~5-8 pts | Diagrammes de classes a partir de texte, diagrammes de cas d'utilisation, diagrammes de sequences |
| **Theorie POO / QCM** | ~3-5 pts | QCM, reponses courtes sur les concepts POO |

---

## Analyse detaillee des examens

### [Corriges d'examen par annee](exam-walkthroughs.md)

Solutions pas a pas pour les questions de toutes les annales disponibles.

### [Banque de questions par type](question-bank.md)

Toutes les questions d'examen organisees par sujet pour une revision ciblee.

---

## Strategie d'examen

### Gestion du temps (2 heures)

| Phase | Temps | Activite |
|-------|-------|----------|
| Lecture | 10 min | Lire l'ensemble de l'examen, identifier les points faciles |
| Exercice de test | 40-50 min | Ecrire la classe de test, corriger les assertions |
| Exercice UML | 40-50 min | Dessiner les diagrammes soigneusement |
| Theorie/QCM | 10-15 min | Repondre aux QCM, reponses courtes |
| Relecture | 5-10 min | Verifier toutes les reponses, verifier les diagrammes |

### Ordre de priorite

1. **Exercices de test** : ce sont les plus mecaniques et rapportent bien si vous connaissez les patrons.
2. **Diagrammes de classes UML** : approche systematique (noms=classes, verbes=methodes, relations).
3. **QCM de theorie** : souvent direct si vous connaissez les definitions.
4. **Flot de controle / classes d'equivalence** : necessite une analyse minutieuse, garder pour la fin si le temps presse.

### Ce qu'il faut apporter

- Diapositives du cours imprimees (surtout la reference de notation UML et les aide-memoire JUnit/Mockito)
- Notes manuscrites avec des exemples de classes de test
- Ce guide de revision (imprime)

---

## Patrons cles qui reviennent chaque annee

### 1. "Ecrivez une classe de test pour ce code" (Chaque annee)

On vous donne une classe Java et une interface. L'interface n'a pas d'implementation, il faut donc la mocker. Patron attendu :

```java
@ExtendWith(MockitoExtension.class)
public class TestX {
    X x;
    MockedInterface mock;

    @BeforeEach
    void setUp() throws Exception {
        mock = Mockito.mock(MockedInterface.class);
        Mockito.when(mock.method()).thenReturn(value);
        x = new X(mock);
    }

    @Test void testNormalCase() { ... }
    @Test void testNullInput() {
        assertThrows(IllegalArgumentException.class, () -> new X(null));
    }
    @Test void testExceptionPath() { ... }
}
```

### 2. "Corrigez ces assertions" (La plupart des annees)

Corrections courantes :
- `assertTrue(a.equals(b))` becomes `assertEquals(a, b)`
- `assertFalse(!a.foo())` becomes `assertTrue(a.foo())`
- `assertTrue(a == b)` becomes `assertSame(a, b)`
- try/catch with `fail()` becomes `assertThrows()`
- `if (x != 10) fail()` becomes `assertEquals(10, x)`
- Duplicate `new C()` in each test becomes `@BeforeEach`

### 3. "Dessinez un diagramme de classes UML a partir de ce texte" (Chaque annee)

Approche systematique :
1. Souligner tous les noms (classes/attributs)
2. Souligner tous les verbes (methodes)
3. Identifier "est un" = heritage
4. Identifier "possede" / "contient" = association/agregation/composition
5. Identifier la multiplicite dans le texte ("un", "plusieurs", "au moins un")
6. Identifier les enumerations ("est soit X, Y, ou Z")
7. Dessiner les boites, relier avec des lignes, ajouter les multiplicites

### 4. "Graphe de flot de controle / table de verite / classes d'equivalence" (La plupart des annees)

- Dessiner des noeuds pour chaque instruction/branche
- Dessiner des aretes pour le flot de controle
- Pour `||` (court-circuit) : gauche vrai signifie que la droite n'est PAS evaluee
- Pour `&&` (court-circuit) : gauche faux signifie que la droite n'est PAS evaluee
- Classes d'equivalence : regrouper les entrees qui produisent le meme comportement
- Valeurs aux limites : tester aux frontieres de chaque classe

### 5. "Quelle est la couverture maximale atteignable ?" (2021-2022)

Verifier le code mort :
- Exceptions declarees mais jamais lancees
- Branches jamais atteignables a cause de l'evaluation en court-circuit
- Methodes privees qui transforment l'etat (ex. `doSomething()` fixe `str = "yolo"`, ce qui signifie que la branche `str == null` dans le `if` suivant est morte)

---

## Reference rapide : Vocabulaire d'examen

| Francais (examen) | Anglais | Signification |
|-------------------|---------|--------------|
| couverture de lignes | line coverage | % de lignes source executees |
| couverture de branches | branch coverage | % de chemins if/else pris |
| couverture de conditions | condition coverage | chaque sous-expression vraie et fausse |
| graphe de flot de controle | control flow graph | noeuds=instructions, aretes=flot de controle |
| classes d'equivalence | equivalence classes | partitions d'entrees avec meme comportement |
| diagramme de classes | class diagram | relations entre classes UML |
| diagramme de cas d'utilisation | use case diagram | acteurs et cas d'utilisation |
| diagramme de sequence | sequence diagram | ordre des appels de methode |
| heritage | inheritance | extends |
| polymorphisme | polymorphism | liaison dynamique |
| encapsulation | encapsulation | champs prives + methodes publiques |
| integrite referentielle | referential integrity | les deux cotes d'un lien bidirectionnel coherents |
