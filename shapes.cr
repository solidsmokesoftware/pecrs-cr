

class Position
    property x : Int32
    property y : Int32

    def initialize(@x, @y)
    end
end


abstract class Shape
    abstract def dist(x : Int32, y : Int32)
    abstract def dist(o : Position)
    abstract def dist(o : Shape)
    abstract def collide?(x : Int32, y : Int32)
    abstract def collide?(o : Position)
    abstract def collide?(o : Point)
    abstract def collide?(o : Rect)
    abstract def collide?(o : Circle)
end


class Point < Shape
    property pos : Position

    def initialize(x, y)
        @pos = Position.new x, y
    end

    def initialize(@pos)
    end

    def dist(x : Int32, y : Int32)
        dx = @pos.x - x
        dy = @pos.y - y
        Math.sqrt ((dx * dx) + (dy * dy))
    end

    def dist(o : Position)
        dist o.x, o.y
    end

    def dist(o : Shape)
        dist o.pos.x, o.pos.y
    end

    def collide?(x : Int32, y : Int32)
        if @pos.x == x &&
            @pos.y == y
            true
        else
            false
        end
    end

    def collide?(o : Position)
        collide? o.x, o.y
    end
    
    def collide?(o : Point)
        collide? o.pos.x, o.pos.y
    end

    def collide?(o : Rect)
        if @pos.x > o.pos.x &&
            @pos.x < o.pos.x + o.w &&
            @pos.y > o.pos.y &&
            @pos.y < o.pos.y + o.h
            true
        else
            false
        end
    end

    def collide?(o : Circle)
        dx = @pos.x - o.pos.x
        dy = @pos.x - o.pos.y
        if dx * dx + dy * dy < o.r * o.r
            true
        else
            false
        end
    end
end


class Rect < Shape
    property pos : Position
    property w : Int32
    property h : Int32

    def initialize(@pos, @w, @h)
    end

    def initialize(x, y, @w, @h)
        @pos = Position.new(x, y)
    end

    def dist(x : Int32, y : Int32)
        dx = @pos.x - x
        dy = @pos.y - y
        Math.sqrt (dx * dx + dy * dy)
    end

    def dist(o : Position)
        dist o.x, o.y
    end

    def dist(o : Shape)
        dist o.pos.x, o.pos.y
    end

    def dist(o : Shape)
        dx = @pos.x - o.pos.x
        dy = @pos.y - o.pos.y
        Math.sqrt (dx * dx + dy * dy)
    end

    def collide?(x : Int32, y : Int32)
        if @pos.x < x &&
            @pos.x + @w > x &&
            @pos.y < y &&
            @pos.y + @h > y
            true
        else
            false
        end
    end

    def collide?(o : Position)
        collide? o.x, o.y
    end

    def collide?(o : Point)
        collide? o.pos.x, o.pos.y
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
            x = @pos.x + @w
        elsif @pos.x < o.pos.x
            x = @pos.x
        else
            x = o.pos.x
        end
        
        if @pos.y > o.pos.y
            y = @pos.y + @h
        elsif @pos.y < o.pos.x
            y = @pos.y
        else
            y = o.pos.y
        end

        dx = @pos.x - o.pos.x
        dy = @pos.y - o.pos.y
        if dx * dx + dy * dy < o.r * o.r
            true
        else
            false
        end
    end
end

class Circle < Shape
    property pos : Position
    property r : Int32

    def initialize(@pos, @r)
    end

    def initialize(x, y, @r)
        @pos = Position.new x, y
    end

    def dist(x : Int32,  y : Int32)
        dx = @pos.x - x
        dy = @pos.y - y
        Math.sqrt (dx * dx + dy * dy)
    end

    def dist(o : Shape)
        dist o.pos.x, o.pos.y
    end

    def dist(o : Position)
        dist o.x, o.y
    end

    def collide?(x : Int32, y : Int32)
        dx = @pos.x - x
        dy = @pos.y - y
        if dx * dx + dy * dy < @r * @r
            true
        else
            false
        end
    end

    def collide?(o : Position)
        dx = @pos.x - o.x
        dy = @pos.y - o.y
        collide? dx, dy
    end

    def collide?(o : Point)
        dx = @pos.x - o.pos.x
        dy = @pos.y - o.pos.y
        collide? dx, dy
    end

    def collide?(o : Circle)
        dx = @pos.x - o.pos.x
        dy = @pos.y - o.pos.y
        rs = @r + o.r
        if dx * dx + dy * dy < rs * rs
            true
        else
            false
        end
    end

    def collide?(o : Rect)
        #dx = a.pos.x - (b.pos.x).clamp()
        
        if o.pos.x > @pos.x
            x = o.pos.x + o.w
        elsif o.pos.x < @pos.x
            x = o.pos.x
        else
            x = @pos.x
        end
        
        if o.pos.y > @pos.y
            y = o.pos.y + o.h
        elsif o.pos.y < @pos.x
            y = o.pos.y
        else
            y = @pos.y
        end
    
        dx = o.pos.x - @pos.x
        dy = o.pos.y - @pos.y
        collide? dx, dy
    end
end

