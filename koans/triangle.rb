# Triangle Project Code.

# Triangle analyzes the lengths of the sides of a triangle
# (represented by a, b and c) and returns the type of triangle.
#
# It returns:
#   :equilateral  if all sides are equal
#   :isosceles    if exactly 2 sides are equal
#   :scalene      if no sides are equal
#
# The tests for this method can be found in
#   about_triangle_project.rb
# and
#   about_triangle_project_2.rb
#
def triangle(a, b, c)
    # WRITE THIS CODE
    valid = false
    if((a+b) > c && (b+c) > a && (a+c) > b)
      # Check all the sides, return true if all conditions are met.
      valid = true
    end
    if(valid)
      if(a==b && a==c)
        :equilateral
      elsif(a == b || b == c || a == c )
        :isosceles
      elsif(a != b && b != c && c != a)
        :scalene
      else
        raise TriangleError
      end
    elsif(a == 0 && b == 0 && c == 0)
        raise TriangleError, "Zero values encountered"
    elsif(a <= 0 && b <= 0 && c <= 0)
      raise TriangleError, "Negative values Encountered"
    else
      raise TriangleError
    end
end

# Error class used in part 2.  No need to change this code.
class TriangleError < StandardError
end
