require "./space"
require "./collision"
require "./body"

require "./fasttime"

abstract class AbsEngine
end

class Engine < AbsEngine
  property space : Space
  property collider : SpaceCollider
  property objects : PairList(Int32, Body)
  property timer : FastTime
  property running : Bool
  property rate : Int64
  property time : Int64
    
  def initialize(space : Space, collider : SpaceCollider, rate : Int64)
    @space = space
    @collider = collider
    @rate = rate * 1_000_000_000_i64
    
    @objects = PairList(Int32, Body).new
    @timer = FastTime.new
    @running = false
    @time = 0_i64
  end

  def add(body : Body)
    @objects.add body.id, body
  end

  def start
    @running = true
    run space, collider
  end

  def stop
    @running = false
  end

  def step(delta : Float64)
    @objects.values.size.times do |index|
      body = @objects.values[index]
      body.move(delta)
        
      pp "#{index} = #{body.pos.x}:#{body.pos.y}"
    end
    @collider.check @space #This should be either two calls or two actions
  end

  def test(delta : Float64)
  end

  def run(n : Int32)
    value = 0_i64
    i = 0

    while i < n 
      value += @timer.get
      if value > rate
        delta = (value / rate).to_f64
        step delta
        value = 0_i64
        i += 1
      end
    end
  end

  def test(n : Int32)
    value = 0_i64
    i = 0

    while i < n 
      value += @timer.get
      if value > rate
        delta = (value / rate).to_f64
        test delta
        value = 0_i64
        i += 1
      end
    end
  end

  def run
    value = 0_i64
    spawn do
      while @running 
        value += @timer.get
        if value > rate
          delta = (value / rate).to_f64
          test delta
          value = 0_i64
          @time += 1
        end
        Fiber.yield
      end
    end
  end

end#class

