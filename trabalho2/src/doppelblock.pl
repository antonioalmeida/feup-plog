:- use_module(library(lists)).
:- use_module(library(clpfd)).

solveInstance(N, LineSums, ColumnSums):-
    N > 2,

    % Numbers can only go up to N-2
    Limit is N-2,

    % Get an empty NxN board
    getInitialBoard(N, Board),

    % Ensure every value on the board is in range [0,N-2] (0 = black cell)
    ensureDomain(Limit, Board),

    % Ensure that numbers in each row/column are distinct
    % Also ensures exactly two black cells per row/column
    ensureAllDistinct(Limit, Board),

    % Ensures sum between black cells in each line is specified value (if specified)
    ensureSums(Limit, Board, LineSums),
    transpose(Board, Transposed),
    ensureSums(Limit, Transposed, ColumnSums),

    append(Board, Flattened),
    reset_timer,
    labeling([], Flattened),
    print_time,
    fd_statistics,
    write(Board), nl.

reset_timer :- statistics(walltime,_).
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.


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

ensureSums(_, [], []).
ensureSums(Limit, [Line | RemL], [Sum | RemS]):-
    getTransitions(Limit, [], TransitionList, C),
    automaton(Line, _, Line, [source(q0), sink(q2)], TransitionList, [C], [0], [Sum]),
    ensureSums(Limit, RemL, RemS).
