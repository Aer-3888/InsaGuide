% Quelques mains pour faire des tests manuels 
% main_test(+Identifiant, -Main) 

main_test( main_triee_une_paire, 	main(carte(sept,trefle), carte(valet,coeur), carte(dame,carreau), carte(dame,pique), carte(roi,pique))).
main_test( m2, 						main(carte(valet,_), carte(valet,coeur), carte(dame,carreau), carte(roi,coeur), carte(as,pique))). % Attention m2 avec inconnue représente plusieurs mains	 

main_test( main_triee_deux_paires,	main(carte(valet,trefle), carte(valet,coeur), carte(dame,carreau), carte(roi,coeur), carte(roi,pique))).
main_test( main_triee_brelan, 		main(carte(sept,trefle), carte(dame,carreau), carte(dame,coeur), carte(dame,pique), carte(roi,pique))).	
main_test( main_triee_suite,		main(carte(sept,trefle),carte(huit,pique),carte(neuf,coeur),carte(dix,carreau),carte(valet,carreau))).
main_test( main_triee_full,			main(carte(deux,coeur),carte(deux,pique),carte(quatre,trefle),carte(quatre,coeur),carte(quatre,pique))).

main_test( merreur1, 				main(carte(sep,trefle), carte(sept,coeur), carte(dame,pique), carte(as,trefle), carte(as,pique))).
main_test( merreur2, 				main(carte(sept,trefle), carte(sept,coeur), carte(dame,pique), carte(as,trefle))).


% Tests automatiques
 
tests :-
 	test(test_est_carte),
 	test(test_est_main),
 	test(test_inf_carte),
 	test(test_est_main_triee),
 	test(test_une_paire),
 	test(test_deux_paires),
 	test(test_brelan),
 	test(test_suite),
 	test(test_full),
  	test(test_carre),
 	test(test_suite_royale).

test_est_carte :-
	assert_true( est_carte(carte(dix,pique)) ),
	assert_false( est_carte(carte(10,pique)) ),
	assert_false( est_carte(carte(pique,dix)) ),
	assert_true( (findall(Carte,est_carte(Carte),L), length(L,52)) ). 

test_est_main :-
	assert_true( est_main(main(carte(as,trefle), carte(as,carreau), carte(as,coeur), carte(as,pique), carte(roi,coeur))) ),
	assert_false( est_main(main(carte(as,trefle), carte(as,carreau), carte(as,coeur), carte(as,carreau), carte(roi,coeur))) ),
	assert_false( est_main(main(as, roi, dame, valet, dix)) ).

test_inf_carte :-
    assert_true( inf_carte(carte(quatre,coeur), carte(cinq,coeur)) ),
    assert_true( inf_carte(carte(quatre,coeur), carte(dix,coeur)) ),
    assert_true( inf_carte(carte(quatre,coeur), carte(quatre,pique)) ),
    assert_true( inf_carte(carte(quatre,trefle), carte(quatre,pique)) ),
    assert_true( inf_carte(carte(quatre,trefle), carte(dix,pique)) ),
    assert_false( inf_carte(carte(cinq,cinq), carte(six,six)) ),
    assert_true( sortall(C,inf_carte(C,carte(trois,trefle)), [carte(deux, carreau), carte(deux, coeur), carte(deux, pique), carte(deux, trefle)]) ).

test_est_main_triee :-
	assert_true( est_main_triee(main(carte(valet,trefle), carte(valet,coeur), carte(dame,carreau), carte(roi,coeur), carte(roi,pique))) ),
	assert_true( est_main_triee(main(carte(sept,trefle), carte(dame,carreau), carte(dame,coeur), carte(dame,pique), carte(roi,pique))) ),	
	assert_true( est_main_triee(main(carte(sept,trefle),carte(huit,pique),carte(neuf,coeur),carte(dix,carreau),carte(valet,carreau))) ),
	assert_true( est_main_triee(main(carte(deux,coeur),carte(deux,pique),carte(quatre,trefle),carte(quatre,coeur),carte(quatre,pique))) ),
	assert_false( est_main_triee(main(carte(deux,coeur),carte(quatre,trefle))) ),
	assert_false( est_main_triee(main(carte(deux,pique),carte(deux,coeur),carte(quatre,trefle),carte(quatre,coeur),carte(quatre,pique))) ).

test_une_paire :-
	assert_true( une_paire(main(carte(valet,trefle), carte(valet,coeur), carte(dame,carreau), carte(roi,coeur), carte(as,pique))) ),
	assert_false( une_paire(main(carte(valet,coeur), carte(valet,trefle), carte(dame,carreau), carte(roi,coeur), carte(as,pique))) ),
	assert_false( une_paire(main(carte(dix,trefle), carte(valet,coeur), carte(dame,carreau), carte(roi,coeur), carte(as,pique))) ).

test_deux_paires :-
	assert_true( deux_paires(main(carte(valet,trefle), carte(valet,coeur), carte(dame,carreau), carte(roi,coeur), carte(roi,pique))) ),
	assert_false( deux_paires(main(carte(dame,carreau), carte(valet,trefle), carte(valet,coeur), carte(roi,coeur), carte(roi,pique))) ).

test_brelan :-
	assert_true( brelan(main(carte(sept,trefle), carte(dame,carreau), carte(dame,coeur), carte(dame,pique), carte(roi,pique))) ),
	assert_false( brelan(main(carte(sept,trefle), carte(dame,coeur), carte(dame,carreau), carte(dame,pique), carte(roi,pique))) ).

test_suite :-
	assert_true( suite(main(carte(sept,trefle), carte(huit,pique), carte(neuf,coeur), carte(dix,carreau), carte(valet,carreau))) ),
	assert_false( suite(main(carte(sept,trefle), carte(huit,pique), carte(neuf,coeur), carte(dix,carreau), carte(dame,carreau))) ).

test_full :-
	assert_true( full(main(carte(deux,coeur), carte(deux,pique), carte(quatre,trefle), carte(quatre,coeur), carte(quatre,pique))) ),
	assert_false( full(main(carte(deux,coeur), carte(quatre,trefle), carte(quatre,carreau), carte(quatre,coeur), carte(quatre,pique))) ),
	assert_true( (findall(M,full(M),L), length(L,3744)) ).

test_carre :-
	assert_true( carre(main(carte(dame,trefle), carte(dame,carreau), carte(dame,coeur), carte(dame,pique), carte(as,coeur))) ),
	assert_true( (findall((A,B,C,D),carre(main(carte(deux,pique),A,B,C,D)),L), length(L,12)) ).

test_suite_royale :-
	assert_true( suite_royale(main(carte(dix,coeur), carte(valet,coeur), carte(dame,coeur), carte(roi,coeur), carte(as,coeur))) ),
	assert_true( (findall(M,suite_royale(M),L), length(L,4)) ).

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
