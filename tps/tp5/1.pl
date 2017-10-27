% 1) - predicado if */
A:- B, C, !, D, E.
A:- F, G.

% Exemplo de predicado
ite( If, Then, Else ):- If, !, Then.
ite( _, _, Else ):- Else.


 