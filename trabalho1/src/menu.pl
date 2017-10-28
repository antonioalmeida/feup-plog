:-include('test2.pl').

mainMenu( FinalBoard ):-
	write('Bem vindo ao Xadrersi.'), nl,
	write('O que vai ser hoje?'), nl,
	playXadrersi( FinalBoard ).

displayOptions:-
	write('1 - Single player match.'), nl,
	write('2 - Multiplayer match.'), nl,
	write('3 - Exit.'),nl.

