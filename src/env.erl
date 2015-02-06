%% @author HassanNazar
%% @doc @todo Add description to env.


-module(env).
-compile(export_all).
%----------------------------------------------------------------------------------
%V�r enviromnet representeras av en lista med Atom, Value tupler. Environment 
%inneh�ller alla bindningar
%----------------------------------------------------------------------------------

%return an empty enviroment
new()->
 []. 

%add a key-value tuple in the enviroment
add(Id,Str,Env) -> 
	A = [{Id,Str}],
	lists:append(Env, A).
	 
lookup(Id,Env) -> 
	lists:keyfind(Id, 1, Env).