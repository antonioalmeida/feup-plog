:-include('display.pl').

mainMenu:-
	write('Bem vindo ao Xadrersi.'), nl,
	write('O que vai ser hoje?'), nl,
	displayOptions,
	read( Option ),
	initialBoard( Board ),
	displayBoard( Board ).

generateBoard( Result ):-
	N is 1,
	append( [] , Result, ResultAppend),
	generateBoardAux(N, [ 0, 0, 0, 0, 0, 0, 0, 0], ResultAppend ).

displayOptions:-
	write('1 - Single player match.'), nl,
	write('2 - Multiplayer match.'), nl,
	write('3 - Exit.'),nl.

initialBoard([[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0]]).