#include <stdio.h>
#include <stdlib.h>

#define FILE_MAX 32

#define NB_ELEVES_MAX 100

float* lecturedeuxfois(void);

int main() {
    // Gonna do some realloc nonsense
    float* notes = (float*)malloc(sizeof(float));
    float* tmpnotes = NULL;
    float note_temp[] = {0.0};
    int i;
    int nb_notes;
    float moy;
    char nom_fichier[FILE_MAX];
    FILE * ptr_fic = NULL;

    if (notes == NULL)
	    return -1;

    /*lecture des notes dans un fichier*/
    printf("Tapez le nom du fichier de notes :\n");
    scanf("%s",nom_fichier);

    /*ouverture du fichier de notes*/
    ptr_fic = fopen(nom_fichier, "r");

    /*lecture des notes dans le fichier et stockage dans le tableau*/
    i = 0;
    // Compress everything into a single line
    // Check that we still have room to add grades, i.e.
    // that the scanning index is below the maximum number of students
    // Secondly, if fscanf reaches the end of the file, it will return a negative
    // value. This can be exploited to know when the end of the grade sis reached (assuming correct format on every line).
    // Finally, all is sent to NULL, because we're just counting.
    while (i < NB_ELEVES_MAX && fscanf(ptr_fic, "%f", note_temp) >= 0) {
	    i++;
	    printf("%d*%d=%d\n", i, sizeof(float), i*sizeof(float));
	    if ((tmpnotes = (float*)realloc(notes, i*sizeof(float))) == NULL) {
		    free(notes);
		    notes = NULL;
		    return -1;
	    } else {
		    notes = tmpnotes;
		    notes[i-1] = note_temp[0];
	    }
    }
    // Since i was a scanning index, it's moved exactly as many times
    // as we've loaded in grades
    nb_notes = i;

    /*fermeture du fichier*/
    fclose(ptr_fic);
    
    /*afficher le tableau de notes sur une ligne*/
    printf("voici le tableau de notes :\n");
    for(i=0 ; i<nb_notes ; ++i)
        printf("%.1f ",notes[i]);
    printf("\n");

    /*calcul de la moyenne*/
    moy = notes[0];
    printf("%d\n", nb_notes);
    for(i=1 ; i<nb_notes ; ++i)
        moy += notes[i];
    moy /= nb_notes;

    printf("Tapez le nom du fichier où écrire la moyenne:\n");
    scanf("%s",nom_fichier);

    /*ouverture du fichier*/
    ptr_fic = fopen(nom_fichier, "w");

    /*écriture du résultat dans un fichier*/
    fprintf(ptr_fic, "%.1f\n", moy);

    /*fermeture du fichier*/
    fclose(ptr_fic);
    free(notes);
    notes = tmpnotes = NULL;

    return 0;
}
