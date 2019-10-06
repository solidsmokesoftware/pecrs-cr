require "./shapes"
require "./vector"


class AbsBody
    property id : Int32
    property pos : Vector
    property shape : Shape

    def initialize(@id, @pos, @shape)
    end
end

class StaticBody < AbsBody
    def initialize(id : Int32, pos : Vector, shape : Shape)
        super id, pos, shape
    end
end


class Body < AbsBody
    property dir : Vector

    def initialize(id : Int32, pos : Vector, shape : Shape)
        super id, pos, shape
        @dir = Vector.new 0, 0
    end
end

