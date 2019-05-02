defmodule TimeStampTest do
  use ExUnit.Case

  describe "TimeStamp doc tests" do
		doctest TimeStamp
  end

  def time_data do
    year2020 = "2020-01-01T07:40Z"
    year2019 = "2019-01-01T07:40Z"
    year2019_delta5minutes = "2019-01-01T07:45Z"
		{
			:ok,
			year2020: year2020,
			year2019: year2019,
			year2019_delta5minutes: year2019_delta5minutes,
		}
  end

  setup do
		time_data()
	end

  describe "TimeStamp tests" do
		test "TimeStamp.delta_time negative year of seconds", context do
			year2020 = context[:year2020]
			year2019 = context[:year2019]
      year_seconds = TimeStamp.delta_time(year2020, year2019)
			# IO.puts "Negative year of seconds is #{inspect year_seconds}"
      assert year_seconds == -31536000
    end

    test "TimeStamp.delta_time positive 5 minutes", context do
			year2019 = context[:year2019]
			year2019_delta5minutes = context[:year2019_delta5minutes]
      delta_seconds = TimeStamp.delta_time(year2019, year2019_delta5minutes)
			# IO.puts "Delta 5 minutes is #{inspect delta_seconds}"
      assert delta_seconds == 5 * 60
    end

    test "TimeStamp comparison", context do
			year2020 = context[:year2020]
			year2019 = context[:year2019]
			# IO.puts "Negative year of seconds is #{inspect year_seconds}"
      assert year2019 < year2020
    end
  end
end
