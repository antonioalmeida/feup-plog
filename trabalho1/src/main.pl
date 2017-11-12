start:-
	write('Bem vindo ao Xadrersi.'), nl, nl,

	write('1 - Multiplayer match.'), nl,
	write('2 - Single Player match.'), nl,
	write('3 - No Player match.'), nl,
	write('4 - Exit.'), nl,
	get_char( N ),
	get_char( _ ),
	secondMenu( N ), !.

secondMenu( '1' ):-
	startGame( multiPlayer, Game ), !,
	playGame( Game ).

secondMenu( '2' ):-
	write('Single Player '), nl, nl,
	write('Choose your difficulty:'), nl,
	write('1 - Easy'), nl,
	write('2 - Medium'), nl,
	write('3 - Hard (experimental, very slow)'), nl,
	write('4 - Go back.'), nl,
	get_char( N ),
	get_char( _ ),
	clearScreen,
	thirdMenu( N ).

secondMenu( '3' ):-
	startGame( noPlayer, Game ), !,
	playGame( Game ).

secondMenu( '4' ):- fail.

thirdMenu( '1' ):-
	startGame( singlePlayer, easy, Game ),
	clearScreen, !,
	playGame( Game ).

thirdMenu( '2' ):-
	startGame( singlePlayer, medium, Game ),
	clearScreen, !,
	playGame( Game ).

thirdMenu( '3' ):-
	startGame( singlePlayer, hard, Game ),
	clearScreen, !,
	playGame( Game ).

thirdMenu( '4' ):-
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

startGame( singlePlayer, hard, Game ):-
	asserta(typeOfGame(singlePlayer)),
	asserta(difficulty(hard)),
	initSingleplayerGame( Game, black ).

startGame( multiPlayer, Game ):-
	asserta(typeOfGame(multiPlayer)),
	initMultiplayerGame( Game ).

startGame( noPlayer, Game ):-
	asserta(typeOfGame(noPlayer)),
	initMultiplayerGame( Game ).
