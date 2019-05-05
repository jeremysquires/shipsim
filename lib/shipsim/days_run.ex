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
            new_delta = last_delta + TimeStamp.delta_time(last_time, timestamp)
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
        IO.puts "### Vessel #{vesselname} run"
        IO.puts ""
        IO.puts "Run:   #{Float.round(distance_run, 2)|>Float.to_string()} km"
        IO.puts "Time:  #{Float.round(hours_run,1)|>Float.to_string()} hours"
        IO.puts "Speed: #{Float.round(speed,2)|>Float.to_string()} km/hr"
      end  
    )
  end
end
