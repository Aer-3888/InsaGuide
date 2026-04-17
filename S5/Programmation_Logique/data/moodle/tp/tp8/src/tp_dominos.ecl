/*
 * TP8 - Puzzle des Dominos
 *
 * Ce fichier resout le puzzle des dominos : etant donne un ensemble de
 * dominos (stones), les organiser en chaines (chains) ou chaque domino
 * est connecte au suivant par des valeurs identiques.
 *
 * Representation :
 *   - stone(A, B) : un domino avec les valeurs A et B
 *   - chain(L1, L2) : une chaine representee par deux listes de valeurs ;
 *     la chaine complete est reverse(L2) ++ L1
 *     Un chain([X], [double]) represente un domino double isole.
 *
 * Predicats principaux :
 *   choose/3    - choisir un element dans une liste
 *   chains/3    - construire les chaines a partir des dominos
 *   chainsAux/3 - tenter d'ajouter un domino a une chaine existante
 *   domino/2    - point d'entree du puzzle
 *
 * Utilisation : [tp_dominos].
 *               stones1(S), domino(S, R), print_chains(R).
 */


% =============================================================================
% Donnees de test : listes de dominos
% =============================================================================

stones1([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2)]).

stones2([stone(2, 2), stone(4, 6), stone(1, 2), stone(2, 4), stone(6, 2),
         stone(5, 1), stone(5, 5), stone(4, 5), stone(2, 3), stone(3, 6)]).

stones3([stone(6, 6), stone(6, 5), stone(6, 4), stone(6, 3), stone(6, 2),
         stone(6, 1), stone(6, 0),
         stone(5, 5), stone(5, 4), stone(5, 3), stone(5, 2), stone(5, 1),
         stone(5, 0),
         stone(4, 4), stone(4, 3), stone(4, 2), stone(4, 1), stone(4, 0),
         stone(3, 3), stone(3, 2), stone(3, 1), stone(3, 0),
         stone(2, 2), stone(2, 1), stone(2, 0),
         stone(1, 1), stone(1, 0),
         stone(0, 0)]).


% =============================================================================
% Affichage des chaines
% =============================================================================

% print_chains(+Chains) : affiche chaque chaine sous forme lineaire
print_chains([]).
print_chains([C | Rest]) :-
    print1chain(C),
    print_chains(Rest).

print1chain(chain(L1, L2)) :-
    reverse(L2, L2R),
    append(L1, L2R, L),
    print1list(L),
    writeln("").

print1list([A, B]) :-
    print1domino(A, B).
print1list([A, B, C | Rest]) :-
    print1domino(A, B),
    print1list([B, C | Rest]).

print1domino(A, B) :-
    printf("[%w:%w]", [A, B]).


% =============================================================================
% choose(+List, -Element, -Remaining)
% =============================================================================
% Choisit un Element dans List et retourne le Remaining (les autres elements).
% Produit autant de solutions qu'il y a d'elements dans la liste.
choose([E | R], E, R).
choose([E1 | R], E, [E1 | L]) :-
    choose(R, E, L).


% =============================================================================
% chains(+Stones, +Partial, -Chains)
% =============================================================================
% Construit les Chains (solution) a partir des Stones en utilisant
% l'accumulateur Partial.
%   - Quand il n'y a plus de dominos, le resultat partiel est la solution.
%   - Sinon, on choisit un domino et on tente de l'ajouter a une chaine.
chains([], Acc, Acc).
chains(Stones, Acc, Res) :-
    choose(Stones, Stone, RestStones),
    chainsAux(Stone, Acc, AccRes),
    chains(RestStones, AccRes, Res).


% =============================================================================
% chainsAux(+Stone, +Chains, -NewChains)
% =============================================================================
% Tente d'ajouter le domino Stone a l'une des chaines existantes.
% Un domino stone(E, F) peut se connecter :
%   - par la gauche d'une chaine si F correspond au debut de la chaine
%   - par la gauche d'une chaine si E correspond au debut (en retournant)
%   - par la droite d'une chaine si E correspond a la fin
%   - par la droite d'une chaine si F correspond a la fin (en retournant)
% Les dominos doubles creent aussi une chaine [X],[double] pour marquer.

% Connecter stone(E,F) a gauche : F = debut de la chaine gauche
chainsAux(stone(E, F), [chain([F | R1], R2) | R],
                        [chain([E, F | R1], R2) | R]).
% Connecter stone(E,F) a gauche : E = debut de la chaine gauche (retourne)
chainsAux(stone(E, F), [chain([E | R1], R2) | R],
                        [chain([F, E | R1], R2) | R]).
% Connecter stone(E,F) a droite : E = debut de la chaine droite
chainsAux(stone(E, F), [chain(R1, [E | R2]) | R],
                        [chain(R1, [F, E | R2]) | R]).
% Connecter stone(E,F) a droite : F = debut de la chaine droite (retourne)
chainsAux(stone(E, F), [chain(R1, [F | R2]) | R],
                        [chain(R1, [E, F | R2]) | R]).

% Double connecte a gauche : cree une chaine double supplementaire
chainsAux(stone(E, E), [chain([E | R1], R2) | R],
                        [chain([E, E | R1], R2), chain([E], [double]) | R]).
% Double connecte a droite : cree une chaine double supplementaire
chainsAux(stone(E, E), [chain(R1, [E | R2]) | R],
                        [chain(R1, [E, E | R2]), chain([E], [double]) | R]).

% Passer a la chaine suivante si le domino ne s'y connecte pas
chainsAux(S, [D | R], [D | Res]) :-
    chainsAux(S, R, Res).


% =============================================================================
% domino(+Stones, -Chains)
% =============================================================================
% Point d'entree : resout le puzzle des dominos.
% Le premier domino initialise les chaines partielles.
%   - Si c'est un double (A=A), on cree deux chaines : une normale et une "double"
%   - Sinon, on cree une seule chaine chain([A], [B])
domino([stone(A, A) | R], Res) :-
    chains(R, [chain([A], [A]), chain([A], [double])], Res).
domino([stone(A, B) | R], Res) :-
    A \= B,
    chains(R, [chain([A], [B])], Res).
