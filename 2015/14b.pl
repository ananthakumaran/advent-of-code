%-*- mode:prolog -*-

:- use_module(library(dcg/basics)).
:- use_module(library(yall)).

line([]) --> eos.
line([X | Xs]) -->
    string(N1), { atom_codes(Name, N1) },
    " can fly ",
    integer(Speed),
    " km/s for ",
    integer(Limit),
    " seconds, but then must rest for ",
    integer(Rest),
    " seconds.\n", !, { X = driver(Name, Speed, Limit, Rest) },
    line(Xs).

tick(Name-fly-S-Distance-B, Name-fly-S1-D1-B) :-
    driver(Name, Speed, Limit, _Rest),
    S < Limit,
    S1 is S + 1,
    D1 is Distance + Speed.
tick(Name-fly-S-Distance-B, Name-rest-1-Distance-B) :-
    driver(Name, _Speed, Limit, _Rest),
    S =:= Limit.
tick(Name-rest-S-Distance-B, Name-rest-S1-Distance-B) :-
    driver(Name, _Speed, _Limit, Rest),
    S < Rest,
    S1 is S + 1.
tick(Name-rest-S-Distance-B, Out) :-
    driver(Name, _Speed, _Limit, Rest),
    S =:= Rest,
    tick(Name-fly-0-Distance-B, Out).

bonus([], _, []).
bonus([X-Y-Z-Max-B|Xs], Max, [X-Y-Z-Max-B1|Out]) :-
    B1 is B + 1,
    bonus(Xs, Max, Out).
bonus([X-Y-Z-M-B|Xs], Max, [X-Y-Z-M-B|Out]) :-
    M =\= Max,
    bonus(Xs, Max, Out).

max_distance(States, Out) :-
    foldl([_-_-_-Distance-_, In, Out1]>>max_member(Out1, [In, Distance]), States, 0, Out).

max_score(States, Out) :-
    foldl([_-_-_-_-B, In, Out1]>>max_member(Out1, [In, B]), States, 0, Out).

tickAll(States, T, T, Out) :-
    max_score(States, Out).
tickAll(States, T, Times, Out) :-
    T < Times,
    foldl([State, In, [S1|In]]>>tick(State, S1), States, [], S2),
    max_distance(S2, M),
    T1 is T + 1,
    bonus(S2, M, S3),
    tickAll(S3, T1, Times, Out).

solve(File, Time, X) :-
    phrase_from_file(line(Drivers), File),
    retractall(driver(_, _, _, _)),
    maplist(assertz, Drivers),
    foldl([driver(X, _, _, _), In, [X|In]]>>true, Drivers, [], NameDuplicates),
    list_to_ord_set(NameDuplicates, Names),
    foldl([Name, In, [Name-fly-0-0-0|In]]>>true, Names, [], States),
    tickAll(States, 0, Time, X).

%?- solve('14a.input', 2503, X).
%@ X = 1059 ;
%@ false.

