# add your tests below serial, calling your new function
Benchee.run(
  %{
    "serial" => fn input -> ShipSim.run_sim(input) end,
  },
  inputs: %{
    "pos_1k" => "bench/data/pos1000.json",
    "pos_10k" => "bench/data/pos10000.json",
    "pos_100k" => "bench/data/pos100000.json",
    "pos_1M" => "bench/data/pos1000000.json"
  }
)
