/*!
 * \file sinus.c
 * \brief Calcul du sinus par développement de Taylor
 * \author ESM05 - Langage C
 * \date 2021
 */

#define _USE_MATH_DEFINES
#include <stdio.h>
#include <math.h>

#ifndef M_PI
#define M_PI 3.14159265358979323846
#endif

/*!
 * \brief Calcule x élevé à la puissance n
 *
 * \param x La base
 * \param n L'exposant (entier positif)
 * \return x^n
 */
double puissance(double x, int n) {
    double res = 1;
    for (int i = 0; i < n; i++) {
        res *= x;
    }
    return res;
}

/*!
 * \brief Calcule n! (factorielle)
 *
 * \param n L'entier (doit être >= 0)
 * \return n! ou -1 si n < 0
 */
int myfact(int n) {
    if (n < 0) {
        return -1;
    }

    int fact = 1;
    for (int i = 1; i <= n; i++) {
        fact *= i;
    }
    return fact;
}

/*!
 * \brief Calcule un terme de la série de Taylor
 *
 * Calcule x^n / n!
 *
 * \param x La valeur
 * \param n Le rang du terme
 * \return x^n / n!
 */
double terme(double x, int n) {
    return puissance(x, n) / myfact(n);
}

/*!
 * \brief Calcule sin(x) par série de Taylor (version naïve)
 *
 * sin(x) = Σ (-1)^i × x^(2i+1) / (2i+1)!
 *        = x - x³/3! + x⁵/5! - x⁷/7! + ...
 *
 * Cette version recalcule chaque terme indépendamment (inefficace).
 *
 * \param x L'angle en radians
 * \param n Le nombre de termes à calculer
 * \return Approximation de sin(x)
 */
double sinus(double x, int n) {
    double res = 0;
    /* Réduction de x dans [0, π] pour améliorer la convergence */
    double m = fmod(x, M_PI);

    for (int i = 0; i < n / 2; i++) {
        /* Alterne les signes: +, -, +, -, ... */
        res += puissance(-1, i) * terme(m, 2 * i + 1);
    }
    return res;
}

/*!
 * \brief Calcule le terme suivant à partir du précédent
 *
 * Au lieu de recalculer x^n / n!, utilise la relation:
 * terme_{n} = terme_{n-2} × x² / (n × (n-1))
 *
 * \param t Le terme précédent
 * \param x La valeur de x
 * \param n Le rang du nouveau terme
 * \return Le terme suivant
 */
double suiv(double t, double x, int n) {
    return t * x * x / ((double)(n * (n - 1)));
}

/*!
 * \brief Calcule sin(x) par série de Taylor (version optimisée)
 *
 * Calcule chaque terme à partir du précédent au lieu de tout recalculer.
 * Beaucoup plus efficace que sinus().
 *
 * \param x L'angle en radians
 * \param n Le nombre de termes (doit être impair)
 * \return Approximation de sin(x)
 */
double sinus2(double x, int n) {
    double m = fmod(x, M_PI);
    double res = m;  /* Premier terme: x */
    double t = m;    /* Terme courant */
    int signe = -1;  /* Alterne -1, +1, -1, +1, ... */

    /* Calcule les termes x³/3!, x⁵/5!, x⁷/7!, ... */
    for (int i = 3; i <= n; i += 2) {
        t = suiv(t, m, i);
        res += (double)signe * t;
        signe *= (-1);
    }
    return res;
}

int main() {
    int n;
    double x;

    /* Test avec valeur saisie */
    printf("Rentrez x puis n : \n");
    scanf("%lf %d", &x, &n);
    printf("x a la puissance n = %lf\n", puissance(x, n));
    printf("sin(x) au rang n (en RADIANT) = %lf\n\n", sinus(x, n));

    /* Convergence de la série pour sin(π/2) = 1 */
    printf("Convergence de sin(π/2) vers 1:\n");
    printf("================================\n");
    for (int i = 1; i <= 41; i += 2) {
        printf("sinus(Pi/2) au rang %2d = %g\n", i, sinus2(M_PI / 2, i));
    }
    printf("\nValeur exacte: sin(π/2) = %g\n", sin(M_PI / 2));

    return 0;
}
