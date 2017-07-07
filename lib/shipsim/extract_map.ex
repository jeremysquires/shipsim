defmodule ShipSim.ExtractMap do

  @doc """
  Extract all the data from the JSON maps into the arrays and maps
  needed to do the next steps of calculation
  Also use:
  Map.fetch!(extract_article_content, "key")
  Enum.find(fn {key, _value} ->
       case Integer.parse(key) do
         :error -> false
         _ -> key
       end
     end)
  """
  def extract_from_body(map) do
    {:ok, body} = map
    all = fn :get, data, next -> Enum.map(data, next) end
    extract_vessels_names = get_in(body, ["vessels", all, "name"])
    IO.inspect extract_vessels_names
    extract_vessels = get_in(body, ["vessels", all])
    IO.inspect extract_vessels

  end
end
