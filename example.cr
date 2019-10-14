require "benchmark"
require "./physi"

# 400 > 800 for these sizes

esmall = Engine.new 200, 16
ebig = Engine.new 1600, 16

r = Random.new

dynamic = 0
static = 0
10_000.times do |i|
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

10_000.times do |i|
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

# start = Time.monotonic
puts "Starting tests"

# esmall.run 10

# fin = Time.monotonic
# puts "Total: #{fin - start}"

Benchmark.ips do |bm|
    bm.report "Static/Dynamic world test" {esmall.run 100 }
    bm.report "Dynamic world test" {ebig.run 100 }
end
