:- use_module(library(random)).
:- use_module(library(system)).

getPieceDisplay(0, 32). % space

%white pieces
getPieceDisplay(1, 9812). % king
getPieceDisplay(2, 9813). % queen
getPieceDisplay(3, 9815). % bishop
getPieceDisplay(4, 9815). % knight
getPieceDisplay(5, 9814). % rook

%black pieces
getPieceDisplay(6, 9818). % king
getPieceDisplay(7, 9819). % queen
getPieceDisplay(8, 9821). % bishop
getPieceDisplay(9, 9822). % knight
getPieceDisplay(10, 9820). % rook

displayBoard( Board ) :-
	displayBoardHeader,
	N is 8,
	displayBoardTail(Board, N),
	displayBottom.

displayBoardTail([], 0). 

displayBoardTail( [ Line | T ], N ):-
	write('|       |       |       |       |       |       |       |       |'), nl,
	write('-----------------------------------------------------------------'), nl,
	write('|       |       |       |       |       |       |       |       |'), nl,
	displayLine(Line, N), nl,
	N1 is N-1,
	displayBoardTail(T, N1).

displayLine([], N):- 
	write('|  '), displayNumber(N).

displayLine( [ CurrentPiece | T ] , N ):-
	write('|   '),
	getPieceDisplay(CurrentPiece, PieceDisplay),
	put_code(PieceDisplay),
	write('   '),
	displayLine(T, N).

displayBoardHeader:- 
	nl,
	write('     a      b       c       d       e       f       g       h     '),
	nl.

displayBottom:-
	write('|       |       |       |       |       |       |       |       |'), nl,
	write('-----------------------------------------------------------------'), nl.


displayNumber(N) :- write(N), !.

initialBoard([[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0]]).

