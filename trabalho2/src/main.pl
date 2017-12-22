:- include('doppelblock.pl').

clearScreen:-
	nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl,nl.

doppelblock:-
	clearScreen,
	write(' Doppelblock Solver Main Menu'), nl, nl,
	write('1 - Solve user puzzle.'), nl,
	write('2 - Generate and solve puzzle.'), nl,
	write('3 - Solve sample puzzle.'), nl,
	write('4 - Exit.'), nl,
	get_char( N ),
    get_char(_),
	clearScreen,
	runOption( N ).

runOption('1'):-
    write('Insert line sums in format [Sum1, Sum2, ..., SumN]: '),
    read(LineSums),
    write('Insert column sums in the same format: '),
    read(ColumnSums), !,
    solveInstance(LineSums, ColumnSums),
    backtoMainMenu.

runOption('2'):-
    write('Difficulty of board to generate:'), nl,
    write('1 - Easy'), nl,
    write('2 - Medium'), nl,
    write('3 - Hard'), nl,
    get_char(DN),
    get_char(_),
    clearScreen,
    write('Size of board sums to generate: '),
    read(N),
    getDifficulty(DN, Difficulty),
    generateInstance(N, LineSums, ColumnSums, Difficulty),
    write('Generated instance:'),nl,
    write('Line sums: '), write(LineSums),nl,
    write('Column sums: '), write(ColumnSums),nl,
    write('Solving...'), !,
    solveInstance(LineSums, ColumnSums),
    backtoMainMenu.

runOption('3'):-
    write('Which sample puzzle do you want to see solved: '), nl,
    write('1 - Line Sums/Column Sums = [9,7,2,10,3,1]/[4,8,4,5,6,5]'),nl,
    write('2 - Line Sums/Column Sums = [2,6,0,3,4]/[3,1,0,6,3]'),nl,
    write('3 - Line Sums/Column Sums = [4,5,4,4,8,4,0]/[10,4,4,4,5,5,12]'),nl,
    write('Your choice: '),
    get_char(N),
    get_char(_),
    write('Solving...'),nl,!,
    solveSample(N),
    backtoMainMenu.

runOption(_).

solveSample('1'):-
    solveInstance([9,7,2,10,3,1],[4,8,4,5,6,5]).

solveSample('2'):-
    solveInstance([2,6,0,3,4],[3,1,0,6,3]).

solveSample('3'):-
    solveInstance([4,5,4,4,8,4,0],[10,4,4,4,5,5,12]).

getDifficulty('1', easy).
getDifficulty('2', medium).
getDifficulty('3', hard).

solveSample(_).

backtoMainMenu:-
    write('Press any key to continue'), nl,
    get_char(_),
    get_char(_),
    doppelblock.
