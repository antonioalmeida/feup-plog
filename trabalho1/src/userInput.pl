:- use_module(library(lists)).

getPieceFromChar(' ', 0). % space

%white pieces
getPieceFromChar('K', 1). % king
getPieceFromChar('Q', 2). % queen
getPieceFromChar('R', 3). % rook
getPieceFromChar('B', 4). % bishop
getPieceFromChar('N', 5). % knight

%black pieces
getPieceFromChar('k', 6). % king
getPieceFromChar('q', 7). % queen
getPieceFromChar('r', 8). % rook
getPieceFromChar('b', 9). % bishop
getPieceFromChar('n', 10). % knight

readMoveFromUser(Move):-
	write('What move would you like to make?'),nl,
	write('Use the format Piece-Row-Col. Example : (K-e-4)'),nl,
	read(PieceChar-Row-Col),
	getPieceFromChar(PieceChar, PieceValue).

