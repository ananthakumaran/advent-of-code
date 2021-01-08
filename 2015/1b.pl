%-*- mode:prolog -*-

lift(_, 0, -1).
lift(['(' | Rest], Position, Floor) :-
    plus(1, Floor, F1),
    lift(Rest, P1, F1),
    plus(1, P1, Position).
lift([')' | Rest], Position, Floor) :-
    plus(-1, Floor, F1),
    lift(Rest, P1, F1),
    plus(1, P1, Position).

basement(String, Position) :-
    string_chars(String, Chars),
    lift(Chars, Position, 0).
