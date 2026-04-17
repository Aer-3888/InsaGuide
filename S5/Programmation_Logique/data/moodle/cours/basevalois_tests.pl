% Tests automatiques

tests :-
	test( test_enfant ),
	test( test_parent ),
	test( test_grand_pere ),
	test( test_frere ),
	test( test_oncle ),
	test( test_cousin ),
	test( test_le_roi_est_mort_vive_le_roi ),
	test( test_ancetre ).

test_enfant :-
	assert_true( enfant(claude_de_france, louis_XII) ),
	assert_true( enfant(charles_VII, charles_VI) ),
	assert_false( enfant(charles_VIII, charles_VI) ),
	assert_false( enfant(valentine_de_milan, charles_VII) ).

test_parent :-
	assert_true( parent(louis_XII, claude_de_france) ),
	assert_false( parent(anne_de_Bretagne, francois_I) ),
	assert_true( sortall(P, parent(P,louis_d_Orleans), [charles_V, jeanne_de_Bourbon]) ).

test_grand_pere :-
	assert_true( grand_pere(louis_d_Orleans, charles_d_angouleme) ),
	assert_false( grand_pere(louis_XI, charles_d_angouleme) ),
	assert_true( sortall(E, grand_pere(louis_d_Orleans,E), [charles_d_angouleme, louis_XII]) ).

test_frere :-
	assert_true( frere(francois_II, charles_IX) ),
	assert_true( sortall(F, frere(charles_IX,F), [francois_II, henri_III]) ).

test_oncle :-
	assert_true( oncle(charles_VI, jean_d_angouleme) ),
	assert_false( oncle(louis_d_Orleans, louis_XII) ),
	assert_true( sortall(N, oncle(charles_VI,N), [charles_d_Orleans, jean_d_angouleme]) ).

test_cousin :-
	assert_true( cousin(jean_d_angouleme,charles_VII) ),
	assert_false( cousin(charles_IX, henri_III) ),
	assert_true( sortall(C, cousin(charles_VII,C), [charles_d_Orleans, jean_d_angouleme]) ).

test_le_roi_est_mort_vive_le_roi :-
	assert_true( le_roi_est_mort_vive_le_roi(charles_VI, 1422, charles_VII) ),
	assert_false( le_roi_est_mort_vive_le_roi(charles_VI, 1421, charles_VII) ).

test_ancetre :-
	assert_true( ancetre(charles_V, charles_VII) ),
	assert_false( ancetre(charles_VII, charles_V) ),
	assert_true( sortall(A, ancetre(A,louis_d_Orleans), [bonne_de_luxembourg, charles_V, charles_de_Valois, jean_II, jeanne_de_Bourbon, jeanne_de_Bourgogne, philippe_VI]) ).

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
