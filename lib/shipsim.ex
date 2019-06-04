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
    IO.puts "End Loop :- Timestamp: #{timestamp} > Highest Time: #{highest_time}"
    {:ok, ship_trackers, closest_points}
  end

  def advance_loop(ship_trackers, _timestamp, highest_time, closest_points) do
    # advance ships
    # TODO: advance ships in parallel
    new_ship_trackers = Enum.map(
      ship_trackers,
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

  # for running shipsim as the main application
  def start(_how, args) do
    # handle mix test by removing "test"
    sysargs = List.delete(System.argv(), "test")
    cond do
      length(args) > 0 -> run_sim(args)
      length(sysargs) > 0 -> :ok
      true -> run_sim()
    end
    {:ok, self()}
  end

  def final_output(vessels, end_trackers, closest_points) do
    # output distance and speed for all ships
    IO.puts "# Ship Run Statistics"
    runs = ShipSim.DaysRun.days_run_out(vessels)
    average_speed = Enum.reduce(runs, 0, &( &1.speed + &2)) / length(runs)
    # output end state
    # IO.puts "#{inspect end_trackers}"
    # Enum.each(end_trackers, &(Scribe.print(&1, colorize: false)))
    IO.puts ""
    IO.puts "# Ship End State"
    IO.puts ""
    Enum.each(end_trackers,
      fn tracker ->
        IO.puts "## #{tracker["name"]}"
        IO.puts ""
        Scribe.print([tracker.current_position],
          colorize: false,
          data: [{"Date/Time",
            fn row ->
              {:ok, dt} = Timex.parse(row["timestamp"], "{ISO:Extended:Z}")
              DateTime.to_string(dt)
            end
            },
            {"North",
              fn row ->
                Float.round(row["y"] + 0.0, 1)|>Float.to_string()
              end
            },
            {"East",
              fn row ->
                Float.round(row["x"] + 0.0, 1)|>Float.to_string()
              end
            }
          ]
        )
      end
    )
    # Scribe.print(end_trackers, colorize: false, style: Scribe.Style.GithubMarkdown)
    # output closest point of approach information
    # IO.puts "#{inspect closest_points}"
    # Enum.each(closest_points, &(Scribe.print(&1, colorize: false)))
    IO.puts "# Closest Points of Approach"
    IO.puts "To display: #{length(closest_points)} closest points"
    IO.puts ""
    Enum.each(closest_points,
      fn closest ->
        IO.puts "## #{closest.ownship} -> #{closest.target}"
        IO.puts ""
        IO.puts "* Range:   #{Float.round(closest.range, 2)|>Float.to_string()} km"
        IO.puts "* Bearing: #{Float.round(closest.bearing, 1)|>Float.to_string()} deg T"
        {:ok, dt} = Timex.parse(closest.time, "{ISO:Extended:Z}")
        IO.puts "* Time:    #{DateTime.to_string(dt)}"
        IO.puts ""
        if (closest.range < (average_speed / 2)) do
          IO.puts "WARN: The range is less than half the average speed of all the vessels."
          IO.puts "WARN: The two vessels are closer than one hour's steam from each other."
          IO.puts ""
        end
        IO.puts "### #{closest.ownship} Position"
        IO.puts ""
        Scribe.print([closest.own_position],
          colorize: false,
          data: [{"Date/Time",
            fn row ->
              {:ok, dt} = Timex.parse(row["timestamp"], "{ISO:Extended:Z}")
              DateTime.to_string(dt)
            end
            },
            {"North",
              fn row ->
                Float.round(row["y"] + 0.0, 1)|>Float.to_string()
              end
            },
            {"East",
              fn row ->
                Float.round(row["x"] + 0.0, 1)|>Float.to_string()
              end
            }
          ]
        )
        IO.puts "### #{closest.target} Position"
        IO.puts ""
        Scribe.print([closest.trg_position],
          colorize: false,
          data: [{"Date/Time",
            fn row ->
              {:ok, dt} = Timex.parse(row["timestamp"], "{ISO:Extended:Z}")
              DateTime.to_string(dt)
            end
            },
            {"North",
              fn row ->
                Float.round(row["y"] + 0.0, 1)|>Float.to_string()
              end
            },
            {"East",
              fn row ->
                Float.round(row["x"] + 0.0, 1)|>Float.to_string()
              end
            }
          ]
        )
      end
    )
    IO.puts "# End of Closest Points Listing"
  end

  @doc """
  Run the simulator

  TODO: remove the default or don't call with missing args
  """
  def run_sim(file_name \\ "test/TestData.json") do
    # TODO: pattern match against :ok and :error
    {result, vessels} = ShipSim.JSONFetch.fetch(file_name)
    if (result == :error) do
      # error = "File : #{inspect file_name}" <> "Error : #{inspect vessels}"
      IO.puts "File : #{inspect file_name}"
      IO.puts "Error : #{inspect vessels}"
      Process.exit(self(), :kill)
    end
    ships = vessels["vessels"]
    first_time = List.first(List.first(ships)["positions"])["timestamp"]
    # start time slice at the lowest time
    # TODO: find the actual lowest timestamp
    lowest_time =
      if (String.starts_with?(first_time, "2020")) do
        # use lowest time in TestData.json
        "2020-01-01T07:40Z"
      else
        # start at the first day in this month
        "#{String.slice(first_time, 0..7)}01T00:00Z"
      end
    # end at the highest time
    # TODO: find the highest timestamp
    highest_time =
      if (String.starts_with?(first_time, "2020")) do
        # use highest time in TestData.json
        "2020-01-01T11:24Z"
      else
        # highest date possible is the last day in the month (2017-08-31T23:59Z)
        # "#{String.slice(first_time, 0..7)}31T23:59Z"
        # only run for a single day initially
        "#{String.slice(first_time, 0..7)}01T23:59Z"
      end
    # initialize all ship processes
    # using message passing loop
    # _ships = ShipSim.initSimLoop()
    # using Agent
    # using Task
    # using in memory objects
    ship_trackers = Enum.map(
      ships,
      fn ship ->
        start_position = List.first(ship["positions"])
        ship_tracker =
          Map.put(ship, :position_index, 0)
          |> Map.put(:current_time, lowest_time)
          |> Map.put(:current_position, start_position)
        ShipSim.Ship.where(ship_tracker, lowest_time)
      end
    )
    # move time slice ahead in loop
    # until latest time is encountered
    {:ok, end_trackers, closest_points} =
      advance_loop(ship_trackers, lowest_time, highest_time, [])
    # print output
    final_output(vessels, end_trackers, closest_points)
  end

end
