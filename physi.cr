require "./spaces"

struct Collision
    property pos : Point
    property objs : Array(Shape)

    def initialize(@pos, @objs)
    end
end



