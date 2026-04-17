# Travaux Pratiques - Langage C (ESM05)

**INSA Rennes - 3ème année Informatique**

Ce dépôt contient l'ensemble des travaux pratiques du module "Langage C" couvrant les concepts fondamentaux de la programmation en C: pointeurs, gestion mémoire, structures de données, et entrées/sorties.

## Vue d'Ensemble des TPs

| TP | Thème | Concepts Clés |
|----|-------|---------------|
| [TP1](tp1/) | Introduction au C | Pointeurs, fonctions, math.h |
| [TP2](tp2/) | Structures de contrôle | Boucles, récursivité, algorithmes numériques |
| [TP3](tp3/) | Tableaux et chaînes | Tableaux, strings, nombres aléatoires |
| [TP4](tp4/) | Structures et fichiers | struct, fscanf/fprintf, E/S fichier |
| [TP5](tp5/) | Allocation dynamique | malloc/free, listes chaînées, pointeurs de fonctions |
| [TP6](tp6/) | Automates et parsing | Automate à états, variables statiques, GEDCOM |
| [TP7](tp7/) | Gestionnaire mémoire | Implémentation de malloc/free personnalisé |

## Progression Pédagogique

### Phase 1: Fondamentaux (TP1-TP2)
- Syntaxe de base du C
- Pointeurs et références
- Fonctions et bibliothèques standard
- Algorithmes mathématiques
- Stabilité numérique

### Phase 2: Structures de Données (TP3-TP4)
- Manipulation de tableaux
- Chaînes de caractères (char[])
- Structures personnalisées (struct)
- Entrées/sorties fichiers
- Formats de données structurées

### Phase 3: Gestion Mémoire Avancée (TP5-TP7)
- Allocation dynamique
- Structures de données dynamiques (listes chaînées)
- Pointeurs de fonctions
- Automates à états finis
- Implémentation bas niveau (allocateur mémoire)

## Structure des Répertoires

Chaque TP est organisé de la même manière:

```
tpN/
├── README.md           # Documentation complète du TP
├── src/                # Code source
│   ├── *.c            # Fichiers d'implémentation
│   ├── *.h            # En-têtes
│   ├── Makefile       # Compilation
│   └── *.txt          # Fichiers de données (si applicable)
└── [autres fichiers]   # PDFs, documentation supplémentaire
```

## Compilation et Exécution

Tous les TPs utilisent un Makefile standard:

```bash
cd tpN/src
make           # Compile le projet
make clean     # Nettoie les fichiers objets
make run       # Compile et exécute
```

### Compilation Manuelle

Si nécessaire, compiler manuellement avec:

```bash
gcc -Wall -Wextra -std=c11 -g -o programme fichier.c -lm
```

Options importantes:
- `-Wall -Wextra` : Active tous les avertissements
- `-std=c11` : Utilise la norme C11
- `-g` : Inclut les symboles de débogage
- `-lm` : Lie la bibliothèque mathématique (si besoin)

## Concepts C Couverts

### Bases
- Variables et types (`int`, `double`, `char`)
- Pointeurs et adresses mémoire
- Tableaux et chaînes de caractères
- Fonctions et prototypes
- Bibliothèques standard (`stdio.h`, `stdlib.h`, `math.h`, `string.h`)

### Structures de Contrôle
- Conditionnelles (`if`, `switch`)
- Boucles (`for`, `while`, `do-while`)
- Récursivité

### Structures de Données
- Structures (`struct`, `typedef`)
- Énumérations (`enum`)
- Tableaux statiques et dynamiques
- Listes chaînées
- Structures auto-référentes

### Gestion Mémoire
- Allocation statique vs dynamique
- `malloc()`, `calloc()`, `free()`
- Fuites mémoire
- Pointeurs dangling
- Arithmétique de pointeurs

### Entrées/Sorties
- Console: `scanf()`, `printf()`
- Fichiers: `fopen()`, `fclose()`, `fscanf()`, `fprintf()`, `fgets()`
- Formats de lecture/écriture

