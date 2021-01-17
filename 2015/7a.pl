%-*- mode:prolog -*-

:- use_module(library(dcg/basics)).
:- use_module(library(assoc)).

connections([]) -->
    eos.

connections([C]) -->
    connection(C).

connections([C|Cs]) -->
    connection(C),
    "\n",
    connections(Cs).

connection(Out-not(In, _)) -->
    unary("NOT", In, Out).

connection(Out-or(L, R, _)) -->
    binary("OR", L, R, Out).

connection(Out-and(L, R, _)) -->
    binary("AND", L, R, Out).

connection(Out-lshift(L, R, _)) -->
    binary("LSHIFT", L, R, Out).

connection(Out-rshift(L, R, _)) -->
    binary("RSHIFT", L, R, Out).

connection(Out-assign(X, _)) -->
    string_without(" ", Xc), { atom_codes(X, Xc)},
    white,
    "->",
    white,
    string_without("\n", Outc), { atom_codes(Out, Outc) }.

unary(Op, In, Out) -->
    Op,
    white,
    string_without(" ", Inc), { atom_codes(In, Inc) },
    white,
    "->",
    white,
    string_without("\n", Outc), { atom_codes(Out, Outc) }.

binary(Op, L, R, Out) -->
    string_without(" ", Lc), { atom_codes(L, Lc) },
    white,
    Op,
    white,
    string_without(" ", Rc), { atom_codes(R, Rc) },
    white,
    "->",
    white,
    string_without("\n", Outc), { atom_codes(Out, Outc) }.

compute(_Gate, Instruction, Out) :-
    functor(Instruction, _, 2),
    arg(2, Instruction, Out),
    number(Out).
compute(_Gate, Instruction, Out) :-
    functor(Instruction, _, 3),
    arg(3, Instruction, Out),
    number(Out).

compute(Gate, assign(X, Out), Out) :-
    var(Out),
    resolve(Gate, X, Out).

compute(Gate, and(L, R, Out), Out) :-
    var(Out),
    resolve(Gate, L, Li),
    resolve(Gate, R, Ri),
    Out is Li /\ Ri.

compute(Gate, or(L, R, Out), Out) :-
    var(Out),
    resolve(Gate, L, Li),
    resolve(Gate, R, Ri),
    Out is Li \/ Ri.

compute(Gate, rshift(L, R, Out), Out) :-
    var(Out),
    resolve(Gate, L, Li),
    resolve(Gate, R, Ri),
    Out is Li >> Ri.

compute(Gate, lshift(L, R, Out), Out) :-
    var(Out),
    resolve(Gate, L, Li),
    resolve(Gate, R, Ri),
    Out is Li << Ri.

compute(Gate, not(L, Out), Out) :-
    var(Out),
    resolve(Gate, L, Li),
    Out is 65535 - Li.

resolve(_Gate, X, Out) :-
    atom_number(X, Out).
resolve(Gate, X, Out) :-
    not(atom_number(X, Out)),
    get(Gate, X, Out).

get(Gate, Register, Value) :-
    get_assoc(Register, Gate, Instruction),
    compute(Gate, Instruction, Value).

value(File, Register, X) :-
    phrase_from_file(connections(Cs), File),
    list_to_assoc(Cs, Gate),
    get(Gate, Register, X).

%?- value('7a.input', a, X).
%@ X = 3176 ;
%@ false.
