-module(node1).
-export([node/3]).

node(Id, Predecessor, Successor) ->
    receive
	{key, Qref, Peer} ->
	    Peer ! {Qref, Id},
	    node(Id, Predecessor, Successor);
	{notify, New} ->
	    Pred = notify(New, Id, Predecessor),
	    node(Id, Pred, Successor);
	{request, Peer} ->
	    request(Peer, Predecessor),
	    node(Id, Predecessor, Successor);
	{status, Pred} ->
	    Succ = stabilize(Pred, Id, Successor),
	    node(Id, Predecessor, Succ);
	state ->
	    io:format('Id : ~w~n Predecessor : ~w~n Successor : ~w~n', [Id, Predecessor, Successor]),
	    node(Id, Predecessor, Successor);
	stop -> ok;
	_ ->
	    io:format('Strange message received'),
	    node(Id, Predecessor, Successor)
    end.
