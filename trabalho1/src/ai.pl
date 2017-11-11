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
 	easyGetMove( Game, Player, Piece, X, Y ).

 getAIMove( Game, Player, Piece, X, Y ):-
 	difficulty( medium ),
 	getBestMove( Game, Player, Piece, X, Y ).

easyGetMove( Game, Player, Piece, X, Y ):-
	getAllMoves( Game, Player, MovesList ),
	random_member( Piece-X-Y, MovesList ).

getBestMove( Game, Player, Piece, X, Y):-
	evaluateAllMoves( Game, Player, MovesList ),
	last( MovesList, _-Piece-X-Y ).

getBestMoveWithScore( Game, Player, Score, Piece, X, Y):-
	evaluateAllMoves( Game, Player, MovesList ),
	last( MovesList, Score-Piece-X-Y ).

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

evaluatehardGetMove( MovesList, BestMove ):-
	sort( MovesList, SortedMoves ),
	last( MovesList, _-LastPiece-LastX-LastY ),
	!,
	connected( TempPiece-TempX-TempY, LastPiece-LastX-LastY ),
	connected( Piece-X-Y, TempPiece-TempX-TempY ),
	BestMove = Piece-X-Y.

hardGetMove( Game, Player, BestMove ):-
	getAllMoves( Game, Player, MovesList ),
	getOpponentBestMoves( Game, Player, MovesList, [], OtherMoves ),
	otherPlayer( Player, Other ),
	getNextBestMove( OtherMoves, Other, [], MagicMoves ),
	evaluatehardGetMove( MagicMoves, BestMove ).

getNextBestMove( [], _, NewMoves, NewMoves).

getNextBestMove( [ Piece-X-Y-Game | RestOfMoves ], Player, TempMoves, NewMoves ):-
	simulateGameProgression( Game, Player, Piece, X, Y, NewGame ),
	otherPlayer( Player, Other ),
	!,
	getBestMoveWithScore( NewGame, Other, OtherScore, OtherPiece, OtherX, OtherY ),

	assert(connected(Piece-X-Y, OtherPiece-OtherX-OtherY)),

	getNextBestMove( RestOfMoves, Player, [ OtherScore-OtherPiece-OtherX-OtherY | TempMoves], NewMoves ).

getOpponentBestMoves( _, _, [], OthersMoves, OthersMoves).

getOpponentBestMoves( Game, Player, [ Piece-X-Y | RestOfMoves ], TempNewMoves, OthersMoves ):-
	simulateGameProgression( Game, Player, Piece, X, Y, NewGame ),
	otherPlayer( Player, Other ),
	getBestMove( NewGame, Other, OtherPiece, OtherX, OtherY ),
	assert(connected(Piece-X-Y, OtherPiece-OtherX-OtherY)),
	getOpponentBestMoves( Game, Player, RestOfMoves, [ OtherPiece-OtherX-OtherY-NewGame | TempNewMoves ], OthersMoves ).

simulateGameProgression( Game, Player, Piece, X, Y, NewGame ):-
	getBoard( Game, Board ),
	makeMove( Board, Piece, X, Y, NextBoard ),	
	updateMadeMoves( Game, Player, Piece, GameTemp ),
	setBoard( GameTemp, NextBoard, GameTemp2 ),
	!,
	updateAttackedBoard( GameTemp2, GameTemp3 ),
	incTurnIndex( GameTemp3, GameTemp4 ),
	switchPlayer( GameTemp4, NewGame ).

