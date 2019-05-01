defmodule ShipSim.Mixfile do
  use Mix.Project

  def project do
    [app: :shipsim,
     version: "0.1.0",
     elixir: "~> 1.5",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     escript: [main_module: ShipSim.CLI], #Added escript     
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    # add :httpoison to get HTTP REST access
    [extra_applications: [:logger, :timex]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  # Add {:httpoison, "~> 0.9.0"} to get HTTP REST access
  defp deps do
    [{:poison, "~> 4.0"},
     {:earmark, "~> 1.3.2", only: :dev},
     {:ex_doc, "~> 0.20.2", only: :dev},
     {:timex, "~> 3.0"}]
  end
end
