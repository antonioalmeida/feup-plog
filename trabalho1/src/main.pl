start:-
	write('Bem vindo ao Xadrersi.'), nl, nl,

	write('1 - Single player match.'), nl,
	write('2 - Multiplayer match.'), nl,
	write('3 - Exit.'),
	startSinglePlayer.


startSinglePlayer:-
	asserta(typeOfGame(multiPlayer)),
	initMultiplayerGame( Game ),
	playGame( Game ).


startMultiPlayer:-
	asserta(typeOfGame(multiPlayer)).
