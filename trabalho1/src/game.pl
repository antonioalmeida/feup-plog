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

% playGame( Game, Board, Board ):-
%	sendGame( Game, Board ).

% playGame( Player, Board, FinalBoard ):-
%	getOrderedMoves( Player, Board, MovesList ),
%	getBestMove( MovesList, BestMove ),
%	makeMove( Board, BestMove, NewBoard ),
%	getNextPlayer( Player, NextPlayer ),
%	displayBoard( NewBoard ),
%	playGame( NextPlayer, NewBoard, FinalBoard ).

getNextPlayer( CurrentPlayer, NewPlayer ):-
	(CurrentPlayer == whitePlayer -> 
		NewPlayer is blackPlayer;
		NewPlayer is whitePlayer).
 
% getValidMove( Player, Board, Piece, X, Y, NewBoard ):-
 	% one of the most important functions to develop % 

 % Result : int
% evaluateBoard( Board, Result ):- 
 	% also one of the most important functions %

%getOrderedMoves( Player, Board, MovesList ):-
% 	setof(Evaluation-X-Y, 
% 		(getValidMove( Player, Board, X, Y, NewBoard )), evaluateBoard( NewBoard, Evaluation)),
% 		MovesList ).

%getBestMove( [ BestMove | _], BestMove ).

% working
makeMove( Board, Piece, X, Y, NewBoard ):-
	N is 0,
	makeMoveAux( Board, N, Piece, X, Y, [], NewBoard ).

% base case - need to reverse list
% TODO: find a way to do this without having to reverse final list
makeMoveAux([], _, _, _, _, InvertedBoard, FinalBoard):-
	reverse(InvertedBoard, FinalBoard).

makeMoveAux( [ CurrentLine | RestOfBoard ], N, Piece, X, Y, TempBoard, FinalBoard ):-
	N1 is N+1,
	( N == Y -> replace( CurrentLine, X, Piece, NewLine), 
				makeMoveAux( RestOfBoard, N1, Piece, X, Y, [ NewLine | TempBoard], FinalBoard )
		;
			makeMoveAux( RestOfBoard, N1, Piece, X, Y, [ CurrentLine | TempBoard ], FinalBoard )
 	).
