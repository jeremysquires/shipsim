defmodule GeometryTest do
  use ExUnit.Case

  describe "Geometry doc tests" do
		doctest Math
		doctest GeometryUtils
		doctest Polygon
		doctest Circle
		doctest Triangle
		doctest Rectangle
		doctest Square
		doctest Line
		doctest Segment
		doctest Point
  end

	def geometry_data do
		# positive quadrant
		r = {3,4}
		s = {4}
		point = {3,4}
		line1 = {{3,4},{10,6}}
		path = {{7,3},{6,4},{3,2}}
		circle = {{0,0}, 1}
		# could use a tuple and Tuple.to_list it
		polygon = {{7,3},{6,4},{3,2},{10,6}}
		triangle = {{7,3},{6,4},{3,2}}
		right_triangle = {{0,0},{3,0},{3,4}}
		# other quadrants
		point2 = {-3,4}
		line2 = {{-3,4},{-10,6}}
		path2 = {{-7,3},{-6,4},{-3,2}}
		point3 = {3,-4}
		line3 = {{3,-4},{10,-6}}
		path3 = {{7,-3},{6,-4},{3,-2}}
		point4 = {-3,-4}
		line4 = {{-3,-4},{-10,-6}}
		path4 = {{-7,-3},{-6,-4},{-3,-2}}
		# cross quadrants
		line5 = {{-3,4},{10,-6}}
		path5 = {{-7,3},{6,-4},{3,2}}
		line6 = {{-3,4},{10,-6}}
		path6 = {{-7,-3},{6,-4},{3,2}}
		line7 = {{-3,-4},{10,6}}
		path7 = {{7,3},{-6,-4},{-3,2}}
		{
			:ok,
			r: r,
			s: s,
			point: point,
			line1: line1,
			path: path,
			circle: circle,
			polygon: polygon,
			triangle: triangle,
			right_triangle: right_triangle,
			point2: point2,
			line2: line2,
			path2: path2,
			point3: point3,
			line3: line3,
			path3: path3,
			point4: point4,
			line4: line4,
			path4: path4,
			line5: line5,
			path5: path5,
			line6: line6,
			path6: path6,
			line7: line7,
			path7: path7,
		}
	end

	setup do
		geometry_data()
	end

	describe "Geometry Rectangle tests" do
		test "Geometry.Rectangle.area", context do
			r = context[:r]
			line = context[:line1]
			# IO.puts "Area of the rectangle  #{inspect r} is #{Rectangle.area r}"
			# IO.puts "Area of rectangle #{inspect line} is #{Rectangle.area line}"
      assert Rectangle.area(r) == 12 && Rectangle.area(line) == 14
    end  
	end

	describe "Geometry Square tests" do
		test "Geometry.Square.area", context do
			s = context[:s]
			# IO.puts "Area of square #{inspect s} is #{Square.area s}"
      assert Square.area(s) == 16
    end  
  end

	describe "Geometry Point tests" do
		test "Geometry.Point.distance_from_origin", context do
			point = context[:point]
			# IO.puts "Distance from origin #{inspect point} is
				#{Point.distance_from_origin point}"
      assert Point.distance_from_origin(point) == 5.0
    end  
  end

	describe "Geometry Segment tests" do
		test "Geometry.Segment.length", context do
			line = context[:line1]
			# IO.puts "Length of line #{inspect line} is #{Segment.length line}"
      assert Segment.length(line) == 7.280109889280518
		end
	
		test "Geometry.Segment.det", context do
			line = context[:line1]
			IO.puts "Determinant of line #{inspect line} is #{Segment.det line}"
      assert Segment.det(line) == -22
    end  
	end

	describe "Geometry Line tests" do
		test "Geometry.Line.det", context do
			path = context[:path]
			IO.puts "Determinant of 2-segment Line #{inspect path}
				is #{Line.det path}"
      assert Line.det(path) == 5
    end  

		test "Geometry.Line.angle right_triangle positive quad", context do
			right_triangle = context[:right_triangle]
			# IO.puts "Angle between 2-segment Line #{inspect right_triangle}
			#	is #{Line.angle(right_triangle)}"
      assert Line.angle(right_triangle) == 90.0
    end  
	end

	describe "Geometry Circle tests" do
		test "Geometry.Circle.circumference", context do
			circle = context[:circle]
			#IO.puts "Circumference of circle #{inspect circle} is
				#{Circle.circumference circle}"
      assert Circle.circumference(circle) == 3.141592653589793
    end  

		test "Geometry.Circle.area", context do
			circle = context[:circle]
			#IO.puts "Area of circle #{inspect circle} is
				#{Circle.area circle}"
      assert Circle.area(circle) == 0.7853981633974483
    end  
	end

	describe "Geometry Polygon tests" do
		test "Geometry.Polygon.convex", context do
			polygon = context[:polygon]
			triangle = context[:triangle]
			#IO.puts "Polygon #{inspect polygon} is convex:
				#{Polygon.convex polygon}"
			#IO.puts "Triangle #{inspect triangle} is convex:
				#{Polygon.convex triangle}"
      assert Polygon.convex(polygon) != true && Polygon.convex(triangle) == true
    end
	end

	describe "Geometry Triangle tests" do
		test "Geometry.Triangle.hypotenuse", context do
			right_triangle = context[:right_triangle]
			IO.puts "Triangle #{inspect right_triangle} hypotenuse is length:
				#{Triangle.hypotenuse right_triangle}"
      assert Triangle.hypotenuse(right_triangle) == 5.0
    end
	end
end
