-module(yacht).

-export([score/2]).


score([X, X, X, X, X], yacht) -> 50;
score(_, yacht) -> 0;

score(Dices, choice) -> lists:sum(Dices);

score(Dices, big_straight) ->
    case lists:sort(Dices) of
        [2, 3, 4, 5, 6] -> 30;
        _ -> 0
    end;

score(Dices, little_straight) ->
    case lists:sort(Dices) of
        [1, 2, 3, 4, 5] -> 30;
        _ -> 0
    end;

score(Dices, four_of_a_kind) ->
  Sorted = lists:sort(Dices),
  case Sorted of
    [_, X, X, X, X] -> X * 4;
    [X, X, X, X, _] -> X * 4;
    _ -> 0
  end;

score(Dices, full_house) ->
  Sorted = lists:sort(Dices),
  case Sorted of
    [X, X, Y, Y, Y] when X =/= Y -> X * 2 + Y * 3;
    [X, X, X, Y, Y] when X =/= Y -> Y * 2 + X * 3;
    _ -> 0
  end;

score(Dices, ones) -> score_face(1, Dices);
score(Dices, twos) -> score_face(2, Dices);
score(Dices, threes) -> score_face(3, Dices);
score(Dices, fours) -> score_face(4, Dices);
score(Dices, fives) -> score_face(5, Dices);
score(Dices, sixes) -> score_face(6, Dices).


score_face(FaceNum, Dices) ->
  Counted = count_occurrences(Dices),
  maps:get(FaceNum, Counted, 0) * FaceNum.

count_occurrences(Dices) ->
  lists:foldl(fun(D, Acc) ->
    maps:update_with(D, fun(Item) -> Item + 1 end, 1, Acc)
  end, #{}, Dices).


