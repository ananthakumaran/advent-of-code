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

distance(Name, Time, Out) :-
    distance(Name, Time, 0, Out).

distance(_, Time, X, X) :- Time =< 0.
distance(Name, Time, Current, Out) :-
    Time > 0,
    driver(Name, Speed, Limit, Rest),
    C1 is Current + (min(Time, Limit) * Speed),
    T1 is Time - Limit - Rest,
    distance(Name, T1, C1, Out).

solve(File, Time, X) :-
    phrase_from_file(line(Drivers), File),
    retractall(driver(_, _, _, _)),
    maplist(assertz, Drivers),
    foldl([driver(X, _, _, _), In, [X|In]]>>true, Drivers, [], NameDuplicates),
    list_to_ord_set(NameDuplicates, Names),
    foldl([Name, In, Out]>>(distance(Name, Time, D),max_member(Out, [In, D])), Names, 0, X).

%?- solve('14a.input', 2503, X).
%@ X = 2655 ;
%@ false.
