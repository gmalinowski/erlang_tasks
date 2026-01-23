-module(hamming).

-export([distance/2]).


distance(Strand1, Strand2) when length(Strand1) =/= length(Strand2) -> {error, badarg};
distance(S1, S2) -> distance(S1, S2, 0).

distance([], [], Length) -> Length;
distance([S1 | S1Tail], [S2 | S2Tail], Length) ->
    if
        S1 =/= S2 -> distance(S1Tail, S2Tail, Length + 1);
        true -> distance(S1Tail, S2Tail, Length)
    end.

