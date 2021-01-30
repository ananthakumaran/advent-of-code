%-*- mode:prolog -*-

:- use_module(library(dcg/basics)).
:- use_module(library(yall)).

line([]) --> eos.
line([X | Xs]) -->
    string(N1), { atom_codes(Name, N1) },
    ": capacity ",
    integer(Capacity),
    ", durability ",
    integer(Durability),
    ", flavor ",
    integer(Flavor),
    ", texture ",
    integer(Texture),
    ", calories ",
    integer(Calories),
    "\n", !, { X = [Name, Capacity, Durability, Flavor, Texture, Calories] },
    line(Xs).

gen(N, Sum, Out) :-
    gen(N, 0, Sum, Out).

gen(1, Acc, Sum, [X]) :-
    X is Sum - Acc.
gen(N0, Acc0, Sum, [X|Xs]) :-
    N0 > 1,
    Limit is Sum - Acc0,
    between(0, Limit, X),
    N1 is N0 - 1,
    Acc1 is Acc0 + X,
    gen(N1, Acc1, Sum, Xs).

score(Ingredients, Xs, Out) :-
    foldl([[_, C, D, F, T, _], X, [Tc, Td, Tf, Tt], [Tc1, Td1, Tf1, Tt1]]>>(
              Tc1 is Tc + X*C,
              Td1 is Td + X*D,
              Tf1 is Tf + X*F,
              Tt1 is Tt + X*T), Ingredients, Xs, [0, 0, 0, 0], XTs),
    foldl([T, In, Out]>>(In > 0, Out is T*In), XTs, 1, Out).

solve(File, X) :-
    phrase_from_file(line(Ingredients), File),
    length(Ingredients, Length),
    aggregate_all(max(Score), (gen(Length, 0, 100, Xs), score(Ingredients, Xs, Score)), X).

%?- solve('15a.input', X).
%@ X = 18965440 ;
%@ false.
