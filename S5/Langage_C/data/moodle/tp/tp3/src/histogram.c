/*!
 * \file histogram.c
 * \brief Programme principal pour générer et afficher un histogramme
 * \author ESM05 - Langage C
 * \date 2021
 */

#include <stdio.h>
#include <stdlib.h>
#include "tableau.h"

int main() {
    int tabSrc[DIM_TAB];      /* Tableau source (valeurs aléatoires) */
    int tabDest[VAL_MAX];     /* Tableau destination (histogramme) */

    /* Génère des valeurs aléatoires */
    printf("Génération de %d valeurs aléatoires entre 0 et %d:\n\n",
           DIM_TAB, VAL_MAX - 1);
    init_alea_tab(tabSrc, DIM_TAB);

    /* Affiche le tableau source */
    affiche_tab(tabSrc, DIM_TAB);

    /* Calcule l'histogramme */
    histo(tabSrc, tabDest, DIM_TAB, VAL_MAX);

    /* Affiche l'histogramme (sans les valeurs à zéro) */
    affiche_histo(tabDest, VAL_MAX, 0);

    printf("\n(Les valeurs à 0 occurrences ne sont pas affichées)\n");

    return 0;
}
