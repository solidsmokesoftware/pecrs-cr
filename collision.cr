require "./body"
require "./shapes"
require "./space"

struct Collision
    property value : {Body, Body}

    def initialize(@value)
    end

    def initialize(a : Body, b : Body)
        @value = {a, b}
    end

    def to_s
        "#{a.id}:#{b.id}"
    end
end

abstract class Collider
end

abstract class NarrowCollider < Collider
end

abstract class BroadCollider < Collider
end

class ListCollider < BroadCollider
    property collider : LocalCollider

    def initialize
        @collider = LocalCollider.new
    end

    def check(space : OpenSpace)
        collisions = Array({Int32, Int32}).new
        len = space.objects.values.size
        len.times do |index|
            body = space.objects.values[index]
            (len - index).times do |other_offset|
                index_other = other_offset + index
                if index != index_other
                    if @collider.check body, space.objects.values[index_other]
                        collisions << {index, index_other}
                    end
                end          
            end
        end
        collisions
    end
end


class GridCollider < BroadCollider
    property collider : LocalCollider

    def initialize
        @collider = LocalCollider.new
    end

    def check(space : GridSpace)
        collisions = Array(Collision).new
        space.objects.values.each do |body|
            space.get(body.pos.x, body.pos.y, 1).each do |other|
                if body.id != other.id
                    if @collider.check body, other
                        collisions << Collision.new body, other
                        body.collision other
                    end
                end
            end
        end
        collisions
    end

end


class LocalCollider < NarrowCollider
    def dist(x1 : Int32, y1 : Int32, x2 : Int32, y2 : Int32)
        dx = x1 - x2
        dy = y1 - y2
        Math.sqrt ((dx * dx) + (dy * dy))
    end

    def dist(x1 : Float32, y1 : Float32, x2 : Float32, y2 : Float32)
        dx = x1 - x2
        dy = y1 - y2
        Math.sqrt ((dx * dx) + (dy * dy))
    end

    def dist(s : Vector, o : Vector)
        dist s.x, s.y, o.x, o.y
    end

    def dist(s : AbsBody, o : AbsBody)
        dist s.pos.x, s.pos.y, o.pos.x, o.pos.y
    end

    def check(s : AbsBody, o : AbsBody)
        check s.shape, s.pos, o.shape, o.pos
    end

    def check(s1 : Point, p1 : Vector, s2 : Point, p2 : Vector)
        if p1.x == p2.x && p1.y == p2.y
            true
        else
            false
        end
    end

    def check(s1 : Point, p1 : Vector, s2 : Rect, p2 : Vector)
        if p1.x > p2.x &&
            p1.x < p2.x + s2.w &&
            p1.y > p2.y &&
            p1.y < p2.y + s2.h
            true
        else
            false
        end
    end

    def check(s1 : Point, p1 : Vector, s2 : Circle, p2 : Vector)
        dx = p1.x - p2.x
        dy = p1.y - p2.y
        if dx * dx + dy * dy < s2.r * s2.r
            true
        else
            false
        end
    end

    def check(s1 : Rect, p1 : Vector, s2 : Point, p2 : Vector)
        check s2, p2, s1, p1
    end

    def check(s1 : Rect, p1 : Vector, s2 : Rect, p2 : Vector)
        if p1.x < p2.x + s2.w &&
            p1.x + s1.w > p2.x &&
            p1.y < p2.y + s2.h &&
            p1.y + s1.h > p2.y
            true
        else
            false
        end
    end

    def check(s1 : Rect, p1 : Vector, s2 : Circle, p2 : Vector)
        if p1.x > p2.x
            x = p1.x + s1.w
        elsif p1.x < p2.x
            x = p1.x
        else
            x = p2.x
        end
        
        if p1.y > p2.y
            y = p1.y + s1.h
        elsif p1.y < p2.x
            y = p1.y
        else
            y = p2.y
        end

        dx = p1.x - p2.x
        dy = p1.y - p2.y
        if dx * dx + dy * dy < s2.r * s2.r
            true
        else
            false
        end
    end

    def check(s1 : Circle, p1 : Vector, s2 : Point, p2 : Vector)
        check s2, p2, s1, p2
    end

    def check(s1 : Circle, p1 : Vector, s2 : Rect, p2 : Vector)
        check s2, p2, s1, p1
    end

    def check(s1 : Circle, p1 : Vector, s2 : Circle, p2 : Vector)
        dx = p1.x - p2.x
        dy = p1.y - p2.y
        rs = s1.r + s2.r
        if dx * dx + dy * dy < rs * rs
            true
        else
            false
        end
    end
end

