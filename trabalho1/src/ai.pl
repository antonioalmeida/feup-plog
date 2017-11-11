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

getBestMoveWithScore( Game, Player, Score, Piece, X, Y):-
	evaluateAllMoves( Game, Player, MovesList ),
	last( MovesList, Score-Piece-X-Y ).

evaluateAllMoves( Game, Player, MovesWithScore ):-
	getAllMoves( Game, Player, MovesList ), !,
	write('getAllMoves'), nl,
	getBoard( Game, Board ), !,
	write('getBoard'), nl,
	evaluateAllMovesAux( MovesList, Board, Player, [], UnsortedMoves ), !,
	write('evaluateAllMovesAux'), nl,
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

evaluateMagicShit( MovesList, BestMove ):-
	sort( MovesList, SortedMoves ),
	last( MovesList, _-LastPiece-LastX-LastY ),
	write( 'LAST : ' ), write(LastPiece-LastX-LastY), nl,
	!,
	connected( TempPiece-TempX-TempY, LastPiece-LastX-LastY ),
	write( 'TEMP : ' ), write(TempPiece-TempX-TempY), nl,
	connected( Piece-X-Y, TempPiece-TempX-TempY ),
	write( 'BEST : ' ), write(Piece-X-Y), nl,
	BestMove = Piece-X-Y.

magicShit( Game, Player, BestMove ):-
	getAllMoves( Game, Player, MovesList ),
	getOtherBestMoves( Game, Player, MovesList, [], OtherMoves ),
	write('OTHER MOVES '),
	write(OtherMoves),
	otherPlayer( Player, Other ),
	magicShit2( OtherMoves, Other, [], MagicMoves ),
	evaluateMagicShit( MagicMoves, BestMove ).

magicShit2( [], _, NewMoves, NewMoves).

magicShit2( [ Piece-X-Y-Game | RestOfMoves ], Player, TempMoves, NewMoves ):-
	
	getBoard( Game, Board ),


	% simulate game progression
	makeMove( Board, Piece, X, Y, NextBoard ),	
	write('make Move'), nl,
	updateMadeMoves( Game, Player, Piece, GameTemp ),
	write('update Move'), nl,
	setBoard( GameTemp, NextBoard, GameTemp2 ),
	write('set Board'), nl,
	!,
	displayBoard(NextBoard),
	updateAttackedBoard( GameTemp2, GameTemp3 ),
	write('update Attacked'), nl,
	incTurnIndex( GameTemp3, GameTemp4 ),
	write('incTurnIndex'), nl,
	switchPlayer( GameTemp4, NewGame ),
	write('switchPlayer'), nl,
	otherPlayer( Player, Other ),
	!,
	getBestMoveWithScore( NewGame, Other, OtherScore, OtherPiece, OtherX, OtherY ),
	write('getBestMoveWithScore'), nl,

	assert(connected(Piece-X-Y, OtherPiece-OtherX-OtherY)),
	write( 'ASSERTED : '), write( Piece-X-Y), write( 'WITH '), write( OtherPiece-OtherX-OtherY), nl,

	magicShit2( RestOfMoves, Player, [ OtherScore-OtherPiece-OtherX-OtherY | TempMoves], NewMoves ).

getOtherBestMoves( _, _, [], OthersMoves, OthersMoves).

getOtherBestMoves( Game, Player, [ Piece-X-Y | RestOfMoves ], TempNewMoves, OthersMoves ):-
	write('Current : '), write(Player-Piece-X-Y), nl,
	getBoard( Game, Board ),
	displayBoard(Board),

	% simulate game progression
	validateMove( Game, Player, Piece, X, Y ),
	makeMove( Board, Piece, X, Y, NextBoard ),	
	write('make Move'), nl,
	updateMadeMoves( Game, Player, Piece, GameTemp ),
	write('update Move'), nl,
	setBoard( GameTemp, NextBoard, GameTemp2 ),
	write('set Board'), nl,
	!,
	displayBoard(NextBoard),
	updateAttackedBoard( GameTemp2, GameTemp3 ),
	write('update Attacked'), nl,
	incTurnIndex( GameTemp3, GameTemp4 ),
	write('incTurnIndex'), nl,
	switchPlayer( GameTemp4, NewGame ),
	write('switchPlayer'), nl,

	otherPlayer( Player, Other ),
	write('Other player '), nl,
	getBestMove( NewGame, Other, OtherPiece, OtherX, OtherY ),
	assert(connected(Piece-X-Y, OtherPiece-OtherX-OtherY)),
	write( 'ASSERTED : '), write( Piece-X-Y), write( 'WITH '), write( OtherPiece-OtherX-OtherY), nl,
	write('Get best move '), nl,
	getOtherBestMoves( Game, Player, RestOfMoves, [ OtherPiece-OtherX-OtherY-NewGame | TempNewMoves ], OthersMoves ).

