% Tests

tests :-
	test( test_make_all_pairs_1 ),
	test( test_make_all_pairs_2 ),
	test( test_make_all_pairs_3 ),
	test( test_make_all_pairs_4 ),
	test( test_make_all_pairs_5 ),
	test( test_subpart_1 ),
	test( test_subpart_2 ),
	test( test_subpart_3 ),
	test( test_subpart_4 ),
	test( test_proposition1_1 ),
	test( test_proposition1_2 ),
	test( test_proposition1_3 ),
	test( test_proposition1_4 ),
	test( test_proposition2_1 ),
	test( test_proposition2_2 ),
	test( test_proposition2_3 ),
	test( test_proposition3_1 ),
	test( test_proposition3_2 ),
	test( test_proposition3_3 ),
	test( test_proposition4_1 ),
	test( test_proposition4_2 ),
	test( test_proposition4_3 ),
	test( test_proposition4_4 ),
	test( test_proposition4_5 ),
	test( test_proposition5_1 ),
	test( test_proposition5_2 ),
	test( test_proposition5_3 ),
	test( test_proposition5_4 ),
	test( test_proposition6_1 ),
	test( test_proposition6_2 ),
	test( test_proposition6_3 ),
	test( test_proposition6_4 ),
	test( test_proposition6_5 ),
	test( test_proposition7_1 ),
	test( test_proposition7_2 ),
	test( test_proposition7_3 ),
	test( test_proposition7_4 ),
	test( test_possible_world_1 ),
	test( test_possible_world_2 ),
	test( test_possible_world_3 ),
	test( test_possible_world_4 ),
	test( test_possible_world_5 ).


test_make_all_pairs_1 :-
	assert_true( make_all_pairs([], []) ).

test_make_all_pairs_2 :-
	assert_true( (make_all_pairs([1, 2], R),
				  msort(R, [likes(1, 1), likes(1, 2), likes(2, 1), likes(2, 2)])) ).

test_make_all_pairs_3 :-
	assert_true( (make_all_pairs([1, 1, 3, 4], R),
				  msort(R, [likes(1, 1), likes(1, 1), likes(1, 1), likes(1, 1), likes(1, 3), likes(1, 3),
							likes(1, 4), likes(1, 4), likes(3, 1), likes(3, 1), likes(3, 3), likes(3, 4), likes(4, 1), likes(4, 1), likes(4, 3), likes(4, 4)])) ).

test_make_all_pairs_4 :-
	assert_true( (make_all_pairs([a, b, c, d], R),
				  msort(R, [likes(a, a), likes(a, b), likes(a, c), likes(a, d), likes(b, a), likes(b, b), likes(b, c), likes(b, d),
							likes(c, a), likes(c, b), likes(c, c), likes(c, d), likes(d, a), likes(d, b), likes(d, c), likes(d, d)])) ).

test_make_all_pairs_5 :-
	assert_true( countall(P, make_all_pairs([a, b, c, d], P), 1) ).

test_subpart_1 :-
	assert_true( subpart([], []) ).

test_subpart_2 :-
	assert_true( sortall(R, subpart([1, 2], R), [[], [1], [1, 2], [2]]) ).

test_subpart_3 :-
	assert_true( sortall(R, subpart([1, 2, 3], R), [[], [1], [1, 2], [1, 2, 3], [1, 3], [2], [2, 3], [3]]) ).

test_subpart_4 :-
	assert_true( countall(S, subpart([1, 2, 3, 5, 6, 7, 8], S), 128) ).

test_proposition1_1 :-
	assert_true( proposition1([likes(dana, cody)]) ).

test_proposition1_2 :-
	assert_false( proposition1([]) ).

test_proposition1_3 :-
	assert_false( proposition1([likes(dana, dana)]) ).

test_proposition1_4 :-
	assert_true( (proposition1(W),
				  member(likes(dana, cody), W)) ).

test_proposition2_1 :-
	assert_true( proposition2([likes(dana, cody)]) ).

