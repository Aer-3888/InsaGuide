%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Quelques arbres binaires à copier-coller pour faire des tests manuels
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* 

arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))

arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))

arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)))

arb_bin(3, arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)), arb_bin(4, vide, vide))

arb_bin(3, arb_bin(6, vide, vide), arb_bin(5, arb_bin(4, vide, vide), arb_bin(7, vide, vide)))

arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide))

arb_bin(8, arb_bin(4, arb_bin(2, _, _), arb_bin(6, _, _)), arb_bin(12, arb_bin(10, _, _), _))

arb_bin(6, arb_bin(2, arb_bin(1,vide,vide), arb_bin(4,vide,vide)), arb_bin(8, vide, arb_bin(10,vide,vide)))

arb_bin(8, arb_bin(2, arb_bin(1,vide,vide), arb_bin(4,vide,vide)), arb_bin(6, vide, arb_bin(10,vide,vide)))

arb_bin(6, arb_bin(2, arb_bin(1,vide,vide), arb_bin(4,vide,vide)), arb_bin(8, arb_bin(2, arb_bin(1,vide,vide), arb_bin(4,vide,vide)), arb_bin(10,vide,vide)))

arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, 7, vide))		% Arbre non binaire 

*/

% Tests automatiques

tests :-
	test( test_arbre_binaire ),
	test( test_dans_arbre_binaire ),
	test( test_sous_arbre_binaire ),
	test( test_remplacer ),
	test( test_isomorphes ),
	test( test_infixe ),    
 %	test( test_prefixe ),
 %	test( test_postfixe ),
 	test( test_insertion_abr ),
 	true.

test_arbre_binaire :-
	assert_true( arbre_binaire(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))) ),  % arbre_binaire(+B) : vérification B arbre binaire
	assert_false( arbre_binaire(arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, 7, vide))) ). % arbre_binaire(+B)) : vérification B non arbre binaire

test_dans_arbre_binaire :-
	assert_true( dans_arbre_binaire(6,arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))) ), % dans_arbre_binaire(+E, +B) : vérification dans_arbre_binaire
	assert_false( dans_arbre_binaire(12, arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide)))) ). % dans_arbre_binaire(+E, +B) : vérification absent 

test_sous_arbre_binaire :-
	assert_true( sous_arbre_binaire(arb_bin(4, vide, vide),arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(7, vide, vide), vide))) ),  % sous_arbre_binaire(+S, +B)  : vérification sous_arbre_binaire
	assert_false( sous_arbre_binaire(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))),arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(8, vide,vide), vide))) ),  % sous_arbre_binaire(+S, +B)  : vérification non sous_arbre_binaire
	assert_true( sous_arbre_binaire(arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)), arb_bin(6,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(8,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(10,vide,vide)))) ),  % sous_arbre_binaire(+S, +B)  : vérification sous_arbre_binaire
	assert_false( sous_arbre_binaire(arb_bin(4, vide, vide), arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide))) ).  % sous_arbre_binaire(+S, +B)  : vérification non sous_arbre_binaire

test_remplacer :-
	assert_true( findall(B, remplacer(arb_bin(4, vide, vide), arb_bin(7, arb_bin(5, vide, vide), vide), arb_bin(6,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(8,arb_bin(2,arb_bin(1,vide,vide),arb_bin(4,vide,vide)),arb_bin(10,vide,vide))), B), [arb_bin(6, arb_bin(2, arb_bin(1, vide, vide), arb_bin(7, arb_bin(5, vide, vide), vide)), arb_bin(8, arb_bin(2, arb_bin(1, vide, vide), arb_bin(7, arb_bin(5, vide, vide), vide)), arb_bin(10, vide, vide)))]) ).    % remplacer(+SA1, +SA2, +B, -B1)

test_isomorphes :-
	assert_true( isomorphes(arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide))), arb_bin(3, arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide)), arb_bin(4, vide, vide))) ), % isomorphes(+B1, +B2) : vérification isomorphes inversion 1er niveau
	assert_true( isomorphes(arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide))), arb_bin(3, arb_bin(5, arb_bin(7, vide, vide), arb_bin(6, vide, vide)), arb_bin(4, vide, vide))) ), % isomorphes(+B1, +B2) : vérification isomorphes où tout est symétrique
	assert_false( isomorphes(arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, arb_bin(6, vide, vide), arb_bin(7, vide, vide))), arb_bin(3, arb_bin(6, vide, vide), arb_bin(5, arb_bin(4, vide, vide), arb_bin(7, vide, vide)))) ). % isomorphes(+B1, +B2) : vérification non isomorphes 

test_infixe :-
	assert_true( findall(L, infixe(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))), L), [[6, 2, 1, 4, 3, 5]]) ).    % infixe(+B, -L)

test_prefixe :-
	assert_true( findall(L, prefixe(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))), L), [[1, 2, 6, 3, 4, 5]]) ).    % prefixe(+B, -L)

test_postfixe :-
	assert_true( findall(L, postfixe(arb_bin(1, arb_bin(2, arb_bin(6, vide, vide), vide), arb_bin(3, arb_bin(4, vide, vide), arb_bin(5, vide, vide))), L), [[6, 2, 4, 5, 3, 1]]) ).    % postfixe(+B, -L)

    
test_insertion_abr :-
	assert_true( findall(B, insertion_abr(9,arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, vide, vide), vide)), B), [arb_bin(8, arb_bin(4, arb_bin(2, vide, vide), arb_bin(6, vide, vide)), arb_bin(12, arb_bin(10, arb_bin(9, vide, vide), vide), vide))]) ).    % insertion_abr(+X, +B1, -B2)

/* Outils auxiliaires pour les tests. */

% SortedList donne la liste triee de toutes les solutions de Term dans le but Goal 
sortall(Term, Goal, SortedList) :-
	findall(Term, Goal, List),
	msort(List, SortedList).
	
% N donne le nombre de solutions de Term dans le but Goal 
countall(Term, Goal, N) :-
	findall(Term, Goal, List),
	length(List, N).

% Teste la propriete P et affiche ensuite "OK : P" ou "echec : P"
% (pour un test unitaire, càd un bloc de clauses à vérifier)
test(P) :- P, !, print_resul("OK", P).
test(P) :- print_resul("echec", P), fail.

% Assertions sur une propriété P qui n'affichent quelque chose que si non vérifiées
% (pour une clause au sein d'un test unitaire)
assert_true(P) :- P, !.
assert_true(P) :- print_resul("echec", P), fail.

assert_false(P) :- assert_true(not(P)).

% Affiche un texte suivi du but concerné
print_resul(Msg, Goal) :- write(Msg), write(" : "), writeln(Goal).

% Fin des tests
