defmodule ShipsimTest do
  use ExUnit.Case
  doctest ShipSim
  doctest ShipSim.ExtractMap
  doctest ShipSim.JSONFetch
  doctest ShipSim.Ship

  describe "ShipSim.CLI checks --help" do
    doctest ShipSim.CLI
  end

  describe "ShipSim.JSONFetch" do
    setup do
      [file_name: "test/TestData.json"]
    end

    test "reads the json", context do
      {result, _content} = ShipSim.JSONFetch.fetch(context[:file_name])
      assert result == :ok
    end
  
    test "parses the json", context do
      {result, content} =
        ShipSim.JSONFetch.fetch(context[:file_name])
        |> ShipSim.ExtractMap.extract_vessels_names
      assert result == :ok && length(content) == 3
    end
  end
end
