%-*- mode:prolog -*-

:- use_module(library(dcg/basics)).
:- use_module(library(yall)).
:- use_module(library(apply)).

line([]) -->
    eos.

line([X | Xs]) -->
    string(F), { atom_codes(From, F) },
    " to ",
    string(T), { atom_codes(To, T) },
    " = ",
    integer(Distance), { X = route(From, To, Distance) },
    "\n", !,
    line(Xs).

shortest(Places, Total) :-
    member(From, Places),
    delete(Places, From, Remaining),
    shortest(Remaining, From, 0, Total).

shortest([], _, X, X).
shortest(Remaining, From, Current, Total) :-
    member(To, Remaining),
    route(From, To, Distance),
    delete(Remaining, To, Remaining1),
    Next is Current + Distance,
    shortest(Remaining1, To, Next, Total).

add_route(route(F, T, D), Sin, [F,T|Sin]) :-
    assertz(route(F, T, D)),
    assertz(route(T, F, D)).

answer(X) :-
    phrase_from_file(line(Routes), '9a.input'),
    retractall(route(_, _, _)),
    foldl(add_route, Routes, [], Duplicates),
    list_to_ord_set(Duplicates, Places),
    findall(D, shortest(Places, D), Ds, []),
    max_member(X, Ds).

%?- answer(X).
%@ X = 898 ;
%@ false.
