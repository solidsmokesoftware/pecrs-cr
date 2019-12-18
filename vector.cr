

struct Vector
  property x : Float32
  property y : Float32

  def initialize(x : Float32, y : Float32)
    @x = x
    @y = y
  end

  def initialize(x : Int32, y : Int32)
    @x = x.to_f32
    @y = y.to_f32
  end

  def +(other : Vector)
    return Vector.new @x + other.x, @y + other.y
  end

  def +(scalar : Float32)
    return Vector.new @x + scalar, @y + scalar
  end

  def -
    return Vector.new -@x, -@y
  end

  def -(other : Vector)
    return Vector.new @x - other.x, @y - other.y
  end

  def -(scalar : Float32)
    return Vector.new @x - scalar, @y - scalar
  end

  def *(scalar : Float32)
    return Vector.new @x * scalar, @y * scalar
  end

  def /(scalar : Float32)
    return Vector.new @x // scalar, @y // scalar
  end

  def *(other : Vector)
    return Vector.new @x * other.x, @y * other.y
  end

  def <=>(other : Vector)
    if @x <=> other.x && @y <=> other.y
      return true
    else
      return false
    end
  end

  def ==(other : Vector)
    if @x == other.x && @y == other.y
      return true
    else
      return false
    end
  end

  def !=(other : Vector)
    if @x != other.x && @y != other.y
      return true
    else
      return false
    end
  end

  def dot(other : Vector)
    return @x * other.x + @y * other.y
  end

  def cross(other : Vector)
    return @x * other.y - @y * other.x
  end

  def mag_square
    return @x * @x + @y * @y
  end

  def mag
    return Math.sqrt mag_square
  end 

  def angle
    return Math.atan2 @x, @y
  end

  def normal
    len = mag_square
    if len != 0
      len = Math.sqrt len
      return Vector.new @x // len, @y // len
    else
      return Vector.new 0, 0
    end
  end

  def dist_square(x : Float32, y : Float32)
    xd = @x - x
    yd = @y - y
    return xd * xd + yd * yd
  end

  def dist_square(other : Vector)
    return dist_square other.x, other.y
  end

  def dist(x : Float32, y : Float32)
    return Math.sqrt dist_square(x, y)
  end

  def dist(other : Vector)
    return dist other.x, other.y
  end

  def angle(other : Vector)
    return Math.atan2 cross(other), dot(other)
  end

  def anglepoint(other : Vector)
    return Math.atan2 @y - other.y, @x - other.x
  end

  def abs
    return Vector.new abs(@x), abs(@y)
  end

  def project(other : Vector)
    return other * (dot(other) / other.mag_square)
  end

  def clamp(min : Float32, max : Float32)
    if @x < min
      x = min
    elsif @x > max
      x = max
    else
      x = @x
    end

    if @y < min
      y = min
    elsif @y > max
      y = max
    else
      y = @x
    end

    return Vector.new x, y
  end

  def move(other : Vector, delta : Float64)
    x = @x + other.x * delta
    y = @y + other.y * delta
    return Vector.new x, y
    ## return len <= p_delta || len < CMP_EPSILON ? p_to : v + vd / len * p_delta;
  end

  def to_s : String
    return "#{@x.to_i}:#{@y.to_i}"
  end
end

