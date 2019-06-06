# Tuesday, June 4, 2019

[Hands-on with Elixir!](https://www.meetup.com/Elixir-Calgary/events/261665388/)
Hosted by Jonathan and 2 others

From [Elixir Calgary](https://www.meetup.com/Elixir-Calgary)

[Galleon in Full Sail](highres_481546675.jpeg)

Details

Description:

In this meetup, Jer will show us Elixir's many concurrency methods by converting an existing program from a serial to a parallel processing model. We'll do this through the below code challenge! More notes on the challenge at the bottom.

What to bring:

- Laptop with Elixir installed. [Elixir Install](https://elixir-lang.org/install.html)

Agenda:

- What's new on Elixir
- Activity with Jer
- Networking

Coding problem:

There's a ship simulator written in Elixir here: [shipsim](https://github.com/jeremysquires/shipsim). It processes ship movements on a cartesian plane and calculates the closest point of approach between them.

It currently reads the points from a Json file, processes them sequentially, then reports its results. The simulator is complete, but it will not scale well to a large number of ships.

In this hands-on coding workshop, we'll:

1. Get an overview of concurrency in Elixir
2. Walk through the ShipSim code
3. Generate test data to exercise the simulator
4. Implement concurrent processing of ship movements
5. Measure the running times of different implementations
