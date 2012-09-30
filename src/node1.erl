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

stabilize(Pred, Id, Successor) ->
    {Skey, Spid} = Successor,
    case Pred of
	nil -> 
	    Spid ! {notify, {Id, self()}},
	    Successor;
	{Id, _} -> 
	    Successor;
	{Skey, _} -> 
	    Spid ! {notify, {Id, self()}},
	    Successor;
	{Xkey, Xpid} ->
	    case key:between(Xkey, Id, Skey) of
		true ->
		    Xpid ! {request, self()},
		    Pred;
		false ->
		    Spid ! {notify, {Id, self()}},
		    Successor
	    end
    end.
	    
