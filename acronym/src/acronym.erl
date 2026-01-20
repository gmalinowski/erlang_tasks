-module(acronym).

-export([abbreviate/1]).


abbreviate(Phrase) ->
    PhraseTokenized = string:tokens(Phrase, "_- "),
    abbreviate(PhraseTokenized, "").


abbreviate([], Result) -> string:uppercase(lists:reverse(Result));
abbreviate([[I | _] | T], Result) ->
    abbreviate(T, [I | Result]).

