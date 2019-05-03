defmodule Math do
  def abs(a) when a < 0, do: -1*a
  def abs(a) when a >= 0, do: a
end

defmodule GeometryUtils do
  # todo: use mod to allow wrapping greater than size
  def wrap_index(size, target) when target < 0, do: size + target
  def wrap_index(size, target) when target < size, do: target
  def wrap_index(size, target) when target >= size, do: target - size
end

defmodule Polygon do
  def convex(points) when tuple_size(points) >= 3 do
    points_length = tuple_size(points)
    pointlist =
      if elem(points, 0) != elem(points, points_length - 1) do
        [ elem(points, points_length - 1) | Tuple.to_list(points)]
      else
        Tuple.to_list(points)
      end
    # first two lines are clockwise if det is negative
    directionCW = (Line.det({elem(points, 0), elem(points, 1),
      elem(points, 2)}) < 0)
    # IO.puts "First turn is CW: #{directionCW}"
    result = List.foldl(pointlist, 0, fn(point, acc) ->
      # IO.puts "fn: #{inspect(point)}, #{inspect(acc)}"
      point2 = elem(points, GeometryUtils.wrap_index(points_length,
        acc + 1))
      point3 = elem(points, GeometryUtils.wrap_index(points_length,
        acc + 2))
      direction = (Line.det({point, point2, point3}) < 0)
      # IO.puts "Turn is CW: #{direction}"
      if direction != directionCW or acc == -1 do
        # IO.puts "Direction differs"
        -1
      else
        acc + 1
      end
    end
    )
    # IO.puts "Result: #{result}"
    if result < 0 do
      false
    else
      true
    end
  end
  def convex(points) when tuple_size(points) < 3 do
    IO.puts("Polygon #{inspect points} has insufficient points < 3")
  end
end

defmodule Circle do
  def circumference({_, d}), do: :math.pi*d
  def area({_, d}), do: :math.pi*:math.pow(d/2, 2)
end

defmodule Triangle do
  def hypotenuse(points) when tuple_size(points) == 3 do
    # points: {{x1, y1}, {x2, y2}, {x3, y3}}
    # find which points make a right angle
    points_length = tuple_size(points)
    pointlist = Tuple.to_list(points)
    result = List.foldl(pointlist, 0, fn(point, acc) ->
      # IO.puts "fn: #{inspect(point)}, #{inspect(acc)}"
      point2 = elem(points, GeometryUtils.wrap_index(points_length,
        acc + 1))
      point3 = elem(points, GeometryUtils.wrap_index(points_length,
        acc + 2))
      ninety = (Line.angle({point, point2, point3}) == 90)
      # IO.puts "Turn is 90: #{ninety} at point #{inspect point}"
      cond do
        ninety -> -1*acc
        acc < 0 -> acc
        true -> acc + 1
      end
    end
    )
    if result >= 0  do
      # IO.puts("#{inspect points} does not have a right angle")
      0
    else
      Segment.length({
        elem(points, -1*result + 1),
        elem(points, GeometryUtils.wrap_index(3, -1*result - 1))
      })
    end
  end

  def hypotenuse(points) when tuple_size(points) != 3 do
    IO.puts("#{inspect points} does not have 3 points")
  end
end

defmodule Rectangle do
  def area({{x1, y1}, {x2, y2}}) do
    h = Math.abs x1 - x2
    w = Math.abs y1 - y2
    h*w
  end
  def area({w, h}), do: h*w

  def perimeter({w, h}), do: 2*(h + w)
end

defmodule Square do
  def area({w}), do: Rectangle.area({w, w})

  def area({w, h}) when w==h do
    Rectangle.area({w, h})
  end

  def perimeter({w}) do
    Rectangle.perimeter({w, w})
  end

  def perimeter({w,h}) when w==h do
    Rectangle.perimeter({w, w})
  end

  def draw(square, options \\ []) do
    IO.puts "Perimeter: #{Square.perimeter(square)}"
    for opt <- options, do: opt
  end
end

defmodule Line do
  def det({{x1, y1}, {x2, y2}, {x3, y3}}) do
    a1 = x2 - x1
    b1 = y2 - y1
    a2 = x3 - x1
    b2 = y3 - y1
    Segment.det({{a1, b1}, {a2, b2}})
  end

  def angle({{x1, y1}, {x2, y2}, {x3, y3}}) do
    a1 = x2 - x1
    b1 = y2 - y1
    a2 = x3 - x1
    b2 = y3 - y1
    Segment.angle({a1, b1}, {a2, b2})
  end
end

defmodule Segment do
  def length(x1, y1, x2, y2) do
    :math.sqrt(
      :math.pow(Math.abs(x1 - x2), 2) +
      :math.pow(Math.abs(y1 - y2), 2)
    )
  end
  def length({x1, y1}, {x2, y2}) do
    Segment.length(x1, y1, x2, y2)
  end
  def length({{x1, y1}, {x2, y2}}) do
    Segment.length(x1, y1, x2, y2)
  end

  def angle({x, y}) do
    # IO.puts "Call to Segment.angle (#{x},#{y}) = #{:math.atan(y/x) * 180/:math.pi()}"
    :math.atan2(y,x) * 180/:math.pi()
  end
  def angle({x1, y1}, {x2, y2}) do
    Math.abs(Segment.angle({x2, y2}) - Segment.angle({x1, y1}))
  end

  def azimuth({x1, y1}) do
    atan2 = Segment.angle({x1, y1})
    cond do
      atan2 < 0 -> Math.abs(atan2) + 90
      atan2 < 90 -> 90 - atan2
      atan2 == 90 -> 0
      true -> 450 - atan2
    end
  end
  def azimuth({x1, y1}, {x2, y2}) do
    azimuth({x2 - x1, y2 - y1})
  end

  # signed area of the parallelogram using the origin
  def det({{x1, y1}, {x2, y2}}), do: x1*y2 - x2*y1
  # rectangular area from 0,0 to x,y
  def det({x, y}), do: Rectangle.area {x, y}
end

defmodule Point do
  def distance_from_origin({x, y}) do
    :math.sqrt( x*x + y*y )
  end
end

# TODO:
# get bounding box (line)
# in bounding box (point)
# is parallel (line, line)
# shared point
# is coincident
# is intersecting