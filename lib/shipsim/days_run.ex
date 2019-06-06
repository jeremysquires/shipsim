defmodule ShipSim.DaysRun do
  def days_run_task(vessels) do
    # days run in parallel using tasks
    tasks = Enum.map(
      vessels["vessels"],
      fn vessel ->
        Task.async(
          fn ->
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
            speed =
              if (hours_run == 0) do
                0.0
              else
            distance_run / hours_run
              end
            %{
              :vesselname => vesselname,
              :distance_run => distance_run,
              :hours_run => hours_run,
              :speed => speed
            }
          end
        )
      end
    )
    completedTasks = Task.yield_many(tasks, :infinity)
    results = Enum.map(
      completedTasks,
      fn { task, result } ->
        result || Task.shutdown(task, :brutal_kill)
      end
    )
    Enum.map(
      results,
      fn result ->
        case result do
          { :ok, res } ->
            res
          { :exit, reason } ->
            %{ distance_run: 0.0, hours_run: 0.0, speed: 0.0, vesselname: reason }
          _ ->
            %{ distance_run: 0.0, hours_run: 0.0, speed: 0.0, vesselname: "unknown error" }
        end
      end
    )
  end  

  def days_run_serial(vessels) do
    # calculates days run serially
    Enum.map(
      vessels["vessels"],
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
        speed =
          if (hours_run == 0) do
            0.0
          else
		    distance_run / hours_run
          end
        %{
          :vesselname => vesselname,
          :distance_run => distance_run,
          :hours_run => hours_run,
          :speed => speed
        }
      end
    )
  end

  def days_run(vessels, method \\ "task") do
    case method do
      "serial" ->
        days_run_serial(vessels)
      "task" ->
        days_run_task(vessels)
      _ ->
        days_run_task(vessels)
      end
  end

  def days_run_out(vessels, method \\ "task") do
    results = ShipSim.DaysRun.days_run(vessels, method)
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
        IO.puts "Run:   #{Float.round(distance_run + 0.0, 2)|>Float.to_string()} km"
        IO.puts "Time:  #{Float.round(hours_run + 0.0,1)|>Float.to_string()} hours"
        IO.puts "Speed: #{Float.round(speed + 0.0,2)|>Float.to_string()} km/hr"
      end  
    )
    results
  end
end
