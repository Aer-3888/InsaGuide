membre(X, [X|_]).
membre(X, [Y|L]) :-
	X \== Y,
	membre(X, L).

/*
 * Q1.1
 */
% This cut will prevent Prolog from saying there are other possibilities
oter_n_prem(0, L, L) :- !.
oter_n_prem(M, [_|L], R) :-
	% Try and remove negative elements and
	% it will tell you "No"
	M > 0,
	N is M-1,
	oter_n_prem(N, L, R).

/*
 * Q1.2
 */
pas_dans([], L2, []).
pas_dans([X|L1], L2, R) :-
	membre(X, L2),
	!, % So that we don't try the other predicate
	pas_dans(L1, L2, R).
pas_dans([X|L1], L2, [X|R]) :-
	pas_dans(L1, L2, R).

/*
 * Q1.3
 */
maxi([X], X).
maxi([X|L], Y) :-
	maxi(L, Y),
	X < Y,
	!. % Don't try the other predicate
maxi([X|L], X).

/*
 * Q1.4
 */
revlist([], L, L).
revlist([X|L], K, R) :- revlist(L, [X|K], R).
ajout_deb(K, L, [K|U]) :-
	% Reverse list
	revlist(L, [], U).

arbitre(a1, dupont, jean, 09230).
arbitre(a2, vincent, marc, 93203).
arbitre(a3, corelin, marylin, 88921).

joueur(j1, voce, alexis, 30/1, tc_lorient, 39233).
joueur(j2, voce, corentin, 18/1, tc_rennes, 90323).
joueur(j3, sanchez, michel, 8/1, tc_rennes, 92033).

match(1, lundi, 18, c2, j2, j1, a2).
match(2, mardi, 14, c1, j2, j1, a1).
match(3, mardi, 16, c2, j1, j3, a1).
match(4, mardi, 10, c2, j2, j3, a2).
match(5, mardi, 12, c3, j1, j2, a3).

victoire(1, j1).
victoire(2, j2).
victoire(3, j1).
victoire(4, j2).

/*
 * Q2.1
 */
arbitre_ok(N, P) :-
	% Referees who oversaw matches
	% where one player from TC Rennes won on Tuesday at c2
	% Get all the matches from Tuesday on C2
	match(_MID, mardi, _HEURE, c2, _LIC1, _LIC2, ARBITRE),
	% Figure out who won
	victoire(_MID, LICWIN),
	% Assert that they're from tc_rennes
	joueur(LICWIN, _N, _P, _CLASS, tc_rennes, _TEL),
	% Get referee name and surname
	arbitre(ARBITRE, N, P, _TELA).

prog_lundi(prog(C, H)) :-
	match(_MID, lundi, H, C, _LIC1, _LIC2, _ARB).

tout_perdu(N, P) :-
	joueur(_LIC, N, P, _CLASS, _CLUB, _TEL),
	not victoire(_MID, _LIC).

a_day_i_dont_play(A) :-
	% Find a day
	match(_MID, DAY, _H, _C, _LIC1, _LIC2, _ARB),
	not match(_MID2, DAY, _HO, _CO, _LIC1O, _LIC2O, A).

tous_les_jours(A) :-
	arbitre(A, _N, _P, _T),
	not a_day_i_dont_play(A).
