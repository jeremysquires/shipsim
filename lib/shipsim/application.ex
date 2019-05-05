defmodule ShipSim.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false
  use Application

  def start(_type, _args \\ []) do
    import Supervisor.Spec, warn: false
    children = [
      # id: :shipsim, start: {ShipSim, :start, [:normal, []]}
      # id: :shipsim, start: {ShipSim.CLI, :start, [:normal, []]}
      %{
        id: :shipsim, start: {ShipSim, :start, [:normal, []]}
      }
    ]
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ShipSim.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

