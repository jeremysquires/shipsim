defmodule ShipSim.CLI do
  @moduledoc """
  Command Line Interface (CLI) for the ShipSim
  Provides the main() class for an escript command line app
  https://hackernoon.com/elixir-console-application-with-json-parsing-lets-print-to-console-b701abf1cb14
  """

  @doc ~S"""
  Build a classic command line that will be run through the escript processor

    ## doctest

    iex> ShipSim.CLI.main(["--help"])
    :ok
  
  """
  def main(args \\ []) do
    # IO.puts "#{inspect args}"
    parse_args(args)
    |> process
  end

  # use this if CLI will be the main Application
  # def start(_how, _state) do
  #  IO.puts "#{inspect System.argv()}"
  #  main(System.argv())
  #  {:ok, self()}
  # end

  def parse_args(args) do
    parse = OptionParser.parse(args, 
                               switches: [
                                 help: :boolean,
                                 file: :string
                                ],
                               aliases: [h: :help])

    case parse do
      {[help: true], _, _} -> :help
      {[file: file_name], _, _} -> {file_name}
      {_, [file_name], _} -> {file_name}
      {[], [], []} -> :help
    end
  end

  @doc """
  Passed a file name, fetch the JSON and extract it into variables
  """
  def process({file_name}) do
    # ShipSim.JSONFetch.fetch(file_name)
    # |> ShipSim.DaysRun.days_run
    # |> ShipSim.ExtractMap.extract_from_body
    # IO.inspect file_name
    ShipSim.run_sim(file_name)
    {:ok, self()}
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
    {:ok, self()}
  end

end
