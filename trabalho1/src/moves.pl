:-include('board.pl').

calculateAttackedPositions( Game ):-
    getBoard( Game, Board ),
    getAttackedBoard( Game, AttackedBoard ),
    X is 0, Y is 0,
    calculateAttackedPositionsAux( Board, AttackedBoard, X, Y, NewAttackedBoard ).

% case where board locations is NOT empty
calculateAttackedPositionsAux( Board, AttackedBoard, X, Y, NewAttackedBoard ):-
    \+(X==8),
    \+(isEmpty( Board, X, Y )),
    getPieceAt( Board, X, Y, Piece ),
    attackingPositions( Board, AttackedBoard, Piece, X, Y, NextAttackedBoard ),
    X1 is X+1,
    calculateAttackedPositionsAux( Board, NextAttackedBoard, X1, Y1, NewAttackedBoard).

% case where board location is empty
calculateAttackedPositionsAux( Board, AttackedBoard, X, Y, NewAttackedBoard ):-
    \+(X==8),
    isEmpty( Board, X, Y ),
    X1 is X+1,
    calculateAttackedPositionsAux( Board, NextAttackedBoard, X1, Y1, NewAttackedBoard).

% case where X == 8
calculateAttackedPositionsAux( Board, AttackedBoard, 8, Y, NewAttackedBoard ):-
    X1 is 0,
    Y1 is Y+1,
    calculateAttackedPositionsAux( Board, NextAttackedBoard, X1, Y1, NewAttackedBoard).

% King
attackingPositions( Board, AttackedPositions, Piece, X, Y, FinalAttackedPositions ):-
    isKing( Piece ),
    write('King'),
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
    makeMove( AttackedPositions8, '1', X, Y2, FinalAttackedPositions), % 1 means attacked position
    displayBoard(FinalAttackedPositions).

% Knight
attackingPositions( Board, AttackedPositions, Piece, X, Y, FinalAttackedPositions ):-
    isKnight( Piece ),
    write('Knight'),
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
    makeMove( AttackedPositions8, '1', X-2, Yminus1, FinalAttackedPositions ),
    displayBoard( FinalAttackedPositions ).

% Rook
attackingPositions( Board, AttackedPositions, Piece, X, Y, FinalAttackedPositions ):-
    isRook( Piece ),
    rookAttackedPositions( Board, AttackedPositions, X, Y, 1, 0, AttackedPositions1 ),
    rookAttackedPositions( Board, AttackedPositions1, X, Y, -1, 0, AttackedPositions2 ),
    rookAttackedPositions( Board, AttackedPositions2, X, Y, 0, 1, AttackedPositions3 ),
    rookAttackedPositions( Board, AttackedPositions3, X, Y, 0, -1, FinalAttackedPositions ),
    displayBoard( FinalAttackedPositions ).

rookAttackedPositions( _, AttackedPositions, 8, _, _, _, FinalAttackedPositions):-
    FinalAttackedPositions is AttackedPositions.

rookAttackedPositions( _, AttackedPositions, _, 8, _, _, FinalAttackedPositions):-
    FinalAttackedPositions is AttackedPositions.

% case where board location is occupied
rookAttackedPositions( Board, AttackedPositions, X, Y, DX, DY, FinalAttackedPositions):-
    CurrX is X+DX, CurrY is Y+DY,
    \+(isEmpty( Board, CurrX, CurrY )),
    makeMove( AttackedPositions, 'k', CurrX, CurrY, FinalAttackedPositions ).

% case where board location is empty
rookAttackedPositions( Board, AttackedPositions, X, Y, DX, DY, FinalAttackedPositions):-
    CurrX is X+DX, CurrY is Y+DY,
    isEmpty( Board, CurrX, CurrY ),
    makeMove( AttackedPositions, 'k', CurrX, CurrY, AttackedPositions1 ),
    rookAttackedPositions( Board, AttackedPositions1, CurrX, CurrY, DX, DY, FinalAttackedPositions ).

isKing('k').
isKing('K').

isKnight('N').
isKnight('n').

isRook('R').
isRook('r').
