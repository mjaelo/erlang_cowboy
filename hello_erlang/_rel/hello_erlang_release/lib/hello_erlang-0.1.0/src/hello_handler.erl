-module(hello_handler).
-behaviour(cowboy_handler).

-export([init/2]).
-export([handle/2]).
-export([terminate/3]).

-record(state, {
}).

ctuples(L)->ctuples(L,[]).
ctuples([],X)->lists:flatten(io_lib:format("~p",[X]));
ctuples([H1,H2|T],X) when H2>H1->
	X1=X++[{H1,H2}],
	ctuples(T,X1);
ctuples([H1,H2|T],X) ->
	X1=X++[{H2,H1}],
	ctuples(T,X1).
	
hello()->"hello".

init(Req, State) ->
 QueryPropBinLst = cowboy_req:parse_qs(Req),
 A = string_to_term(binary_to_list(proplists:get_value(<<"A">>,QueryPropBinLst))),
 ReplyStr = ctuples(A),
 ReplyBin = list_to_binary(ReplyStr),
 Req1 = cowboy_req:reply(200,
 #{<<"content-type">> => <<"text/plain">>},
 ReplyBin,
 Req),
 {ok, Req1, State}.
handle(Req, State=#state{}) ->
 {ok, Req2} = cowboy_req:reply(200, Req),
 {ok, Req2, State}.
terminate(_Reason, _Req, _State) -> ok.
%%%%%% Aauxiliary functions %%%%%%
string_to_term(S) ->
 {ok,Tokens,_EndLine} = erl_scan:string(S++"."),
 {ok,Term} = erl_parse:parse_term(Tokens),
 Term.