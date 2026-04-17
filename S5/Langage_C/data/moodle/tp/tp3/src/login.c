/*!
 * \file login.c
 * \brief Implémentation des fonctions de génération d'identifiants
 * \author ESM05 - Langage C
 * \date 2021
 */

#include "login.h"

void identifiant(char *prenom, char *nom, char *id) {
    /* Première lettre du prénom */
    id[0] = prenom[0];

    /* Copie le nom après la première lettre */
    int i;
    for (i = 0; i < MAX_ID - 1; i++) {
        id[i + 1] = nom[i];
        /* Arrêt si fin de chaîne */
        if (nom[i] == '\0') {
            break;
        }
    }

    /* Assure la terminaison si le nom est trop long */
    if (i == MAX_ID - 1) {
        id[MAX_ID - 1] = '\0';
    }
}

void identifiant2(char *prenom, char *nom, char *id) {
    /* Première lettre du prénom en minuscule */
    id[0] = tolower(prenom[0]);

    /* Copie le nom en minuscules */
    int i;
    for (i = 0; i < MAX_ID - 1; i++) {
        id[i + 1] = tolower(nom[i]);
        /* Arrêt si fin de chaîne */
        if (nom[i] == '\0') {
            break;
        }
    }

    /* Assure la terminaison si le nom est trop long */
    if (i == MAX_ID - 1) {
        id[MAX_ID - 1] = '\0';
    }
}
