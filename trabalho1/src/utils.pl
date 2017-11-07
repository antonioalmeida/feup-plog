:- use_module(library(lists)).

% replace element at I with X
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L). 

% get element at index - alias for easier reading
elementAt(N, List, Element):- nth0(N, List, Element).

% verifies if given board position is empty (aka == 0)
isEmpty( Board, X, Y ):-
	N is 0,
	isEmptyAux( Board, N, X, Y ).

isEmptyAux( [ Row | RestOfBoard ], Y, X, Y ):-
	nth0( X, Row, 0). % true if Row[X] is 0

isEmptyAux( [ Row | RestOfBoard ], N, X, Y ):-
	N1 is N+1,
	isEmptyAux( RestOfBoard, N1, X, Y).

isWithinLimits(N):-
	N > -1,
	N < 8.

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