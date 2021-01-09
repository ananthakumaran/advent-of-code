%-*- mode:prolog -*-

vowels(String) :-
    intersection(String, [a, e, i, o, u], Vowels),
    length(Vowels, Length),
    Length >= 3.

rows([X, X | _]).
rows([_ | Xs]) :- rows(Xs).

seq([a, b | _]).
seq([c, d | _]).
seq([p, q | _]).
seq([x, y | _]).
seq([_ | Xs]) :- seq(Xs).

nice(Chars) :-
    vowels(Chars),
    rows(Chars),
    \+ seq(Chars).

sum(_Stream, end_of_file, X, X).

sum(Stream, Line, Acc, X) :-
    string_chars(Line, Chars),
    nice(Chars),
    Y is Acc + 1,
    read_line_to_string(Stream, Line1),
    sum(Stream, Line1, Y, X).

sum(Stream, _, Acc, X) :-
    read_line_to_string(Stream, Line),
    sum(Stream, Line, Acc, X).

answer(File, X) :-
    open(File, read, Stream),
    read_line_to_string(Stream, Line),
    sum(Stream, Line, 0, X),
    close(Stream).
