require "./shape"
require "./vector"


class Collider
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
