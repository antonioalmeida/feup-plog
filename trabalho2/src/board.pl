:- use_module(library(system)).

getDisplay(0, ' '). % black space
getDisplay(A,A). % other digits

displayBoard(Board, N, LineSums, ColumnSums):-
	nl,
	write('   '),
	displayBoardHeader(LineSums),
	displayBoardTail(Board, N, ColumnSums),
	write('  '),
	displaySeparator(N).

displayBoardTail([], _, _).
displayBoardTail([Line | RestLines], N, [Sum | RestSums]):-
	write('  '),
	displaySeparator(N),
	write('  '),
	displayLine(Line, Sum), nl,
	displayBoardTail(RestLines, N, RestSums).

displayLine([], Sum):- write('| - '), write(Sum).
displayLine([Value | T], Sum):-
	write('| '),
	write(Value),
	write(' '),
	displayLine(T, Sum).

displayBoardHeader([]):- nl.
displayBoardHeader([H|T]):-
	write(' '), write(H), write('  '),
	displayBoardHeader(T).

displaySeparator(0):- nl.
displaySeparator(N):-
	write('----'),
	N1 is N-1,
	displaySeparator(N1).
