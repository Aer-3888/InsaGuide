/*!
 * \file tache.h
 * \brief Module de gestion de tâches pour la planification de projets
 * \author ESM05 - Langage C
 * \date 2021
 */

#ifndef TACHE_H
#define TACHE_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define LGMAX 64        /* Longueur maximum du titre */
#define NMAXPRED 16     /* Nombre maximum de prédécesseurs */
#define MAXTACHES 64    /* Nombre maximum de tâches */

/*!
 * \struct Tache
 * \brief Structure représentant une tâche de projet
 */
typedef struct {
    int no;              /* Numéro d'identification de la tâche */
    int duree;           /* Durée de la tâche (en heures) */
    int nbPred;          /* Nombre effectif de prédécesseurs */
    int pred[NMAXPRED];  /* Tableau des numéros de prédécesseurs */
    char titre[LGMAX];   /* Titre/description de la tâche */
} Tache;

/*!
 * \brief Lit une tâche depuis un fichier
 *
 * Format attendu: <no> <duree> <nbPred> [<pred1> <pred2> ...] <titre>
 *
 * \param t Pointeur vers la tâche à remplir
 * \param f Fichier ouvert en lecture
 */
void saisieTache(Tache *t, FILE *f);

/*!
 * \brief Affiche les informations d'une tâche
 *
 * \param t Pointeur vers la tâche à afficher
 */
void afficheTache(Tache *t);

/*!
 * \brief Lit toutes les tâches d'un fichier
 *
 * Lit jusqu'à MAXTACHES ou jusqu'à la fin du fichier.
 *
 * \param nomFichier Nom du fichier à lire
 * \param tab Tableau pour stocker les tâches
 * \return Le nombre de tâches lues
 */
int lireTachesFichier(char *nomFichier, Tache *tab);

/*!
 * \brief Affiche un tableau de tâches
 *
 * \param tab_t Tableau de tâches
 * \param nbtaches Nombre de tâches dans le tableau
 */
void afficheTabTaches(Tache *tab_t, int nbtaches);

/*!
 * \brief Calcule la durée totale de toutes les tâches
 *
 * Note: Ceci est la somme simple, pas le chemin critique!
 *
 * \param tab_t Tableau de tâches
 * \param nbtaches Nombre de tâches
 * \return La somme des durées
 */
int sommeDureeTotale(Tache *tab_t, int nbtaches);

/*!
 * \brief Écrit les tâches dans un fichier
 *
 * \param nomFichier Nom du fichier de sortie
 * \param tab_t Tableau de tâches
 * \param nbTaches Nombre de tâches à écrire
 * \return 1 si succès, 0 si erreur
 */
int ecrireTachesFichier(char *nomFichier, Tache *tab_t, int nbTaches);

#endif /* TACHE_H */
