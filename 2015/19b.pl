%-*- mode:prolog -*-

:- use_module(library(dcg/basics)).
:- use_module(library(ordsets)).

line([], Input) -->
    "\n", !,
    string(I), { string_codes(Input, I) },
    "\n", !,
    eos.
line([X-Y|Xs], Input) -->
    string(Xc), { string_codes(X, Xc) },
    " => ",
    string(Yc), { string_codes(Y, Yc) },
    "\n", !,
    line(Xs, Input).


sub(String, SubString, Before, After) :-
    sub_string(String, BeforeN, L, AfterN, SubString),
    sub_string(String, 0, BeforeN, _, Before),
    AfterStart is BeforeN + L,
    sub_string(String, AfterStart, AfterN, 0, After).

reduce(_Mappings, R, C, R, C).
reduce(Mappings, Input, C, R, Out) :-
    member(X-Y, Mappings),
    sub(Input, Y, Before, After),
    string_concat(Before, X, Before1),
    string_concat(Before1, After, Output),
    C1 is C + 1,
    reduce(Mappings, Output, C1, R, Out).

solve(File, R, X) :-
    phrase_from_file(line(Mappings, Input), File),
    reduce(Mappings, Input, 0, R, X).

%?- solve('19a.input', "e", X).
%@ X = 212 .
