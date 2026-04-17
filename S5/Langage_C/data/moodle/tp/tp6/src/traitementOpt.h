#ifndef TRAITEMENTOPT_H_INCLUDED
#define TRAITEMENTOPT_H_INCLUDED

#include <stdio.h>
#include <stdlib.h>

#include "commun.h" /* Some definitions, including TMAX */

/* Counting structure */
typedef struct {
	char* modele;
	char* message;
	unsigned int compteur;
} Comptage;

int compterIndividu(char* str);
int compterSex(char* str);
int compterFemmes(char* str);
int compterNaissances(char* str);

#endif
