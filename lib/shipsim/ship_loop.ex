defmodule ShipSim.ShipLoop do
  @moduledoc """
  ShipSim.Ship simulates the actions taken by a Ship
  """

  @doc """
  ops_loop is a message loop
  Ships communicate with each other and with the simulator
  """
  def ops_loop(vessel) do
    # set up initial location and time
    %{
      "name" => _vessel_name,
      "positions" => positions,
      :position_index => _position_index,
      :current_time => _current_time,
      :current_position => current_position,
    } = vessel
    # assume all ships start at their initial locations and the lowest time
    # they do not start to move until the time reaches their initial timestamps
    receive do
      {:advance} ->
        # increment the time and position
        new_position_index = 0
        new_current_position = positions[new_position_index]
        new_time = positions[new_position_index]["timestamp"]
        # if the current time is less than the first position time, do not change
        # otherwise calculate new position based upon time, speed, and direction
        ops_loop(%{
          vessel |
          :current_position => new_current_position,
          :position_index => new_position_index,
          :current_time => new_time,
        })
      {:range, {x, y}} when is_number(x) and is_number(y) ->
        # TODO: calculate range and bearing from current position
        range = Segment.length(current_position, {x,y})
        # TODO: figure out bearing
        bearing = Segment.angle(current_position, {x,y})
        IO.puts("Range = #{range}")
        IO.puts("Bearing = #{bearing}")
        # TODO: send back range and bearing
        ops_loop(vessel)
      {:range, _position} ->
        IO.puts(":range did not provide a valid position")
        ops_loop(vessel)
      {:reload} ->
        IO.puts("Reloading")
        # TODO: get original vessel and start from scratch
        ShipSim.ShipLoop.ops_loop(vessel)
    end
  end

  # set initial position
  # increment time
  # calculate distance
end
