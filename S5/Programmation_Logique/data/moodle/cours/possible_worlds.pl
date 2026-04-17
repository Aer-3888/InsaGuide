/*
TP Possible Worlds

@author Prenom1 NOM1
@author Prenom2 NOM2
@version Annee scolaire 20__/20__
*/

% abby bess cody dana

% dana likes cody
% bess does not like dana
% cody does not like abby
% nobody likes someone who does not like her
% abby likes everyone who likes bess
% dana likes everyone bess likes
% everybody likes somebody

people([abby, bess, cody, dana]).

% Questions 1.6 and 1.7
test_possible_world :-
	possible_world(World),
	writeln(World),
	fail.
