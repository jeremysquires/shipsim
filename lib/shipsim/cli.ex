defmodule ShipSim.CLI do
  @moduledoc """
  https://hackernoon.com/elixir-console-application-with-json-parsing-lets-print-to-console-b701abf1cb14
  """

  @doc """
  Build a classic command line that will be run through the escript processor
  """
  def main(args \\ []) do
    parse_args(args)
    |> process
  end

  def parse_args(args) do
    parse = OptionParser.parse(args, 
                               switches: [help: :boolean], 
                               aliases: [h: :help])

    case parse do
      {[help: true], _, _} -> :help
      {_, [file_name], _} -> {file_name}
    end
  end

  def process({file_name}) do
    ShipSim.JSONFetch.fetch(file_name)
    IO.inspect file_name
  end

  def process(:help) do
  IO.puts """
    Ship Simulator
    - - - - - - - 
    usage: shipsim <file_name> | -help
    example: shipsim plato.json
  """
  end

end
