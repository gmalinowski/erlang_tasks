-module(lru_tests).
-include_lib("eunit/include/eunit.hrl").
-include("lru.hrl").

state() ->
    lru:lru_cache_init(5).
state(Cap) when Cap > 1 ->
    lru:lru_cache_init(Cap).
state_with_elements() -> 
    R1 = lru:lru_cache_put(state(3), 3, "one"),
    R2 = lru:lru_cache_put(R1, 8, "two"),
    lru:lru_cache_put(R2, 4, "three").


lru_cache_init_signle_test() ->
    ?assertEqual(10, (lru:lru_cache_init(10))#lru.cap).

lru_cache_init_test() ->
    [
        ?assertEqual(#lru{cap = Arg}, lru:lru_cache_init(Arg))
        || Arg <- [1, 4, 84]
    ].

lru_cache_init_cap_is_integer_test() ->
    Res = lru:lru_cache_init(3),
    ?assert(is_integer(Res#lru.cap)).

lru_cache_init_zero_cap_test() ->
    ?assertError(badarg, lru:lru_cache_init(0)).

lru_cache_init_negative_cap_test() ->
    ?assertError(badarg, lru:lru_cache_init(-1)).

lru_cache_put_test_() -> 
    [
        {"add key and value",
        fun() ->
            Cache = state(),
            Key = 2,
            Value = value,
            R = lru:lru_cache_put(Cache, Key, Value),
            ?assert(lists:member(Key, R#lru.keys)),
            ?assertEqual(maps:get(Key, R#lru.values), Value)
        end},
        {"when key exists overwrites value",
        fun() ->
            Cache = lru:lru_cache_put(state(), 2, old),
            KeysPre = Cache#lru.keys,
            ValuesPre = Cache#lru.values,
            ?assertEqual(maps:get(2, ValuesPre), old),
            ?assertEqual(length(KeysPre), 1),
            NewCache = lru:lru_cache_put(Cache, 2, new),
            KeysPost = NewCache#lru.keys,
            ValuesPost = NewCache#lru.values,
            ?assertEqual(maps:get(2, ValuesPost), new),
            ?assertEqual(length(KeysPost), 1)
        end},
        {"update key position",
        fun() ->
            Cache = lru:lru_cache_put(state(), 2, first2),
            C1 = lru:lru_cache_put(Cache, 3, first3),
            C2 = lru:lru_cache_put(C1, 2, second2),
            [H | _T] = C2#lru.keys,
            ?assertEqual(H, 2)
        end},
        {"remove last used el if reached cap",
        fun() ->
            S = state_with_elements(),
            LastKey = lists:last(S#lru.keys),

            ?assertEqual(S#lru.cap, length(S#lru.keys)),

            NewS = lru:lru_cache_put(S, 888, new_el),

            ?assertEqual(length(S#lru.keys), length(NewS#lru.keys)),

            ?assertEqual(S#lru.keys -- [LastKey], NewS#lru.keys -- [888]),

            ?assertEqual(null, maps:get(LastKey, NewS#lru.values, null))
            
        end},
        {"overwrite does not evict when  cache is full",
        fun() ->
            S = state_with_elements(),
            S2 = lru:lru_cache_put(S, 88, updated),
            ?assertEqual(S#lru.cap, length(S2#lru.keys)),
            ?assert(maps:is_key(88, S2#lru.values))
        end},
        {"keys and values are always consistent",
        fun() ->
            S = state_with_elements(),
            ?assertEqual(lists:sort(S#lru.keys), lists:sort(maps:keys(S#lru.values))),
            S2 = lru:lru_cache_put(S, 8889, new_value),
            ?assertEqual(lists:sort(S2#lru.keys), lists:sort(maps:keys(S2#lru.values)))
        end},
        {"always remove key and value when cap is 1",
        fun() ->
            S0 = lru:lru_cache_init(1),
            S1 = lru:lru_cache_put(S0, 2, 22),
            S2 = lru:lru_cache_put(S1, 3, 33),

            ?assertEqual(length(S2#lru.keys), 1),
            ?assertEqual(length(maps:keys(S2#lru.values)), 1),

            ?assertEqual(33, maps:get(3, S2#lru.values, null)),
            ?assertEqual(null, maps:get(2, S2#lru.values, null))
        end}
    ].

lru_cache_get_test_() ->
    [
        {"get value by key returns correct response",
        fun() ->
            S = state(),
            S1 = lru:lru_cache_put(S, 88, new_value),

            NewStateShouldBe = S1#lru{keys = [ 88 | S#lru.keys], values = maps:put(88, new_value, S#lru.values)},

            ?assertEqual({ok, new_value, NewStateShouldBe}, lru:lru_cache_get(S1, 88))
        end},
        {"when key not exists returns not_found status",
        fun() ->
            S = state(),
            ?assertEqual(not_found, lru:lru_cache_get(S, 843245))
        end},
        {"refresh key order when read",
        fun() ->
            S = lru:lru_cache_init(5),
            S1 = lru:lru_cache_put(S, 1, v1),
            S2 = lru:lru_cache_put(S1, 2, v2),
            ?assertEqual([2, 1], S2#lru.keys),

            {ok, _, S2_read} = lru:lru_cache_get(S2, 1),
            ?assertEqual([1, 2], S2_read#lru.keys),

            S3 = lru:lru_cache_put(S2_read, 3, v3),
            ?assertEqual([3, 1, 2], S3#lru.keys),

            {ok, _, S3_read} = lru:lru_cache_get(S3, 1),
            ?assertEqual([1, 3, 2], S3_read#lru.keys),

            {ok, _, S3_read2} = lru:lru_cache_get(S3_read, 2),
            ?assertEqual([2, 1, 3], S3_read2#lru.keys)
        end}
    ].