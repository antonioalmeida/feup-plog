updateAttackedBoard( Game, NewGame ):-
    getBoard( Game, Board ),
    initialBoard( AttackedBoard ),
    X is 0, Y is 0,
    updateAttackedBoardAux( white, Board, AttackedBoard, X, Y, NewAttackedBoardWhite ),
    updateAttackedBoardAux( black, Board, AttackedBoard, X, Y, NewAttackedBoardBlack ),
    setAttackedBoard( Game, white, NewAttackedBoardWhite, TempGame ),
    setAttackedBoard( TempGame, black, NewAttackedBoardBlack, NewGame ),
    nl, write('Attacked White'), nl,
    displayBoard( NewAttackedBoardWhite ),
    nl, write('Attacked Black'), nl,
    displayBoard( NewAttackedBoardBlack ).

% case where board locations is NOT empty
updateAttackedBoardAux( Player, Board, AttackedBoard, X, Y, NewAttackedBoard ):-
    \+(X == 8),
    \+(isEmpty( Board, X, Y )),
    getPieceAt( Board, X, Y, Piece ),
    attackingPositions( Player, Board, AttackedBoard, Piece, X, Y, NextAttackedBoard ),
    X1 is X+1,
    updateAttackedBoardAux( Player, Board, NextAttackedBoard, X1, Y, NewAttackedBoard).

% case where board location is empty
updateAttackedBoardAux( Player, Board, AttackedBoard, X, Y, NewAttackedBoard ):-
    \+(X == 8),
    isEmpty( Board, X, Y ),
    X1 is X+1,
    updateAttackedBoardAux( Player, Board, AttackedBoard, X1, Y, NewAttackedBoard).

% case where X == 8
updateAttackedBoardAux( Player, Board, AttackedBoard, 8, Y, NewAttackedBoard ):-
    X1 is 0,
    Y1 is Y+1,
    updateAttackedBoardAux( Player, Board, AttackedBoard, X1, Y1, NewAttackedBoard).

% case where Y == 8 (final case)
updateAttackedBoardAux( Player, _, AttackedBoard, _, 8, NewAttackedBoard ):-
    NewAttackedBoard = AttackedBoard.

% King
attackingPositions( Player, Board, AttackedPositions, Piece, X, Y, FinalAttackedPositions ):-
    isKing( Piece, Player ),
    Y1 is Y-1,
    Y2 is Y+1,
    X1 is X-1,
    X2 is X+1,
    % not really making a move, simply putting 1 on the given position %
    makeMove( AttackedPositions, '1', X1, Y, AttackedPositions2), % 1 means attacked position
    makeMove( AttackedPositions2, '1', X1, Y1, AttackedPositions3), % 1 means attacked position
    makeMove( AttackedPositions3, '1', X1, Y2, AttackedPositions4), % 1 means attacked position
    makeMove( AttackedPositions4, '1', X2, Y, AttackedPositions5), % 1 means attacked position
    makeMove( AttackedPositions5, '1', X2, Y1, AttackedPositions6), % 1 means attacked position
    makeMove( AttackedPositions6, '1', X2, Y2, AttackedPositions7), % 1 means attacked position
    makeMove( AttackedPositions7, '1', X, Y1, AttackedPositions8), % 1 means attacked position
    makeMove( AttackedPositions8, '1', X, Y2, FinalAttackedPositions). % 1 means attacked position

% Knight
attackingPositions( Player, Board, AttackedPositions, Piece, X, Y, FinalAttackedPositions ):-
    isKnight( Piece, Player ),
    Yplus2 is Y+2,
    Yminus2 is Y-2,
    Yplus1 is Y+1,
    Yminus1 is Y-1,
    makeMove( AttackedPositions, '1', X+1, Yplus2, AttackedPositions2 ),
    makeMove( AttackedPositions2, '1', X+1, Yminus2, AttackedPositions3 ),
    makeMove( AttackedPositions3, '1', X-1, Yplus2, AttackedPositions4 ),
    makeMove( AttackedPositions4, '1', X-1, Yminus2, AttackedPositions5 ),
    makeMove( AttackedPositions5, '1', X+2, Yplus1, AttackedPositions6 ),
    makeMove( AttackedPositions6, '1', X+2, Yminus1, AttackedPositions7 ),
    makeMove( AttackedPositions7, '1', X-2, Yplus1, AttackedPositions8 ),
    makeMove( AttackedPositions8, '1', X-2, Yminus1, FinalAttackedPositions ).

