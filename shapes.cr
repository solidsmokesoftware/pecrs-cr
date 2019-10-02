

class Point
    property x : Int32
    property y : Int32
    
    def initialize(@x, @y)
    end

    def delta(a : Point, b : Point)
        Point.new(a.x - b.x, a.y - b.y)
    end
    
    def dist(a : Point, b : Point)
        dx = a.x - b.x
        dy = a.y - b.y
        Math.sqrt ((dx * dx) + (dy * dy))
    end
    
    def collide?(a : Point, b : Point)
        if a.x == b.x &&
            a.y == b.y
            true
        else
            false
        end
    end

    def collide?(o : Rect)
        if @x >= o.pos.x &&
            @x <= o.pos.x + o.w &&
            @y >= o.pos.y &&
            @y <= o.pos.y + o.h
            true
        else
            false
        end
    end

    def collide?(o : Circle)
        dx = o.pos.x - @x
        dy = o.pos.y - @y
        if dx * dx + dy + dy < o.r * o.r
            true
        else
            false
        end
    end
end


class Shape
    property pos : Point
    
    def initialize(@pos)
    end
    
    def collide?(o : Point)
    end
    
    def collide?(o : Rect)
    end

    def collide?(o : Circle)
    end
end


class Rect < Shape
    property pos : Point
    property w : Int32
    property h : Int32

    def initialize(@pos, @w, @h)
    end

    def initialize(x, y, @w, @h)
        @pos = Point.new(x, y)
    end

    def collide?(o : Point)
        if @pos.x <= o.x &&
            @pos.x + @w >= o.x &&
            @pos.y <= o.y &&
            @pos.y + @h >= o.y
            true
        else
            false
        end
    end

    def collide?(o : Rect)
        if @pos.x < o.pos.x + o.w &&
            @pos.x + @w > o.pos.x &&
            @pos.y < o.pos.y + o.h &&
            @pos.y + @h > o.pos.y
            true
        else
            false
        end
    end

    def collide?(o : Circle)
        #dx = a.pos.x - (b.pos.x).clamp()
    
        if @pos.x > o.pos.x
            x = @pos.x
        elsif @pos.x + @w < o.pos.x
            x = @pos.x + @w
        else
            x = o.pos.x
        end
    
        if @pos.y > o.pos.y
            y = @pos.y
        elsif @pos.y + @h < o.pos.y
            y = @pos.y + @h
        else
            y = o.pos.y
        end
    
        p = Point.new(x, y)
        collide? p
    end
end

class Circle < Shape
    property pos : Point
    property r : Int32

    def initialize(@pos, @r)
    end

    def initialize(x, y, @r)
        @pos = Point.new(x, y)
    end

    def collide?(o : Point)
        dx = @pos.x - o.x
        dy = @pos.y - o.y
        if dx * dx + dy + dy < @r * @r
            true
        else
            false
        end
    end

    def collide?(o : Circle)
        if ((@pos.x - o.pos.x) * (@pos.x - o.pos.x) + (@pos.y + o.pos.y) * (@pos.y - o.pos.y)).abs < (@r + o.r) * (@r + o.r)
            true
        else
            false
        end
    end

    def collide?(o : Rect)
        #dx = a.pos.x - (b.pos.x).clamp()
    
        if @pos.x < o.pos.x
            x = o.pos.x
        elsif @pos.x > o.pos.x + o.w
            x = o.pos.x + o.w
        else
            x = @pos.x
        end
    
        if @pos.y < o.pos.y
            y = o.pos.y
        elsif @pos.y > o.pos.y + o.h
            y = o.pos.y + o.h
        else
            y = @pos.y
        end
    
        p = Point.new(x, y)
        collide? p
    end
end


       
