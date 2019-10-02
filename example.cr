
require "./physi"


a = Rect.new(10, 10, 2, 2)
b = Rect.new(15, 15, 2, 2)
c = Rect.new(11, 11, 2, 2)
d = Rect.new(10, 20, 1, 1)

puts "Rect Collision test"
puts "A:B = #{collide? a, b}"
puts "A:C = #{collide? a, c}"
puts "A:D = #{collide? a, d}"

x = Circle.new(10, 10, 2)
y = Circle.new(12, 11, 2)
z = Circle.new(16, 10, 2)

puts "Circle Collision test"
puts "X:Y #{collide? x, y}"
puts "X:Z #{collide? x, z}"

puts "Dist test"
puts "A:D = #{dist a.pos, d.pos}"
puts "X:Y = #{dist x.pos, y.pos}"
puts "X:Z = #{dist x.pos, z.pos}"
