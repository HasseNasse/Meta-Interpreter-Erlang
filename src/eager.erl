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
			error1;
		{Id, Val} ->
			{ok, Val}
	end;

eval_expr({cons, {var, X}, {atm, B}}, Env) ->
	case eval_expr({var, X}, Env) of
		error ->
			error5;
		{ok, A} ->
			case eval_expr({atm, B}, Env) of
				error ->
					error2;
				{ok, B} ->
					{ok, {A,B}}
			end
	end;

%% ====================================================================
%%  Case Handeler 3.0
%% ====================================================================
eval_expr({switch, Exp, [{clause, Ptr, Seq}|Rest]}, Env)->
	case eval_expr(Exp,Env) of
		error ->
			error3;
		{ok, _} ->
			case eval_match(Exp, Ptr, Env) of
				fail-> 
					eval_expr({switch, Exp, Rest}, Env);
				{ok, [{_,_}]} -> 
					eval_seq(Seq, Env)
			end
	end;
eval_expr({switch, _, []}, _)->
	error.

%% ====================================================================
%%  Pattern Matching 2.4
%% ====================================================================

eval_match(ignore, _, Env) ->
	{ok, Env};
eval_match({atm, Id}, _, Env) ->
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

eval_match({cons, Head, Tail}, {A,B}, Env) ->
case eval_match(Head , {A}, Env) of
		fail ->
			fail;
		{ok, NewEnv} ->
			eval_match(Tail, {B}, NewEnv)
		end;
eval_match(_, _, _) ->
	fail.

%% ====================================================================
%%  sequences 2.5
%% ====================================================================
eval(Seq) ->
	eval_seq(Seq, []).

%%%%% HANTERAR FLERA EXPRESSIONS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval_seq([Exp|[]], Env) ->
    eval_expr(Exp, Env);
eval_seq([{var,Id}|Seq], Env) ->
    eval_expr({var,Id}, Env),
    eval_seq(Seq, Env);

%%%%% HANTERAR FLERA MATCHES%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
eval_seq([{match, Ptr, Exp}|Seq], Env) ->
	case eval_expr(Exp, Env) of
		error ->
			error4;
		{ok, Str} ->
			case eval_match(Ptr, Str, Env) of
				fail ->
					error8;
				{ok, NewEnv} ->
					eval_seq(Seq,NewEnv)
			end
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% Expr 


















