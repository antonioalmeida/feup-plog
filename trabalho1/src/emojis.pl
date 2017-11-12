emoji(trophy):- write(' '), put_code(127942). 
emoji(dice):- write(' '), put_code(127922). 
emoji(flag):- write(' '), put_code(127937). 

emoji( _, 0).
emoji( Code, N ):-
	N1 is N-1,
	emoji( Code ),
	emoji( Code, N1 ).
