:-include('display.pl');

% high level play match function %
playXadrersi:-
	initialBoard( InicialBoard ),
	getGameState( Player, InicialBoard ),
	playGame( Game, Board, FinalBoard ),
	showResult( FinalBoard ).

playGame( Game, Board, Board ):-
	endGame( Game, Board).

playGame( Player, Board, FinalBoard ):-
	getOrderedMoves( Player, Board, MovesList ),
	getBestMove( MovesList, BestMove ),
	makeMove( Board, BestMove, NewBoard ),
	getNextPlayer( Player, NextPlayer ),
	displayBoard( NewBoard ),
	playGame( NextPlayer, NewBoard, FinalBoard ).
 
 getValidMove( Player, Board, X, Y, NewBoard ):-
 	% one of the most important functions to develop % 
 	.

 % Result : int
 evaluateBoard( Board, Result ):- 
 	% also one of the most important functions %
 	.	

 % 
 getOrderedMoves( Player, Board, MovesList ):-
 	setof(Evaluation-X-Y, 
 		(getValidMove( Player, Board, X, Y, NewBoard )), evaluateBoard( NewBoard, Evaluation)),
 		MovesList ).

getBestMove( [ BestMove | _], BestMove ).