test_proposition2_2 :-
	assert_false( proposition2([likes(bess, dana)]) ).

test_proposition2_3 :-
	assert_true( proposition2([]) ).

test_proposition3_1 :-
	assert_true( proposition3([likes(dana, cody), likes(cody, cody)]) ).

test_proposition3_2 :-
	assert_false( proposition3([likes(cody, abby)]) ).

test_proposition3_3 :-
	assert_true( proposition3([]) ).

test_proposition4_1 :-
	assert_true( proposition4([]) ).

test_proposition4_2 :-
	assert_false( proposition4([likes(cody, abby)]) ).

test_proposition4_3 :-
	assert_true( proposition4([likes(abby, abby)]) ).

test_proposition4_4 :-
	assert_true( proposition4([likes(abby, cody), likes(dana, bess), likes(cody, abby), likes(bess, dana)]) ).

test_proposition4_5 :-
	assert_false( proposition4([likes(abby, cody), likes(dana, bess), likes(cody, abby), likes(bess, dana), likes(bess, abby)]) ).

test_proposition5_1 :-
	assert_true( proposition5([likes(cody, bess), likes(dana, bess), likes(abby, cody), likes(abby, dana), likes(dana, dana)]) ).

test_proposition5_2 :-
	assert_true( proposition5([]) ).

test_proposition5_3 :-
	assert_false( proposition5([likes(cody, bess)]) ).

test_proposition5_4 :-
	assert_true( proposition5([likes(cody, cody)]) ).

test_proposition6_1 :-
	assert_true( proposition6([likes(cody, bess), likes(dana, bess), likes(abby, cody), likes(abby, dana), likes(dana, dana)]) ).

test_proposition6_2 :-
	assert_true( proposition6([]) ).

test_proposition6_3 :-
	assert_false( proposition6([likes(bess, dana), likes(bess, cody), likes(abby, cody)]) ).

test_proposition6_4 :-
	assert_false( proposition6([likes(bess, dana), likes(bess, cody), likes(dana, bess), likes(abby, dana), likes(abby, cody), likes(abby, abby)]) ).

test_proposition6_5 :-
	assert_true( proposition6([likes(bess, dana), likes(bess, cody), likes(dana, bess), likes(dana, dana), likes(dana, cody), likes(abby, abby)]) ).

test_proposition7_1 :-
	assert_false( proposition7([]) ).

test_proposition7_2 :-
	assert_true( proposition7([likes(abby, _), likes(cody, _), likes(bess, _), likes(dana, _)]) ).

test_proposition7_3 :-
	assert_false( proposition7([likes(cody, _), likes(bess, _), likes(dana, _)]) ).

test_proposition7_4 :-
	assert_false( proposition7([likes(cody, _), likes(bess, _), likes(dana, _), likes(cody, _)]) ).

test_possible_world_1 :-
	assert_true( (possible_world(W),
				  msort(W, W1),
				  W1 = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby),
						likes(cody, cody), likes(cody, dana), likes(dana, abby), likes(dana, cody), likes(dana, dana)]) ).

test_possible_world_2 :-
	assert_true( (possible_world(W),
				  msort(W, W1),
				  W1 = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby),
						likes(cody, cody), likes(cody, dana), likes(dana, abby), likes(dana, cody)]) ).

test_possible_world_3 :-
	assert_true( (possible_world(W),
				  msort(W, W1),
				  W1 = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby),
						likes(cody, dana), likes(dana, abby), likes(dana, cody), likes(dana, dana)]) ).

test_possible_world_4 :-
	assert_true( (possible_world(W),
				  msort(W, W1),
				  W1 = [likes(abby, abby), likes(abby, bess), likes(abby, dana), likes(bess, abby),
						likes(cody, dana), likes(dana, abby), likes(dana, cody)]) ).

test_possible_world_5 :-
	assert_true( countall(W, possible_world(W), 4) ).

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
