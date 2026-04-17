#ifndef VILLE_H
#define VILLE_H

#include <stdio.h>

#define CHAINE 50

typedef struct structville {
  char departement[3]; // Numero du departement (char a cause des departements 2A et 2B)
  char departementNom[CHAINE]; 
  char region[CHAINE]; // Nom de la region de la ville
  char nom[CHAINE]; // Nom en majuscule de la ville
  char nomReel[CHAINE]; // Nom avec Accent
  char codeCommune[CHAINE]; // Code de la commune INSEE numero departement+id commune
	/*
	 * statut
	 * -1 ville ayant disparu au dernier recensement
	 * 0 commune
	 * 1 chef-lieu de canton
	 * 2 sous prefecture
	 * 3 prefecture
	 * 4 chef lieu de region
	 */
  int statut;
  int arrondissement; // Numero de arrondissement (responsabilite de la sous prefecture)
char arrondissementNom[CHAINE]; // Souvent le nom du chef lieu
char cantonNom[CHAINE]; // Souvent le nom du chef lieu
 int canton; // Identifiant du canton (regroupement de commune)
 int population2010;	// Population de la ville en 2010
 int population1999;	// Population de la ville en 1999
 int population2012;	// Population de la ville en 2012 arrondi a la 100 inferieure
 int densite;				// Densite de population rapport population sur superficie
 int surface;				// Superficie de la ville en hectometre carre
 double longitude;		// longitude en degre
 double latitude;		// latitude en degre
 int altitudeMin;		// Altitude minimale de la ville
 int altitudeMax;		// Altitude maximale de la ville
} Ville;

  Ville convertir(char *);

void affiche(Ville*);

#endif
