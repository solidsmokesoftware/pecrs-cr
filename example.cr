require "benchmark"
require "./physi"

# 400 > 800 for these sizes

esmall = Engine.new 1600, 8
ebig = Engine.new 1600, 8

r = Random.new

dynamic = 0
static = 0
1_000.times do |i|
    rxp = r.rand 100_00
    ryp = r.rand 100_00
    rxd = (r.rand 20) - 10
    ryd = (r.rand 20) - 10
    s = Rect.new 200, 200
    p = Vector.new rxp.to_f32, ryp.to_f32
    
    if i % 2 == 0
        dynamic += 1
        d = Vector.new rxd.to_f32, ryd.to_f32
        b = Body.new(i, p, s)
        b.dir = d
        esmall.add b
    else
        static += 1
        b = StaticBody.new(i, p, s)
        esmall.add b
    end
   end

puts "Mobile bodies: #{dynamic}"
puts "Static bodies: #{static}"

1_000.times do |i|
    rxp = r.rand 100_000_000
    ryp = r.rand 100_000_000
    rxd = (r.rand 20) - 10
    ryd = (r.rand 20) - 10
    s = Rect.new 200, 200
    p = Vector.new rxp.to_f32, ryp.to_f32
    d = Vector.new rxd.to_f32, ryd.to_f32
    b = Body.new(i, p, s)
    b.dir = d
    ebig.add b
end

puts "Starting tests"

# start = Time.monotonic
# n = 1000

# esmall.run n

# fin = Time.monotonic
# puts "Total: #{(fin - start) / n}"

Benchmark.ips do |bm|
    bm.report "Static/Dynamic world test" {esmall.run 100 }
    bm.report "Dynamic world test" {ebig.run 100 }
end
