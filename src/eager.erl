%% @author HassanNazar


-module(eager).

%% ====================================================================
%%  Functions
%% ====================================================================
-compile(export_all).
	
%% ====================================================================
%%  Expressions 2.3
%% ====================================================================
eval_expr({atm, Id}, _) ->		% Vår Expression är en Atom
	{ok, Id};					% Då retunerar vi endast Atomnamnet

eval_expr({var, Id}, Env) ->	% 
	case env:lookup(Id, Env) of	% Finns vår Variable i vår miljö?
		false -> 				% Nej tydligen inte!
			error;
		{Id, Val} ->			% Ja den finns
			{ok, Val}			% Då retunerar vi svaret tillbaka
	end;

eval_expr({cons, {var, X}, {atm, B}}, Env) -> %
	case eval_expr({var, X}, Env) of	% Finns Head i vår miljö?
		error ->						% Nej
			error;						
		{ok, A} ->						% Ja den finns
			case eval_expr({atm, B}, Env) of %Titta om b finns?
				error ->
					error;	
				{ok, B} ->	
					{ok, {A,B}}		% Retunera {A,B} 
			end
	end;

%% ====================================================================
%%  Case Handeler 3.0
%% ====================================================================
eval_expr({switch, Exp, [{clause, Ptr, Seq}|Rest]}, Env)-> % Vår case heter Switch, Exp är vad som evalueras
														   % Ptr är vad som testas, om Exp svar är lika med Ptr
														   % Så kör vi Seq av operationer.	
	case eval_expr(Exp,Env) of
		error ->
			error;
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
%% 	Vi kopplar här variabler till values?
%% ====================================================================

eval_match(ignore, _, Env) -> 
	{ok, Env};
eval_match({atm, _}, _, Env) ->
	{ok, Env};
eval_match({var, Id}, Str, Env) -> % Vi tittar här om en variable med angiven value finns i miljö
	case env:lookup(Id, Env) of
		false ->
			{ok, env:add(Id, Str, Env)}; % om nej lägg till
		{Id, Str} ->
			{ok, [env:lookup(Id, Env)]}; % om ja skicka tillbaka
		{Id, _} ->
			fail	% Id av var finns i Env, Dock så har den ett annat värde
	end;

eval_match({cons, Head, Tail}, {A,B}, Env) -> % Vi skickar med 2 patterns och 2 strukturer
case eval_match(Head , {A}, Env) of			%Match 
		fail ->
			fail;
		{ok, NewEnv} ->						 % Vi skickar med nya Miljön för att 
			eval_match(Tail, {B}, NewEnv)	 % Matcha Tail med B
		end;
eval_match(_, _, _) ->			% Om inget annat körs så skickar vi fail.
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
			error;
		{ok, Str} ->
			case eval_match(Ptr, Str, Env) of
				fail ->
					error;
				{ok, NewEnv} ->
					eval_seq(Seq,NewEnv)
			end
	end.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

















