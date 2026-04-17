/*!
 * \file main.c
 * \brief TP1 - Manipulation de pointeurs et calculs mathématiques
 * \author ESM05 - Langage C
 * \date 2021
 */

#include <stdio.h>
#include <math.h>

/*!
 * \brief Élève un nombre au carré en place (modifie la valeur pointée)
 *
 * Cette fonction démontre le passage par référence en C.
 * La valeur est modifiée directement en mémoire via le pointeur.
 *
 * \param a Pointeur vers le nombre à élever au carré
 * \return La valeur du carré (la variable pointée est aussi modifiée)
 */
double carre(double* a) {
    return (*a) *= (*a);  /* Équivalent à: *a = *a * *a; return *a; */
}

/*!
 * \brief Calcule la norme euclidienne d'un vecteur 2D
 *
 * La norme d'un vecteur (x, y) est calculée comme:
 * norme = √(x² + y²)
 *
 * \param x Coordonnée x du vecteur
 * \param y Coordonnée y du vecteur
 * \return La norme du vecteur
 */
double norme(double x, double y) {
    return sqrt(x*x + y*y);
}

int main() {
    double n;

    /* Test de la fonction carre() */
    printf("Nombre a elever au carre : \n");
    scanf("%lf", &n);
    carre(&n);  /* Passage par référence: &n est l'adresse de n */
    printf("Resultat \n");
    printf("%lf\n", n);

    /* Test de la fonction norme() */
    double x, y, resultat;
    printf(" \n Vector \n");
    scanf("%lf %lf", &x, &y);
    resultat = norme(x, y);  /* Passage par valeur */
    printf("%lf\n", resultat);

    return 0;
}
