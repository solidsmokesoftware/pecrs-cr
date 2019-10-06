require "./space"
require "./colliders"
require "./body"

require "./clock"

abstract class AbsEngine
end

class Engine
    property clock : Clock
    property running : Bool
    property objects : PairList(Int32, Body)
    
    def initialize(rate : Int64)
        @clock = Clock.new rate
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

    def run(space : Space, collider : Collider)
        spawn do
            while @running
                if clock.tick
                    puts "tick #{clock.value}"
                    @objects.values.each do |mover|
                        mover.pos = mover.pos + (mover.dir * clock.value.to_i)
                        puts "#{mover.id}: #{mover.pos.x}:#{mover.pos.y}"
                    end

                    pp collider.check space
                end

                Fiber.yield
            end
        end
    end
end