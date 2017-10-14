factorial(X,Y):-
        fat(X,1,Y).
        fat(1,V,V).
fat(N, Acc, V):-
        N > 1, N1 is N - 1,
        Acc1 is Acc * N,
        fat(N1, Acc1, V).