#include "automaton.h"
#include <stdio.h>
#include <string.h>

/* Constants */
const char* chIndi = " 0 @%*[^@]@ INDI%[ \r\n ]";
const char* chName = " 1 NAME %*[^/\r\n]/%[^/]/%[ \r\n]";
const char* chSabo = " 1 OCCU %[^\r\n]%[ \r\n]";
const char* needle = "sabotier";
/* They cannot be put in automaton.h because principal.c imports them */

int rechercheNomSabotiers(char* str) {
	static EtatAutomate etatA = {EINIT, ""};
	static int cpt = 0;

	int res;
	char trash[TMAX];	/* end of lines storage area */
	char extract[TMAX];	/* storage for actually useful data */

	switch (etatA.etat) {
		case EINIT: {
				    /* Detection of the individuals */
				    res = sscanf(str, chIndi, trash);
				    if (res == 1) {
					    etatA.etat = EINDI;
				    }
				    break;
			    }
		case EINDI: {
				    /* Complete it thyself */
				    /* From EINDI, there's only one way
				     * out, and that's finding a name
				     */
				    res = sscanf(str, chName, extract, trash);
				    if (res == 2) {
					    etatA.etat = ENAME;
					    /* Copy at most TMAX chars */
					    /* This should prevent a buffer overflow */
					    strncpy(etatA.nom, extract, TMAX);
				    }
				    break;
			    }
		case ENAME:
			    {
				    /* Try and find a person */
				    res = sscanf(str, chIndi, trash);
				    if (res == 1) {
					    etatA.etat = EINDI;
				    } else {
					    /* complete it thyself */
					    /* Try for an OCCU tag */
					    res = sscanf(str, chSabo, extract, trash);
					    if (res == 2 && strstr(extract, needle) != NULL) {
						    /* ding ding ding
						     * we got a sabotier
						     */
						    printf("%s\n", etatA.nom);
						    etatA.etat = EINIT;
					    }
				    }
				    /* kinda useless break but why not */
				    break;
			    }
	}
}

/* Question 24 : what is the complete name of the variable that strores the name of an individual in the automaton ?
 *
 * It is etatA.nom (of type char[TMAX] within a struct of type EtatAutomate ) 
 *
 *
 * Question 25 : What state transitions are already programmed for the automaton in the code first provided above ?
 *
 * With the code given above, we can already transition from the initial state (EINIT) to the state where an individual was found (EINDI), and transition from the state where we are looking for an OCCU tag but have found a name already (ENAME) to the state where we find another, new person (EINDI).
 * We are missing a transition from ENAME to EINIT and a transition from EINDI to ENAME.
 *
 *
 * Question 26 : Write automate.h and modify principal.c to test this function.
 *
 * Questoin 27 : Complete the provided code to display the name of people whose occupation title contains the word 'sabotier'.
 */
