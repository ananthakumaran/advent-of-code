%-*- mode:prolog -*-

increment(point(X, Y), T, Value) :-
    N is Y * 1000 + X + 1,
    arg(N, T, Current),
    New is Current + Value,
    New >= 0,
    nb_setarg(N, T, New).

increment(point(X, Y), T, Value) :-
    N is Y * 1000 + X + 1,
    arg(N, T, Current),
    New is Current + Value,
    New < 0,
    nb_setarg(N, T, 0).

turn_on(Point, T) :-
    increment(Point, T, 1).

turn_off(Point, T) :-
    increment(Point, T, -1).

toggle(Point, T) :-
    increment(Point, T, 2).

row(point(X, Y), X, Op, T) :-
    call(Op, point(X, Y), T).

row(point(X, Y), Z, Op, T) :-
    X < Z,
    call(Op, point(X, Y), T),
    X1 is X + 1,
    !, row(point(X1, Y), Z, Op, T).

foreach(point(Xn, Y), point(X1n, Y), Op, T) :-
    row(point(Xn, Y), X1n, Op, T).

foreach(point(Xn, Yn), point(X1n, Y1n), Op, T) :-
    Yn < Y1n,
    row(point(Xn, Yn), X1n, Op, T),
    Yn1 is Yn + 1,
    !, foreach(point(Xn, Yn1), point(X1n, Y1n), Op, T).

execute([], _).
execute([I| Is], T) :-
    I =.. [Op, S, E],
    foreach(S, E, Op, T),
    !, execute(Is, T).

parse_line(["toggle", X, Y, "through", X1, Y1], toggle(point(Xn, Yn), point(X1n, Y1n))) :-
    number_string(Xn, X),
    number_string(Yn, Y),
    number_string(X1n, X1),
    number_string(Y1n, Y1).

parse_line(["turn", "on", X, Y, "through", X1, Y1], turn_on(point(Xn, Yn), point(X1n, Y1n))) :-
    number_string(Xn, X),
    number_string(Yn, Y),
    number_string(X1n, X1),
    number_string(Y1n, Y1).

parse_line(["turn", "off", X, Y, "through", X1, Y1], turn_off(point(Xn, Yn), point(X1n, Y1n))) :-
    number_string(Xn, X),
    number_string(Yn, Y),
    number_string(X1n, X1),
    number_string(Y1n, Y1).

do_parse(_Stream, end_of_file, X, Y) :-
    reverse(X, Y).

do_parse(Stream, Line, Acc, X) :-
    split_string(Line, " ,", "", Strings),
    parse_line(Strings, Result),
    read_line_to_string(Stream, Line1),
    do_parse(Stream, Line1, [Result | Acc], X).

parse(File, X) :-
    open(File, read, Stream),
    read_line_to_string(Stream, Line),
    do_parse(Stream, Line, [], X),
    close(Stream).

count([], S, S).

count([N | Xs], S, Sout) :-
    S1 is S + N,
    count(Xs, S1, Sout).

initialize(_, I, I).
initialize(T, I, Limit) :-
    I1 is I + 1,
    nb_setarg(I1, T, 0),
    initialize(T, I1, Limit).

answer(File, Size) :-
    parse(File, I),
    functor(T, grid, 1000000),
    initialize(T, 0, 1000000),
    execute(I, T),
    write(e),
    T =.. [grid | Gs],
    count(Gs, 0, Size).
