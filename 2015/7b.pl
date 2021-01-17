%-*- mode:prolog -*-

override(File, Register, OverrideRegister, X) :-
    value(File, Register, Y),
    phrase_from_file(connections(Cs), File),
    list_to_assoc(Cs, Gate),
    put_assoc(OverrideRegister, Gate, assign(Y, Y), Gate1),
    get(Gate1, Register, X).


%?- override('7a.input', a, b, X).
%@ X = 14710 ;
%@ false.
