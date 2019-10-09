require "./body"

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