:-include('board.pl').
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
	setBoard( GameTemp, NextBoard, NewGame ),

	playGame( NewGame ).


% working
makeMove( Board, Piece, X, Y, NewBoard ):-
	N is 0,
	makeMoveAux( Board, N, Piece, X, Y, [], NewBoard ).

% base case - need to reverse list
% TODO: find a way to do this without having to reverse final list
makeMoveAux([], _, _, _, _, InvertedBoard, FinalBoard):-
	reverse(InvertedBoard, FinalBoard).

% case where N == Y
makeMoveAux( [ CurrentLine | RestOfBoard ], Y, Piece, X, Y, TempBoard, FinalBoard):-
	N1 is Y+1,
	replace( CurrentLine, X, Piece, NewLine ),
	makeMoveAux( RestOfBoard, N1, Piece, X, Y, [ NewLine | TempBoard ], FinalBoard).

makeMoveAux( [ CurrentLine | RestOfBoard ], N, Piece, X, Y, TempBoard, FinalBoard ):-
	N1 is N+1,
	makeMoveAux( RestOfBoard, N1, Piece, X, Y, [ CurrentLine | TempBoard ], FinalBoard ).

validateMove( Board, Player, Piece, X, Y ):-
	isEmpty( Board, X, Y).
	% add more stuff

% Game "class"
initGame( Game ):-
	initialBoard( Board ),
	Game = [ Board, white].

getBoard( Game, Board ):-
	elementAt(0, Game, Board).

setBoard( Game, Board, NewGame ):-
	replace( Game, 0, Board, NewGame).

getCurrentPlayer( Game, Player ):-
	elementAt(1, Game, Player).

switchPlayer( Game, NewGame ):-
	getCurrentPlayer( Game, CurrentPlayer ),
	switchPlayerAux( CurrentPlayer, NewPlayer ),
	replace( Game, 1, NewPlayer, NewGame ).

switchPlayerAux(white, black).
switchPlayerAux(black, white).
	