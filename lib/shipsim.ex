defmodule ShipSim do
  @moduledoc """
  Read in the data, initialize the ships, and control the simulation
  """

  @doc """
  Initialize the simulator
  """
  def initSimLoop do
    # read json
    file_name = "test/TestData.json"
    # TODO: pattern match against :ok and :error
    {_result, vessels} = ShipSim.JSONFetch.fetch(file_name)
    # TODO: preprocess all timestamp strings to DateTime objects
    # start time slice at the lowest time
    # TODO: find the lowest timestamp
    lowest_time = "2020-01-01T07:40Z"
    # spawn ship message listeners
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
  Run the simulator
  """
  def runSim do
    # initialize all ship processes
    _ships = ShipSim.initSimLoop()
    # move time slice ahead in loop
    # notify all registered ships
    # until latest time is encountered
  end

end
