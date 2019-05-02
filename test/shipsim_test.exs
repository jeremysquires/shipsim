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

    test "extracts positions", context do
      {_, ships} = ShipSim.JSONFetch.fetch(context[:file_name])
      {result, positions} = ShipSim.ExtractMap.extract_positions_by_vessel(ships, "Vessel 1")
      assert result == :ok && length(positions) == 8
    end
 
    test "extracts vessel by name", context do
      {_, ships} = ShipSim.JSONFetch.fetch(context[:file_name])
      vessel_name = "Vessel 1"
      {result, ship} = ShipSim.ExtractMap.extract_vessel_by_name(ships, vessel_name)
      assert result == :ok && ship["name"] == vessel_name
    end
  end

  describe "ShipSim.DaysRun" do
    setup do
      [file_name: "test/TestData.json"]
    end

    test "overall distance and speed for all ships", context do
      {read_result, vessels} = ShipSim.JSONFetch.fetch(context[:file_name])
      runs = ShipSim.DaysRun.days_run(vessels)
      assert read_result == :ok && length(runs) == 3
    end

    test "output distance and speed for all ships", context do
      {read_result, vessels} = ShipSim.JSONFetch.fetch(context[:file_name])
      _runs = ShipSim.DaysRun.days_run_out(vessels)
      assert read_result == :ok
    end
  end

  describe "ShipSim.Ship" do
    setup do
      {
        :ok,
        file_name: "test/TestData.json",
        v1_before_start_time: "2020-01-01T07:30Z",
        v1_middle_time: "2020-01-01T09:00Z",
        v1_after_end_time: "2020-01-01T10:30Z",
      }
    end

    test "where is Vessel 1 at middle time", context do
      {read_result, ships} = ShipSim.JSONFetch.fetch(context[:file_name])
      vessel_name = "Vessel 1"
      # v1_before_start_time = context[:v1_before_start_time]
      v1_middle_time = context[:v1_middle_time]
      # v1_after_end_time = context[:v1_after_end_time]
      {extract_result, ship} = ShipSim.ExtractMap.extract_vessel_by_name(ships, vessel_name)
      positions = ship["positions"]
      start_position = List.first(positions)
      ship_tracker =
        Map.put(ship, :position_index, 0) |>
        Map.put(:current_time, start_position["timestamp"]) |>
        Map.put(:current_position, start_position)
      new_tracker = ShipSim.Ship.where(ship_tracker, v1_middle_time)
      # IO.puts "#{inspect new_tracker}"
      assert new_tracker["name"] == vessel_name
    end

    test "where is Vessel 1 before start time", context do
      {read_result, ships} = ShipSim.JSONFetch.fetch(context[:file_name])
      vessel_name = "Vessel 1"
      v1_before_start_time = context[:v1_before_start_time]
      # v1_middle_time = context[:v1_middle_time]
      # v1_after_end_time = context[:v1_after_end_time]
      {extract_result, ship} = ShipSim.ExtractMap.extract_vessel_by_name(ships, vessel_name)
      positions = ship["positions"]
      start_position = List.first(positions)
      ship_tracker =
        Map.put(ship, :position_index, 0) |>
        Map.put(:current_time, start_position["timestamp"]) |>
        Map.put(:current_position, start_position)
      new_tracker = ShipSim.Ship.where(ship_tracker, v1_before_start_time)
      # IO.puts "#{inspect new_tracker}"
      assert new_tracker[:current_position] == start_position
    end

    test "where is Vessel 1 after end time", context do
      {read_result, ships} = ShipSim.JSONFetch.fetch(context[:file_name])
      vessel_name = "Vessel 1"
      # v1_before_start_time = context[:v1_before_start_time]
      # v1_middle_time = context[:v1_middle_time]
      v1_after_end_time = context[:v1_after_end_time]
      {extract_result, ship} = ShipSim.ExtractMap.extract_vessel_by_name(ships, vessel_name)
      positions = ship["positions"]
      start_position = List.first(positions)
      end_position = List.last(positions)
      ship_tracker =
        Map.put(ship, :position_index, 0) |>
        Map.put(:current_time, start_position["timestamp"]) |>
        Map.put(:current_position, start_position)
      new_tracker = ShipSim.Ship.where(ship_tracker, v1_after_end_time)
      # IO.puts "#{inspect new_tracker}"
      assert new_tracker[:current_position] == end_position
    end
  end
end
