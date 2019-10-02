
require "./physi"


a = Rect.new(10, 10, 2, 2)
b = Rect.new(15, 15, 2, 2)
c = Rect.new(11, 11, 2, 2)
d = Rect.new(10, 20, 1, 1)

x = Circle.new(10, 10, 2)
y = Circle.new(12, 11, 2)
z = Circle.new(16, 10, 2)

col = Collider.new

puts "Rect Collision test"
puts "A:B = #{col.collide? a, b}"
puts "A:C = #{col.collide? a, c}"
puts "A:D = #{col.collide? a, d}"

puts "Circle Collision test"
puts "X:Y #{col.collide? x, y}"
puts "X:Z #{col.collide? x, z}"

puts "Dist test"
puts "A:D = #{col.dist a.pos, d.pos}"
puts "X:Y = #{col.dist x.pos, y.pos}"
puts "X:Z = #{col.dist x.pos, z.pos}"

puts "Circle-Rect Collision test"
puts "A:X = #{col.collide? a, x}"
puts "C:Y = #{col.collide? c, y}"
puts "A:Z = #{col.collide? a, z}"

puts "Object Collision tests"
puts "A:B = #{a.collide? b}"
puts "A:C = #{a.collide? c}"
puts "A:D = #{a.collide? d}"

puts "X:Y #{x.collide? y}"
puts "X:Z #{x.collide? z}"

puts "A:X = #{a.collide? x}"
puts "C:Y = #{c.collide? y}"
puts "Z:A = #{z.collide? a}"