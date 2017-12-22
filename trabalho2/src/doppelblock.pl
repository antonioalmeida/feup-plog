:- use_module(library(lists)).
:- use_module(library(clpfd)).
:- use_module(library(system)).
:- use_module(library(random)).

:- include('board.pl').

solveInstance(LineSums, ColumnSums):-
    %Ensure sums lists are of equal size
    length(LineSums, N),
    length(ColumnSums, N),

    % Numbers go from 1 to N-2 so puzzle is not defined for N <= 2
    N > 2,

    % Numbers can only go up to N-2
    Limit is N-2,

    % Get the NxN board domain variables
    getInitialBoard(N, Board),

    % Ensure domain of every value on the board (is in range [0,N-2], with 0 = black cell)
    ensureDomain(Limit, Board),

    % Restriction 1
    % Ensure that numbers in each row/column are distinct
    % Also ensures exactly two black cells per row/column
    ensureAllDistinct(Limit, Board),

    % Restriction 2
    % Ensures sum between black cells in each line/column is specified value (if specified)
    maplist(ensureSums(Limit), Board, LineSums),
    transpose(Board, Transposed),
    maplist(ensureSums(Limit), Transposed, ColumnSums),

    append(Board, Flattened),
    reset_timer,
    labeling([bisect, down], Flattened),
    print_time,
    fd_statistics,
    displayBoard(Board, N, LineSums, ColumnSums), nl.

