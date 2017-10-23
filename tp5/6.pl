 imaturo(X):- adulto(X), !, fail.
 imaturo(X).
 adulto(X):- pessoa(X), !, idade(X, N), N>=18.
 adulto(X):- tartaruga(X), !, idade(X, N), N>=50. 

 /* Primeiro: cut vermelho: implementação de um not

 Segundo: cut verde, se um X é pessoa, não é tartaruga
 atenção às clausulas mutuamente exclusivas 
 
 */