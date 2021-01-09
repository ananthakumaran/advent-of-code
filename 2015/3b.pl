%-*- mode:prolog -*-

move('>', point(Cx, Cy), point(Nx, Ny)) :-
    Nx is Cx + 1,
    Ny is Cy.

move('<', point(Cx, Cy), point(Nx, Ny)) :-
    Nx is Cx - 1,
    Ny is Cy.

move('^', point(Cx, Cy), point(Nx, Ny)) :-
    Nx is Cx,
    Ny is Cy + 1.

move('v', point(Cx, Cy), point(Nx, Ny)) :-
    Nx is Cx,
    Ny is Cy - 1.

moves(Ds, Length) :-
    moves(Ds, point(0, 0), point(0, 0), [point(0, 0)], Visited),
    length(Visited, Length).

moves([], _, _, Visited, Visited).
moves([D | Ds], Current1, Current2, HadVisited, Visited) :-
    move(D, Current1, Next),
    union(HadVisited, [Next], HadVisited1),
    moves(Ds, Current2, Next, HadVisited1, Visited).

answer(File, X) :-
    open(File, read, Stream),
    read_line_to_string(Stream, Line),
    string_chars(Line, Ds),
    moves(Ds, X),
    close(Stream).
