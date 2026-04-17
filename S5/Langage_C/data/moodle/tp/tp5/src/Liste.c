//
// Created by marius on 16/10/2021.
//

#include <string.h>
#include "Liste.h"

void ajoutdeb(Liste * l, Tache t){
    Element * elem;
    elem = (Element *)calloc(1,sizeof (Element));
    elem->t = t;
    elem->suivant = (*l);
    *l = elem;
}

int nbelement(Liste l){
    int res =0;
    if(l == NULL){
        return res;
    }
    while((*l).suivant !=NULL){
        l = (*l).suivant;
        res++;
    }
    res++;
    return res;
}

void afficheListe(Liste l){
    while(l!=NULL){
        afficheTache(&((*l).t));
        l=(*l).suivant;
    }


}

void ajouttrield(Liste *l,Tache t){
    if((*l)==NULL){
        ajoutdeb(l,t);
        return;
    }

    int id = t.no;
    Element * act = (*l);
    Element * pre;

    while(id>(((*act).t).no)){
        pre = act;
        act = (*act).suivant;

        if(act==NULL){
            Element * elem = (Element *) calloc(1, sizeof(Element));
            elem->suivant=NULL;
            elem->t=t;
            (*pre).suivant=elem;
            return;
        }
    }

    Element * elem = (Element *) calloc(1, sizeof(Element));
    elem->suivant=act;
    elem->t=t;
    (*pre).suivant=elem;
}

void ajouttrie(Liste *l, Tache t, int (*ptrfonc)(Tache,Tache)){
    if((*l)==NULL || (*ptrfonc)((*l)->t,t)<0) {
        ajoutdeb(l,t);
        return;
    }
    Element * act = (*l);
    Element * pre;

    while((*ptrfonc)((*act).t,t) > 0){
        pre = act;
        act = (*act).suivant;
        if(act==NULL){
            Element * elem = (Element *) calloc(1, sizeof(Element));
            elem->suivant=NULL;
            elem->t=t;
            (*pre).suivant=elem;
            return;
        }
    }
    //pre = act;
    //act = (*act).suivant;

    Element * elem = (Element *) calloc(1, sizeof(Element));
    elem->suivant = act;
    elem->t=t;
    (*pre).suivant=elem;
}

//renvoi un truc positif si c est plus long que t
int  compareDuree(Tache t, Tache c){
    return (c.duree) - (t.duree) ;
}

int compareID(Tache t, Tache c){
    return (c.no) - (t.no);
}

int compareNom(Tache t, Tache c){
//    int i = 0;
//    while(t.titre[i]==c.titre[i]){
//        i++;
//    }
    int k;
    //= c.titre[i] - t.titre[i];
    k = strncmp((c.titre),(t.titre),64);
    return k;
    }