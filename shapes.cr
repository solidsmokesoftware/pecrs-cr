

abstract struct Shape
end


struct Point < Shape
    property x : Int32
    property y : Int32
    
    def initialize(@x, @y)
    end
end


struct Rect < Shape
    property pos : Point
    property w : Int32
    property h : Int32

    def initialize(@pos, @w, @h)
    end

    def initialize(x, y, @w, @h)
        @pos = Point.new(x, y)
    end
end

struct Circle < Shape
    property pos : Point
    property r : Int32

    def initialize(@pos, @r)
    end

    def initialize(x, y, @r)
        @pos = Point.new(x, y)
    end
end

