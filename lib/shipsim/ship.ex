defmodule ShipSim.Ship do
  @moduledoc """
  ShipSim.Ship encapsulates the actions taken by a Ship
  """

  def interpolate_positions(first_position, next_position, timestamp) do
    # passed first_position == next_position, return first_position
    # time difference
    leg_time_difference = TimeStamp.delta_time(
      first_position["timestamp"],
      next_position["timestamp"]
    )
    run_time_difference = TimeStamp.delta_time(
      first_position["timestamp"],
      timestamp
    )
    # increase of x and y are proportional, so calculate position using ratios
    time_ratio =
      if (leg_time_difference != 0) do
        run_time_difference / leg_time_difference
      else
        0
      end
    leg_delta_x = next_position["x"] - first_position["x"]
    leg_delta_y = next_position["y"] - first_position["y"]
    run_delta_x = leg_delta_x * time_ratio
    run_delta_y = leg_delta_y * time_ratio
    run_x = first_position["x"] + run_delta_x
    run_y = first_position["y"] + run_delta_y
    # end position
    %{"x" => run_x, "y" => run_y, "timestamp" => timestamp}
  end

  # loop through positions until timestamp is between two positions
  def find_ship(positions, timestamp) do
    # if timestamp is before first position, return the first position
    # if timestamp is after last position, return the last position
    cond do
      timestamp <= List.first(positions)["timestamp"] ->
        {0, List.first(positions), timestamp}
      timestamp >= List.last(positions)["timestamp"] ->
        {Enum.count(positions) - 1, List.last(positions), timestamp}
      true ->
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
            position = interpolate_positions(next_lower_position, next_higher_position, timestamp)
            %{index: next_lower_index, position: position, timestamp: timestamp}
          end
        {result_map.index, result_map.position, result_map.timestamp}
    end
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
    {
      new_position_index,
      new_current_position,
      new_time
    } = find_ship(positions, timestamp)
    %{
      vessel |
      :current_position => new_current_position,
      :position_index => new_position_index,
      :current_time => new_time,
    }
  end

  def advance_indexes(position_index, positions_tuple, new_time) do
    next_index =
      if (position_index == tuple_size(positions_tuple) - 1) do
        position_index
      else
        position_index + 1
      end
    next_position = elem(positions_tuple, next_index)
    new_position_index =
      if ((new_time >= next_position["timestamp"]) && (next_index != position_index)) do
        next_index
      else
        position_index
      end
    new_next_index =
      if (new_position_index == tuple_size(positions_tuple) - 1) do
        new_position_index
      else
        new_position_index + 1
      end
    new_previous_position = elem(positions_tuple, new_position_index)
    new_next_position = elem(positions_tuple, new_next_index)
    %{
      new_position_index: new_position_index,
      new_previous_position: new_previous_position,
      new_next_position: new_next_position
    }
  end

  def advance(vessel, time_increment \\ 60) do
    # set up current location and time
    %{
      "name" => _vessel_name,
      "positions" => positions,
      :position_index => position_index,
      :current_time => current_time,
      :current_position => _current_position,
    } = vessel
    # increment the time
    new_time = TimeStamp.increment_time(current_time, time_increment)
    # get the position bracket of the current time
    positions_tuple = List.to_tuple(positions)
    # advance the indexes if necessary
    %{
      new_position_index: new_position_index,
      new_previous_position: new_previous_position,
      new_next_position: new_next_position
    } = advance_indexes(position_index, positions_tuple, new_time)
    # calculate the next position unless time is less than first waypoint
    new_current_position =
      if (new_time < new_previous_position["timestamp"]) do
        new_previous_position
      else
        interpolate_positions(new_previous_position, new_next_position, new_time)
      end
    %{
      vessel |
      :current_position => new_current_position,
      :position_index => new_position_index,
      :current_time => new_time,
    }
  end

  def range_and_bearing(vessel1, vessel2) do
    # extract ship information
    %{
      "name" => _vessel_name_1,
      "positions" => _positions_1,
      :position_index => _position_index_1,
      :current_time => _current_time_1,
      :current_position => current_position_1,
    } = vessel1
    %{
      "name" => _vessel_name_2,
      "positions" => _positions_2,
      :position_index => _position_index_2,
      :current_time => _current_time_2,
      :current_position => current_position_2,
    } = vessel2
    %{"x" => x1, "y" => y1, "timestamp" => _timestamp1} = current_position_1
    %{"x" => x2, "y" => y2, "timestamp" => _timestamp2} = current_position_2
    range = Segment.length(x1, y1, x2, y2)
    # calculate true bearing from vessel1 to vessel2
    bearing = Segment.azimuth({x1, y1}, {x2, y2})
    # IO.puts("Range = #{range}")
    # IO.puts("Bearing = #{bearing}")
    # return range and bearing
    %{
      :range => range,
      :bearing => bearing
    }
  end
end
