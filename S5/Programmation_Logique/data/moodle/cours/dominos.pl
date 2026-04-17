/*
TP Dominos
Inspired by Domino from "The First 10 Prolog Programming Contests"

@author FirstName1 LASTNAME1
@author FirstName2 LASTNAME2
@version Annee scolaire 20__/20__
*/

% Predicates provided for user-friendly display of chain lists

% print_chains(+): chain list
% print_chains(Chains): prints each chain from Chains as a linear and uncompressed list of stones.

print_chains([]).
print_chains([C|Rest]) :-
    print1chain(C),
    print_chains(Rest).

print1chain(chain(L1,L2)) :-
    reverse(L2, L2R),
    append(L1, L2R, L),
    print1list(L),
    writeln("").

print1list([A,B]) :-
    print1domino(A,B).
print1list([A,B,C|Rest]) :-
    print1domino(A,B),
    print1list([B,C|Rest]).
    
print1domino(A,B) :-
	write("["), write(A), write(":"), write(B), write("]").


% choose(+, -, -): 'a list * 'a * 'a list
% choose(List, Element, Remaining) returns an Element from List and the Remaining list of elements.

% ?- choose([1, 2, 3], Elt, Rest).
% Elt = 1
% Rest = [2, 3]
% Yes
% Elt = 2
% Rest = [1, 3]
% Yes
% Elt = 3
% Rest = [1, 2]
% Yes


% chains(+, +, -): stone list * chain list * chain list
% chains(Stones, Partial, Chains) computes Chains, the solution from Stones using the accumulator Partial.


% domino(+, -): stone list * chain list
% domino(Stones, Chains) computes Chains, the solution to the puzzle from Stones.
