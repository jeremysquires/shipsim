# Implementing Parallel/Distributed Computation

In Elixir/erlang there are many options for parallel and distributed
computation. This is a list of the major types and the primary calls used to
implement them.

* Process/Node
    - `Process.spawn/2, get/2, put/2, send/1, receive/1`
    - `Node.spawn/2`
* Task/Agent
	- `Task.async/1, Task.yield_many/2`
	- `Task.async_stream/3`
	- `Agent.cast/2, Agent.get/3`
* GenServer
    - `GenServer.multi_call/4`
* erlang
	- `:rpc.multicall/4, :rpc.async_call/4, :rpc.yield/2`

## Links

* [Distributed Tasks](https://elixir-lang.org/getting-started/mix-otp/distributed-tasks-and-configuration.html)
* [Task](https://elixir-lang.org/getting-started/mix-otp/task-and-gen-tcp.html)
* [Agent](https://elixir-lang.org/getting-started/mix-otp/agent.html)
* [GenServer](https://elixir-lang.org/getting-started/mix-otp/genserver.html)

