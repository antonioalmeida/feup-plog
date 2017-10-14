:- use_module(library(random)).
:- use_module(library(system)).

%white pieces
getPieceDisplay(0, ' ').
getPieceDisplay(1, 'K').
getPieceDisplay(2, 'Q').
getPieceDisplay(3, 'B').
getPieceDisplay(4, 'H').
getPieceDisplay(5, 'T').

%black pieces
getPieceDisplay(6, 'k').
getPieceDisplay(7, 'q').
getPieceDisplay(8, 'b').
getPieceDisplay(9, 'h').
getPieceDisplay(10, 't').

displayBoard( Board ) :-
	displayBoardHeader,
	N is 1,
	displayBoardTail(Board, N),
	displayBottom.

displayBoardTail([], 9). %not sure why 9 works and 8 not

displayBoardTail( [ Line | T ], N ):-
	write('|       |       |       |       |       |       |       |       |'), nl,
	write('-----------------------------------------------------------------'), nl,
	write('|       |       |       |       |       |       |       |       |'), nl,
	displayLine(Line, N), nl,
	N1 is N+1,
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
