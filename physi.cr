require "math"

require "./shapes"
require "./spatialhash"


struct Collision
    property pos : Point
    property objs : Array(Shape)

    def initialize(@pos, @objs)
    end
end

class Collider
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
    
    def collide?(a : Rect, b : Point)
        if a.pos.x <= b.x &&
            a.pos.x + a.w >= b.x &&
            a.pos.y <= b.y &&
            a.pos.y + a.h >= b.y
            true
        else
            false
        end
    end       
    
    def collide?(a : Point, b : Rect)
        collide? b, a
    end
    
    def collide?(a : Circle, b : Point)
        dx = a.pos.x - b.x
        dy = a.pos.y - b.y
        if dx * dx + dy + dy < a.r * a.r
            true
        else
            false
        end
    end
    
    def collide?(a : Point, b : Circle)
        collide b, a
    end
    
    def collide?(a : Rect, b : Rect)
        if a.pos.x < b.pos.x + b.w &&
            a.pos.x + a.w > b.pos.x &&
            a.pos.y < b.pos.y + b.h &&
            a.pos.y + a.h > b.pos.y
            true
        else
            false
        end
    end
    
    def collide?(a : Circle, b : Circle)
        if ((a.pos.x - b.pos.x) * (a.pos.x - b.pos.x) + (a.pos.y + b.pos.y) * (a.pos.y - b.pos.y)).abs < (a.r + b.r) * (a.r + b.r)
            true
        else
            false
        end
    end
    
    def collide?(a : Circle, b : Rect)
        #dx = a.pos.x - (b.pos.x).clamp()
    
        if a.pos.x < b.pos.x
            x = b.pos.x
        elsif a.pos.x > b.pos.x + b.w
            x = b.pos.x + b.w
        else
            x = a.pos.x
        end
    
        if a.pos.y < b.pos.y
            y = b.pos.y
        elsif a.pos.y > b.pos.y + b.h
            y = b.pos.y + b.h
        else
            y = a.pos.y
        end
    
        p = Point.new(x, y)
        collide? a, p
    end
    
    def collide?(a : Rect, b : Circle)
        collide? b, a
    end
end