:- use_module(library(random)).

playerPiece(white, 'K').
playerPiece(white, 'Q').
playerPiece(white, 'R').
playerPiece(white, 'N').
playerPiece(white, 'B').

playerPiece(black, 'k').
playerPiece(black, 'q').
playerPiece(black, 'r').
playerPiece(black, 'n').
playerPiece(black, 'b').

getValidMove( Game, Player, Piece, X, Y ):-
	playerPiece(Player, Piece), %wtf????????????????? it works idc
	validateMove( Game, Player, Piece, X, Y).

getAllMoves( Game, Player, MovesList ):-
 	findall(Piece-X-Y, 
 		getValidMove( Game, Player, Piece, X, Y ), UnsortedMoves ),
 	sort( UnsortedMoves, MovesList ).

 getAIMove( Game, Player, Piece, X, Y ):-
 	difficulty( easy ),
 	getRandomMove( Game, Player, Piece, X, Y ).

 getAIMove( Game, Player, Piece, X, Y ):-
 	difficulty( medium ),
 	getBestMove( Game, Player, Piece, X, Y ).

getRandomMove( Game, Player, Piece, X, Y ):-
	getAllMoves( Game, Player, MovesList ),
	random_member( Piece-X-Y, MovesList ).

getBestMove( Game, Player, Piece, X, Y):-
	evaluateAllMoves( Game, Player, MovesList ),
	last( MovesList, _-Piece-X-Y ).

evaluateAllMoves( Game, Player, MovesWithScore ):-
	getAllMoves( Game, Player, MovesList ), !,
	getBoard( Game, Board ), !,
	evaluateAllMovesAux( MovesList, Board, Player, [], UnsortedMoves ), !,
	sort( UnsortedMoves, MovesWithScore ).

evaluateAllMovesAux( [], _, _, ScoresList, ScoresList).

evaluateAllMovesAux( [ Piece-X-Y | RestOfMoves ], Board, Player, TempScores, ScoresList ):-
	evaluateMove( Player, Piece, X, Y, Board, Score ),
	evaluateAllMovesAux( RestOfMoves, Board, Player, [ Score-Piece-X-Y | TempScores ], ScoresList).	

evaluateMove(Player, Piece, X, Y, Board, Score):-
	makeMove( Board, Piece, X, Y, NewBoard ),
	updateAttackedBoard( NewBoard, Player, AttackedBoard ),
	!,
	evaluateBoard( AttackedBoard, Score ).

