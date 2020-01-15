

# Shapes are simple data structures that describe the physical properties of an object to the Collider.
# Note that shapes do not have a position, thus all bodies with the same shape can use the same Shape instance


#Base shape that all shapes inherit from
abstract struct Shape
end#class


#Single point in space
struct Point < Shape
end#class


#AABB Rectangle
#Width and height, extending up and right from the bottom-left corner.
struct Rect < Shape
  property w : Int32
  property h : Int32

  def initialize(@w, @h)
  end
end#class


#Circle
#radius, extending from the center of the circle
struct Circle < Shape
  property r : Int32

  def initialize(@r)
  end
end#class

