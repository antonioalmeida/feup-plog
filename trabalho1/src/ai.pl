getValidMove( Game, Player, Piece, X, Y, NewBoard ):-
	getBoard( Game, Board ),
	!,
	validateMove(Game, Player, Piece, X, Y ).

getMoves( Game, Player, MovesList ):-
 	findall(Piece-X-Y, 
 		getValidMove(Game, Player, Piece, X, Y, _), UnsortedMoves ),
 	sort( UnsortedMoves, MovesList ).

evaluateAllMoves( Game, Player, MovesWithScore ):-
	getMoves( Game, Player, MovesList ),
	!,
	getBoard( Game, Board ),
	!,
	evaluateAllMovesAux( MovesList, Board, Player, [], UnsortedMoves ),
	!,
	sort( UnsortedMoves, MovesWithScore ).

getBestMove( Game, Player, Piece, X, Y):-
	evaluateAllMoves( Game, Player, MovesList ),
	last( MovesList, _-Piece-X-Y ).

evaluateAllMovesAux( [], _, _, ScoresList, ScoresList).

evaluateAllMovesAux( [ Piece-X-Y | RestOfMoves ], Board, Player, TempScores, ScoresList ):-
	evaluateMove( Player, Piece, X, Y, Board, Score ),
	evaluateAllMovesAux( RestOfMoves, Board, Player, [ Score-Piece-X-Y | TempScores ], ScoresList).	

evaluateMove(Player, Piece, X, Y, Board, Score):-
	makeMove( Board, Piece, X, Y, NewBoard ),
	updateAttackedBoard( NewBoard, Player, AttackedBoard ),
	!,
	evaluateBoard( AttackedBoard, Score ).

