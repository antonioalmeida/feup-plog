:- use_module(library(system)).

getPieceDisplay(0, 32). % space

% DONT FORGET : update internal 
% piece representation on final
% report 

%white pieces
getPieceDisplay('K', 9812). % king
getPieceDisplay('Q', 9813). % queen
getPieceDisplay('R', 9814). % rook
getPieceDisplay('B', 9815). % bishop
getPieceDisplay('N', 9816). % knight

%black pieces
getPieceDisplay('k', 9818). % king
getPieceDisplay('q', 9819). % queen
getPieceDisplay('r', 9820). % rook
getPieceDisplay('b', 9821). % bishop
getPieceDisplay('n', 9822). % knight

displayBoard( Board ) :-
	displayBoardHeader,
	N is 8,
	displayBoardTail(Board, N),
	displayBottom.

displayBoardTail([], 0). 

displayBoardTail( [ Row | T ], N ):-
	write('---------------------------------'), nl,
	displayRow(Row, N), nl,
	N1 is N-1,
	displayBoardTail(T, N1).

displayRow([], N):- 
	write('| '), displayNumber(N).

displayRow( [ CurrentPiece | T ] , N ):-
	write('| '),
	getPieceDisplay(CurrentPiece, PieceDisplay),
	put_code(PieceDisplay),
	write(' '),
	displayRow(T, N).

displayBoardHeader:- 
	nl,
	write('  a   b   c   d   e   f   g   h '),
	nl.

displayBottom:-
	write('---------------------------------'), nl.


displayNumber(N) :- write(N), !.

% verifies if given board position is empty (aka == 0)
isEmpty( Board, X, Y ):-
	N is 0,
	isEmptyAux( Board, N, X, Y ).

isEmptyAux( [ Row | RestOfBoard ], Y, X, Y ):-
	nth0( X, Row, 0). % true if Row[X] is 0

isEmptyAux( [ Row | RestOfBoard ], N, X, Y ):-
	N1 is N+1,
	isEmptyAux( RestOfBoard, N1, X, Y).

initialBoard([[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0]]).

