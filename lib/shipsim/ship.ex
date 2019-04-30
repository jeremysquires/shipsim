defmodule ShipSim.Ship do
  @moduledoc """
  ShipSim.Ship simulates the actions taken by a Ship
  """

  @doc """
  ops_loop is a message loop
  Ships communicate with each other and with the simulator
  """
  def ops_loop do
    receive do
      {:rectangle, w, h} ->
        IO.puts("Area New = #{w * h}")
        ops_loop()
      {:circle, r} when is_number(r) ->
        IO.puts("Area = #{3.14 * r * r}")
        ops_loop()
      {:circle, _r} ->
        IO.puts("Not a number")
        ops_loop()
      {:reload} ->
        IO.puts("Reloading")
        ShipSim.Ship.ops_loop()
    end
  end

end
