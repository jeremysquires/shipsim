# Parallel/Distributed Computation

The initial version of ShipSim was written to process the ships' position data serially, in sequence. The JSON was loaded in a single blob and the code to compute the day's run statistics and the closest point of approach was run in a single process.

This code and this problem lends itself well to being refactored to operate in a parallel or in a distributed way. Computers have multiple CPUs which have multiple cores, and there are even GPUs that can be used to compute in parallel. Multiple hosts can be coordinated to compute parallel results in a distributed way.

## Elixir

In Elixir/erlang there are many options for parallel and distributed
computation. This is a list of the major types and the primary calls used to
implement them.

* [Process](https://hexdocs.pm/elixir/Process.html)/[Node](https://hexdocs.pm/elixir/Node.html)
  * `Process.spawn/2, get/2, put/2, send/1, receive/1`
  * `Node.spawn/2`
* [Task](https://hexdocs.pm/elixir/Task.html)/[Agent](https://hexdocs.pm/elixir/Agent.html)
  * `Task.async/1, Task.yield_many/2`
  * `Task.async_stream/3`
  * `Agent.cast/2, Agent.get/3`
* [GenServer](https://hexdocs.pm/elixir/GenServer.html)
  * `GenServer.multi_call/4`
* [Phoenix](https://hexdocs.pm/phoenix)
  * [Channels](https://hexdocs.pm/phoenix/channels.html)
* [erlang rpc](http://erlang.org/doc/man/rpc.html)
  * `:rpc.multicall/4, :rpc.async_call/4, :rpc.yield/2`

## ShipSim Parallel Touch Points

* `shipsim\lib\shipsim.ex`
    def advance_loop(ship_trackers, _timestamp, highest_time, closest_points) do
      # TODO: advance ships in parallel
      new_ship_trackers = Enum.map( ... )

    def all_ranges([ownship|others], results, method) do
      # compute range and bearing
      # TODO: range and bearing in parallel
      new_ranges = Enum.map( ... )

* `shipsim\lib\shipsim\days_run.ex`

    def days_run(vessels) do
      # TODO: calculate days run in parallel
      Enum.map( ...)

## Bench Testing

Read the instructions in `docs/data.md` to get and install the data.

By default the software will run bench tests on only one data set, the smallest one
having only 10 data points, and for a minimal time period of only one day.

Edit the file `bench/run_sim_bench.exs` and uncomment larger data files in order
to exercise the software on a larger number of ships.

Edit the file `lib/shipsim.ex` and modify the following line in order
to exercise the software on a longer time period:

    "#{String.slice(first_time, 0..7)}01T23:59Z"

Run the bench tests and capture the output so that you can see the bench results as
they are written out to the command line:

>
> `mix run bench/run_sim_bench.exs > results.log`
>


## Other Links

* [Distributed Tasks](https://elixir-lang.org/getting-started/mix-otp/distributed-tasks-and-configuration.html)
* [Task](https://elixir-lang.org/getting-started/mix-otp/task-and-gen-tcp.html)
* [Agent](https://elixir-lang.org/getting-started/mix-otp/agent.html)
* [GenServer](https://elixir-lang.org/getting-started/mix-otp/genserver.html)

