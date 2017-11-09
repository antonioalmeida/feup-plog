
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
	\+(piecePlayed( Game, Player, Piece )),
	getBoard( Game, Board ),

	isEmpty( Board, X, Y),
	isKing( Piece, Player ),
	assert( gameOver( currentGame )).

% move where player is forced to use queen
validateMove( Game, Player, Piece, X, Y ):-
	needsToPlayQueen( Game, Player ),
	!, 
	isQueen( Piece, Player ),
	getBoard( Game, Board ),	
	isEmpty( Board, X, Y ),

	otherPlayer( Player, Other ),
	getAttackedBoard( Game, Other, AttackedBoard ),
	getPieceAt( AttackedBoard, X, Y, TempPiece ),
	TempPiece == '1'.

% move where first player uses queen
validateMove( Game, Player, Piece, X, Y ):-
	\+(piecePlayed( Game, Player, Piece )),
	isQueen( Piece, Player ),
	getBoard( Game, Board ),	
	isEmpty( Board, X, Y ),

	otherPlayer( Player, Other ),
	getAttackedBoard( Game, Other, AttackedBoard ),
	getPieceAt( AttackedBoard, X, Y, TempPiece ),
	TempPiece == '1'.

% moves where player attempts to use queen or king when it was already played - invalid
validateMove( Game, Player, Piece, X, Y ):-
	piecePlayed( Game, Player, Piece ),
	isQueen( Piece, Player ), 
	!, false.

validateMove( Game, Player, Piece, X, Y ):-
	isKing( Piece, Player ), !, false.

% regular move
validateMove( Game, Player, Piece, X, Y ):-
	\+(piecePlayedTwice( Game, Player, Piece )),

	getBoard( Game, Board ),	
	isEmpty( Board, X, Y ),

	otherPlayer( Player, Other ),
	getAttackedBoard( Game, Other, AttackedBoard ),
	getPieceAt( AttackedBoard, X, Y, TempPiece ),
	TempPiece == '1'.
