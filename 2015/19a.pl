%-*- mode:prolog -*-

:- use_module(library(dcg/basics)).

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

generate(Mappings, Input, Output) :-
    member(X-Y, Mappings),
    sub(Input, X, Before, After),
    string_concat(Before, Y, Before1),
    string_concat(Before1, After, Output).

solve(File, Size) :-
    phrase_from_file(line(Mappings, Input), File),
    aggregate(set(Output), generate(Mappings, Input, Output), Outputs),
    length(Outputs, Size).

%?- solve('19a.input', X).
%@ X = 535.
