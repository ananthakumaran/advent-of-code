%-*- mode:prolog -*-

:- use_module(library(http/json)).

not_red([]).
not_red([_=X|Xs]) :-
    X \= red,
    not_red(Xs).

count(json(NameValueList), Out) :-
    not_red(NameValueList),
    !, count(NameValueList, Out).
count([X|Xs], Out) :-
    count(X, Out1),
    count(Xs, Out2),
    !, Out is Out1 + Out2.
count(_=Y, Out) :-
    !, count(Y, Out).
count(X, X) :-
    number(X), !.
count(_, 0).

answer(File, X) :-
    open(File, read, Stream),
    json_read(Stream, Json),
    count(Json, X).

%?- answer('12a.json', X).
%@ X = 96852.
