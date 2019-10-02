require "math"

require "./shapes"
require "./spatialhash"


struct Collision
    property pos : Point
    property objs : Array(Shape)

    def initialize(@pos, @objs)
    end
end

def dist(a : Point, b : Point)
    xd = a.x - b.x
    yd = a.y - b.y
    Math.sqrt ((xd * xd) + (yd * yd))
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

