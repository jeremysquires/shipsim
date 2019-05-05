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

  NOTE: poison options are now required, but %{keys: :atoms!}
  produces an error, so pass empty options, default keys are reused
  """
  def handle_json({:ok, body}) do
    {:ok, Poison.Parser.parse!(body, %{})}
  end

  @doc """
  Failure case
  """
  def handle_json({:error, code}) do
    outstring = :file.format_error(code)
    # IO.puts "Error #{outstring}"
    {:error, outstring}
  end

end
