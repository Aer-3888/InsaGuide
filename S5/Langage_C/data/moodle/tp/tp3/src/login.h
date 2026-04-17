/*!
 * \file login.h
 * \brief Module de génération d'identifiants
 * \author ESM05 - Langage C
 * \date 2021
 */

#ifndef LOGIN_H
#define LOGIN_H

#include <ctype.h>

#define MAX_NOM 255  /* Taille maximale pour nom/prénom */
#define MAX_ID 10    /* Taille maximale pour l'identifiant */

/*!
 * \brief Génère un identifiant: première lettre du prénom + nom
 *
 * Format: Pnom (ex: Jean Dupont → Jdupont)
 * Respecte la casse originale.
 *
 * \param prenom Le prénom
 * \param nom Le nom de famille
 * \param id Le tableau pour stocker l'identifiant (sortie)
 */
void identifiant(char prenom[], char nom[], char id[]);

/*!
 * \brief Génère un identifiant en minuscules
 *
 * Format: pnom (ex: Jean Dupont → jdupont)
 * Convertit tout en minuscules.
 *
 * \param prenom Le prénom
 * \param nom Le nom de famille
 * \param id Le tableau pour stocker l'identifiant (sortie)
 */
void identifiant2(char prenom[], char nom[], char id[]);

#endif /* LOGIN_H */