% Rook
attackingPositions( Player, Board, AttackedPositions, Piece, X, Y, FinalAttackedPositions ):-
    isRook( Piece, Player ),
    pieceAttackedPositions( Board, AttackedPositions, X, Y, 1, 0, AttackedPositions1 ),
    pieceAttackedPositions( Board, AttackedPositions1, X, Y, -1, 0, AttackedPositions2 ),
    pieceAttackedPositions( Board, AttackedPositions2, X, Y, 0, 1, AttackedPositions3 ),
    pieceAttackedPositions( Board, AttackedPositions3, X, Y, 0, -1, FinalAttackedPositions ).

% Bishop
attackingPositions( Player, Board, AttackedPositions, Piece, X, Y, FinalAttackedPositions ):-
    isBishop( Piece, Player ),
    pieceAttackedPositions( Board, AttackedPositions, X, Y, 1, 1, AttackedPositions1 ),
    pieceAttackedPositions( Board, AttackedPositions1, X, Y, 1, -1, AttackedPositions2 ),
    pieceAttackedPositions( Board, AttackedPositions2, X, Y, -1, 1, AttackedPositions3 ),
    pieceAttackedPositions( Board, AttackedPositions3, X, Y, -1, -1, FinalAttackedPositions ).

% Queen
attackingPositions( Player, Board, AttackedPositions, Piece, X, Y, FinalAttackedPositions ):-
    isQueen( Piece ),
    pieceAttackedPositions( Board, AttackedPositions, X, Y, 1, 0, AttackedPositions1 ),
    pieceAttackedPositions( Board, AttackedPositions1, X, Y, -1, 0, AttackedPositions2 ),
    pieceAttackedPositions( Board, AttackedPositions2, X, Y, 0, 1, AttackedPositions3 ),
    pieceAttackedPositions( Board, AttackedPositions3, X, Y, 0, -1, AttackedPositions4 ),
    pieceAttackedPositions( Board, AttackedPositions4, X, Y, 1, 1, AttackedPositions5 ),
    pieceAttackedPositions( Board, AttackedPositions5, X, Y, 1, -1, AttackedPositions6 ),
    pieceAttackedPositions( Board, AttackedPositions6, X, Y, -1, 1, AttackedPositions7 ),
    pieceAttackedPositions( Board, AttackedPositions7, X, Y, -1, -1, FinalAttackedPositions ).

% Case where piece is from different player
attackingPositions( Player, Board, AttackedPositions, Piece, X, Y, FinalAttackedPositions ):-
    FinalAttackedPositions = AttackedPositions.

% Recursive generic function %

% case where off limits in x
pieceAttackedPositions( _, AttackedPositions, 8, _, _, _, FinalAttackedPositions):-
    FinalAttackedPositions is AttackedPositions.

pieceAttackedPositions( _, AttackedPositions, -1, _, _, _, FinalAttackedPositions):-
    FinalAttackedPositions is AttackedPositions.

% case where off limits in y
pieceAttackedPositions( _, AttackedPositions, _, 8, _, _, FinalAttackedPositions):-
    FinalAttackedPositions is AttackedPositions.

pieceAttackedPositions( _, AttackedPositions, _, -1, _, _, FinalAttackedPositions):-
    FinalAttackedPositions is AttackedPositions.

% case where board location is occupied
pieceAttackedPositions( Board, AttackedPositions, X, Y, DX, DY, FinalAttackedPositions):-
    CurrX is X+DX, CurrY is Y+DY,
    \+(isEmpty( Board, CurrX, CurrY )),
    makeMove( AttackedPositions, '1', CurrX, CurrY, FinalAttackedPositions ).

% case where board location is empty
pieceAttackedPositions( Board, AttackedPositions, X, Y, DX, DY, FinalAttackedPositions):-
    CurrX is X+DX, CurrY is Y+DY,
    isEmpty( Board, CurrX, CurrY ),
    makeMove( AttackedPositions, '1', CurrX, CurrY, AttackedPositions1 ),
    pieceAttackedPositions( Board, AttackedPositions1, CurrX, CurrY, DX, DY, FinalAttackedPositions ).

isKing('K', white).
isKing('k', black).

isKnight('N', white).
isKnight('n', black).

isRook('R', white).
isRook('r', black).

isBishop('B', white).
isBishop('b', black).

isQueen('Q', white).
isQueen('q', black).
