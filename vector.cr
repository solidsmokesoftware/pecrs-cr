

struct Vector
    property x : Float32
    property y : Float32

    def initialize(x : Float32, y : Float32)
        @x = x
        @y = y
    end

    def +(other : Vector)
        Vector.new @x + other.x, @y + other.y
    end

    def +(scalar : Float32)
        Vector.new @x + scalar, @y + scalar
    end

    def -
        Vector.new -@x, -@y
    end

    def -(other : Vector)
        Vector.new @x - other.x, @y - other.y
    end

    def -(scalar : Float32)
        Vector.new @x - scalar, @y - scalar
    end

    def *(scalar : Float32)
        Vector.new @x * scalar, @y * scalar
    end

    def /(scalar : Float32)
        Vector.new @x // scalar, @y // scalar
    end

    def *(other : Vector)
        Vector.new @x * other.x, @y * other.y
    end

    def <=>(other : Vector)
        if @x <=> other.x && @y <=> other.y
            true
        else
            false
        end
    end

    def ==(other : Vector)
        if @x == other.x && @y == other.y
            true
        else
            false
        end
    end

    def !=(other : Vector)
        if @x != other.x && @y != other.y
            true
        else
            false
        end
    end

    def dot(other : Vector)
        @x * other.x + @y + other.y
    end

    def cross(other : Vector)
        @x * other.y - @y * other.x
    end

    def mag_square
        @x * @x + @y * @y
    end

    def mag
        Math.sqrt mag_square
    end 

    def angle
        Math.atan2 @x, @y
    end

    def normal
        len = mag_square
        if len != 0
            len = Math.sqrt len
            Vector.new x // len, y // len
        else
            Vector.new 0, 0
        end
    end

    def dist_square(x : Float32, y : Float32)
        xd = @x - x
        yd = @y - y
        xd * xd + yd * yd
    end

    def dist_square(other : Vector)
        dist_square other.x, other.y
    end

    def dist(x : Float32, y : Float32)
        Math.sqrt dist_square(x, y)
    end

    def dist(other : Vector)
        dist other.x, other.y
    end

    def angle(other : Vector)
        Math.atan2 cross(other), dot(other)
    end

    def anglepoint(other : Vector)
        Math.atan2 @y - other.y, @x - other.x
    end

    def abs
        Vector.new abs(@x), abs(@y)
    end

    def project(other : Vector)
        other * (dot(other) / other.mag_square)
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

        Vector.new x, y
    end

    def move(other : Vector, delta : Float64)
        x = @x + other.x * delta
        y = @y + other.y * delta
        Vector.new x, y
        ## return len <= p_delta || len < CMP_EPSILON ? p_to : v + vd / len * p_delta;
    end
end


class VectorC
    property x : Float32
    property y : Float32

    def initialize(x : Float32, y : Float32)
        @x = x
        @y = y
    end

    def +(other : Vector)
        @x += other.x
        @y += other.y
    end

    def +(scalar : Float32)
        @x += scalar
        @y += scalar
    end

    def -
        @x = -@x
        @y = -@y
    end

    def -(other : Vector)
        @x -= other.x
        @y -= other.y
    end

    def -(scalar : Float32)
        @x -= scalar
        @y -= scalar
    end

    def *(scalar : Float32)
        @x *= scalar
        @y *= scalar
    end

    def /(scalar : Float32)
        @x // scalar
        @y // scalar
    end

    def *(other : Vector)
        @x *= other.x
        @y *= other.y
    end

    def ==(other : Vector)
        if @x == other.x && @y == other.y
            true
        else
            false
        end
    end

    def !=(other : Vector)
        if @x != other.x && @y != other.y
            true
        else
            false
        end
    end

    def dot(other : Vector)
        @x * other.x + @y + other.y
    end

    def cross(other : Vector)
        @x * other.y - @y * other.x
    end

    def mag_square
        @x * @x + @y * @y
    end

    def mag
        Math.sqrt mag_square
    end 

    def angle
        Math.atan2 @x, @y
    end

    def normal
        len = mag_square
        if len != 0
            len = Math.sqrt len
            Vector.new x // len, y // len
        else
            Vector.new 0, 0
        end
    end

    def dist_square(x : Float32, y : Float32)
        xd = @x - x
        yd = @y - y
        xd * xd + yd * yd
    end

    def dist_square(other : Vector)
        dist_square other.x, other.y
    end

    def dist(x : Float32, y : Float32)
        Math.sqrt dist_square(x, y)
    end

    def dist(other : Vector)
        dist other.x, other.y
    end

    def angle(other : Vector)
        Math.atan2 cross(other), dot(other)
    end

    def anglepoint(other : Vector)
        Math.atan2 @y - other.y, @x - other.x
    end

    def abs
        @x = abs(@x)
        @y = abs(@y)
    end

    def project(other : Vector)
        other * (dot(other) / other.mag_square)
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

        @x = x
        @y = y
    end

    def move(dir : Vector, delta : Float64)
      @x += dir.x * delta
      @y += dir.y * delta
   end

  def move(dir : Vector)
    @x += dir.x
    @y += dir.y
  end
end

