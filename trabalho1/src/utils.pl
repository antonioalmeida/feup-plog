:- use_module(library(lists)).

% replace element at I with X
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L).

% replace element at I 
inc([H|T], 0, R):- H1 is H+1, R = [H1|T].
inc([H|T], I, [H|R]):- I > -1, NI is I-1, inc(T, NI, R), !.
inc(L, _, L).

% if then else
ifte( If, Then, Else):-
	( If 
    -> Then
    ;  Else  
     ).

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
	N >= 0,
	N < 8.

countOccurences( List, Value, N ):-
	countOccurencesAux( List, Value, 0, N ).

countOccurencesAux( [], _, Result, Result ).
countOccurencesAux( [ Value | Tail ], Value, N, Result ):-
	N1 is N+1,
	countOccurencesAux( Tail, Value, N1, Result ).

countOccurencesAux( [ Head | Tail ], Value, N, Result ):-
	countOccurencesAux( Tail, Value, N, Result ).

clearScreen:-
	nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl.