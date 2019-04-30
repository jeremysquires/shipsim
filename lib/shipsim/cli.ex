defmodule ShipSim.CLI do
  @moduledoc """
  Command Line Interface (CLI) for the ShipSim
  Provides the main() class for an escript command line app
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
      {[], [], []} -> :help
    end
  end

  @doc """
  Passed a file name, fetch the JSON and extract it into variables
  """
  def process({file_name}) do
    ShipSim.JSONFetch.fetch(file_name)
    |> ShipSim.ExtractMap.extract_from_body
    # IO.inspect file_name
  end

  @doc """
  Passed the :help atom, print out help
  """
  def process(:help) do
  IO.puts """
    Ship Simulator
    - - - - - - - 
    usage: shipsim <file_name> | --help
    example: shipsim test/TestData.json
  """
  end

end
