

class Clock
    property rate : Time::Span
    property value : Int64
    property last : Time::Span

    def initialize(rate : Int64)
        #@rate = Time::Span.new(nanoseconds: rate * 10000000)
        @rate = Time::Span.new(0, 0, 1) #For testing

        @value = 0
        @last = Time.monotonic
    end

    def tick
        results = false
        current_time = Time.monotonic()
        if current_time - @last > @rate
            results = true
            @last = current_time
            @value += 1
        end

        results
    end
end