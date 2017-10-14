aluno(joao, paradigmas).
aluno(maria, paradigmas).
aluno(joel, lab2).
aluno(joel, estruturas).
frequenta(joao, feup).
frequenta(maria, feup).
frequenta(joel, ist).
professor(carlos, paradigmas).
professor(ana_paula, estruturas).
professor(pedro, lab2).
funcionario(pedro, ist).
funcionario(ana_paula, feup).
funcionario(carlos, feup). 

/**
* a) aluno(A,_B),professor(X,_B), frequenta(A,_C), funcionario(X,_C).
* b) frequenta(A, X); funcionario(A, X).
* c) ((aluno(A, _B), aluno(C, _B)) ; (frequenta(A, _D), frequenta(C, _D)) ; (funcionario(A, _D), funcionario(C, _D))), A/=C.
*/