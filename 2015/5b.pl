%-*- mode:prolog -*-

rows([X, Y | _], X, Y).
rows([_ | Xs], X, Y) :- rows(Xs, X, Y).

rows2([X, Y | Xs]) :- rows(Xs, X, Y).
rows2([_ | Xs]) :- rows2(Xs).

seq([X, _, X | _]).
seq([_ | Xs]) :- seq(Xs).

nice(Chars) :-
    rows2(Chars),
    seq(Chars).

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
