# Shipsim

ShipSim takes a JSON file containing ship's positions and simulates the ships moving through the water, reporting crossing vectors and potential collisions.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `shipsim` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:shipsim, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/shipsim](https://hexdocs.pm/shipsim).

## Build

mix escript.build

## Run

escript shipsim --help

escript shipsim test/TestData.json

iex -S mix

## Test

mix test

escript shipsim test/TestData.json

## References

### Create New App Using Mix

mix new shipsim --module ShipSim

edit mix.exs and other module files based upon: 

[Elixir Console Application](https://hackernoon.com/elixir-console-application-with-json-parsing-lets-print-to-console-b701abf1cb14)


