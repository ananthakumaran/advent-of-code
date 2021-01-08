%-*- mode:prolog -*-

lift([], 0).
lift(['(' | Rest], Floor) :-
    lift(Rest, F1),
    plus(1, F1, Floor).
lift([')' | Rest], Floor) :-
    lift(Rest, F1),
    plus(-1, F1, Floor).

floor(String, Floor) :-
    string_chars(String, Chars),
    lift(Chars, Floor).
