%-*- mode:prolog -*-

:- use_module(library(clpfd)).
:- use_module(library(yall)).

fit(Values) :-
    convlist([N, Y]>>(X in 0..1, Y #= X * N), Values, Vars),
    sum(Vars, #=, 150),
    label(Vars).

solve(Values, X) :-
    aggregate_all(count, fit(Values), X).

%?- solve([43, 3, 4, 10, 21, 44, 4, 6, 47, 41, 34, 17, 17, 44, 36, 31, 46, 9, 27, 38], X).
%@ X = 1638.
