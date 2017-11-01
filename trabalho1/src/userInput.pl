:- use_module(library(lists)).

% rows to ints
getIndexFromRow('a', 0).
getIndexFromRow('b', 1).
getIndexFromRow('c', 2).
getIndexFromRow('d', 3).
getIndexFromRow('e', 4).
getIndexFromRow('f', 5).
getIndexFromRow('g', 6).
getIndexFromRow('h', 7).

readMoveFromUser(PieceChar, X, Y):-
	write('What move would you like to make?'),nl,
	write('Use the format PieceRowCol. Example : (ke4)'), nl,
	get_char(PieceChar),
	get_char(Row),
	read(Col),
	get_char(_),
	getIndexFromRow(Row, X),
	Y is 8-Col,
	write(PieceChar-Row-Col).

