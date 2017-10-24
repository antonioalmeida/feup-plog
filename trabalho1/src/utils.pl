:- use_module(library(lists)).

readLine( Line ):-
	get_char( Char ),
	readAllChars( Char, Line ).

% Line terminators
readAllChars('\n', []).

readAllChars( Char, [ Char | MoreChars ] ):-
	get_char( NewChar ),
	readAllChars( NewChar, MoreChars ).

	

