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

  def advance_loop(ship_trackers, timestamp, highest_time, closest_points) when timestamp > highest_time do
    {:ok, ship_trackers, closest_points}
  end

  def advance_loop(ship_trackers, _timestamp, highest_time, closest_points) do
    new_ship_trackers = Enum.map(ship_trackers,
      fn tracker ->
        ShipSim.Ship.advance(tracker, 60)
      end
    )
    # find the closest points of approach
    # TODO: | 1 => %{position: position, range: range, bearing: bearing}
    new_closest_points = closest_points
    new_timestamp = List.first(new_ship_trackers)[:current_time]
    advance_loop(new_ship_trackers, new_timestamp, highest_time, new_closest_points)
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
    {:ok, end_trackers, closest_points} = advance_loop(ship_trackers, lowest_time, highest_time, %{})
    IO.puts "#{inspect end_trackers}"
    IO.puts "#{inspect closest_points}"
    # output closest point of approach information
  
    # output distance and speed for all ships
    _runs = ShipSim.DaysRun.days_run_out(vessels)
  end

end
