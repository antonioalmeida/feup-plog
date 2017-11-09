:-include('board.pl').
:-include('moveValidation.pl').
:-include('attackedBoard.pl').
:-include('userInput.pl').
:-include('ai.pl').
:-include('utils.pl').
:-include('main.pl').
:-include('emojis.pl').

:-dynamic typeOfGame/1.
:-dynamic piecePlayed/2.
:-dynamic piecePlayedTwice/2.
:-dynamic needsToPlayQueen/1.
:-dynamic gameOver/1.

playGame( Game ):-
	gameOver( currentGame ),
	getAttackedBoard( Game, white, AttackedBoardWhite ),
	getAttackedBoard( Game, black, AttackedBoardBlack ),

	evaluateBoard( AttackedBoardWhite, WhiteScore ),
	evaluateBoard( AttackedBoardBlack, BlackScore ),

	displayWinner( WhiteScore, BlackScore ).

playGame( Game ):-
	% get stuff from game class
	getBoard( Game, Board ),
	displayTurnInfo( Game ),
	getCurrentPlayer( Game, Player ),
	displayBoard( Board ),

	% read and validate move
	getNextMove( Game, Player, Piece, X, Y ),
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

getNextMove( Game, Player, Piece, X, Y ):-
	typeOfGame( singlePlayer ),
	getAIPlayer( Game, AIPlayer ),
	AIPlayer == Player,
	write('AI MOVE'), nl,
	getBestMove( Game, Player, Piece, X, Y ),
	nl, write('AI has its move, press SPACE to play'), nl.

getNextMove( Game, Player, Piece, X, Y ):-
	typeOfGame( singlePlayer ),
	getAIPlayer( Game, AIPlayer ),
	Player \= AIPlayer,
	readMoveFromUser( Player, Piece, X, Y ).

%%%%%%%%%%%%%%%%
% Game "class" %
%%%%%%%%%%%%%%%%

initMultiplayerGame( Game ):-
	initialBoard( Board ),
	initialBoard( AttackedBoardWhite ),
	initialBoard( AttackedBoardBlack ),
	Game = [ Board, white, 0, AttackedBoardWhite, AttackedBoardBlack, AIPlayer, [] ].

initSingleplayerGame( Game, AIPlayer ):-
	initialBoard( Board ),
	initialBoard( AttackedBoardWhite ),
	initialBoard( AttackedBoardBlack ),
	Game = [ Board, white, 0, AttackedBoardWhite, AttackedBoardBlack, AIPlayer ].

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
	N1 is N+1,
	replace( Game, 2, N1, NewGame ).

getPlayedPieces( Game, PlayedPieces ):-
	elementAt( 5, PlayedPieces ).

addPlayedPiece( Game, Piece, X, Y, NewGame ):-
	getPlayedPieces( Game, PlayedPieces ),
	append( PlayedPieces, [ Player-Piece ], NewPlayedPieces ),
	replace( Game, 5, NewPlayedPieces, NewGame ).

piecePlayed( Game, Player, Piece ):-
	getPlayedPieces( Game, PlayedPieces ),
	member( Player-Piece, PlayedPieces ).

piecePlayedTwice( Game, Player, Piece ):-
	getPlayedPieces( Game, PlayedPieces ),
	countOccurences( PlayedPieces, Played-Piece, N ),
	N == 2.

getAIPlayer( Game, AIPlayer ):-
	elementAt(5, Game, AIPlayer ).

% case where piece was already played once - used for rooks, bishops and knights
updateMadeMoves( Player, Piece ):-
	piecePlayed( Player, Piece ),
	assert(piecePlayedTwice( Player, Piece )).
	
% case where piece can only be played once - kings and queens
updateMadeMoves( Player, Piece ):-
	assert(piecePlayed( Player, Piece )).

switchPlayer( Game, NewGame ):-
	getCurrentPlayer( Game, CurrentPlayer ),
	otherPlayer( CurrentPlayer, NewPlayer ),
	replace( Game, 1, NewPlayer, NewGame ).

displayTurnInfo( Game ):-
	getCurrentPlayer( Game, CurrentPlayer ),
	getTurnIndex( Game, N ),
	nl, write('Player: '), displayPlayer( CurrentPlayer ), nl,
	write('Turn N: '), write(N), nl,
	ifte( needsToPlayQueen( CurrentPlayer ), (write('NOTE: You must play Queen.'), nl), write('') ).

displayWinner( White, Black ):-
	White > Black,
	write('!!!!!!!!!!!!'),
	write('!White Wins!'),
	write('!!!!!!!!!!!!').

displayWinner( White, Black ):-
	emoji(trophy), 
	emoji(trophy),
	emoji(trophy),
	emoji(trophy),
	emoji(trophy),
	emoji(trophy), nl,
	emoji(trophy),
	write(' Black Wins '), 
	emoji(trophy), nl,
	emoji(trophy),
	emoji(trophy),
	emoji(trophy),
	emoji(trophy),
	emoji(trophy),
	emoji(trophy).

displayPlayer(white):- write('white').
displayPlayer(black):- write('black').

otherPlayer(white, black).
otherPlayer(black, white).

