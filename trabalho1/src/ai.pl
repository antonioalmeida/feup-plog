getValidMove( Game, Player, Piece, X, Y, NewBoard ):-
	getBoard( Game, Board ),
	!,
	validateMove(Game, Player, Piece, X, Y ), 
	makeMove(Board, Piece, X, Y, NewBoard ).

getOrderedMoves( Game, Player, MovesList ):-
 	setof(Score-Piece-X-Y, 
 		(getValidMove( Game, Player, Piece, X, Y, Board ), calcEvBoard( Board, Player, Score)),
 		MovesList ).

 getMoves( Game, Player, MovesList ):-
 	findall(Piece-X-Y, 
 		getValidMove(Game, Player, Piece, X, Y, _), MovesList ).

 getMovesScore( Game, Player, MovesList ):-
 	findall(Score-Piece-X-Y,
 		(getValidMove( Game, Player, Piece, X, Y, Board ), calcEvBoard( Board, Player, Score)),
 		MovesList ).

calcEvBoard( Board, Player, Score ):-
	updateAttackedBoard( Board, Player, AttackedBoard ),
	!,
	evaluateBoard( AttackedBoard, Score ).