defmodule ShipSim.JSONFetch do
  @moduledoc """
  ShipSim.JSONFetch reads JSON from a file
  """

  def fetch(file_name) do
    # check existence of file_name
    # read it into a binary blob
    File.read(file_name)
    |> handle_json
    # |> IO.inspect
    # parse the object and return a JSON structure
    # return the blob, or an error
  end

  @doc """
  Success case
  """
  def handle_json({:ok, body}) do
    {:ok, Poison.Parser.parse!(body, %{keys: :atoms!})}
  end

  @doc """
  Failure case
  """
  def handle_json({:error, code}) do
    outstring = :file.format_error(code)
    IO.puts "Error #{outstring}"
  end

end
