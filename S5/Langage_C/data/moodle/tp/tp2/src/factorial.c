/*!
 * \file factorial.c
 * \brief Calcul de la factorielle et détection de dépassement
 * \author ESM05 - Langage C
 * \date 2021
 */

#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

/*!
 * \brief Calcule la factorielle de n
 *
 * Calcule n! = 1 × 2 × 3 × ... × n
 * Retourne -1 si n est négatif.
 *
 * \param n L'entier dont on calcule la factorielle
 * \return La factorielle de n, ou -1 si n < 0
 */
int myfact(int n) {
    if (n < 0) {
        return -1;  /* Factorielle non définie pour les négatifs */
    }

    int fact = 1;
    for (int i = 1; i <= n; i++) {
        fact *= i;
    }
    return fact;
}

/*!
 * \brief Affiche les factorielles de 1 à 20
 *
 * Attention: À partir de n=13, le résultat dépasse INT_MAX
 * et les valeurs deviennent incorrectes (dépassement d'entier).
 */
void display_fact() {
    printf("\nTable des factorielles:\n");
    printf("========================\n");
    for (int i = 1; i <= 20; i++) {
        printf("Factorielle de %2d = %d\n", i, myfact(i));
    }
}

/*!
 * \brief Trouve le plus grand n dont la factorielle est calculable
 *
 * Utilise une vérification anticipée du dépassement:
 * Si fact × (i+1) > INT_MAX, alors fact(i+1) dépassera.
 *
 * \return Le plus grand n tel que n! < INT_MAX
 */
int rang() {
    int i = 0;
    /* Tant que la prochaine multiplication ne dépassera pas INT_MAX */
    while (myfact(i) < INT_MAX / (i + 1)) {
        i++;
    }
    return i;
}

int main() {
    int n;

    /* Test avec une valeur saisie */
    printf("Rentrez n \n");
    scanf("%d", &n);
    printf("Factorielle de n = %d \n", myfact(n));

    /* Affichage des factorielles de 1 à 20 (observe le dépassement) */
    display_fact();

    /* Détermination du plus grand n calculable correctement */
    printf("\nRang de la plus grande factorielle correcte = %d \n", rang());
    printf("(Au-delà de ce rang, le résultat dépasse INT_MAX = %d)\n", INT_MAX);

    return EXIT_SUCCESS;
}
