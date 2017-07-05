defmodule ShipSim.JSONFetch do
  @moduledoc """
  To use HTTPoison to fetch from a URL, use the following
  def fetch(search_term) do
    wiki_url(search_term)
    |> HTTPoison.get
    |> handle_json
    |> IO.inspect
  end

  defp wiki_url(search_term) do
    "https://en.wikipedia.org/w/api.php? format=json&action=query&prop=extracts&exintro=&explaintext=&titles= # {search_term}"
  end

  def handle_json({:ok, %{status_code: 200, body: body}}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_json({_, %{status_code: _, body: body}}) do
    IO.puts "Something went wrong. Please check your internet connection"
  end
  """

  def fetch(file_name) do
    # check existence of file_name
    # read it into a binary blob
    File.read(file_name)
    |> handle_json
    |> IO.inspect
    # parse the object and return a JSON structure
    # return the blob, or an error
  end

  def handle_json({:ok, body}) do
    {:ok, Poison.Parser.parse!(body)}
  end

  def handle_json({:error, code}) do
    outstring = :file.format_error(code)
    IO.puts "Error #{outstring}"
  end

end
