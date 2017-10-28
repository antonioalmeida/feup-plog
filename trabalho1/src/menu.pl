:-include('utils.pl').
:-include('game.pl').

mainMenu:-
	write('Bem vindo ao Xadrersi.'), nl,
	write('O que vai ser hoje?'), nl,
	displayOptions,
	read( Option ),
	.

displayOptions:-
	write('1 - Single player match.'), nl,
	write('2 - Multiplayer match.'), nl,
	write('3 - Exit.'),nl.

