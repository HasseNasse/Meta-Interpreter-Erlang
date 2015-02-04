%% @author HassanNazar
%% @doc @todo Add description to eager.


-module(eager).

%% ====================================================================
%% API functions
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

eval_expr({cons, {var, x}, {atm, b}}, Env) ->
	case eval_expr({var, x}, Env) of
		error ->
			error;
		{ok, A} ->
			case eval_expr({atm, b}, Env) of
				error ->
					error;
				{ok, B} ->
					{ok, {A,B}}
			end
	end.

%% ====================================================================
%% Internal functions
%% ====================================================================


