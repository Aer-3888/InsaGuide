/*!
 * \file main.c
 * \brief Programme principal de gestion de tâches
 * \author ESM05 - Langage C
 * \date 2021
 */

#include <stdio.h>
#include "tache.h"

int main() {
    Tache tabTaches[MAXTACHES];
    int nbLignes;

    char monfichier[] = "taches.txt";
    char monfichierDest[] = "taches_out.txt";

    /* Lecture des tâches depuis le fichier */
    printf("Lecture du fichier %s...\n", monfichier);
    nbLignes = lireTachesFichier(monfichier, tabTaches);
    printf("Nombre de tâches lues: %d\n", nbLignes);

    /* Affichage des tâches */
    afficheTabTaches(tabTaches, nbLignes);

    /* Calcul de la durée totale */
    int dureeTotal = sommeDureeTotale(tabTaches, nbLignes);
    printf("\nDurée totale: %d heures\n", dureeTotal);

    /* Écriture dans un nouveau fichier */
    printf("\nÉcriture dans %s...\n", monfichierDest);
    if (ecrireTachesFichier(monfichierDest, tabTaches, nbLignes)) {
        printf("Écriture réussie!\n");
    } else {
        printf("Erreur lors de l'écriture.\n");
    }

    return 0;
}
