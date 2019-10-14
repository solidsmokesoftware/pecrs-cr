

#Base shape that all shapes inherit from
abstract struct Shape
end


#Single point in space
struct Point < Shape
end


#Straight line
struct Line < Shape
  property x : Int32
  property y : Int32

  def initialize(@x, @y)
  end
end


#Unaligned line
struct ULine < Shape
  property x : Int32
  property y : Int32

  def initialize(@x, @y)
  end
end


#AABB Rectangle
struct Rect < Shape
  property w : Int32
  property h : Int32

  def initialize(@w, @h)
  end
end


#Unaligned Rect
struct URect < Shape
  property w : Int32
  property h : Int32

  def initialize(@w, @h)
  end
end


#Circle
struct Circle < Shape
  property r : Int32

  def initialize(@r)
  end
end

