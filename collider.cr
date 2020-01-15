require "./shape"
require "./vector"


class Collider
  #Collider handles collisions two shapes at two given positions. Positions are Vectors
  #Note that the collider is abstract, dealing with any set of shapes and positions, rather than in-game physical bodies.
  #Use check(shape, pos, shape_other, pos_other) to see if there would be a collision at a position when you don't know what
  #shapes are being used in the collision. Otherwise use the specific collider methods such as rect_rect(shape, pos, shape_other, pos_other)
  #For the purposes of this collider, Rects are AABBs (Axis-Aligned Bounding Boxes).

  #Point-Point distance from collision
  def dist(shape : Point, pos : Vector, shape_other : Point, pos_other : Vector)
    return pos.dist pos_other
  end

  #Point-Rect distance from collision
  def dist(shape : Rect, pos : Vector, shape_other : Rect, pos_other : Vector) : Vector
    if pos.x > pos_other.x
      xd = pos_other.x + shape_other.w - pos.x
    else
      xd = pos.x + shape.w - pos_other.x
    end
    if pos.y > pos_other.y
      yd = pos_other.y + shape_other.h - pos.y
    else
      yd = pos.y + shape.h - pos_other.y
    end
    return Vector.new xd, yd
  end

  def dist(shape : Rect, pos : Vector, shape_other : Circle, pos_other : Vector) : Vector
    #TODO fix this circles are being handles as if they were square
    if pos.x > pos_other.x
      xd = pos_other.x + shape_other.r - pos.x
    else
      xd = pos.x + shape.w - pos_other.x
    end
    if pos.y > pos_other.y
      yd = pos_other.y + shape_other.r - pos.y
    else
      yd = pos.y + shape.h - pos_other.y
    end
    return Vector.new xd, yd
  end

  def dist(shape : Circle, pos : Vector, shape_other : Rect, pos_other : Vector) : Vector
    return dist shape_other, pos_other, shape, pos
  end

  def dist(shape : Circle, pos : Vector, shape_other : Circle, pos_other : Vector) : Vector
    #TODO fix this circles are being handled like a rect
    if pos.x > pos_other.x
      xd = pos_other.x + shape_other.r - pos.x
    else
      xd = pos.x + shape.r - pos_other.x
    end
    if pos.y > pos_other.y
      yd = pos_other.y + shape_other.r - pos.y
    else
      yd = pos.y + shape.r - pos_other.y
    end
    return Vector.new xd, yd
  end    

  #Point-Point collision
  def check(shape : Point, pos : Vector, shape_other : Point, pos_other : Vector) : Bool
    if pos.x == pos_other.x && pos.y == pos_other.y
      return true
    else
      return false
    end
  end
  
  #Point-Rect collision
  def check(shape : Point, pos : Vector, shape_other : Rect, pos_other : Vector) : Bool
    if pos.x > pos_other.x &&
      pos.x < pos_other.x + shape_other.w &&
      pos.y > pos_other.y &&
      pos.y < pos_other.y + shape_other.h
      return true
    else
      return false
    end
  end

  #Point-Circle collision
  def check(shape : Point, pos : Vector, shape_other : Circle, pos_other : Vector) : Bool
    dx = pos.x - pos_other.x
    dy = pos.y - pos_other.y
    if dx * dx + dy * dy < shape_other.r * shape_other.r
      return true
    else
      return false
    end
  end

  #Rect-Point collision
  def check(shape : Rect, pos : Vector, shape_other : Point, pos_other : Vector) : Bool
    return check shape_other, pos_other, shape, pos
  end

  #Rect-Rect collision
  def check(shape : Rect, pos : Vector, shape_other : Rect, pos_other : Vector) : Bool
    if pos.x < pos_other.x + shape_other.w &&
      pos.x + shape.w > pos_other.x &&
      pos.y < pos_other.y + shape_other.h &&
      pos.y + shape.h > pos_other.y
      #puts "Collider: Collision at #{pos.x}:#{pos.y}"
      return true
    else
      #puts "Collider: No Collision at #{pos.x}:#{pos.y}"
      return false
    end
  end

  #Rect-Circle collision
  def check(shape : Rect, pos : Vector, shape_other : Circle, pos_other : Vector) : Bool
    #Clamp x
    if pos_other.x < pos.x
      x = pos.x
    elsif pos_other.x > pos.x + shape.w
      x = pos.x + shape.w
    else
      x = pos_other.x
    end

    #Clamp y
    if pos_other.y < pos.y
      y = pos.y
    elsif pos_other.y > pos.y + shape.h
      y = pos.y + shape.h
    else
      y = pos_other.y
    end

    dx = x - pos_other.x
    dy = y - pos_other.y
    if dx * dx + dy * dy < shape_other.r * shape_other.r
      #puts "Shape: Collision at #{pos.x}:#{pos.y}"
      return true
    else
      #puts "Shape: No collision at #{pos.x}:#{pos.y}"
      return false
    end
  end

  #Circle-Point collision
  def check(shape : Circle, pos : Vector, shape_other : Point, pos_other : Vector) : Bool
    return check shape_other, pos_other, shape, pos
  end

  #Circle-Rect collision
  def check(shape : Circle, pos : Vector, shape_other : Rect, pos_other : Vector) : Bool
    return check shape_other, pos_other, shape, pos
  end

  #Circle-Circle collision
  def check(shape : Circle, pos : Vector, shape_other : Circle, pos_other : Vector) : Bool
    dx = pos.x - pos_other.x
    dy = pos.y - pos_other.y
    rs = shape.r + shape_other.r
    if dx * dx + dy * dy < rs * rs
      return true
    else
      return false
    end
  end

end#class
