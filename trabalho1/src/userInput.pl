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

readMoveFromUser(Player, FinalPiece, X, Y):-
	write('What move would you like to make?'),nl,
	write('Use the format PieceRowCol. Example : (ke4)'), nl,
	get_char(PieceChar),
	get_char(Row),
	read(Col),
	get_char(_),
	getPiece(Player, PieceChar, FinalPiece),
	getIndexFromRow(Row, X),
	Y is 8-Col,
	write(FinalPiece-Row-Col).

getPiece(black, PieceChar, FinalPiece):-
	toLowercase( PieceChar, FinalPiece).

getPiece(white, PieceChar, FinalPiece):-	
	toUppercase(PieceChar, FinalPiece).

toUppercase(L, U):-
	atom_codes(L, [ NL | _] ),
	NL > 90,
	!,
	NX is NL-32,
	atom_codes(U, [ NX ] ).

toUppercase(L, L).

toLowercase(U, L):-
	atom_codes(U, [ NU | _] ),
	NU < 90,
	!,
	NX is NU+32,
	atom_codes(L, [ NX ] ).

toLowercase(U, U).

