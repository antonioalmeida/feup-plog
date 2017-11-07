
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Move validation is ordered by priority %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% first move, white king needs to be played
validateMove( Game, Player, Piece, X, Y ):-
	getTurnIndex( Game, N ),
	N == 0,
	!, 
	getBoard( Game, Board ),
	isEmpty( Board, X, Y ), 
	isKing( Piece, Player ).

% final move, black king needs to be played
validateMove( Game, Player, Piece, X, Y ):-
	getTurnIndex( Game, N ),
	N == 15	,
	!, 
	\+(piecePlayed( Player, Piece )),
	getBoard( Game, Board ),

	isEmpty( Board, X, Y),
	isKing( Piece, Player ),
	assert( gameOver( cenas )).

% move where player is forced to use queen
validateMove( Game, Player, Piece, X, Y ):-
	needsToPlayQueen( Player ),
	!, 
	isQueen( Piece, Player ),
	getBoard( Game, Board ),	
	isEmpty( Board, X, Y ),

	otherPlayer( Player, Other ),
	getAttackedBoard( Game, Other, AttackedBoard ),
	getPieceAt( AttackedBoard, X, Y, TempPiece ),
	TempPiece == '1',
	retract(needsToPlayQueen( Player )).

% move where first player uses queen
validateMove( Game, Player, Piece, X, Y ):-
	\+(piecePlayed( Player, Piece )),
	isQueen( Piece, Player ),
	getBoard( Game, Board ),	
	isEmpty( Board, X, Y ),

	otherPlayer( Player, Other ),
	getAttackedBoard( Game, Other, AttackedBoard ),
	getPieceAt( AttackedBoard, X, Y, TempPiece ),
	TempPiece == '1',
	assert(needsToPlayQueen( Other )).

% moves where player attempts to use queen or king when it was already played - invalid
validateMove( Game, Player, Piece, X, Y ):-
	piecePlayed( Player, Piece ),
	isQueen( Piece, Player ), !, false.

validateMove( Game, Player, Piece, X, Y ):-
	isKing( Piece, Player ), !, false.

% regular move
validateMove( Game, Player, Piece, X, Y ):-
	\+(piecePlayedTwice( Player, Piece )),

	getBoard( Game, Board ),	
	isEmpty( Board, X, Y ),

	otherPlayer( Player, Other ),
	getAttackedBoard( Game, Other, AttackedBoard ),
	getPieceAt( AttackedBoard, X, Y, TempPiece ),
	TempPiece == '1'.

