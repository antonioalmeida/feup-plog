emoji(trophy):- write(' '), put_code(127942). 
emoji(party):- write(' '), put_code(7574). 

emoji( _, 0).
emoji( Code, N ):-
	N1 is N-1,
	emoji( Code ),
	emoji( Code, N1 ).
