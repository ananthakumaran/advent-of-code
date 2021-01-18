%-*- mode:prolog -*-

:- use_module(library(dcg/basics)).


hex(X) :-
    string_codes("abcdef0123456789", Hs),
    member(X, Hs).

line(X, X) -->
    eos.

line(X, Out) -->
    "\"",
    chars(X, X1), { X2 is X1 + 2},
    "\n",
    line(X2, Out).

chars(X, Out) -->
    "\\\\", !, { X1 is X + 2 - 1},
    chars(X1, Out).

chars(X, Out) -->
    "\\\"", !, { X1 is X + 2 - 1},
    chars(X1, Out).

chars(X, Out) -->
    "\\x",
    [A, B], { hex(A), hex(B), X1 is X + 4 - 1}, !,
    chars(X1, Out).

chars(X, X) -->
    "\"", !.

chars(X, Out) -->
    [_], !,
    chars(X, Out).

%?- phrase_from_file(line(0, X), '8a.input').
%@ X = 1333 ;
%@ false.
