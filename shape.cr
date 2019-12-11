

#Base shape that all shapes inherit from
abstract struct Shape
  abstract def check(pos : Vector, shape_other : Point, pos_other : Vector)
  abstract def check(pos : Vector, shape_other : Rect, pos_other : Vector)
  abstract def check(pos : Vector, shape_other : Circle, pos_other : Vector)
end#class


#Single point in space
struct Point < Shape
  #Point-Point collision
  def check(pos : Vector, shape_other : Point, pos_other : Vector)
    if pos.x == pos_other.x && pos.y == pos_other.y
      true
    else
      false
    end
  end
  
  #Point-Rect collision
  def check(pos : Vector, shape_other : Rect, pos_other : Vector)
    if pos.x > pos_other.x &&
      pos.x < pos_other.x + shape_other.w &&
      pos.y > pos_other.y &&
      pos.y < pos_other.y + shape_other.h
      true
    else
      false
    end
  end

  #Point-Circle collision
  def check(pos : Vector, shape_other : Circle, pos_other : Vector)
    dx = pos.x - pos_other.x
    dy = pos.y - pos_other.y
    if dx * dx + dy * dy < shape_other.r * shape_other.r
      true
    else
      false
    end
  end

end#class


#Line
# struct Line < Shape
#   property x : Int32
#   property y : Int32

#   def initialize(@x, @y)
#   end
# end#class

#AABB Rectangle
struct Rect < Shape
  property w : Int32
  property h : Int32

  def initialize(@w, @h)
  end

  #Rect-Point collision
  def check(pos : Vector, shape_other : Point, pos_other : Vector)
    if pos_other.x > pos.x &&
      pos_other.x < pos.x + @w &&
      pos_other.y > pos.y &&
      pos_other.y < pos.y + @h
      puts "Shape: Collision at #{pos.x}:#{pos.y}"
      return true
    else
      return false
    end
  end

  #Rect-Rect collision
  def check(pos : Vector, shape_other : Rect, pos_other : Vector)
    if pos.x < pos_other.x + shape_other.w &&
      pos.x + @w > pos_other.x &&
      pos.y < pos_other.y + shape_other.h &&
      pos.y + @h > pos_other.y
      puts "Shape: Collision at #{pos.x}:#{pos.y}"
      return true
    else
      #puts "Shape: No Collision at #{pos.x}:#{pos.y}"
      return false
    end
  end

  #Rect-Circle collision
  def check(pos : Vector, shape_other : Circle, pos_other : Vector)
    if pos.x > pos_other.x
      x = pos.x + @w
    elsif pos.x < pos_other.x
      x = pos.x
    else
      x = pos_other.x
    end
        
    if pos.y > pos_other.y
      y = pos.y + @h
    elsif pos.y < pos_other.x
      y = pos.y
    else
      y = pos_other.y
    end

    dx = pos.x - pos_other.x
    dy = pos.y - pos_other.y
    if dx * dx + dy * dy < shape_other.r * shape_other.r
      puts "Shape: Collision at #{pos.x}:#{pos.y}"
      return true
    else
      #puts "Shape: No collision at #{pos.x}:#{pos.y}"
      return false
    end
  end

end#class


#Unaligned Rect
# struct URect < Shape
#   property w : Int32
#   property h : Int32

#   def initialize(@w, @h)
#   end
# end#class


#Circle
struct Circle < Shape
  property r : Int32

  def initialize(@r)
  end

  #Circle-Point collision
  def check(pos : Vector, shape_other : Point, pos_other : Vector)
    dx = pos.x - pos_other.x
    dy = pos.y - pos_other.y
    if dx * dx + dy * dy < @r * @r
      true
    else
      false
    end
  end

  #Circle-Rect collision
  def check(pos : Vector, shape_other : Rect, pos_other : Vector)
    if pos_other.x > pos.x
      x = pos_other.x + shape_other.w
    elsif pos_other.x < pos.x
      x = pos_other.x
    else
      x = pos.x
    end
        
    if pos_other.y > pos.y
      y = pos_other.y + shape_other.h
    elsif pos_other.y < pos.x
      y = pos_other.y
    else
      y = pos.y
    end

    dx = pos.x - pos_other.x
    dy = pos.y - pos_other.y
    if dx * dx + dy * dy < @r * @r
      true
    else
      false
    end
  end

  #Circle-Circle collision
  def check(pos : Vector, shape_other : Circle, pos_other : Vector)
    dx = pos.x - pos_other.x
    dy = pos.y - pos_other.y
    rs = @r + shape_other.r
    if dx * dx + dy * dy < rs * rs
      true
    else
      false
    end
  end

end#class

