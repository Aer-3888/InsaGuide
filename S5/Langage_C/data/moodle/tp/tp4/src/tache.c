/*!
 * \file tache.c
 * \brief Implémentation des fonctions de gestion de tâches
 * \author ESM05 - Langage C
 * \date 2021
 */

#include "tache.h"

void saisieTache(Tache *t, FILE *f) {
    /* Lecture des attributs principaux */
    fscanf(f, "%d %d %d", &(t->no), &(t->duree), &(t->nbPred));

    /* Lecture des prédécesseurs */
    for (int i = 0; i < t->nbPred; i++) {
        fscanf(f, "%d", &(t->pred[i]));
    }

    /* Lecture du titre (jusqu'au saut de ligne) */
    /* %[^\n] lit tous les caractères jusqu'au \n (non inclus) */
    fscanf(f, " %[^\n]", t->titre);  /* Espace initial consomme les blancs */
}

void afficheTache(Tache *t) {
    printf("=========================\n");
    printf("Tâche n°%d: %s\n", t->no, t->titre);
    printf("Durée: %d heures\n", t->duree);
    printf("Nombre de prédécesseurs: %d\n", t->nbPred);

    if (t->nbPred > 0) {
        printf("Prédécesseurs: ");
        for (int i = 0; i < t->nbPred; i++) {
            printf("%d", t->pred[i]);
            if (i < t->nbPred - 1) {
                printf(", ");
            }
        }
        printf("\n");
    }
}

int lireTachesFichier(char *nomFichier, Tache *tab) {
    FILE *fichier;

    /* Ouverture du fichier en lecture */
    if ((fichier = fopen(nomFichier, "r")) == NULL) {
        fprintf(stderr, "Erreur d'ouverture du fichier %s\n", nomFichier);
        exit(1);
    }

    int i = 0;
    /* Lecture jusqu'à MAXTACHES ou fin de fichier */
    while (i < MAXTACHES && !feof(fichier)) {
        Tache t;
        saisieTache(&t, fichier);

        /* Vérification que la lecture a réussi */
        if (!feof(fichier)) {
            tab[i] = t;
            i++;
        }
    }

    /* Fermeture du fichier */
    if (fclose(fichier)) {
        fprintf(stderr, "Erreur à la fermeture du fichier\n");
    }

    return i;  /* Retourne le nombre de tâches lues */
}

void afficheTabTaches(Tache *tab_t, int nbtaches) {
    printf("\n========== LISTE DES TACHES ==========\n");
    for (int i = 0; i < nbtaches; i++) {
        afficheTache(&tab_t[i]);
    }
    printf("======================================\n");
}

int sommeDureeTotale(Tache *tab_t, int nbtaches) {
    int res = 0;
    for (int i = 0; i < nbtaches; i++) {
        res += tab_t[i].duree;
    }
    return res;
}

int ecrireTachesFichier(char *nomFichier, Tache *tab_t, int nbTaches) {
    FILE *fichier;

    /* Ouverture du fichier en écriture */
    if ((fichier = fopen(nomFichier, "w")) == NULL) {
        fprintf(stderr, "Erreur d'ouverture du fichier %s\n", nomFichier);
        return 0;
    }

    /* Écriture de chaque tâche */
    for (int i = 0; i < nbTaches; i++) {
        /* Écriture des attributs principaux */
        fprintf(fichier, "%d %d %d ", tab_t[i].no, tab_t[i].duree, tab_t[i].nbPred);

        /* Écriture des prédécesseurs */
        for (int j = 0; j < tab_t[i].nbPred; j++) {
            fprintf(fichier, "%d ", tab_t[i].pred[j]);
        }

        /* Écriture du titre */
        fprintf(fichier, " %s\n", tab_t[i].titre);
    }

    /* Fermeture du fichier */
    if (fclose(fichier)) {
        fprintf(stderr, "Erreur à la fermeture du fichier\n");
        return 0;
    }

    return 1;  /* Succès */
}
