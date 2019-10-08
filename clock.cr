require "./fasttime"


class Clock
    property timer : FastTime
    property rate : Int64
    property value : Int64
    property result : Float32

    def initialize(rate : Float32)
        @timer = FastTime.new
        @rate = (1_000_000_000_000 * rate).to_i64
        @value = 0_i64
        @result = 0_f32
    end

    def tick : Float32
        @value += timer.get
        if @value > @rate
            @result = (@value / @rate).to_f32
            @value = 0_i64
            @result
        else
            0_f32
        end
    end
end

