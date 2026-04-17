/*!
 * \file suite.c
 * \brief Étude de la stabilité numérique d'une suite récurrente
 * \author ESM05 - Langage C
 * \date 2021
 */

#define _USE_MATH_DEFINES
#include <stdio.h>
#include <math.h>

#ifndef M_E
#define M_E 2.71828182845904523536
#endif

/*!
 * \brief Calcule la suite par récurrence ascendante (INSTABLE)
 *
 * Suite définie par:
 * - u₀ = e - 1
 * - uₙ = e - n × uₙ₋₁
 *
 * Cette méthode est numériquement instable car les erreurs d'arrondi
 * sont amplifiées à chaque itération (multiplication par n).
 *
 * \param n Le rang à calculer
 * \param verbose Si 1, affiche les valeurs intermédiaires
 * \return La valeur (incorrecte) de uₙ
 */
double suite(int n, int verbose) {
    double res = 0;

    if (n == 0) {
        res = M_E - 1;  /* Cas de base: u₀ = e - 1 ≈ 1.718 */
    } else {
        res = M_E - n * suite(n - 1, verbose);
        if (verbose == 1) {
            printf("La suite au rang %d vaut %lf\n", n, res);
        }
    }
    return res;
}

/*!
 * \brief Calcule la suite par récurrence descendante (STABLE)
 *
 * Reformule la relation: uₙ₋₁ = (e - uₙ) / n
 * Calcule à partir d'une valeur initiale u₅₀ = 0 vers u₀.
 *
 * Cette méthode est stable car les erreurs sont divisées (non amplifiées).
 *
 * \return La valeur correcte de u₀
 */
double suiteDecroissante() {
    double res = 0;  /* Initialisation: u₅₀ ≈ 0 */

    /* Calcule de u₅₀ vers u₀ */
    for (int i = 50; i > 0; i--) {
        res = (M_E - res) / i;
        printf("La suite au rang %d vaut %.6lf\n", i - 1, res);
    }
    return res;
}

int main() {
    int n, v;

    /* Méthode instable (pour démonstration) */
    printf("=== Méthode Récursive Ascendante (INSTABLE) ===\n");
    printf("Rentrez n et la verbose (0 ou 1):\n");
    scanf("%d %d", &n, &v);
    double res_instable = suite(n, v);
    printf("Résultat (instable): u_%d = %lf\n\n", n, res_instable);

    /* Méthode stable */
    printf("=== Méthode Itérative Descendante (STABLE) ===\n");
    double res_stable = suiteDecroissante();
    printf("\nRésultat (stable): u_0 = %.6lf\n", res_stable);
    printf("Valeur théorique: u_0 = e - 1 = %.6lf\n", M_E - 1);

    /* Explication */
    printf("\n=== Analyse ===\n");
    printf("La méthode ascendante amplifie les erreurs d'arrondi (×n).\n");
    printf("La méthode descendante réduit les erreurs (/n).\n");
    printf("Résultat: la version descendante est beaucoup plus précise!\n");

    return 0;
}
