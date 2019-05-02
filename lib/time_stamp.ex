defmodule TimeStamp do
  def delta_time(tstring1, tstring2) do
    {:ok, dt1} = Timex.parse(tstring1, "{ISO:Extended:Z}")
    {:ok, dt2} = Timex.parse(tstring2, "{ISO:Extended:Z}")
    DateTime.diff(dt2, dt1, :second)
  end
end