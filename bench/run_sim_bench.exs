# Bench tests
#
# Add your tests below serial, rename test, call your function
#
# Uncomment the larger data sets if your bench is too fast
# (1M positions took 48 minutes on a 32 bit 2 core with 1 GB mem)
#
Benchee.run(
  %{
    "serial" => fn input -> ShipSim.run_sim(input, "serial") end,
    "task" => fn input -> ShipSim.run_sim(input, "task") end,
  },
  inputs: %{
    # "pos_10" => "bench/data/pos10.json",
    # "pos_100" => "bench/data/pos100.json",
    # "pos_1k" => "bench/data/pos1000.json",
    # "pos_10k" => "bench/data/pos10000.json",
    "pos_100k" => "bench/data/pos100000.json",
    # "pos_1M" => "bench/data/pos1000000.json",
    # "pos_10M" => "bench/data/pos10000000.json",
    # "pos_20M" => "bench/data/pos20000000.json"
  }
)

## Bench Results Captured
#
# Operating System: Windows
# CPU Information: Intel(R) Core(TM) i7-3630QM CPU @ 2.40GHz
# Number of Available Cores: 8
# Available memory: 15.89 GB
# Elixir 1.8.1
# Erlang 21.2
#
##### With input pos_100k #####
# Name             ips        average  deviation         median         99th %
# task          0.0179       0.93 min     ±0.00%       0.93 min       0.93 min
# serial        0.0147       1.14 min     ±0.00%       1.14 min       1.14 min
#
# Comparison:
# task          0.0179
# serial        0.0147 - 1.22x slower +0.20 min
#
# Benchmarking serial with input pos_1M...
#
##### With input pos_1M #####
# Name             ips        average  deviation         median         99th %
# serial       0.00063      26.58 min     ±0.00%      26.58 min      26.58 min
# 
# Test results from 32 bit netbook : 1 million positions
#
# Benchmarking serial with input pos_1M...
# Operating System: Linux
# CPU Information: Intel(R) Atom(TM) CPU N280   @ 1.66GHz
# Number of Available Cores: 2
# Available memory: 990.68 MB
# Elixir 1.8.2
# Erlang 21.1
#
# ##### With input pos_1M #####
# Name             ips        average  deviation         median         99th %
# serial       0.00034      48.45 min     ±0.00%      48.45 min      48.45 min
