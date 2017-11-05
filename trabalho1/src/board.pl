:- use_module(library(system)).
:-include('utils.pl').

getPieceDisplay(0, 32). % space
getPieceDisplay('1', 65). % 'A' - temporary
% DONT FORGET : update internal
% piece representation on final
% report

%white pieces
getPieceDisplay('K', 9812). % king
getPieceDisplay('Q', 9813). % queen
getPieceDisplay('R', 9814). % rook
getPieceDisplay('B', 9815). % bishop
getPieceDisplay('N', 9816). % knight

%black pieces
getPieceDisplay('k', 9818). % king
getPieceDisplay('q', 9819). % queen
getPieceDisplay('r', 9820). % rook
getPieceDisplay('b', 9821). % bishop
getPieceDisplay('n', 9822). % knight

% not tested %
getPieceAt( Board, X, Y, Piece ):-
	getPieceAtAux( Board, 0, X, Y, Piece).

getPieceAtAux( [ CurrentLine | RestOfBoard ], Y, X, Y, Piece ):-
	elementAt( X, CurrentLine, Piece ).

getPieceAtAux( [ CurrentLine | RestOfBoard ], N, X, Y, Piece ):-
	N1 is N+1,
	getPieceAtAux( RestOfBoard, N1, X, Y, Piece).

displayBoard( Board ) :-
	displayBoardHeader,
	N is 8,
	displayBoardTail(Board, N),
	displayBottom.

displayBoardTail([], 0).

displayBoardTail( [ Row | T ], N ):-
	write('---------------------------------'), nl,
	displayRow(Row, N), nl,
	N1 is N-1,
	displayBoardTail(T, N1).

displayRow([], N):-
	write('| '), displayNumber(N).

displayRow( [ CurrentPiece | T ] , N ):-
	write('| '),
	getPieceDisplay(CurrentPiece, PieceDisplay),
	put_code(PieceDisplay),
	write(' '),
	displayRow(T, N).

displayBoardHeader:-
	nl,
	write('  a   b   c   d   e   f   g   h '),
	nl.

displayBottom:-
	write('---------------------------------'), nl.

displayNumber(N) :- write(N), !.

% working
makeMove( Board, Piece, X, Y, NewBoard ):-
	N is 0,
	makeMoveAux( Board, N, Piece, X, Y, [], NewBoard ).

% base case - need to reverse list
% TODO: find a way to do this without having to reverse final list
makeMoveAux([], _, _, _, _, InvertedBoard, FinalBoard):-
	reverse(InvertedBoard, FinalBoard).

% case where N == Y
makeMoveAux( [ CurrentLine | RestOfBoard ], Y, Piece, X, Y, TempBoard, FinalBoard):-
	N1 is Y+1,
	replace( CurrentLine, X, Piece, NewLine ),
	makeMoveAux( RestOfBoard, N1, Piece, X, Y, [ NewLine | TempBoard ], FinalBoard).

makeMoveAux( [ CurrentLine | RestOfBoard ], N, Piece, X, Y, TempBoard, FinalBoard ):-
	N1 is N+1,
	makeMoveAux( RestOfBoard, N1, Piece, X, Y, [ CurrentLine | TempBoard ], FinalBoard ).

initialBoard([[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0],
[0, 0, 0, 0, 0, 0, 0, 0]]).
