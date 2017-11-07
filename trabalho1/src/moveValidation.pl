
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
validateMove( Game, 7, Player, Piece, X, Y ):-
	!, 
	\+(piecePlayed( Player, Piece )),
	getBoard( Game, Board ),

	isEmpty( Board, X, Y),
	isKing( Piece, Player ).

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
	write('Move where first player uses queen.'), nl,
	\+(piecePlayed( Player, Piece )),
	write('Passed'), nl,
	isQueen( Piece, Player ),
	getBoard( Game, Board ),	
	isEmpty( Board, X, Y ),

	otherPlayer( Player, Other ),
	getAttackedBoard( Game, Other, AttackedBoard ),
	getPieceAt( AttackedBoard, X, Y, TempPiece ),
	TempPiece == '1',
	assert(needsToPlayQueen( Other )).

% regular move
validateMove( Game, Player, Piece, X, Y ):-
	write('Regular move'), nl,
	\+(piecePlayed( Player, Piece )),
	write('Passed'), nl,
	getBoard( Game, Board ),	
	isEmpty( Board, X, Y ),

	otherPlayer( Player, Other ),
	getAttackedBoard( Game, Other, AttackedBoard ),
	getPieceAt( AttackedBoard, X, Y, TempPiece ),
	TempPiece == '1'.
