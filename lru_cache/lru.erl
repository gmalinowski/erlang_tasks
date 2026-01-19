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



lru_cache_put(Cache, Key, Value) when Cache#lru.cap > length(Cache#lru.keys) ->
    Values = Cache#lru.values,
    Keys = Cache#lru.keys,

    NewKeys = case maps:is_key(Key, Values) of
        true -> [Key | Keys -- [Key]];
        _ -> [Key | Keys]
    end,
    NewValues = Values#{Key => Value},
    Cache#lru{values = NewValues, keys = NewKeys};


lru_cache_put(Cache, Key, Value) ->
    [LastKey | NewKeys] = lists:reverse(Cache#lru.keys),
    NewValues = maps:remove(LastKey, Cache#lru.values),
    NewCache = Cache#lru{keys = lists:reverse(NewKeys), values = NewValues},
    lru_cache_put(NewCache, Key, Value).