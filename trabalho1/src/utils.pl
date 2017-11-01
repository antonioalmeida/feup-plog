:- use_module(library(lists)).

% replace element at I with X
replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]):- I > -1, NI is I-1, replace(T, NI, X, R), !.
replace(L, _, _, L). 

% get element at index - alias for easier reading
elementAt(N, List, Element):- nth0(N, List, Element).