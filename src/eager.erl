%% @author HassanNazar
%% @doc @todo Add description to eager.


-module(eager).

%% ====================================================================
%%  Functions
%% ====================================================================
-compile(export_all).
	
%% ====================================================================
%%  Expressions 2.3
%% ====================================================================
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

%% ====================================================================
%%  Pattern Matching 2.4
%% ====================================================================

eval_match(ignore, _, Env) ->
	{ok, Env};
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
	end;

eval_match({cons, Head, Tail}, Str, Env) ->
case eval_match(Head , Str, Env) of
		fail ->
			fail;
		{ok, Success} ->
			eval_match(Tail, Str, Success)
		end;
eval_match(_, _, _) ->
	fail.

%% ====================================================================
%%  sequences 2.5
%% ====================================================================
eval(Seq) ->
	eval_seq(Seq, []).

eval_seq([Exp], Env) ->
	eval_expr(Exp, Env);
eval_seq([{match, Ptr, Exp}|Seq], Env) ->
	case eval_expr(Exp, Env) of
		error ->
			error;
		{ok, Str} ->
			case eval_match(Ptr, Str, Env) of
				fail ->
					error;
				{ok, NewEnv} ->
					eval_seq(Seq,NewEnv)
			end
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%























