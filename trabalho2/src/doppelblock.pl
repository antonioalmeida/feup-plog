:- use_module(library(lists)).
:- use_module(library(clpfd)).

solveInstance(N, ColumnsSum, LinesSum, Board):-
    N > 2,

    % Numbers can only go up to N-2
    Limit is N-2,

    % Get an empty NxN board
    getInitialBoard(N, Board),

    % Ensure every value on the board is in range [0,N-2] (0 = black cell)
    ensureDomain(Limit, Board),

    % Ensure that in every row/column there are exactly two black cells
    %ensureBlackCells(Board),

    % Ensure that numbers in each row/column are distinct
    ensureAllDistinct(Limit, Board),

    ensureSums(Board, ColumnsSum, LinesSum),

    append(Board, Flattened),
    labeling([], Flattened),
    write(Board).

% Ensures the domain of the variables used
ensureDomain(_, []).
ensureDomain(Limit, [Line | Remaining]):-
    domain(Line, 0, Limit),
    ensureDomain(Limit, Remaining).

% Ensures that in a line/column there are exactly two black cells
%ensureBlackCells(Board):-
%    maplist(twoBlackCells, Board),
%    transpose(Board, TransposedBoard),
%    maplist(twoBlackCells, TransposedBoard).
%twoBlackCells(List):-
%    count(0, List, #=, 2).

% Ensures that all elements in a line/column are different (except black cells, which there are 2 of)
ensureAllDistinct(Limit, Board):-
    getValueAmountPairList(Limit, PairList),
    write(PairList), nl,
    maplist(allDistinct(PairList), Board),
    transpose(Board, TransposedBoard),
    maplist(allDistinct(PairList), TransposedBoard).

getValueAmountPairList(0, [0-2]). % Each value comes up once, except for 0 (black cell)
getValueAmountPairList(N, PairList):-
    N1 is N-1,
    getValueAmountPairList(N1, PairListTemp),
    append(PairListTemp, [N-1], PairList). %Value should show up exactly once

allDistinct(PairList, Line):-
    global_cardinality(Line, PairList). 

% Generate an empty NxN matrix represented by a list of lists
getInitialBoard(N, Board):-
    getInitialBoardAux(N, N, [], Board).

getInitialBoardAux(0, _, Board, Board).
getInitialBoardAux(N, Size, AccBoard, Board):-
    N1 is N-1,
    length(NewLine, Size),
    append(AccBoard, [NewLine], NewAccBoard),
    getInitialBoardAux(N1, Size, NewAccBoard, Board).

ensureSums(Board, ValuesRows, ValuesCols):-
   maplist(ensureSumsAux(5),Board),
   transpose(Board, TransposedBoard),
   maplist(ensureSumsAux(5),TransposedBoard).

ensureSumsAux(Value, Line):-
    getSubList(Line, SubList),
    sum(SubList, #=, Value).

getSubList(List, Sub):-
    Element #= 0,
    subseq1(List, [Element|Sub]),
    last(Sub, Element).
