defmodule ShipSim.Agent do
  use Agent
  require ShipSim.Ship

  def start_link(ships \\ []) do
    Agent.start_link(fn -> ships end, name: __MODULE__)
  end

  def get(item) do
    Agent.get(__MODULE__, &Keyword.get(&1, item))
  end

  def update({:add, ship}) do
    Agent.update(__MODULE__, & [ship|&1])
  end

  def update({action, item}) do
    ship = Agent.get(__MODULE__, &Keyword.get(&1, item))
    new_ship = apply Ship, action, [ship]
    Agent.update(__MODULE__, &Keyword.put(&1, item, new_ship))
  end
end