### Concepts Avancés
- Pointeurs de fonctions
- Variables statiques
- Automates à états finis
- Macros et préprocesseur
- Compilation conditionnelle

## Bonnes Pratiques Enseignées

1. **Gestion d'erreurs systématique**
   ```c
   if (fichier == NULL) {
       fprintf(stderr, "Erreur d'ouverture\n");
       exit(1);
   }
   ```

2. **Vérification des allocations**
   ```c
   int *ptr = malloc(n * sizeof(int));
   if (ptr == NULL) {
       /* Gestion d'erreur */
   }
   ```

3. **Libération de la mémoire**
   ```c
   free(ptr);
   ptr = NULL;  /* Évite les pointeurs dangling */
   ```

4. **Documentation du code**
   - Commentaires Doxygen (`/*!`, `\brief`, `\param`, `\return`)
   - En-têtes de fichiers
   - Commentaires explicatifs

5. **Compilation avec warnings**
   - Toujours compiler avec `-Wall -Wextra`
   - Traiter les warnings comme des erreurs

## Outils de Développement

### Compilation
- **GCC** (GNU Compiler Collection) - Compilateur C standard
- **Make** - Automatisation de la compilation

### Débogage
- **GDB** - Débogueur GNU
- **Valgrind** - Détection de fuites mémoire

```bash
# Débogage avec gdb
gcc -g programme.c -o programme
gdb ./programme

# Détection de fuites mémoire
valgrind --leak-check=full ./programme
```

### Éditeurs Recommandés
- Visual Studio Code (avec extensions C/C++)
- CLion (JetBrains)
- Vim/Emacs (pour les puristes)

## Ressources Complémentaires

### Documentation
- [C Reference](https://en.cppreference.com/w/c)
- [GNU C Library](https://www.gnu.org/software/libc/manual/)
- [GCC Documentation](https://gcc.gnu.org/onlinedocs/)

### Livres Recommandés
- "The C Programming Language" (K&R) - Kernighan & Ritchie
- "C Programming: A Modern Approach" - K.N. King
- "Expert C Programming" - Peter van der Linden

### Standards C
- **C89/C90** - Premier standard ANSI
- **C99** - Ajout de features modernes
- **C11** - Standard utilisé dans ce cours
- **C17/C18** - Corrections mineures de C11
- **C23** - Standard le plus récent (2023)

## Conseils pour Réussir

1. **Comprendre les pointeurs** - Fondamental en C
2. **Dessiner les structures** - Visualiser la mémoire
3. **Compiler souvent** - Détecter les erreurs tôt
4. **Utiliser le débogueur** - Ne pas se contenter de `printf()`
5. **Lire les messages d'erreur** - Ils sont précis et utiles
6. **Gérer la mémoire** - Toujours `free()` ce que vous `malloc()`
7. **Tester les cas limites** - Valeurs nulles, tableaux vides, etc.

## Problèmes Courants et Solutions

### Segmentation Fault
- **Cause:** Accès mémoire invalide (pointeur NULL, hors limites)
- **Solution:** Utiliser GDB pour localiser la ligne fautive

### Fuite Mémoire
- **Cause:** Oublier de `free()` la mémoire allouée
- **Solution:** Valgrind pour détecter les fuites

### Comportement Indéfini
- **Cause:** Utiliser des variables non initialisées, buffer overflow
- **Solution:** Initialiser toutes les variables, vérifier les limites

### Warning: Unused Variable
- **Cause:** Variable déclarée mais pas utilisée
- **Solution:** Supprimer la variable ou l'utiliser

## Contact et Support

Pour toute question sur les TPs:
- Consulter d'abord le README du TP concerné
- Vérifier la documentation en ligne (cppreference.com)
- Poser des questions pendant les séances de TP
- Utiliser les forums du cours sur Moodle

---

**Bon courage pour vos TPs!** 🚀

*Dernière mise à jour: Avril 2026*
