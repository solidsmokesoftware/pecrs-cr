require "benchmark"

require "./physi"

# 400 > 800 for these sizes

bw1 = BigWorld.new 400
bw2 = BigWorld.new 400

sw1 = SimpleWorld.new
sw2 = SimpleWorld.new

r = Random.new

10.times do |i|
    rxp = r.rand 100_00
    ryp = r.rand 100_00
    rxd = (r.rand 20) - 10
    ryd = (r.rand 20) - 10
    s = Rect.new 200, 200
    p = Vector.new rxp.to_f32, ryp.to_f32
    d = Vector.new rxd.to_f32, ryd.to_f32
    b = Body.new(i, p, s)
    b.dir = d

    p1 = Vector.new rxp.to_f32, ryp.to_f32
    d1 = Vector.new rxd.to_f32, ryd.to_f32
    b1 = Body.new(i, p1, s)
    b1.dir = d1
    
    bw1.add b
    sw1.add b1
end

100.times do |i|
    rxp = r.rand 100_00
    ryp = r.rand 100_00
    rxd = (r.rand 20) - 10
    ryd = (r.rand 20) - 10
    s = Rect.new 200, 200
    p = Vector.new rxp.to_f32, ryp.to_f32
    d = Vector.new rxd.to_f32, ryd.to_f32
    b = Body.new(i, p, s)
    b.dir = d

    p1 = Vector.new rxp.to_f32, ryp.to_f32
    d1 = Vector.new rxd.to_f32, ryd.to_f32
    b1 = Body.new(i, p1, s)
    b1.dir = d1
    
    bw2.add b
    sw2.add b1
end


puts "Starting tests"

Benchmark.ips do |bm|
    bm.report "Grid test Rx10" {bw1.run 1000 }
    bm.report "Grid test Rx100" {bw2.run 1000 }
    bm.report "List test Rx10" {sw1.run 1000 }
    bm.report "List test Rx100" {sw2.run 1000 }
end
