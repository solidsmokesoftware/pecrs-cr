require "./world"
require "./colliders"

struct Collision
    property pos : Point
    property objs : Array(Shape)

    def initialize(@pos, @objs)
    end
end



