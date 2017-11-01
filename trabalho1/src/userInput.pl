:- use_module(library(lists)).

% white pieces
getPieceFromChar('K', 1). % king
getPieceFromChar('Q', 2). % queen
getPieceFromChar('R', 3). % rook
getPieceFromChar('B', 4). % bishop
getPieceFromChar('N', 5). % knight

% black pieces
getPieceFromChar('k', 6). % king
getPieceFromChar('q', 7). % queen
getPieceFromChar('r', 8). % rook
getPieceFromChar('b', 9). % bishop
getPieceFromChar('n', 10). % knight

getPieceFromChar(' ', 0). % space

% rows to ints
getIndexFromRow('a', 0).
getIndexFromRow('b', 1).
getIndexFromRow('c', 2).
getIndexFromRow('d', 3).
getIndexFromRow('e', 4).
getIndexFromRow('f', 5).
getIndexFromRow('g', 6).
getIndexFromRow('h', 7).

readMoveFromUser(PieceValue, X, Y):-
	get_char(_), % this fixes the bug for like 2 moves
	write('What move would you like to make?'),nl,
	write('Use the format PieceRowCol. Example : (ke4)'), nl,
	get_char(PieceChar),
	get_char(Row),
	read(Col),
	write('Got here'), nl,
	write('First : '),
	write(PieceChar), write('row'),write(Row), write('col'),write(Col),
	getPieceFromChar(PieceChar, PieceValue),
	getIndexFromRow(Row, X),
	Y is 8-Col,
	write('Read : '),
	write(PieceChar-Row-Col).

