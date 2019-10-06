require "benchmark"

require "./physi"

# 400 > 800 for these sizes

b1 = BigWorld.new 400
b2 = BigWorld.new 400
b3 = BigWorld.new 400

s1 = SimpleWorld.new
s2 = SimpleWorld.new
s3 = SimpleWorld.new

r = Random.new

10.times do |i|
    rx = r.rand 100_00
    ry = r.rand 100_00
    s = Rect.new 200, 200
    p = Vector.new rx, ry
    b = Body.new(i, p, s)
    
    b1.add i, b
    s1.add i, b
end

100.times do |i|
    rx = r.rand 100_00
    ry = r.rand 100_00
    s = Rect.new 200, 200
    p = Vector.new rx, ry
    b = Body.new(i, p, s)
    
    b2.add i, b
    s2.add i, b
end


1000.times do |i|
    rx = r.rand 100_00
    ry = r.rand 100_00
    s = Rect.new 200, 200
    p = Vector.new rx, ry
    b = Body.new(i, p, s)
    
    b3.add i, b
    s3.add i, b
end


def col_grid_test(s : World)
    2.times do |o|
        s.check
    end
end


def col_list_test(s : World)
    2.times do |o|
        s.check
    end
end

puts "Starting tests"

Benchmark.ips do |bm|
    bm.report "Grid test Rx10" {col_grid_test b1 }
    bm.report "Grid test Rx100" {col_grid_test b2 }
    bm.report "Grid test Rx1000" {col_grid_test b3 }
    bm.report "List test Rx10" {col_list_test s1 }
    bm.report "List test Rx100" {col_list_test s2 }
    bm.report "List test Rx1000" {col_list_test s3 }
end
