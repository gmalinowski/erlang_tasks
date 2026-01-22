-module(bob).

-export([response/1]).


response(Msg) -> 
    case decoder(Msg) of
        all_upper_but_question -> "Calm down, I know what I'm doing!";
        all_upper -> "Whoa, chill out!";
        only_question -> "Sure.";
        only_whites -> "Fine. Be that way!";
        _ -> "Whatever."
    end.

decoder(Msg) ->
    Cases = [{Type, re:run(Msg, Regexp) =/= nomatch} || {Type, Regexp} <- [
        {all_upper_but_question, "^(?=.*\\p{Lu})\\P{Ll}*\\?$"},
        {all_upper, "^(?=.*\\p{Lu})\\P{Ll}*$"},
        {only_question, "\\?\\h*$"},
        {only_whites, "^\\s*$"}
    ]],

    case lists:keyfind(true, 2, Cases) of
        false -> nomatch;
        {Name, true} -> Name
    end.

