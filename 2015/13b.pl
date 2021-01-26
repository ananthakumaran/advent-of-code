%-*- mode:prolog -*-

:- use_module(library(dcg/basics)).
:- use_module(library(yall)).
:- use_module(library(apply)).
:- use_module(library(aggregate)).

multiplier(1) --> "gain".
multiplier(-1) --> "lose".

line([]) --> eos.
line([X | Xs]) -->
    string(N1), { atom_codes(Name1, N1) },
    " would ",
    multiplier(M),
    white,
    integer(Point),
    " happiness units by sitting next to ",
    string(N2), { atom_codes(Name2, N2) },
    ".\n", !, { Point1 is M * Point, X = likes(Name1, Name2, Point1) },
    line(Xs).

score([X|Xs], Out) :-
    score(Xs, X, X, 0, Out).
score([Y], X, F, Current, Out) :-
    likes(X, Y, S1),
    likes(Y, X, S2),
    likes(F, Y, S3),
    likes(Y, F, S4),
    Out is S1 + S2 + S3 + S4 + Current.
score([Y,Z|Xs], X, F, Current, Out) :-
    likes(X, Y, S1),
    likes(Y, X, S2),
    Out1 is S1 + S2 + Current,
    score([Z|Xs],Y, F, Out1, Out).

gen(Names, Score) :-
    permutation(Names, NamesPerm),
    score(NamesPerm, Score).

add_me(N) :-
    assertz(likes(N, 'Me', 0)),
    assertz(likes('Me', N, 0)).

solve(File, X) :-
    phrase_from_file(line(Preferences), File),
    retractall(likes(_, _, _)),
    maplist(assertz, Preferences),
    foldl([likes(X, Y, _), In, [X,Y|In]]>>true,Preferences, [], NameDuplicates),
    list_to_ord_set(NameDuplicates, Names),
    maplist(add_me, Names),
    Names1 = ['Me' | Names],
    aggregate_all(max(Score), gen(Names1, Score), X).

%?- solve('13a.input', X).
%@ X = 725 ;
%@ false.
