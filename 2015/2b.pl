%-*- mode:prolog -*-

ribbon(L, W, H, X) :-
    LW is (L + W) * 2,
    WH is (W + H) * 2,
    HL is (H + L) * 2,
    min_member(Min, [LW, WH, HL]),
    X is (L * W * H) + Min.


parse(Line, Acc, Result) :-
    split_string(Line, "x", "", [Ls, Ws, Hs]),
    number_string(L, Ls),
    number_string(W, Ws),
    number_string(H, Hs),
    ribbon(L, W, H, X),
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
