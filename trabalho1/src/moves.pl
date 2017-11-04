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

attackingPositions( AttackedPositions, KingInt, X, Y, FinalAttackedPositions ):-
	isKing( KingInt ),
	Y1 is Y-1,
	Y2 is Y+1,
	% not really making a movie, simply putting 1 on the given position %
	makeMove( AttackedPositions, 1, X+1, Y, AttackedPositions2), % 1 means attacked position
	makeMove( AttackedPositions2, 1, X-1, Y, AttackedPositions3), % 1 means attacked position
	makeMove( AttackedPositions3, 1, X, Y1, AttackedPositions4), % 1 means attacked position
	makeMove( AttackedPositions4, 1, X, Y2, FinalAttackedPositions), % 1 means attacked position
	displayBoard(FinalAttackedPositions).

isKing(1).
isKing(6).