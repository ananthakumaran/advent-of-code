%-*- mode:prolog -*-

say([X | Xs], Result) :-
    say(X-1, Xs, Result).

say(X-Count, [], [Count, X]).
say(X-Count, [X | Xs], Result) :-
    Count1 is Count + 1,
    say(X-Count1, Xs, Result).
say(X-Count, [Y | Xs], [Count, X | Result]) :-
    X \= Y,
    say(Y-1, Xs, Result).

times(0, I, I).
times(N, I, Out) :-
    N \= 0,
    say(I, O),
    N1 is N - 1,
    times(N1, O, Out).

%?- times(40, [3,1,1,3,3,2,2,1,1,3], Xs), length(Xs, X).
%@ Xs = [1, 3, 2, 1, 1, 3, 2, 1, 3|...],
%@ X = 329356 ;
%@ false.
