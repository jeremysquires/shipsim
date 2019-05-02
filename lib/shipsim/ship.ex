defmodule ShipSim.Ship do
  @moduledoc """
  ShipSim.Ship encapsulates the actions taken by a Ship
  """

  # if timestamp is before first position, return the first position
  def find_ship(first_time, _last_time, timestamp, positions) when (timestamp <= first_time) do
    {0, List.first(positions), timestamp}
  end

  # if timestamp is after last position, return the last position
  def find_ship(_first_time, last_time, timestamp, positions) when (timestamp >= last_time) do
    {Enum.count(positions) - 1, List.last(positions), timestamp}
  end

  # loop through positions until timestamp is between two positions
  def find_ship(_first_time, _last_time, timestamp, positions) do
    # find before and after indexes
    # TODO: implement binary search on sorted array rather than linear
    next_higher_index = Enum.find_index(positions, &( &1["timestamp"] > timestamp))
    positions_tuple = List.to_tuple(positions)
    next_lower_index = next_higher_index - 1
    next_lower_position = elem(positions_tuple,next_lower_index)
    next_higher_position = elem(positions_tuple,next_higher_index)
    result_map =
      if (next_lower_position["timestamp"] == timestamp) do
        %{index: next_lower_index, position: next_lower_position, timestamp: timestamp}
      else
        # speed and direction between these waymarks
        # time difference
        leg_time_difference = TimeStamp.delta_time(
          next_lower_position["timestamp"],
          next_higher_position["timestamp"]
        )
        run_time_difference = TimeStamp.delta_time(
          next_lower_position["timestamp"],
          timestamp
        )
        # increase of x and y are proportional, so calculate position using ratios
        time_ratio =
          if (leg_time_difference != 0) do
            run_time_difference / leg_time_difference
          else
            0
          end
        leg_delta_x = next_higher_position["x"] - next_lower_position["x"]
        leg_delta_y = next_higher_position["y"] - next_lower_position["y"]
        run_delta_x = leg_delta_x * time_ratio
        run_delta_y = leg_delta_y * time_ratio
        run_x = next_lower_position["x"] + run_delta_x
        run_y = next_lower_position["y"] + run_delta_y
        # end position
        position = %{"x" => run_x, "y" => run_y, "timestamp" => timestamp}
        %{index: next_lower_index, position: position, timestamp: timestamp}
      end
    {result_map.index, result_map.position, result_map.timestamp}
  end

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
    first_time = List.first(positions)["timestamp"]
    last_time = List.last(positions)["timestamp"]
    {
      new_position_index,
      new_current_position,
      new_time
    } = find_ship(first_time, last_time, timestamp, positions) 
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
