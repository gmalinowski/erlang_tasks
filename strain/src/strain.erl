-module(strain).

-export([keep/2, discard/2]).

keep(Fn, List) -> keep(Fn, List, []).

keep(_Fn, [], Result) -> lists:reverse(Result);
keep(Fn, [Item | Tail], Result) ->
  case Fn(Item) of
    true -> keep(Fn, Tail, [Item | Result]);
    _ -> keep(Fn, Tail, Result)
  end.

discard(Fn, List) -> keep(fun(Item) -> not Fn(Item) end, List).

