# Bench tests
#
# Add your tests below serial, rename test, call your function
#
# Uncomment the larger data sets if your bench is too fast
# (1M positions took 48 minutes on a 32 bit 2 core with 1 GB mem)
#
Benchee.run(
  %{
    "serial" => fn input -> ShipSim.run_sim(input) end,
  },
  inputs: %{
    "pos_10" => "bench/data/pos10.json",
    # "pos_100" => "bench/data/pos100.json",
    # "pos_1k" => "bench/data/pos1000.json",
    # "pos_10k" => "bench/data/pos10000.json",
    # "pos_100k" => "bench/data/pos100000.json",
    # "pos_1M" => "bench/data/pos1000000.json",
    # "pos_10M" => "bench/data/pos10000000.json",
    # "pos_20M" => "bench/data/pos20000000.json"
  }
)

# Test results from 32 bit netbook : 1 million positions
#
# Benchmarking serial with input pos_1M...
#
# ##### With input pos_1M #####
# Name             ips        average  deviation         median         99th %
# serial       0.00034      48.45 min     ±0.00%      48.45 min      48.45 min
#
# Operating System: Linux
# CPU Information: Intel(R) Atom(TM) CPU N280   @ 1.66GHz
# Number of Available Cores: 2
# Available memory: 990.68 MB
# Elixir 1.8.2
# Erlang 21.1
# 
# Benchmark suite executing with the following configuration:
# warmup: 2 s
# time: 5 s
# memory time: 0 ns
# parallel: 1
# inputs: pos_1M
# Estimated total run time: 7 s

# Test results from 64 bit laptop : 1 million positions
#
# Benchmarking serial with input pos_1M...
#
##### With input pos_1M #####
# Name             ips        average  deviation         median         99th %
# serial       0.00063      26.58 min     ±0.00%      26.58 min      26.58 min
# Operating System: Windows
# CPU Information: Intel(R) Core(TM) i7-3630QM CPU @ 2.40GHz
# Number of Available Cores: 8
# Available memory: 15.89 GB
# Elixir 1.8.1
# Erlang 21.2
# 
# Benchmark suite executing with the following configuration:
# warmup: 2 s
# time: 5 s
# memory time: 0 ns
# parallel: 1
# inputs: pos_1M
# Estimated total run time: 7 s
