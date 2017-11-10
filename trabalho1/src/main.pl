start:-
	write('Bem vindo ao Xadrersi.'), nl, nl,

	write('1 - Multiplayer match.'), nl,
	write('2 - Single Player match.'), nl,
	write('3 - Exit.'), nl,
	get_char( N ),
	get_char( _ ),
	secondMenu( N ).

secondMenu( '1' ):-
	startGame( multiPlayer, Game ), !,
	playGame( Game ).

secondMenu( '2' ):-
	write('Single Player '), nl, nl,
	write('Choose your difficulty:'), nl,
	write('1 - Easy'), nl,
	write('2 - Medium'), nl,
	write('3 - Go back.'), nl,
	get_char( N ),
	get_char( _ ),
	thirdMenu( N ).

thirdMenu( '1' ):-
	startGame( singlePlayer, easy, Game ), !,
	playGame( Game ).

thirdMenu( '2' ):-
	startGame( singlePlayer, medium, Game ), !,
	playGame( Game ).

thirdMenu( '3' ):-
	!,
	start.

startGame( singlePlayer, easy, Game ):-
	asserta(typeOfGame(singlePlayer)),
	asserta(difficulty(easy)),
	initSingleplayerGame( Game, black ).

startGame( singlePlayer, medium, Game ):-
	asserta(typeOfGame(singlePlayer)),
	asserta(difficulty(medium)),
	initSingleplayerGame( Game, black ).

startGame( multiPlayer, Game ):-
	asserta(typeOfGame(multiPlayer)),
	initMultiplayerGame( Game ).
