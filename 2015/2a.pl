%-*- mode:prolog -*-

paper(L, W, H, X) :-
    LW is L * W,
    WH is W * H,
    HL is H * L,
    min_member(Min, [LW, WH, HL]),
    X is (2 * (LW + WH + HL)) + Min.


parse(Line, Acc, Result) :-
    split_string(Line, "x", "", [Ls, Ws, Hs]),
    number_string(L, Ls),
    number_string(W, Ws),
    number_string(H, Hs),
    paper(L, W, H, X),
    plus(Acc, X, Result).

sum(_Stream, end_of_file, X, X).

sum(Stream, Line, Acc, X) :-
    parse(Line, Acc, Y),
    read_line_to_string(Stream, Line1),
    sum(Stream, Line1, Y, X).

answer(File, X) :-
    open(File, read, Stream),
    read_line_to_string(Stream, Line),
    sum(Stream, Line, 0, X),
    close(Stream).
