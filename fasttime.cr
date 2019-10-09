
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


class FastTime
    
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
                   #0_i64
                else
                    ticks.tv_nsec
                end
            end
        {% end %}
    {% end %}
end


