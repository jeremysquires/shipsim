# Shipsim

ShipSim takes a JSON file containing ship's positions and simulates the ships moving through the water, reporting crossing vectors and potential collisions.

## Installation

Install [elixir](https://elixir-lang.org/install.html)

## Build

>
> `mix deps.get`
>
> `mix`
>

## Test

>
> `mix test`
>

## Run

The application is currently run using the mix build tool, as the standalone
CLI executable depends upon escript, and this has incompatibilities with the
Timex module (see "Escript Standalone Exes" section below).

By default, mix will run against the provided test data. Output can be
redirected to an output file in markdown format.

>
> `mix > final_output.md`
>

If different data should be passed to the application, use the command line
interface to pass in the new file name. This is a workaround due to mix run
attempting to process everything as script files unless code is evaled using
the -e option.

>
> `mix run -e "ShipSim.CLI.main System.argv" -- test/TestData.json`
>
> `mix run -e "ShipSim.CLI.main System.argv" -- --help`
>

## Debug

>
> `iex -S mix`
>
> `ShipSim.run_sim()`
>

* [Debugging Elixir Docs](https://elixir-lang.org/getting-started/debugging.html)
* [Debugging Plataformatec](http://blog.plataformatec.com.br/2016/04/debugging-techniques-in-elixir-lang/)
* [Debugger Erlang](http://erlang.org/doc/apps/debugger/debugger_chapter.html)

## Escript Standalone Exes

Unfortunately, this code uses Timex, which depends upon Tzdata, and there is
currently an incompatibility between Tzdata and escript that has yet to be resolved.

[Timex with escript](https://libraries.io/hex/timex/3.1.0#timex-with-escript)

What this means is that although we have escript enabled in the mix config,
it throws an error when we run it.

For now I have left the escript configuration in place in hopes that Tzdata will
be fixed to work with escript and the following commands can be used to test it.

The workaround for now is to run mix itself to run the code.

### escript Build

>
> `mix escript.build`
>

### escript Run

>
> `escript shipsim --help`
>
> `escript shipsim test/TestData.json`
>
> `escript shipsim --file test/TestData.json`
>

## escript References

[Elixir Console Application](https://hackernoon.com/elixir-console-application-with-json-parsing-lets-print-to-console-b701abf1cb14)
