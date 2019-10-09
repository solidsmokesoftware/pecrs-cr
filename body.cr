require "./shapes"
require "./vector"


class AbsBody
    property id : Int32
    property shape : Shape
    property pos : Vector

    def initialize(@id, @pos, @shape)
    end

    def collision(other : AbsBody)
    end

    def move(dir : Vector, delta : Float32)
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
        @dir = Vector.new 0.0, 0.0
    end

    def collision(other : Body)
        @dir = Vector.new 0.0, 0.0
    end

    #Faster than move(dir, delta)
    def move(delta : Float32)
        @pos.move @dir, delta
    end

    def move(dir : Vector, delta : Float32)
        @pos.move dir, delta
    end
end
