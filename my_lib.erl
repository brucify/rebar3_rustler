-module({{name}}).

-export([
    add/2
]).

-include("crates.hrl").
-on_load(init/0).
-define(NOT_LOADED, not_loaded(?LINE)).

%%%===================================================================
%%% API
%%%===================================================================

add(_A, _B) ->
    ?NOT_LOADED.


%%%===================================================================
%%% NIF
%%%===================================================================

init() ->
    ?load_nif_from_crate({{name}}, ?crate_{{name}}, 0).

not_loaded(Line) ->
    erlang:nif_error({not_loaded, [{module, ?MODULE}, {line, Line}]}).

-ifdef(TEST).
-include_lib("eunit/include/eunit.hrl").

add_test() ->
    ?assertEqual(4, add(2, 2)).

-endif.
