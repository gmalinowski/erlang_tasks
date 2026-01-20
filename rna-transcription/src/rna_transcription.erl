-module(rna_transcription).

-export([to_rna/1]).

% G -> C
% C -> G
% T -> A
% A -> U

to_rna(DNA) -> to_rna(DNA, []).
to_rna([], RNA) -> lists:reverse(RNA);
to_rna([H | Tail], RNA) -> 
    Decoded = case H of
        $G -> $C;
        $C -> $G;
        $T -> $A;
        $A -> $U
    end,
    to_rna(Tail, [Decoded | RNA])
    .
