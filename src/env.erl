%% @author HassanNazar
%% @doc @todo Add description to env.


-module(env).

%% ====================================================================
%% functions
%% ====================================================================
-compile(export_all).

new()-> 
	[].

add(Id,Str,Env) -> 
	A = [{Id,Str}],
	lists:append(Env, A).
	

lookup(Id,Env) -> 
	lists:keyfind(Id, 1, Env).
