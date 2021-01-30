%-*- mode:prolog -*-

:- use_module(library(clpfd)).
:- use_module(library(yall)).

constrain(Values, Vars, Count) :-
    convlist([_, V]>>(V in 0..1), Values, Vars),
    scalar_product(Values, Vars, #=, 150),
    sum(Vars, #=, Count).

min_fit(Values, Count) :-
    constrain(Values, Vars, Count),
    once(labeling([min(Count)], Vars)).

fit_exact(Values, Count) :-
    constrain(Values, Vars, Count),
    label(Vars).

solve(Values, X) :-
    min_fit(Values, Count),
    aggregate_all(count, fit_exact(Values, Count), X).

%?- solve([43, 3, 4, 10, 21, 44, 4, 6, 47, 41, 34, 17, 17, 44, 36, 31, 46, 9, 27, 38], X).
%@ X = 17.
