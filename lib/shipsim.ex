defmodule ShipSim do
  @moduledoc """
  Read in the data, initialize the ships, and control the simulation
  """

  @doc """
  Initialize the simulator using message passing loops
  """
  def init_sim_loop do
    # read json
    file_name = "test/TestData.json"
    # TODO: pattern match against :ok and :error
    {_result, vessels} = ShipSim.JSONFetch.fetch(file_name)
    # start time slice at the lowest time
    # TODO: find the lowest timestamp
    lowest_time = "2020-01-01T07:40Z"
    # TODO: spawn ship message listeners using ShipLoop for message passing
    Enum.map(vessels,
      fn vessel ->
        spawn ShipSim.ShipLoop.ops_loop(%{
          vessel |
          :position_index => 0,
          :current_time => lowest_time,
        })
      end
    )
  end

  @doc """
  Initialize the simulator using ShipAgent processes
  """
  def init_sim_agents do
    # read json
    file_name = "test/TestData.json"
    # TODO: pattern match against :ok and :error
    {_result, _vessels} = ShipSim.JSONFetch.fetch(file_name)
    # start time slice at the lowest time
    # TODO: find the lowest timestamp
    _lowest_time = "2020-01-01T07:40Z"
  end

  def all_ranges([ownship|others], results) do
    # compute ranges
    new_ranges = Enum.map(others,
      fn target ->
        %{
          range: range,
          bearing: bearing
        } = ShipSim.Ship.range_and_bearing(ownship, target)
        # TODO: add reciprocal bearing from target back to ownship
        # TODO: add check for crossing of these two legs
        %{
          ownship: ownship["name"],
          target: target["name"],
          time: target[:current_time],
          own_position: ownship[:current_position],
          trg_position: target[:current_position],
          range: range,
          bearing: bearing
        }
      end
    )
    # add to results
    new_results = results ++ new_ranges
    all_ranges(others, new_results)
  end
  def all_ranges(_, results) do
    # last ship has been compared to all the others
    results
  end

  def update_closest_points([], ranges) do
    ranges
  end
  def update_closest_points(closest_points, ranges) do
    closest_points
    |> Enum.zip(ranges)
    |> Enum.map(fn {closest, range} -> 
      if (closest.range > range.range), do: range, else: closest
    end)
    # IO.puts "#{new_closest_points}"
    # for {closest, range} <- Enum.zip(closest_points, ranges),
    #  into: [],
    #    do: if (closest.range > range.range), do: range, else: closest
  end

  def advance_loop(ship_trackers, timestamp, highest_time, closest_points) when timestamp > highest_time do
    {:ok, ship_trackers, closest_points}
  end

  def advance_loop(ship_trackers, _timestamp, highest_time, closest_points) do
    # advance ships
    new_ship_trackers = Enum.map(ship_trackers,
      fn tracker ->
        ShipSim.Ship.advance(tracker, 60)
      end
    )
    # find the ranges between all ships
    ranges = all_ranges(new_ship_trackers, [])
    # find the closest points of approach
    new_closest_points = update_closest_points(closest_points, ranges)
    new_timestamp = List.first(new_ship_trackers)[:current_time]
    # recurse until time runs out
    advance_loop(new_ship_trackers, new_timestamp, highest_time, new_closest_points)
  end

  def start(_how, _state) do
    run_sim()
    {:ok, self()}
  end

  @doc """
  Run the simulator
  """
  def run_sim do
    file_name = "test/TestData.json"
    # TODO: pattern match against :ok and :error
    {:ok, vessels} = ShipSim.JSONFetch.fetch(file_name)
    # start time slice at the lowest time
    # TODO: find the lowest timestamp
    lowest_time = "2020-01-01T07:40Z"
    # end at the highest time
    # TODO: find the highest timestamp
    highest_time = "2020-01-01T11:24Z"
    # initialize all ship processes
    # using message passing loop
    # _ships = ShipSim.initSimLoop()
    # using Agent
    # using Task
    # using in memory objects
    ships = vessels["vessels"]
    ship_trackers = Enum.map(ships,
      fn ship ->
        start_position = List.first(ship["positions"])
        ship_tracker =
          Map.put(ship, :position_index, 0) |>
          Map.put(:current_time, lowest_time) |>
          Map.put(:current_position, start_position)
        ShipSim.Ship.where(ship_tracker, lowest_time)
      end
    )
    # move time slice ahead in loop
    # until latest time is encountered
    {:ok, end_trackers, closest_points} =
      advance_loop(ship_trackers, lowest_time, highest_time, [])
    # output end state
    IO.puts "#{inspect end_trackers}"
    # output closest point of approach information
    IO.puts "#{inspect closest_points}"  
    # output distance and speed for all ships
    _runs = ShipSim.DaysRun.days_run_out(vessels)
  end

end
