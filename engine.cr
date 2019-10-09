require "./space"
require "./collision"
require "./body"

require "./fasttime"

abstract class AbsEngine
end

class Engine < AbsEngine
    property time : Int64
    property timer : FastTime
    property rate : Float32
    property running : Bool
    property objects : PairList(Int32, Body)
    
    def initialize(rate : Float32)
        @time = 0_i64
        @timer = FastTime.new
        @rate = rate * 10_000
        @running = false
        @objects = PairList(Int32, Body).new
    end

    def add(body : Body)
        @objects.add body.id, body
    end

    def start(space : Space, collider : Collider)
        @running = true
        run space, collider
    end

    def stop
        @running = false
    end

    def step(delta : Float32)
        @objects.values.size.times do |index|
            body = @objects.values[index]
            body.move(delta)
            #pp "#{index} = #{body.pos.x}:#{body.pos.y}"
        end
    end

    def run(space : Space, collider : Collider, n : Int32)
        timer = @timer
        rate = @rate
        value = 0_i64
        
        n.times do |i|
            value += timer.get
            if value > rate
                step (value / rate).to_f32
                collider.check space
                value = 0_i64
            end
        end
    end

    def run(space : Space, collider : Collider)
        timer = @timer
        rate = @rate
        value = 0_i64

        spawn do
            while @running
                value += timer.get
                if value > rate
                    step (value / rate).to_f32
                    collider.check space
                    value = 0_i64
                end
                Fiber.yield
            end
        end
    end

end