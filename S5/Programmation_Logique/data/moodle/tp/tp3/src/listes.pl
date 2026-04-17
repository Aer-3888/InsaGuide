/*
 * TP3 - Listes Prolog
 *
 * Ce fichier implemente des predicats classiques de manipulation de listes,
 * ainsi que des operations ensemblistes representees par des listes sans
 * doublons.
 *
 * Partie 1 : Classiques sur les listes
 *   membre, compte, renverser, palind, enieme, hors_de, tous_diff,
 *   conc3, debute_par, sous_liste, elim, tri
 *
 * Partie 2 : Retour sur les modes et la generation de solutions
 *   enieme2 (mode -,+,+), eniemefinal (combine les deux modes),
 *   conc3final (mode -,-,-,+), comptefinal (mode -,+,-)
 *
 * Partie 3 : Modelisation des ensembles
 *   inclus, non_inclus, union_ens, inclus2 (mode ?,?)
 *
 * Utilisation : [listes].
 *               tests.
 */


% =============================================================================
% Partie 1 : Quelques classiques sur les listes
% =============================================================================

% membre(?A, +X) : A est element de la liste X.
%   Cas de base : A est la tete de la liste.
%   Cas recursif : A est membre du reste de la liste.
membre(A, [A | _]).
membre(A, [_ | R]) :-
    membre(A, R).

% compte(+A, +X, ?N) : N est le nombre d'occurrences de A dans la liste X.
%   Cas de base : liste vide, 0 occurrences.
%   Cas recursif : si la tete = A, incrementer ; sinon, chercher dans le reste.
compte(_, [], 0).
compte(A, [A | R], N) :-
    compte(A, R, M),
    N is M + 1.
compte(A, [B | R], N) :-
    \==(A, B),
    compte(A, R, N).

% renverser(+X, ?Y) : Y est la liste X a l'envers.
%   Utilise un accumulateur pour obtenir un algorithme en O(n).
renverser(X, Y) :-
    renverser_acc(X, [], Y).

renverser_acc([], Acc, Acc).
renverser_acc([X | R], Acc, Res) :-
    renverser_acc(R, [X | Acc], Res).

% palind(+X) : X est un palindrome (identique a son inverse).
palind(X) :-
    renverser(X, X).

% enieme(+N, +X, -A) : A est l'element de rang N dans la liste X.
%   Mode (+, +, -) : on connait N et X, on cherche A.
enieme(1, [A | _], A).
enieme(N, [_ | X], Res) :-
    N > 1,
    M is N - 1,
    enieme(M, X, Res).

% hors_de(+A, +X) : A n'est pas element de la liste X.
hors_de(_, []).
hors_de(A, [Y | X]) :-
    \==(A, Y),
    hors_de(A, X).

% tous_diff(+X) : les elements de la liste X sont tous differents.
tous_diff([]).
tous_diff([X | R]) :-
    hors_de(X, R),
    tous_diff(R).

% conc3(+X, +Y, +Z, ?T) : T est la concatenation des listes X, Y et Z.
%   Approche : on vide X puis Y dans le resultat, puis on ajoute Z.
conc3([], [], Z, Z).
conc3([], [B | Y], Z, [B | Res]) :-
    conc3([], Y, Z, Res).
conc3([A | X], Y, Z, [A | Res]) :-
    conc3(X, Y, Z, Res).

% debute_par(+X, ?Y) : la liste X debute par la liste Y.
debute_par(_, []).
debute_par([A | RX], [A | RY]) :-
    debute_par(RX, RY).

% sous_liste(+X, ?Y) : la liste Y est sous-liste (contigue) de la liste X.
sous_liste(_, []).
sous_liste([A | RX], [A | RY]) :-
    debute_par(RX, RY).
sous_liste([_ | RX], Y) :-
    Y = [_ | _],
    sous_liste(RX, Y).

% elim(+X, -Y) : Y contient les elements de X sans doublons.
%   On garde la derniere occurrence de chaque element.
elim([], []).
elim([A | RX], [A | RY]) :-
    hors_de(A, RX),
    elim(RX, RY).
elim([X | RX], Y) :-
    membre(X, RX),
    elim(RX, Y).

% tri(+X, -Y) : Y est le tri par insertion de la liste d'entiers X.
tri([], []).
tri([E | L1], L2) :-
    tri(L1, LP),
    inserer(E, LP, L2).

% inserer(+E, +L1, -L2) : insere l'entier E dans la liste triee L1.
inserer(E, [], [E]).
inserer(E, [X | L1], [E, X | L1]) :-
    E =< X.
inserer(E, [X | L1], [X | L2]) :-
    E > X,
    inserer(E, L1, L2).


% =============================================================================
% Partie 2 : Retour sur les modes et la generation de solutions
% =============================================================================

% enieme2(-N, +X, +A) : mode inverse, on cherche le rang N de A dans X.
%   Parcourt la liste et compte la position. Permet de trouver toutes
%   les positions d'un element donne.
enieme2(1, [A | _], A).
enieme2(N, [_ | R], A) :-
    enieme2(M, R, A),
    N is M + 1.

% eniemefinal(?N, +X, ?A) : version combinant les modes (+,+,-) et (-,+,+).
%   Si N est instancie, on utilise l'approche directe par decompte.
%   Sinon, on parcourt la liste et on calcule la position.
eniemefinal(N, X, A) :-
    nonvar(N),
    !,
    enieme(N, X, A).
eniemefinal(N, X, A) :-
    enieme2(N, X, A).

% conc3final(?X, ?Y, ?Z, ?T) : version de conc3 supportant le mode (-,-,-,+).
%   Utilise append/3 (concat/3 en ECLiPSe) en deux etapes pour decouper T.
conc3final(X, Y, Z, T) :-
    append(X, YZ, T),
    append(Y, Z, YZ).

% comptefinal(?A, +X, ?N) : version de compte supportant le mode (-,+,-).
%   Peut trouver chaque element A et son nombre d'occurrences N.
%   Si A est instancie, se comporte comme compte/3.
%   Sinon, utilise setof pour trouver tous les elements distincts.
comptefinal(A, X, N) :-
    nonvar(A),
    !,
    compte(A, X, N).
comptefinal(A, X, N) :-
    var(A),
    membre(A, X),
    compte(A, X, N).


% =============================================================================
% Partie 3 : Modelisation des ensembles
% =============================================================================

% inclus(+X, +Y) : tous les elements de l'ensemble X sont dans Y.
%   On utilise uniquement membre et hors_de (+ recursivite).
inclus([], _).
inclus([A | R], Y) :-
    membre(A, Y),
    inclus(R, Y).

% non_inclus(+X, +Y) : au moins un element de X n'est pas dans Y.
non_inclus([A | _], Y) :-
    hors_de(A, Y).
non_inclus([A | R], Y) :-
    membre(A, Y),
    non_inclus(R, Y).

% union_ens(+X, +Y, ?Z) : Z est l'union ensembliste de X et Y.
union_ens([], Y, Y).
union_ens([A | R], Y, Z) :-
    membre(A, Y),
    union_ens(R, Y, Z).
union_ens([A | R], Y, [A | Z]) :-
    hors_de(A, Y),
    union_ens(R, Y, Z).

% inclus2(?X, +Y) : version de inclus supportant le mode (?, +).
%   Genere tous les sous-ensembles de Y qui sont inclus dans Y.
inclus2([], _).
inclus2([A | R], Y) :-
    membre(A, Y),
    inclus2(R, Y),
    hors_de(A, R).
