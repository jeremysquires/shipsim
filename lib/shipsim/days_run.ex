defmodule ShipSim.DaysRun do
  def days_run(vessels) do
    Enum.map(vessels["vessels"],
      fn vessel ->
        %{"name" => vesselname, "positions" => positions} = vessel
        [firstposition|lastpositions] = positions
        %{"timestamp" => firsttime, "x" => firstx, "y" => firsty} = firstposition
        full_days_run = Enum.reduce(lastpositions,
          {0, {firstx,firsty}, 0, firsttime},
          fn position, acc ->
            %{"timestamp" => timestamp, "x" => x, "y" => y} = position
            {last_distance, {lastx, lasty}, last_delta, last_time} = acc
            new_distance = last_distance + Segment.length(lastx, lasty, x, y)
            new_delta = last_delta + delta_time(last_time, timestamp)
            {new_distance, {x,y}, new_delta, timestamp}
          end
        )
        distance_run = elem(full_days_run, 0)
        hours_run = elem(full_days_run, 2) / 60 / 60
        speed = distance_run / hours_run
        %{
          :vesselname => vesselname,
          :distance_run => distance_run,
          :hours_run => hours_run,
          :speed => speed
        }
      end
    )
  end  

  def days_run_out(vessels) do
    results = ShipSim.DaysRun.days_run(vessels)
    Enum.each(results,
      fn vessel ->
        %{
          :vesselname => vesselname,
          :distance_run => distance_run,
          :hours_run => hours_run,
          :speed => speed
        } = vessel
        IO.puts ""
        IO.puts "Vessel #{inspect vesselname} day's run:"
        IO.puts "Run: #{inspect distance_run} km"
        IO.puts "Time: #{inspect hours_run} hours"
        IO.puts "Speed: #{inspect speed} km/hr"
      end  
    )
  end

  def delta_time(tstring1, tstring2) do
    {:ok, dt1} = Timex.parse(tstring1, "{ISO:Extended:Z}")
    {:ok, dt2} = Timex.parse(tstring2, "{ISO:Extended:Z}")
    DateTime.diff(dt2, dt1, :second)
  end
end
