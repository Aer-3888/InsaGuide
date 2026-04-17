/*!
 * \file tableau.h
 * \brief Module de manipulation de tableaux et histogrammes
 * \author ESM05 - Langage C
 * \date 2021
 */

#ifndef TABLEAU_H
#define TABLEAU_H

#define DIM_TAB 50   /* Taille du tableau source */
#define VAL_MAX 20   /* Valeurs entre 0 et VAL_MAX-1 */

/*!
 * \brief Initialise un tableau avec des valeurs aléatoires
 *
 * Remplit le tableau avec des valeurs aléatoires entre 0 et VAL_MAX-1.
 * Nécessite d'avoir appelé srand() avant pour initialiser le générateur.
 *
 * \param tab Le tableau à remplir
 * \param taille La taille du tableau
 */
void init_alea_tab(int tab[], int taille);

/*!
 * \brief Affiche le contenu d'un tableau
 *
 * Affiche chaque élément du tableau avec son indice.
 *
 * \param tab Le tableau à afficher
 * \param taille La taille du tableau
 */
void affiche_tab(int tab[], int taille);

/*!
 * \brief Calcule l'histogramme d'un tableau
 *
 * Pour chaque valeur v dans le tableau source,
 * incrémente dest[v] (compte les occurrences).
 *
 * \param src Le tableau source
 * \param dest Le tableau destination (histogramme)
 * \param tailleSrc Taille du tableau source
 * \param tailleDest Taille du tableau destination (= VAL_MAX)
 */
void histo(int src[], int dest[], int tailleSrc, int tailleDest);

/*!
 * \brief Affiche l'histogramme sous forme graphique
 *
 * Affiche chaque valeur avec un nombre de tirets correspondant
 * à sa fréquence.
 *
 * \param tab Le tableau histogramme
 * \param taille La taille du tableau
 * \param showZ Si 1, affiche aussi les valeurs à zéro
 */
void affiche_histo(int tab[], int taille, int showZ);

#endif /* TABLEAU_H */
