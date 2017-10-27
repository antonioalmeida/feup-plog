male('Aldo Burrows').
male('Lincoln Burrows').
male('Michael Scoffield').
male('LJ Burrows').

female('Christina Rose Scofield').
female('Sara Tancredi').
female('Ella Scofield').

parent('Aldo Burrows','Michael Scofield').
parent('Aldo Burrows','Lincoln Burrows').
parent('Christina Rose Scofield','Lincoln Burrows').
parent('Christina Rose Scofield','Michael Scofield').

parent('Michael Scofield', 'Ella Scofield').
parent('Lincoln Burrows', 'LJ Burrows').
parent('Lisa Rix', 'LJ Burrows').
parent('Sara Tancredi', 'Ella Scofield').

father(A,B):- parent(A,B), male(A).
mother(A,B):- parent(A,B), female(A).

