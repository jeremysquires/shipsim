defmodule TimeStamp do
  def delta_time(tstring1, tstring2) do
    {:ok, dt1} = Timex.parse(tstring1, "{ISO:Extended:Z}")
    {:ok, dt2} = Timex.parse(tstring2, "{ISO:Extended:Z}")
    DateTime.diff(dt2, dt1, :second)
  end

  def truncate_seconds(tstring) do
    if (String.length(tstring) == 20) do
      String.slice(tstring, 0..15) <> "Z"
    else
      tstring
    end
  end

  def add_seconds(dt, increment) do
    unix_seconds = DateTime.to_unix(dt, :second) + increment
    DateTime.from_unix(unix_seconds, :second)
  end

  def round_seconds(tstring) do
    {:ok, dt} = Timex.parse(tstring, "{ISO:Extended:Z}")
    # add a half a minute which will then be truncated
    # elixir 1.8+ has newdt = DateTime.add(dt, 30)
    {:ok, newdt} = add_seconds(dt, 30)
    truncate_seconds(DateTime.to_iso8601(newdt))
  end

  def increment_time(tstring, increment) do
    {:ok, dt} = Timex.parse(tstring, "{ISO:Extended:Z}")
    # newdt = DateTime.add(dt, increment)
    {:ok, newdt} = add_seconds(dt, increment)
    round_seconds(DateTime.to_iso8601(newdt))
  end
end
