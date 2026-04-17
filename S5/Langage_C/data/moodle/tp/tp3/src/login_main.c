/*!
 * \file login_main.c
 * \brief Programme principal pour générer des identifiants
 * \author ESM05 - Langage C
 * \date 2021
 */

#include <stdio.h>
#include "login.h"

int main() {
    char nom[MAX_NOM];
    char prenom[MAX_NOM];
    char id[MAX_ID];

    /* Saisie du nom et du prénom */
    printf("Entrez un nom : \n");
    scanf("%s", nom);

    printf("Entrez un prenom : \n");
    scanf("%s", prenom);

    /* Génération de l'identifiant en minuscules */
    identifiant2(prenom, nom, id);

    printf("Voici votre ID : %s\n", id);

    /* Test de la version avec casse originale */
    char id_original[MAX_ID];
    identifiant(prenom, nom, id_original);
    printf("Version avec casse originale : %s\n", id_original);

    return 0;
}
