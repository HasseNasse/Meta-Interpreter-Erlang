%% @author HassanNazar
%% @doc @todo Add description to eager.


-module(eager).

%% ====================================================================
%% Functions
%% ====================================================================
-compile(export_all).
	
eval_expr({atm, Id}, _) ->
	{ok, Id};
eval_expr({var, Id}, Env) ->
	case env:lookup(Id, Env) of
		false -> 
			error;
		{Id, Val} ->
			{ok, Val}
	end;

eval_expr({cons, {var, X}, {atm, B}}, Env) ->
	case eval_expr({var, X}, Env) of
		error ->
			error;
		{ok, A} ->
			case eval_expr({atm, B}, Env) of
				error ->
					error;
				{ok, B} ->
					{ok, {A,B}}
			end
	end.

eval_match(ignore, _, []) ->
	{ok, []};
eval_match({atm, Id}, ignore, Env) ->
	{ok, env:lookup(Id, Env)};
eval_match({var, Id}, Str, Env) ->
	case env:lookup(Id, Env) of
		false ->
			{ok, env:add(Id, Str, Env)};
		{Id, Str} ->
			{ok, [env:lookup(Id, Env)]};
		{Id, _} ->
			fail
	end.

%eval_match({cons, {var,X}, {atm,Y}}, ..., Env) ->
%	case eval_match(..., ..., ...) of
%		fail ->
%			fail;
%		{ok, ...} ->
%			eval_match(..., ..., ...)
%		end;
%eval_match(_, _, _) ->
%	fail.





