:-include('board.pl').

calculateAttackedPositions( Game ):-
    getBoard( Game, Board ),
    getAttackedBoard( Game, AttackedBoard ),
    X is 0, Y is 0,
    calculateAttackedPositionsAux( Board, AttackedBoard, X, Y, NewAttackedBoard ).
    % needs to be completed %

calculateAttackedPositionsAux( Board, AttackedPositions, X, Y, NewAttackedBoard ):-
    diff(isEmpty( Board, X, Y ), true). % does this work?
    % needs to be completed %

% King
attackingPositions( AttackedPositions, Piece, X, Y, FinalAttackedPositions ):-
    isKing( Piece ),
    write('King'),
    Y1 is Y-1,
    Y2 is Y+1,
    % not really making a move, simply putting 1 on the given position %
    makeMove( AttackedPositions, 'k', X+1, Y, AttackedPositions2), % 1 means attacked position
    makeMove( AttackedPositions2, 'k', X-1, Y, AttackedPositions3), % 1 means attacked position
    makeMove( AttackedPositions3, 'k', X, Y1, AttackedPositions4), % 1 means attacked position
    makeMove( AttackedPositions4, 'k', X, Y2, FinalAttackedPositions), % 1 means attacked position
    displayBoard(FinalAttackedPositions).

% Knight
attackingPositions( AttackedPositions, Piece, X, Y, FinalAttackedPositions ):-
    isKnight( Piece ),
    write('Knight'),
    Yplus2 is Y+2,
    Yminus2 is Y-2,
    Yplus1 is Y+1,
    Yminus1 is Y-1,

    makeMove( AttackedPositions, 'k', X+1, Yplus2, AttackedPositions2 ),
    makeMove( AttackedPositions2, 'k', X+1, Yminus2, AttackedPositions3 ),

    makeMove( AttackedPositions3, 'k', X-1, Yplus2, AttackedPositions4 ),
    makeMove( AttackedPositions4, 'k', X-1, Yminus2, AttackedPositions5 ),

    makeMove( AttackedPositions5, 'k', X+2, Yplus1, AttackedPositions6 ),
    makeMove( AttackedPositions6, 'k', X+2, Yminus1, AttackedPositions7 ),

    makeMove( AttackedPositions7, 'k', X-2, Yplus1, AttackedPositions8 ),
    makeMove( AttackedPositions8, 'k', X-2, Yminus1, FinalAttackedPositions ),
    displayBoard( FinalAttackedPositions ).


isKing('k').
isKing('K').

isKnight('N').
isKnight('n').