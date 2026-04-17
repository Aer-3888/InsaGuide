#include <stdio.h>
#include <stdlib.h>

#define N 10

//définition du type Action
typedef enum {
	AVANCER,
	TOURNERG,
	TOURNERD
} Action;

//définition du type Ordre
typedef struct {
	unsigned long timestamp;
	Action act;
} Ordre;

//définition du type Direction
typedef enum {
	NORD,
	OUEST,
	SUD,
	EST
} Direction;


//définition du type Mobile
struct Mobile {
	int pos_i;
	int pos_j;
	Direction dir;
};
typedef struct Mobile Mobile;

//prototypes des fonctions
void afficherMobile(Mobile m);
int avancer(Mobile * p_m);
int tournerGauche(Mobile * p_m);
int tournerDroite(Mobile * p_m);

/* Implementation de la fontion afficheMobile: decommenter et compléter*/

void afficherMobile(Mobile m){
    printf("le mobile est en (%d,%d)\n", m.pos_i, m.pos_j);
}

/* Implementation de la fonction avancer: a étudier */
int avancer(Mobile * p_m){
    switch(p_m->dir)
    {
        case NORD :
            {
                if(p_m->pos_i>0)
                    p_m->pos_i --;
                else return 0;
                break;
            }
        case SUD :
            {
                if(p_m->pos_i<(N-1))
                    p_m->pos_i ++;
                else return 0;
                break;
            }
        case EST :
            {
                if(p_m->pos_j<(N-1))
                    p_m->pos_j ++;
                else return 0;
                break;
            }
        case OUEST :
            {
                if(p_m->pos_j>0)
                    p_m->pos_j --;
                else return 0;
                break;
            }
         default : printf ("Direction inconnue dans avancer\n");
                    return 0;
    }
    return 1;
}

/* Implementation des fonctiosn tournerGauche et tournerDRoite : à faire */
int tournerGauche(Mobile* m) {
	switch (m->dir) {
		case NORD: {
				   m->dir = OUEST;
				   break;
			   }
		case OUEST: {
				    m->dir = SUD;
				    break;
			    }
		case SUD: {
				  m->dir = EST;
				  break;
			  }
		case EST: {
				  m->dir = NORD;
				  break;
			  }
		default: {
				 printf("Unknown direction for rotation");
				 return 0;
			 }
	}
	return 1;
}

int tournerDroite(Mobile* m) {
	switch (m->dir) {
		case NORD: {
				   m->dir = EST;
				   break;
			   }
		case OUEST: {
				    m->dir = NORD;
				    break;
			    }
		case SUD: {
				  m->dir = OUEST;
				  break;
			  }
		case EST: {
				  m->dir = SUD;
				  break;
			  }
		default: {
				 printf("Unknown direction for rotation");
				 return 0;
			 }
	}
	return 1;
}
int donnerOrdre(Ordre o, Mobile* m);
/* Programme principal */
int main()
{
    Ordre ordre0={0,AVANCER};
    Ordre ordre1={1,TOURNERD};
    Ordre ordre2={2,AVANCER};
    Mobile mobileM ={0,1,EST};
    afficherMobile(mobileM);
    donnerOrdre(ordre0,&mobileM);
    afficherMobile(mobileM);
    donnerOrdre(ordre1,&mobileM);
    afficherMobile(mobileM);
    donnerOrdre(ordre2,&mobileM);
    afficherMobile(mobileM);
    return 0;
}

int donnerOrdre(Ordre o, Mobile* m)
{
	// Inspect the order
	switch (o.act) {
		case AVANCER: {
				      return avancer(m);
			      }
		case TOURNERD: {
				       return tournerDroite(m);
			       }
		case TOURNERG: {
				       return tournerGauche(m);
			       }
		default: {
				 printf("Unknown order.\n");
				 return 1;
			 }
	}
}

