/*!
 * \file tableau.c
 * \brief Implémentation des fonctions de manipulation de tableaux
 * \author ESM05 - Langage C
 * \date 2021
 */

#include "tableau.h"
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

void init_alea_tab(int tab[], int taille) {
    /* Initialisation du générateur aléatoire avec l'heure actuelle */
    srand(time(NULL));

    for (int i = 0; i < taille; i++) {
        /* Génère une valeur entre 0 et VAL_MAX-1 */
        tab[i] = rand() % VAL_MAX;
    }
}

void affiche_tab(int tab[], int taille) {
    for (int i = 0; i < taille; i++) {
        printf("tab[%d] = %d\n", i, tab[i]);
    }
    printf("=====================\n");
}

void histo(int src[], int dest[], int tailleSrc, int tailleDest) {
    /* Initialisation du tableau destination à zéro */
    for (int i = 0; i < tailleDest; i++) {
        dest[i] = 0;
    }

    /* Comptage des occurrences */
    for (int i = 0; i < tailleSrc; i++) {
        /* src[i] contient une valeur entre 0 et VAL_MAX-1 */
        /* On l'utilise comme indice pour incrémenter le compteur */
        dest[src[i]]++;
    }
}

void affiche_histo(int tab[], int taille, int showZ) {
    printf("\nHistogramme:\n");
    for (int i = 0; i < taille; i++) {
        /* Si showZ est 0, on saute les valeurs nulles */
        if (!showZ && tab[i] == 0) {
            continue;
        }

        /* Affiche la valeur */
        printf("%2d : ", i);

        /* Affiche un tiret par occurrence */
        for (int j = 0; j < tab[i]; j++) {
            printf("-");
        }
        printf("\n");
    }
}
