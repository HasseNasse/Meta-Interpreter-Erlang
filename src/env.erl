%% @author HassanNazar
%% @doc @todo Add description to env.


-module(env).
-compile(export_all).
%----------------------------------------------------------------------------------
%Vår enviromnet representeras av en lista med Atom, Value tupler. Environment 
%innehåller alla bindningar
%----------------------------------------------------------------------------------

new()->  %return an empty enviroment
 []. 
add(Id,Str,Env) -> %add a key-value tuple in the enviroment
	A = [{Id,Str}],
	lists:append(Env, A).
	 
lookup(Id,Env) -> 
	lists:keyfind(Id, 1, Env).