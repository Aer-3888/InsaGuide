/*
TP Arithmétique

@author Prenom1 NOM1
@author Prenom2 NOM2
@version Annee scolaire 20__/20__
*/

%%%%%%%%%%% Binary representation

%add_bit(?, ?, ?, ?, ?): bit * bit * bit * bit * bit
%add_bit(Bit1, Bit2, CarryIn, Res, CarryOut)
add_bit(0, 0, 0, 0, 0).
add_bit(0, 0, 1, 1, 0).
add_bit(0, 1, 0, 1, 0).
add_bit(0, 1, 1, 0, 1).
add_bit(1, 0, 0, 1, 0).
add_bit(1, 0, 1, 0, 1).
add_bit(1, 1, 0, 0, 1).
add_bit(1, 1, 1, 1, 1).
