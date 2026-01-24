-module(queen_attack).

-export([can_attack/2]).


can_attack({X1, Y1}, {X2, Y2}) when X1 =:= X2 orelse Y1 =:= Y2 -> true;
can_attack({X1, Y1}, {X2, Y2}) -> abs(X1 - X2) =:= abs(Y1 - Y2).




