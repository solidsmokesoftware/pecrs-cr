require "./space"
require "./collider"
require "./body"
require "./clock"

abstract class AbsEngine
end

class Engine < AbsEngine
  property space : Space
  property objects : PairList(Int32, Body)
  property timer : Ticker
  property running : Bool
  property rate : Int64
  property time : Int64
    
  def initialize(size : Int32, rate : Int64)
    @space = Space.new size
    @rate = rate * 1_000_000_000_i64
    
    @objects = PairList(Int32, Body).new
    @timer = Ticker.new
    @running = false
    @time = 0_i64
  end

  def add(body : Body)
    @objects.add body.id, body
    @space.add body
  end

  def add(body : StaticBody)
    @space.add body
  end

  def del(body : Body)
  end

  def del(body : StaticBody)
  end

  def del(id : Int32)
  end

  def start
    @running = true
    run
  end

  def stop
    @running = false
  end

  def step(delta : Float64)
    @objects.values.size.times do |index|
      body = @objects.values[index]
      body.move(delta)
        
      #pp "#{index} = #{body.pos.x}:#{body.pos.y}"
    end
    @space.check
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
        #puts "Tick: #{i}"
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

