:-include('board.pl').
:-include('moveValidation.pl').
:-include('attackedBoard.pl').
:-include('userInput.pl').
:-include('utils.pl').

:-dynamic piecePlayed/2.
:-dynamic needsToPlayQueen/1.

% high level play match function %
playXadrersi:-
	initGame( Game ), !,
	playGame( Game ).

playGame( Game ):-
	% get stuff from game class
	getBoard( Game, Board ),
	displayTurnInfo( Game ),
	getCurrentPlayer( Game, Player ),
	displayBoard( Board ),

	% read and validate move
	readMoveFromUser( Player, Piece, X, Y ),
	validateMove( Game, Player, Piece, X, Y ),

	% make and update moves
	makeMove( Board, Piece, X, Y, NextBoard ),
	updateMadeMoves( Player, Piece ),

	% prepare for next turn
	setBoard( Game, NextBoard, GameTemp ),
	updateAttackedBoard( GameTemp, GameTemp2 ),
	incTurnIndex( GameTemp2, GameTemp3 ),
	switchPlayer( GameTemp3, NewGame ),

	playGame( NewGame ).


%%%%%%%%%%%%%%%%
% Game "class" %
%%%%%%%%%%%%%%%%

initGame( Game ):-
	initialBoard( Board ),
	initialBoard( AttackedBoardWhite ),
	initialBoard( AttackedBoardBlack ),
	Game = [ Board, white, 0, AttackedBoardWhite, AttackedBoardBlack ].

getBoard( Game, Board ):-
	elementAt(0, Game, Board).

getAttackedBoard( Game, white, AttackedBoard):-
	elementAt(3, Game, AttackedBoard).

getAttackedBoard( Game, black, AttackedBoard):-
	elementAt(4, Game, AttackedBoard).

setBoard( Game, Board, NewGame ):-
	replace( Game, 0, Board, NewGame).

setAttackedBoard( Game, white, AttackedBoard, NewGame ):-
	replace( Game, 3, AttackedBoard, NewGame).

setAttackedBoard( Game, black, AttackedBoard, NewGame ):-
	replace( Game, 4, AttackedBoard, NewGame).

getCurrentPlayer( Game, Player ):-
	elementAt(1, Game, Player).

getTurnIndex( Game, N ):-
	elementAt(2, Game, N).

incTurnIndex( Game, NewGame ):-
	getTurnIndex( Game, N ),
	replace( Game, 2, N+1, NewGame ).
	
updateMadeMoves( Player, Piece ):-
	assert(piecePlayed( Player, Piece )).
	
switchPlayer( Game, NewGame ):-
	getCurrentPlayer( Game, CurrentPlayer ),
	otherPlayer( CurrentPlayer, NewPlayer ),
	replace( Game, 1, NewPlayer, NewGame ).

displayTurnInfo( Game ):-
	getCurrentPlayer( Game, CurrentPlayer ),
	CurrentPlayer == white,
	nl, write('Current player is white.'), nl.

displayTurnInfo( Game ):-
	getCurrentPlayer( Game, CurrentPlayer ),
	CurrentPlayer == black,
	nl, write('Current player is black.'), nl.

otherPlayer(white, black).
otherPlayer(black, white).
	