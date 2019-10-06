

abstract class Shape
end


class Point < Shape
end


class Rect < Shape
    property w : Int32
    property h : Int32

    def initialize(@w, @h)
    end
end


class Circle < Shape
    property r : Int32

    def initialize(@r)
    end
end

