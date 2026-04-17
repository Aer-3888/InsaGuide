#ifndef AUTOMATON_H
#define AUTOMATON_H

#include "commun.h"

/* The finite states of the automaton */
typedef enum {
	EINIT,
	EINDI,
	ENAME
/*	NBETAT*/
} Etat;

/* Automaton state */
typedef struct {
	Etat etat;
	char nom[TMAX];
} EtatAutomate;

/* Simple methods */
int rechercheNomSabotiers(char* str);

#endif
