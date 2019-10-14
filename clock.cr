
{% if flag?(:win32) %}
  require "c/winbase"
  require "winerror"

{% else %}
  require "c/sys/time"
  require "c/time"
  
  {% if flag?(:darwin) %}
    require "c/mach/mach_time"
  {% end %}
{% end %}


class Ticker    
  
  {% if flag?(:win32) %}
    def get : Int64
      if LibC.QueryPerformanceCounter(out ticks) == 0
        raise WinError.new("QueryPerformanceCounter")
      end
        #Not sure if this is right
        ticks
      end
        
  {% else %}
    {% if flag?(:darwin) %}
      def get : Int64
        info = mach_timebase_info
        ticks = LibC.mach_absolute_time * info.numer // info.denom
        ticks
      end

      private def mach_timebase_info
        @@mach_timebase_info ||= begin
          LibC.mach_timebase_info(out info)
          info
        end
      end
        
    {% else %}
      def get : Int64
        if LibC.clock_gettime(LibC::CLOCK_MONOTONIC, out ticks) == 1
          raise Errno.new("clock_gettime(CLOCK_MONOTONIC)")
        else
          ticks.tv_nsec
        end
      end
    {% end %}
  {% end %}

end#class


class Clock
  property ticker : Ticker
  property rate : Int64
  property value : Int64
  property time : Int64
  
  def initialize(rate : Int64)
    @ticker = Ticker.new
    @rate = rate * 1_000_000_000_i64
    @value = 0_i64
    @time = 0_i64
  end

  def tick : Int64
    value = @ticker.get
    @value += value
    if @value > @rate
      @value = 0_i64
      @time += 1
    end
    value
  end
  
  def tick? : Bool
    @value += @ticker.get
    if @value > @rate
      @value = 0_i64
      @time += 1
      true
    else
      false
    end
  end
  
  def delta : Float64
    @value += @ticker.get
    if @value > @rate
      delta = (@value / @rate).to_f64
      value = 0_i64
      @time += 1
      delta
    else
      0_f64
    end
  end

end#class