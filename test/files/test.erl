-module(mmc_logmon_sup).
-behaviour(supervisor).
-export([init/1]).

init(_) ->
    {ok, {
        {one_for_one, 5, 1},
        [
            {listener,
                {aaa, start_link, []},
                permanent, 100, worker,
                [aaa]
            },
            {server,
                {bbb, start_link, []},
                permanent, 100, worker,
                [bbb]
            }
        ]
    }}.
