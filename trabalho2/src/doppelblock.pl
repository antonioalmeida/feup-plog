:- use_module(library(lists)).
:- use_module(library(clpfd)).

:- dynamic pairlist/1.

solveInstance(N, ColumnSums, LineSums):-
    N > 2,
    getInitialBoard(N, Board),
    write('Board generated:'),nl,
    write(Board), nl,

    ensureDomain(N, Board), !,
    write('Domain ensured'), nl,
    write(Board), nl,

    ensureAllDistinct(N, Board),
    ensureSums(Board, ColumnSums, LineSums),

    append(Board, Flattened),
    labeling([], Flattened),
    write(Board).

% Ensures the domain of the variables used
ensureDomain(N, Board):-
    LimitN #= N-2,
    ensureDomainLine(LimitN, Board).

ensureDomainLine(_, []).
ensureDomainLine(Limit, [Line | Remaining]):-
    domain(Line, 0, Limit),
    ensureDomainLine(Limit, Remaining).

% Ensures that all elements in a line/column are different (except black cells which there are always 2 of)
ensureAllDistinct(N, Board):-
    N2 #= N-2,
    getPairList(N2, PairList), !,
    assert(pairlist(PairList)),
    maplist(allDistinct, Board),
    transpose(Board, TransposedBoard),
    maplist(allDistinct, TransposedBoard).

getPairList(N, PairList):-
    getPairListAux(N, [0-2], PairList).

getPairListAux(0, PairList, PairList).
getPairListAux(N, AccPairList, PairList):-
    N1 #= N-1,
    append(AccPairList, [N-1], NewAccPairList),
    getPairListAux(N1, NewAccPairList, PairList).

allDistinct(List):-
    pairlist(PairList),
    global_cardinality(List, PairList).

% Ensures that the sum of the elements between two black cells in a line/columnn is a specified value
ensureSums(Board, ColumnSums, LineSums):-
    write('Ensure sums initiating, board is:'), nl,
    write(Board), nl,
    ensureLineSums(Board, LineSums),
    write('Lines done'), nl,
    transpose(Board, TransposedBoard),
    ensureLineSums(TransposedBoard, ColumnSums),
    write('Columns done'), nl, !.

ensureLineSums([], []).
ensureLineSums([CurrLine | RemLines], [CurrSum | RemSums]):-
    write('Processing line '), write(CurrLine), write(', sum has to be '), write(CurrSum), nl,
    element(BlackCell1, CurrLine, 0),
    element(BlackCell2, CurrLine, 0),
    BlackCell1 #< BlackCell2,
    sumBetween(CurrLine, BlackCell1, BlackCell2, 0, CurrSum),
    ensureLineSums(RemLines, RemSums),
    write('Sum check'), nl.

sumBetween(List, End, End, Sum, Sum).
sumBetween(List, Start, End, AccSum, Sum):-
    NewStart #= Start + 1,
    element(Start, List, Elem),
    NewAcc #= AccSum + Elem,
    sumBetween(List, NewStart, End, NewAcc, Sum).

extractSubList(Line, Start, End, Sublist):-
    extractSubListAux(Line, Start, End, [], Sublist).

extractSubListAux(List, End, End, Sublist, Sublist).
extractSubListAux(List, Start, End, AccSublist, Sublist):-
    element(Start, List, Current),
    append(AccSublist, [Current], NewAccSublist),
    NewStart #= Start + 1,
    extractSubListAux(List, NewStart, End, NewAccSublist, Sublist).

% Generate an empty NxN matrix represented by a list of lists
getInitialBoard(N, Board):-
    getInitialBoardAux(N, N, [], Board).

getInitialBoardAux(0, _, Board, Board).
getInitialBoardAux(N, Size, AccBoard, Board):-
    N1 #= N-1,
    length(NewLine, Size),
    append(AccBoard, [NewLine], NewAccBoard),
    getInitialBoardAux(N1, Size, NewAccBoard, Board).
