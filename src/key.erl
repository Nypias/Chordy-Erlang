-module(key).
-export([generate/0, between/3]).

generate() ->
    random:uniform(1000000000).

between(Key, From, To) ->
    (Key > From) and ((Key < To) or (Key == To)).
