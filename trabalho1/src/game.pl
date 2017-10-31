:-include('board.pl').
:-include('userInput.pl').
:-include('utils.pl').

player(whitePlayer).
player(blackPlayer).

% high level play match function %
playXadrersi(FinalBoard):-
	initialBoard( InitialBoard ),
	displayBoard( InitialBoard ),
	Player = whitePlayer,
	playGame( Player, InitialBoard, FinalBoard ).

playGame( Player, Board, FinalBoard ):-
	readMoveFromUser( Piece, X, Y ),
	write(Piece), nl, write(X), nl, write(Y),
	makeMove( Board, Piece, X, Y, FinalBoard),
	displayBoard( FinalBoard ).

getNextPlayer( CurrentPlayer, NewPlayer ):-
	(CurrentPlayer == whitePlayer -> 
		NewPlayer is blackPlayer;
		NewPlayer is whitePlayer). 

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

validateMove( Board, Player, Piece, X, Y):-
	isEmpty( Board, X, Y)
	% add more stuff
	.
	