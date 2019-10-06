

struct Vector
    property x : Int32
    property y : Int32

    def initialize(x : Int32, y : Int32)
        @x = x
        @y = y
    end

    def +(other : Vector)
        Vector.new @x + other.x, @y + other.y
    end

    def +(scalar : Int32)
        Vector.new @x + scalar, @y + scalar
    end

    def -
        Vector.new -@x, -@y
    end

    def -(other : Vector)
        Vector.new @x - other.x, @y - other.y
    end

    def -(scalar : Int32)
        Vector.new @x - scalar, @y - scalar
    end

    def *(scalar : Int32)
        Vector.new @x * scalar, @y * scalar
    end

    def /(scalar : Int32)
        Vector.new @x // scalar, @y // scalar
    end

    def *(other : Vector)
        Vector.new @x * other.x, @y * other.y
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

    def dist_square(x : Int32, y : Int32)
        xd = @x - x
        yd = @y - y
        xd * xd + yd * yd
    end

    def dist_square(other : Vector)
        dist_square other.x, other.y
    end

    def dist(x : Int32, y : Int32)
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

    def clamp(min : Int32, max : Int32)
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

    def move(other : Vector, delta : Int32)
        distance = Vector.new other.x - @x, other.y - @y
        len = distance.mag
        ## return len <= p_delta || len < CMP_EPSILON ? p_to : v + vd / len * p_delta;
    end
end

