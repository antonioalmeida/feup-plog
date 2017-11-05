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

isWithinLimits(0).
isWithinLimits(1).
isWithinLimits(2).
isWithinLimits(3).
isWithinLimits(4).
isWithinLimits(5).
isWithinLimits(6).
isWithinLimits(7).
