-module(square_root).

-export([square_root/1]).

% F(x) = X^2 - a
% `F(x) = X^2
%
 % Xn+1 = Xn - (Xn^2 - a) / (2Xn)
%
 % Xn+1 = (Xn + a/Xn) / 2


square_root(Radicand) ->
    Result = square_root(1, Radicand),
    trunc(Result).


square_root(CurrentApprox, Radicand) ->
    NextApprox = next_approx(CurrentApprox, Radicand),
    square_root(CurrentApprox, NextApprox, Radicand).


square_root(PrevApprox, CurrentApprox, _Radicand) when abs(PrevApprox - CurrentApprox) < 0.0000001 -> CurrentApprox;
square_root(_PrevApprox, CurrentApprox, Radicand) -> square_root(CurrentApprox, Radicand).

next_approx(CurrentApprox, Radicand) -> (CurrentApprox + Radicand / CurrentApprox) / 2.