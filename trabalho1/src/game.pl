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
	updateMadeMoves( Game, Player, Piece, GameTemp ),

	% prepare for next turn
	setBoard( GameTemp, NextBoard, GameTemp2 ),
	updateAttackedBoard( GameTemp2, GameTemp3 ),
	incTurnIndex( GameTemp3, GameTemp4 ),
	switchPlayer( GameTemp4, NewGame ),

	playGame( NewGame ).

getNextMove( Game, Player, Piece, X, Y ):-
	typeOfGame( singlePlayer ),
	getAIPlayer( Game, AIPlayer ),
	AIPlayer == Player,
	write('AI is thinking...'), nl,
	getAIMove( Game, Player, Piece, X, Y ).

getNextMove( Game, Player, Piece, X, Y ):-
	typeOfGame( singlePlayer ),
	readMoveFromUser( Player, Piece, X, Y ).

getNextMove( Game, Player, Piece, X, Y ):-
	typeOfGame( multiPlayer ),
	readMoveFromUser( Player, Piece, X, Y ).

%%%%%%%%%%%%%%%%
% Game "class" %
%%%%%%%%%%%%%%%%

initMultiplayerGame( Game ):-
	initialBoard( Board ),
	initialBoard( AttackedBoardWhite ),
	initialBoard( AttackedBoardBlack ),

	% Game Object %
	% 0 - game board %		
	% 1 - current player %		
	% 2 - turn counter %		
	% 3 - board with white player's attacked positions %		
	% 4 - board with black player's attacked positions %		
	% 5 - if singleplayer, color which AI is playing for %		
	% 6 - list with the pieces played %		
	% 7 - boolean, true if white player needs to play queen %
	% 8 - boolean, true if black player needs to play queen %
	Game = [ Board, white, 0, AttackedBoardWhite, AttackedBoardBlack, AIPlayer, [], false, false ].

initSingleplayerGame( Game, AIPlayer ):-
	initialBoard( Board ),
	initialBoard( AttackedBoardWhite ),
	initialBoard( AttackedBoardBlack ),
	Game = [ Board, white, 0, AttackedBoardWhite, AttackedBoardBlack, AIPlayer, [], false, false ].

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
	elementAt( 6, Game, PlayedPieces ).

addPlayedPiece( Game, Player, Piece, NewGame ):-
	getPlayedPieces( Game, PlayedPieces ),
	append( [Player-Piece], PlayedPieces, NewPlayedPieces ),
	replace( Game, 6, NewPlayedPieces, NewGame ).

piecePlayed( Game, Player, Piece ):-
	getPlayedPieces( Game, PlayedPieces ),
	member( Player-Piece, PlayedPieces ).

piecePlayedTwice( Game, Player, Piece ):-
	getPlayedPieces( Game, PlayedPieces ),
	countOccurences( PlayedPieces, Played-Piece, N ),
	N == 2.

setNeedsToPlayQueen( Game, white, Value, NewGame ):-
	replace( Game, 7, Value, NewGame ).

setNeedsToPlayQueen( Game, black, Value, NewGame ):-
	replace( Game, 8, Value, NewGame ).

needsToPlayQueen( Game, white ):-
	elementAt( 7, Game,  Value ),
	Value == true.

needsToPlayQueen( Game, black ):-
	elementAt( 8, Game, Value ),
	Value == true.

getAIPlayer( Game, AIPlayer ):-
	elementAt(5, Game, AIPlayer ).
	
% case where player had to play queen and does so
updateMadeMoves( Game, Player, Piece, NewGame ):-
	isQueen( Piece, Player ),	
	needsToPlayQueen( Game, Player ),
	setNeedsToPlayQueen( Game, Player, false, TempGame ),
	otherPlayer( Player, Other ),
	setNeedsToPlayQueen( TempGame, Other , false, TempGame2 ),
	addPlayedPiece( TempGame2, Player, Piece, NewGame ).

% case where a player plays queen for the first time
updateMadeMoves( Game, Player, Piece, NewGame ):-
	isQueen( Piece, Player ),
	otherPlayer( Player, Other ),
	\+needsToPlayQueen( Game, Other ),
	setNeedsToPlayQueen( Game, Other, true, TempGame ),
	addPlayedPiece( TempGame, Player, Piece, NewGame ).

% regular case
updateMadeMoves( Game, Player, Piece, NewGame ):-
	addPlayedPiece( Game, Player, Piece, NewGame ).

switchPlayer( Game, NewGame ):-
	getCurrentPlayer( Game, CurrentPlayer ),
	otherPlayer( CurrentPlayer, NewPlayer ),
	replace( Game, 1, NewPlayer, NewGame ).

displayTurnInfo( Game ):-
	getCurrentPlayer( Game, CurrentPlayer ),
	getTurnIndex( Game, N ),
	nl, write('Player: '), displayPlayer( CurrentPlayer ), nl,
	write('Turn N: '), write(N), nl.

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

