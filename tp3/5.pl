
/*
5.
a)
*/
membro(X, [A | _]):- X == A.

membro(X, [_ | Tail]):- 
        membro(X, Tail).

/* b) */
membro(X,L):- append(_,[X|_],L).     

/* c) */
last(L,X):- append(_,[X],L).

/* d) */
nth_membro(1,[M|_],M). nth_membro(N,[_|T],M):-
N>1,
N1 is N-1,
nth_membro(N1,T,M).