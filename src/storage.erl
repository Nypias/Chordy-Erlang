-module(storage).

create() ->
    [].

add(Key, Value, List) ->
    {Key, Value} | List.

lookup(Key, List) ->
   case lists:keyfind(Key, 1, List) of
       {Key, Value} ->	     
	   Value;
       false ->
	   io:format("Key not found").

split(LocalKey, Delim, Storage) ->
    {Split1, Split2} = lists:foldl(fun({Key,Value},{AccSplit1,AccSplit2}) ->						     
					   case key:between(Key, Delim, LocalKey) of
					       true ->
						   %% keep for local node
						   {[{Key,Value}|AccSplit1],AccSplit2};
					       false ->
						   {AccSplit1,[{Key,Value}|AccSplit2]}
					   end					       
				   end, {[],[]}, Storage).

merge(List1, List2) ->
    lists:append(List1, List2).
