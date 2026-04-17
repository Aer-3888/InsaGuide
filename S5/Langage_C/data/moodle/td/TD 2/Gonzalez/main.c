// Ecrire une fonction qui concatène 2 chaînes de caractères dans une troisième chaine passée en paramètre
// Faire une version basée sur l'allocation statique une autre sur l'allocation dynamique

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* concatstat(char* s1, char* s2, char* s3, unsigned int bufflen) {
	//unsigned int catstr = strlen(s1) + strlen(s2);
	unsigned int len1 = strlen(s1);
	unsigned int len2 = strlen(s2);
	unsigned int scan_index = 0;
	if (s1 == NULL || s2 == NULL || s3 == NULL) {
		return NULL;
	}
	for (scan_index = 0; scan_index < bufflen && scan_index < len1; scan_index++)
		s3[scan_index] = s1[scan_index];
	for ( ; scan_index < bufflen && scan_index-len1 < len2 ; scan_index++ ) {
		s3[scan_index] = s2[scan_index-len1];
	}
	if (scan_index < bufflen)
		s3[scan_index] = '\0';
	return s3;
}

char* concatdyn(char* s1, char* s2, char* s3, unsigned int bufflen) {
	unsigned int len1 = strlen(s1);
	unsigned int len2 = strlen(s2);
	unsigned int scan_index = 0;
	if (s1 == NULL || s2 == NULL) {
		return NULL;
	}
	if (len1+len2 >= bufflen) {
		if ((s3 = (char*)realloc(s3, len1+len2+1)) == NULL)
			return NULL; // Oh fuck
		else {
			// Initialize the fuck out of it
			for (scan_index = 0 ; scan_index < len1+len2+1 ; scan_index++)
				// Wipe go brrr
				s3[scan_index] = '\0';
		}
	}

	for (scan_index = 0; scan_index < len1; scan_index++)
		s3[scan_index] = s1[scan_index];
	for ( ; scan_index-len1 < len2 ; scan_index++ ) {
		s3[scan_index] = s2[scan_index-len1];
	}
	s3[scan_index] = '\0';
	return s3;
}

int main() {
	char s1[] = "moop";
	char s2[] = "merp";
	char s3[5];
	char* s4 = (char*)malloc(1);

	concatstat(s1, s2, s3, 5);
	printf("%s\n", s3);
	s4 = concatdyn(s1, s2, s4, 1);
	printf("%s\n", s4);
	free(s4);
	return 0;
}
