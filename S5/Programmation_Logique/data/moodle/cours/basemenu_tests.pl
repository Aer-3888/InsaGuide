% Tests automatiques

tests :-
	test( test_plat ),
	test( test_repas ),
	test( test_plat_200_400 ),
	test( test_plat_plus_bar ),
	test( test_val_cal ),
	test( test_repas_eq ).

test_plat :-
	assert_true( plat(grillade_de_boeuf) ),
	assert_true( plat(saumon_oseille) ),
	assert_false( plat(artichauts_Melanie) ),
	assert_false( plat(sorbet_aux_poires) ).

test_repas :-
	assert_true( repas(cresson_oeuf_poche, poulet_au_tilleul, fraises_chantilly) ),
	assert_false( repas(melon_en_surprise, poulet_au_tilleul, fraises_chantilly) ).

test_plat_200_400 :-
	assert_true( sortall(P, plat_200_400(P), [bar_aux_algues, poulet_au_tilleul, saumon_oseille]) ).

test_plat_plus_bar :-
	assert_true( sortall(P, plat_plus_bar(P), [grillade_de_boeuf, poulet_au_tilleul]) ).

test_val_cal :-
	assert_true( val_cal(cresson_oeuf_poche, poulet_au_tilleul, fraises_chantilly, 901) ),
	assert_false( val_cal(truffes_sous_le_sel, grillade_de_boeuf, sorbet_aux_poires, 901) ).

test_repas_eq :-
	assert_true( repas_eq(artichauts_Melanie, saumon_oseille, fraises_chantilly) ),
	assert_false( repas_eq(truffes_sous_le_sel, grillade_de_boeuf, sorbet_aux_poires) ).

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
