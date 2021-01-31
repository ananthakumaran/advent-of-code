%-*- mode:prolog -*-

:- use_module(library(yall)).
:- use_module(library(readutil)).

code(46, 0).
code(35, 1).
code(10, -1).

convert(Codes, [Line|Grid]) :-
    convert(Codes, Line, Grid).

convert([Code|Codes], [X|Line], Grid) :-
    code(Code, X),
    X =\= -1,
    convert(Codes, Line, Grid).
convert([Code], [], []) :-
    code(Code, -1).
convert([Code|Codes], [], [Line|Grid]) :-
    not(Codes = []),
    code(Code, -1),
    convert(Codes, Line, Grid).

nth(Grid, R, C, Out) :-
    nth0(R, Grid, Line),
    nth0(C, Line, Out), !.
nth(_, _, _, 0).

parse(File, Grid) :-
    read_file_to_codes(File, Codes, []),
    convert(Codes, Grid).

neighbours(Grid, R, C, Out) :-
    RB is R - 1,
    RA is R + 1,
    CB is C - 1,
    CA is C + 1,
    foldl({Grid}/[[R, C], In, Out]>>(nth(Grid, R, C, S), Out is In + S),
          [[RB, CB], [RB, C], [RB, CA],
           [R,  CB],          [R,  CA],
           [RA, CB], [RA, C], [RA, CA]], 0, Out).

next(GIn, GOut) :-
    nextG(GIn, 0, GIn, GOut).

nextL(G, R, LI, LO) :-
    nextL(G, R, 0, LI, LO).

nextL(_, _, _, [], []).
nextL(G, R, C0, [1|LIs], [1|LOs]) :-
    neighbours(G, R, C0, N),
    member(N, [2, 3]),
    C1 is C0 + 1,
    !, nextL(G, R, C1, LIs, LOs).
nextL(G, R, C0, [0|LIs], [1|LOs]) :-
    neighbours(G, R, C0, 3),
    C1 is C0 + 1,
    !, nextL(G, R, C1, LIs, LOs).
nextL(G, R, C0, [_|LIs], [0|LOs]) :-
    C1 is C0 + 1,
    nextL(G, R, C1, LIs, LOs).

nextG(G, R0, [LI], [LO]) :-
    nextL(G, R0, LI, LO).
nextG(G, R0, [LI|LIs], [LO|LOs]) :-
    not(LIs = []),
    nextL(G, R0, LI, LO),
    R1 is R0 + 1,
    !, nextG(G, R1, LIs, LOs).

solve(File, X) :-
    parse(File, Grid),
    findall(X, between(0, 99, X), Range),
    foldl([_, In, Out]>>next(In, Out), Range, Grid, Out),
    flatten(Out, Flat),
    sum_list(Flat, X).

%?- solve('18a.input', X).
%@ X = 821 ;
%@ false.
