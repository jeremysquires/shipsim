defmodule Math do
	def abs(a) when a < 0, do: -1*a
	def abs(a) when a >= 0, do: a
end

defmodule ShipSim.DaysRun do
  def days_run(vessels) do
    Enum.each(vessels["vessels"], fn vessel ->
      vesselname = vessel["name"]
      positions = vessel["positions"]
      [firstposition|lastpositions] = positions
      firsttime = firstposition["timestamp"]
      firstx = firstposition["x"]
      firsty = firstposition["y"]
      full_days_run = Enum.reduce(lastpositions,
        {0, {firstx,firsty}, 0, firsttime},
        fn position, acc ->
          timestamp = position["timestamp"]
          x = position["x"]
          y = position["y"]
          last_distance = elem(acc, 0)
          last_point = elem(acc, 1)
          last_delta = elem(acc, 2)
          last_time = elem(acc, 3)
          lastx = elem(last_point, 0)
          lasty = elem(last_point, 1)
          new_distance = last_distance + ShipSim.DaysRun.distance(lastx, lasty, x, y)
          new_delta = last_delta + delta_time(last_time, timestamp)
          {new_distance, {x,y}, new_delta, timestamp}
        end
      )
      IO.puts "Vessel #{inspect vesselname} day's run:"
      distance_run = elem(full_days_run, 0)
      IO.puts "Run: #{inspect distance_run} km"
      hours_run = elem(full_days_run, 2) / 60 / 60
      IO.puts "Time: #{inspect hours_run} hours"
      speed = distance_run / hours_run
      IO.puts "Speed: #{inspect speed} km/hr"
    end
    )
  end  

  def distance(x1, y1, x2, y2) do
    :math.sqrt(
      :math.pow(Math.abs(x1 - x2), 2) +
      :math.pow(Math.abs(y1 - y2), 2)
    )
  end  
  def distance({x1, y1}, {x2, y2}) do
    ShipSim.DaysRun.distance(x1, y1, x2, y2)
  end  
  def distance({{x1, y1}, {x2, y2}}) do
    ShipSim.DaysRun.distance(x1, y1, x2, y2)
  end  
  def distance([{x1, y1}, {x2, y2}]) do
    ShipSim.DaysRun.distance(x1, y1, x2, y2)
  end  

  def delta_time(tstring1, tstring2) do
    {:ok, dt1} = Timex.parse(tstring1, "{ISO:Extended:Z}")
    {:ok, dt2} = Timex.parse(tstring2, "{ISO:Extended:Z}")
    DateTime.diff(dt2, dt1, :second)
  end
end