generateInstance(N, LineSums, ColumnSums, Difficulty):-
    N > 2,

    % Numbers can only go up to N-2
    Limit is N-2,

    length(LineSums, N),
    length(ColumnSums, N),

    % Get an empty NxN board
    getInitialBoard(N, Board),

    % Ensure every value on the board is in range [0,N-2] (0 = black cell)
    ensureDomain(Limit, Board),

    % Ensure that numbers in each row/column are distinct
    % Also ensures exactly two black cells per row/column
    ensureAllDistinct(Limit, Board),

    ensureNoAdjacentBlackCells(Limit, Board),

    % Force first sum to be a random value so it generates different boards
    now(Time),
    setrand(Time),
    MaxSum is round(Limit*(Limit+1)/2), %round to avoid number being floating point
    random(0, MaxSum, FirstSum),
    Board = [H | T],
    ensureSums(Limit, H, FirstSum),

    % Force line and column sums to be greater than a number, based on difficulty
    MaxSumLine is MaxSum*N,
    getMinSum(Difficulty, MaxSumLine, MinSum),
    SumL #> MinSum, SumC #> MinSum,
    sum(LineSums, #=, SumL), 
    sum(ColumnSums, #=, SumC), 

    append(Board, Flattened),
    reset_timer,
    labeling([], Flattened),

    calculateSums(Board, LineSums),
    transpose(Board, TransposedBoard),
    calculateSums(TransposedBoard, ColumnSums),

    print_time,
    fd_statistics.

getMinSum(easy, MaxSum, MinSum):- 
    MinSum is round(MaxSum/4).
getMinSum(medium, MaxSum, MinSum):- 
    MinSum is round(MaxSum/3).
getMinSum(hard, MaxSum, MinSum):- 
    MinSum is round(MaxSum/2).

reset_timer:- statistics(walltime,_).
print_time:-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl.

% Generate an empty NxN matrix represented by a list of lists
getInitialBoard(N, Board):-
    getInitialBoardAux(N, N, [], Board).

getInitialBoardAux(0, _, Board, Board).
getInitialBoardAux(N, Size, AccBoard, Board):-
    N > 0,
    N1 is N-1,
    length(NewLine, Size),
    append(AccBoard, [NewLine], NewAccBoard),
    getInitialBoardAux(N1, Size, NewAccBoard, Board).

% Ensures the domain of the variables used
ensureDomain(_, []).
ensureDomain(Limit, [Line | Remaining]):-
    domain(Line, 0, Limit),
    ensureDomain(Limit, Remaining).

% Ensures that all elements in a line/column are different (except black cells, which there are 2 of)
ensureAllDistinct(Limit, Board):-
    getValueAmountPairList(Limit, PairList),
    maplist(allDistinct(PairList), Board),
    transpose(Board, TransposedBoard),
    maplist(allDistinct(PairList), TransposedBoard).

getValueAmountPairList(0, [0-2]). % Each value comes up once, except for 0 (black cell)
getValueAmountPairList(N, PairList):-
    N > 0,
    N1 is N-1,
    getValueAmountPairList(N1, PairListTemp),
    append(PairListTemp, [N-1], PairList). %Value should show up exactly once

allDistinct(PairList, Line):-
    global_cardinality(Line, PairList).

getTransitions(0, AuxList, TransitionList, _):-
    append(AuxList, [arc(q0,0,q1), arc(q1,0,q2)], TransitionList).
getTransitions(N, AuxList, TransitionList, Counter):-
    N > 0,
    append(AuxList, [arc(q0,N,q0), arc(q1,N,q1,[Counter+N]), arc(q2,N,q2)], NewAuxList),
    N1 is N-1,
    getTransitions(N1, NewAuxList, TransitionList, Counter).

ensureSums(Limit, _, -1).
ensureSums(Limit, Line, Sum):-
    getTransitions(Limit, [], TransitionList, C),
    automaton(Line, _, Line, [source(q0), sink(q2)], TransitionList, [C], [0], [Sum]).

getMaxNTransitions(Limit, Source, Dest, TransitionList):-
    write('Ola: '), write(Limit), nl,
    getMaxNTransitionsAux(Limit, 1, Source, Dest, [], TransitionList).

getMaxNTransitionsAux(Limit, Limit, Source, Dest, AuxList, TransitionList):-
    append([arc(Source, Limit, Dest)], AuxList, TransitionList).

getMaxNTransitionsAux(Limit, N, Source, Dest, AuxList, TransitionList):-
    append([arc(Source, N, Dest)], AuxList, NewAuxList),
    N1 is N+1,
    write(N1), nl,
    getMaxNTransitionsAux(Limit, N1, Source, Dest, NewAuxList, TransitionList).

ensureNoAdjacentBlackCells(N, Board):-
    getMaxNTransitions(N, q0, q0, Q0Transitions),
    getMaxNTransitions(N, q1, q2, Q1Transitions),
    getMaxNTransitions(N, q2, q2, Q2Transitions),
    getMaxNTransitions(N, q3, q3, Q3Transitions),
    append(Q0Transitions, Q1Transitions, TempTransitions),
    append(Q2Transitions, Q3Transitions, TempTransitions2),
    append(TempTransitions, TempTransitions2, DynamicTransitions),
    append([arc(q0, 0, q1), arc(q2, 0, q3) ], DynamicTransitions, TransitionList),

    maplist(ensureNoAdjacentBlackCellsLine(N, TransitionList), Board),
    transpose(Board, TransposedBoard),
    maplist(ensureNoAdjacentBlackCellsLine(N, TransitionList), TransposedBoard).

ensureNoAdjacentBlackCellsLine(N, TransitionList, Line):-
    automaton(Line, [source(q0), sink(q3)], TransitionList).

calculateSums(Board, Sums):-
    calculateSumsAux(Board, [], Temp),
    reverse(Temp, Sums).

calculateSumsAux([], Sums, Sums).
calculateSumsAux([Line|RestBoard], Aux, Sums):-
    calculateSumsLine(Line, LineSum),
    append([LineSum], Aux, NextAux),
    calculateSumsAux(RestBoard, NextAux, Sums).

calculateSumsLine([0|Rest], Sum):-
    calculateSumsLineAux(Rest, 0, Sum).
calculateSumsLine([Val|Rest], Sum):-
    calculateSumsLine(Rest, Sum).

calculateSumsLineAux([0|Rest], Sum, Sum).
calculateSumsLineAux([Val|Rest], Aux, Sum):-
    NextAux is Aux+Val,
    calculateSumsLineAux(Rest, NextAux, Sum).
