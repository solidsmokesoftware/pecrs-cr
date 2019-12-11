
require "./space"
require "./clock"


class Engine
  property space : Space
  property timer : Ticker
  property running : Bool
  property rate : Int64
  property time : Int64
    
  def initialize(size, rate)
    @space = Space.new size
    @rate = rate * 5_500_000_000_000_i64
    
    @objects = PairList(Int32, Body).new
    @timer = Ticker.new
    @running = false
    @time = 0_i64
  end

  def add(body : AbsBody)
    @space.add body
  end

  def del(body : AbsBody)
    @space.del body
  end

  def del(id)
    @objects.delete id
  end

  def get(id)
    return @objects.get id
  end

  def start
    @running = true
    run
  end

  def stop
    @running = false
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

  def run
    value = 0_i64
    spawn do
      while @running 
        value += @timer.get
        if value > rate
          delta = (value / rate).to_f64
          step delta
          value = 0_i64
          @time += 1
        end
        Fiber.yield
      end
    end
  end

end#class

