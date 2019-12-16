

#Base shape that all shapes inherit from
abstract struct Shape
end#class


#Single point in space
struct Point < Shape
end#class


#AABB Rectangle
struct Rect < Shape
  property w : Int32
  property h : Int32

  def initialize(@w, @h)
  end
end#class


#Circle
struct Circle < Shape
  property r : Int32

  def initialize(@r)
  end
end#class

