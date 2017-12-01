:- use_module(library(lists)).
:- use_module(library(clpfd)).

solveInstance(N, ColumnsSum, LinesSum):-
    N > 2,
    getInitialBoard(N, Board),

    ensureDomain(N, Board),
    ensureBlackCells(Board),
    ensureAllDistinct(Board),

    append(Board, Flattened),
    labeling([], Flattened),
    write(Board).

% Ensures the domain of the variables used
ensureDomain(N, Board):-
    LimitN is N-2,
    ensureDomainLine(LimitN, Board).

ensureDomainLine(_, []).
ensureDomainLine(Limit, [Line | Remaining]):-
    domain(Line, 0, Limit),
    ensureDomainLine(Limit, Remaining).

% Ensures that in a line/column there are exactly two black cells
ensureBlackCells(Board):-
    maplist(twoBlackCells, Board),
    transpose(Board, TransposedBoard),
    maplist(twoBlackCells, TransposedBoard).

twoBlackCells(List):-
    count(0, List, #=, 2).

% Ensures that all elements in a line/column are different (except black cells)
ensureAllDistinct(Board):-
    maplist(allDistinct, Board),
    transpose(Board, TransposedBoard),
    maplist(allDistinct, TransposedBoard).

allDistinct(List):-
    delete(Line, 0, NewList),
    all_distinct(NewList).

% Generate an empty NxN matrix represented by a list of lists
getInitialBoard(N, Board):-
    getInitialBoardAux(N, N, [], Board).

getInitialBoardAux(0, _, Board, Board).
getInitialBoardAux(N, Size, AccBoard, Board):-
    N1 is N-1,
    length(NewLine, Size),
    append(AccBoard, [NewLine], NewAccBoard),
    getInitialBoardAux(N1, Size, NewAccBoard, Board).
