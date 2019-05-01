defmodule ShipSim.Ship do
  @moduledoc """
  ShipSim.Ship encapsulates the actions taken by a Ship
  """

  @doc """
  At any timestamp, return the associated position
  """
  def where(vessel, timestamp) do
    # extract ship information
    %{
      "name" => _vessel_name,
      "positions" => positions,
      :position_index => _position_index,
      :current_time => _current_time,
      :current_position => _current_position,
    } = vessel
    # if timestamp is before first position, return the first position
    new_position_index = 0
    new_current_position = positions[new_position_index]
    new_time = timestamp
    # if timestamp is after last position, return the last position
    # loop through positions until timestamp is between two positions
    %{
      vessel |
      :current_position => new_current_position,
      :position_index => new_position_index,
      :current_time => new_time,
    }
  end

  def advance(vessel, _time_increment) do
    # set up current location and time
    %{
      "name" => _vessel_name,
      "positions" => positions,
      :position_index => _position_index,
      :current_time => _current_time,
      :current_position => _current_position,
    } = vessel
    # increment the time and position
    # if timestamp is before first position, return the first position
    new_position_index = 0
    new_current_position = positions[new_position_index]
    new_time = positions[new_position_index]["timestamp"]
    # if timestamp is after last position, return the last position
    # otherwise calculate new position based upon time, speed, and direction
    %{
      vessel |
      :current_position => new_current_position,
      :position_index => new_position_index,
      :current_time => new_time,
    }
  end

  def range_and_bearing(vessel, {x, y}) when is_number(x) and is_number(y) do
    # extract ship information
    %{
      "name" => _vessel_name,
      "positions" => _positions,
      :position_index => _position_index,
      :current_time => _current_time,
      :current_position => current_position,
    } = vessel
    range = Segment.length(current_position, {x,y})
    # TODO: calculate bearing from current position
    bearing = Segment.angle(current_position, {x,y})
    IO.puts("Range = #{range}")
    IO.puts("Bearing = #{bearing}")
    # return range and bearing
    %{
      :range => range,
      :bearing => bearing
    }
  end
  def range_and_bearing(_vessel, _position) do
    IO.puts(":range did not provide a valid position")
    %{
      :range => nil,
      :bearing => nil
    }
  end
end
