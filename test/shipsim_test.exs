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

    test "return distance and speed for all ships", context do
      {read_result, vessels} = ShipSim.JSONFetch.fetch(context[:file_name])
      runs = ShipSim.DaysRun.days_run(vessels)
      assert read_result == :ok && length(runs) == 3
    end

    test "output distance and speed for all ships", context do
      {read_result, vessels} = ShipSim.JSONFetch.fetch(context[:file_name])
      IO.puts ""
      IO.puts ""
      _runs = ShipSim.DaysRun.days_run_out(vessels)
      IO.puts ""
      assert read_result == :ok
    end
  end

  describe "ShipSim.Ship" do
    setup do
      file_name = "test/TestData.json"
      {_read_result, ships} = ShipSim.JSONFetch.fetch(file_name)
      {_extract_result, ship} = ShipSim.ExtractMap.extract_vessel_by_name(ships, "Vessel 1")
      {_extract_result2, ship2} = ShipSim.ExtractMap.extract_vessel_by_name(ships, "Vessel 2")
      positions = ship["positions"]
      positions2 = ship2["positions"]
      {
        :ok,
        v1_before_start_time: "2020-01-01T07:30Z",
        v1_middle_time: "2020-01-01T09:00Z",
        v1_after_end_time: "2020-01-01T10:30Z",
        positions: positions,
        ship: ship,
        positions2: positions2,
        ship2: ship2,
      }
    end

    test "where in rising path gives positive slope", context do
      ship = context[:ship]
      positions = context[:positions]
      v1_middle_time = context[:v1_middle_time]
      start_position = List.first(positions)
      ship_tracker =
        Map.put(ship, :position_index, 0) |>
        Map.put(:current_time, start_position["timestamp"]) |>
        Map.put(:current_position, start_position)
      new_tracker = ShipSim.Ship.where(ship_tracker, v1_middle_time)
      # IO.puts "#{inspect new_tracker}"
      assert new_tracker[:current_position]["x"] > start_position["x"] &&
      new_tracker[:current_position]["y"] > start_position["y"]
    end

    test "where before start time gives start position", context do
      ship = context[:ship]
      positions = context[:positions]
      v1_before_start_time = context[:v1_before_start_time]
      start_position = List.first(positions)
      ship_tracker =
        Map.put(ship, :position_index, 0) |>
        Map.put(:current_time, start_position["timestamp"]) |>
        Map.put(:current_position, start_position)
      new_tracker = ShipSim.Ship.where(ship_tracker, v1_before_start_time)
      # IO.puts "#{inspect new_tracker}"
      assert new_tracker[:current_position] == start_position
    end

    test "where after end time gives end position", context do
      ship = context[:ship]
      positions = context[:positions]
      v1_after_end_time = context[:v1_after_end_time]
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

    test "advance across legs increments index", context do
      ship = context[:ship]
      positions = context[:positions]
      v1_middle_time = context[:v1_middle_time]
      start_position = List.first(positions)
      ship_tracker =
        Map.put(ship, :position_index, 0) |>
        Map.put(:current_time, start_position["timestamp"]) |>
        Map.put(:current_position, start_position)
      new_tracker = ShipSim.Ship.where(ship_tracker, v1_middle_time)
      advance_ship = ShipSim.Ship.advance(new_tracker, 300)
      # IO.puts "#{inspect advance_ship2}"
      advance_ship2 = ShipSim.Ship.advance(advance_ship, 300)
      # IO.puts "#{inspect advance_ship2}"
      assert advance_ship[:position_index] == 3 &&
        advance_ship2[:position_index] == 4
    end

    test "advance before start time stays at start", context do
      ship = context[:ship]
      positions = context[:positions]
      v1_before_start_time = context[:v1_before_start_time]
      start_position = List.first(positions)
      ship_tracker =
        Map.put(ship, :position_index, 0) |>
        Map.put(:current_time, start_position["timestamp"]) |>
        Map.put(:current_position, start_position)
      new_tracker = ShipSim.Ship.where(ship_tracker, v1_before_start_time)
      advance_ship = ShipSim.Ship.advance(new_tracker, 300)
      # IO.puts "#{inspect advance_ship[:current_position]}"
      # IO.puts "#{inspect start_position}"
      assert advance_ship[:current_position]["x"] == start_position["x"] &&
        advance_ship[:current_position]["y"] == start_position["y"]
    end

    test "advance after end time stays at end", context do
      ship = context[:ship]
      positions = context[:positions]
      v1_after_end_time = context[:v1_after_end_time]
      start_position = List.first(positions)
      end_position = List.last(positions)
      ship_tracker =
        Map.put(ship, :position_index, 0) |>
        Map.put(:current_time, start_position["timestamp"]) |>
        Map.put(:current_position, start_position)
      new_tracker = ShipSim.Ship.where(ship_tracker, v1_after_end_time)
      advance_ship = ShipSim.Ship.advance(new_tracker, 300)
      # IO.puts "#{inspect advance_ship[:current_position]}"
      # IO.puts "#{inspect end_position}"
      assert advance_ship[:current_position]["x"] == end_position["x"] &&
        advance_ship[:current_position]["y"] == end_position["y"]
    end

    test "range and bearing in rising path", context do
      ship = context[:ship]
      positions = context[:positions]
      ship2 = context[:ship2]
      positions2 = context[:positions2]
      v1_middle_time = context[:v1_middle_time]
      start_position = List.first(positions)
      start_position2 = List.first(positions2)
      ship_tracker =
        Map.put(ship, :position_index, 0) |>
        Map.put(:current_time, start_position["timestamp"]) |>
        Map.put(:current_position, start_position)
      ship_tracker2 =
        Map.put(ship2, :position_index, 0) |>
        Map.put(:current_time, start_position2["timestamp"]) |>
        Map.put(:current_position, start_position2)
      new_tracker = ShipSim.Ship.where(ship_tracker, v1_middle_time)
      new_tracker2 = ShipSim.Ship.where(ship_tracker2, v1_middle_time)
      %{
        range: range,
        bearing: bearing
      } = ShipSim.Ship.range_and_bearing(ship_tracker2, ship_tracker)
      # IO.puts "#{inspect range} km at #{inspect bearing} deg"
      # IO.puts "#{inspect new_tracker[:current_position]}"
      # IO.puts "#{inspect new_tracker2[:current_position]}"
      assert range > 0 && bearing < 360 && bearing > 0
    end
  end
end
