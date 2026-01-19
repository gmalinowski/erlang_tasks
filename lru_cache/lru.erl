-module(lru).
-export([lru_cache_init/1, lru_cache_put/3, lru_cache_get/2]).
-include("lru.hrl").


lru_cache_init(Capacity) when Capacity < 1 -> erlang:error(badarg);
lru_cache_init(Capacity) -> #lru{cap = Capacity}.


lru_cache_get(Cache, Key) ->
    Value = maps:get(Key, Cache#lru.values, not_found),
    case Value of
        not_found -> not_found;
        _ ->
            KeysUpdated = [Key | lists:delete(Key, Cache#lru.keys)],
            {ok, Value, Cache#lru{keys = KeysUpdated}}
    end.


lru_cache_put(Cache, Key, Value) ->
    Values = Cache#lru.values,
    Keys = Cache#lru.keys,
    Cap = Cache#lru.cap,

    {NewKeys, NewValues} = case maps:is_key(Key, Values) of
        true ->
            update_element(Keys, Values, Key, Value);
        false when length(Keys) < Cap ->
            add_element(Keys, Values, Key, Value);
        false ->
            drop_add_element(Keys, Values, Key, Value)
    end,

    Cache#lru{values = NewValues, keys = NewKeys}.

update_element(Keys, Values, Key, Value) ->
    NewKeys = [Key | Keys -- [Key]],
    NewValues = Values#{Key => Value},
    {NewKeys, NewValues}.

add_element(Keys, Values, Key, Value) ->
            NewValues = Values#{Key => Value},
            {[Key | Keys], NewValues}.

drop_add_element(Keys, Values, Key, Value) ->
            {LastKey, NewKeys} = pop_last(Keys),
            NewValues = maps:remove(LastKey, Values),
            {[Key | NewKeys], NewValues#{Key => Value}}.

pop_last([H]) -> {H, []};
pop_last([H|T]) ->
    {Last, Rest} = pop_last(T),
    {Last, [H|Rest]}.