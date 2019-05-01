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

  def output_content(map) do
    {:ok, body} = map
    all = fn :get, data, next -> Enum.map(data, next) end
    extract_vessels = get_in(body, ["vessels", all])
    IO.inspect extract_vessels
  end

  def extract_vessels_names(map) do
    {:ok, body} = map
    all = fn :get, data, next -> Enum.map(data, next) end
    vessels_names = get_in(body, ["vessels", all, "name"])
    if (length(vessels_names) > 0) do
      {:ok, vessels_names}
    else
      {:err, "no vessels found"}
    end
  end

  def extract_positions_by_vessel(map, vessel_name) do
    vessels = map["vessels"]
    %{"name" => _, "positions" => positions} = Enum.find(vessels, [],
      fn vessel ->
        if (vessel["name"] == vessel_name) do
          vessel["positions"]
        else
          false
        end
      end
    )
    if (length(positions) > 0) do
      {:ok, positions}
    else
      {:err, "no positions found"}
    end
  end
end
