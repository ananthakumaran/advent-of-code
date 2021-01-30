%-*- mode:prolog -*-

:- use_module(library(dcg/basics)).
:- use_module(library(record)).

:- record sue(n:integer,
              children: integer,
              cats: integer,
              samoyeds: integer,
              pomeranians: integer,
              akitas: integer,
              vizslas: integer,
              goldfish: integer,
              trees: integer,
              cars: integer,
              perfumes: integer).

object(Record, Record) --> "\n", !.
object(Record0, Out) -->
    string(C), { atom_codes(Name, C) },
    ": ",
    integer(N), { Field =.. [Name, N], set_sue_field(Field, Record0, Record1) },
    (", " | ""),
    object(Record1, Out).

line([]) --> eos.
line([Record2 | Xs]) -->
    "Sue ",
    integer(N), { default_sue(Record0), set_sue_field(n(N), Record0, Record1) },
    ": ",
    object(Record1, Record2),
    !, line(Xs).

solve(File, X) :-
    phrase_from_file(line(Sues), File),
    member(X, Sues).

%?- solve('16a.input', sue(X, 3, 7, 2, 3, 0, 0, 5, 3, 2, 1)).
%@ X = 213 ;
%@ false.
