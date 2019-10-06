require "./shapes"
require "./vector"


class Body
    property id : Int32
    property pos : Vector
    property shape : Shape

    def initialize(@id, @pos, @shape)
    end
end


class Mobile < Body
    property dir : Vector

    def initialize(id : Int32, pos : Vector, shape : Shape)
        super id, pos, shape
        @dir = Vector.new 0, 0
    end
end

