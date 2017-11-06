:-include('board.pl').
:-include('moveValidation.pl').
:-include('userInput.pl').
:-include('utils.pl').

player(white).
player(black).

% high level play match function %
playXadrersi:-
	initGame( Game ), !,
	playGame( Game ).

playGame( Game ):-
	% get stuff from game class
	getBoard( Game, Board ),
	getCurrentPlayer( Game, Player ),
	displayBoard( Board ),

	% read and validate move
	readMoveFromUser( Piece, X, Y ),
	validateMove( Board, Player, Piece, X, Y ),
	makeMove( Board, Piece, X, Y, NextBoard ),

	% prepare for next turn
	switchPlayer( Game, GameTemp ),
	setBoard( GameTemp, NextBoard, GameTemp2 ),

	% this is here just for testing
	updateAttackedBoard( GameTemp2, NewGame ),

	playGame( NewGame ).

validateMove( Board, Player, Piece, X, Y ):-
	isEmpty( Board, X, Y).
	% add more stuff

% Game "class"
initGame( Game ):-
	initialBoard( Board ),
	initialBoard( AttackedBoardWhite ),
	initialBoard( AttackedBoardBlack ),
	Game = [ Board, white, AttackedBoardWhite, AttackedBoardBlack ].

getBoard( Game, Board ):-
	elementAt(0, Game, Board).

getAttackedBoard( Game, white, AttackedBoard):-
	elementAt(2, Game, AttackedBoard).

getAttackedBoard( Game, black, AttackedBoard):-
	elementAt(3, Game, AttackedBoard).

setBoard( Game, Board, NewGame ):-
	replace( Game, 0, Board, NewGame).

setAttackedBoard( Game, white, AttackedBoard, NewGame ):-
	replace( Game, 2, AttackedBoard, NewGame).

setAttackedBoard( Game, black, AttackedBoard, NewGame ):-
	replace( Game, 3, AttackedBoard, NewGame).

getCurrentPlayer( Game, Player ):-
	elementAt(1, Game, Player).

switchPlayer( Game, NewGame ):-
	getCurrentPlayer( Game, CurrentPlayer ),
	switchPlayerAux( CurrentPlayer, NewPlayer ),
	replace( Game, 1, NewPlayer, NewGame ).

switchPlayerAux(white, black).
switchPlayerAux(black, white).
	