%-*- mode:prolog -*-

use_module(library(md5)).

nat(N) :-
    nat(0, N).

nat(N, N).
nat(C, N) :-
    C1 is C + 1,
    nat(C1, N).

answer(Secret, X) :-
    nat(X),
    number_string(X, XString),
    string_concat(Secret, XString, Input),
    md5_hash(Input, Output ,[]),
    string_concat("000000", _, Output).
