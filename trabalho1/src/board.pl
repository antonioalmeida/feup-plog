:- use_module(library(random)).
:- use_module(library(system)).

%white pieces
getPieceDisplay(0, ' ').
getPieceDisplay(1, 'K').
getPieceDisplay(2, 'Q').
getPieceDisplay(3, 'B').
getPieceDisplay(4, 'H').
getPieceDisplay(5, 'R').

%black pieces
getPieceDisplay(6, 'k').
getPieceDisplay(7, 'q').
getPieceDisplay(8, 'b').
getPieceDisplay(9, 'h').
getPieceDisplay(10, 'r').

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
	write(PieceDisplay),
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
