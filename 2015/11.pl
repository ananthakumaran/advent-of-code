%-*- mode:prolog -*-

increment_letter(In, Out) :-
    char_code(In, C),
    C1 is C + 1,
    char_code(Out, C1).

increment(X, Out) :-
    reverse(X, X1),
    do_increment(X1, X2),
    reverse(X2, Out).

do_increment([], []).
do_increment([z | Xs], [a | Out]) :-
    do_increment(Xs, Out).
do_increment([X | Xs], [X1 | Xs]) :-
    X \= z,
    increment_letter(X, X1).

three_seq([X, Y, Z | _]) :-
    X \= z, Y \= z,
    increment_letter(X, Y),
    increment_letter(Y, Z), !.

three_seq([_ | Xs]) :-
    three_seq(Xs).

two_rep_1([Y, Y | _], X) :-
    X \= Y, !.
two_rep_1([_|Xs], X) :-
    two_rep_1(Xs, X).

two_rep([X, X | Xs]) :-
    two_rep_1(Xs, X).
two_rep([_ | Xs]) :-
    two_rep(Xs).

valid(Password) :-
    three_seq(Password),
    not(member(i, Password)), not(member(o, Password)), not(member(l, Password)),
    two_rep(Password).

next(In, Out) :-
    increment(In, Out),
    valid(Out).
next(In, Out) :-
    increment(In, I1),
    next(I1, Out).

%?- next([c,q,j,x,j,n,d,s], X).
%@ X = [c, q, j, x, x, y, z, z] ;
%@ X = [c, q, k, a, a, b, c, c] ;
%@ X = [c, q, k, b, b, c, d, d] .

