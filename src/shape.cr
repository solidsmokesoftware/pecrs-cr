# Abstract Base Shape that other shapes extend from.
# Shapes are simple data structures that describe the physical properties of an body to a Collider.
# Note that shapes do not have a position, thus all bodies with the same shape can use the same Shape instance
abstract struct Shape
end # class

# A Rectangle
# Treated as a Axis-Aligned Bounding Boxes by the Collider.
struct Rect < Shape
  property w : Int32
  property h : Int32

  def initialize(@w, @h)
  end
end # class

# A Circle
# Radius, extending from the center of the circle
struct Circle < Shape
  property r : Int32

  def initialize(@r)
  end
end # class
