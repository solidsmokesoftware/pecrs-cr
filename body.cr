require "./shape"
require "./vector"


class AbsBody
  property id : Int32
  property shape : Shape
  property position : Vector
  property direction : Vector
  property area : Tuple(Int32, Int32)
  property collision : Bool

  def initialize(@id, @position, @shape)
    @direction = Vector.new 0.0, 0.0
    @area = {0, 0}
    @collision = false
  end

  def check(other : AbsBody)
    @shape.check @position, other.shape, other.position
  end

  def collide(other : AbsBody)
    puts "AbsBody: #{@id} Collision with #{other.id}"
    @collision = true
  end

  def move(direction : Vector, delta : Float64)
  end

  def move(delta : Float64)
  end

  def relocate(area : {Int32, Int32})
    @area = area
  end

end#class


class StaticBody < AbsBody
  def initialize(id : Int32, position : Vector, shape : Shape)
    super id, position, shape
  end

  def collide(other : AbsBody)
    puts "StaticBody: #{@id} Collision with #{other.id}"
    @collision = true
  end

end#class
  
  
class Body < AbsBody
  def initialize(id : Int32, position : Vector, shape : Shape)
    super id, position, shape
  end

  def collide(other : AbsBody)
    puts "Body: #{@id} Collision with #{other.id}"
    @direction = Vector.new 0.0, 0.0
  end

  #Faster than move(direction, delta)
  def move(delta : Float64)
    @position = @position.move @direction, delta
  end
 
  def move(direction : Vector, delta : Float64)
    print "moving #{direction.x}:#{direction.y} x#{delta}"
    pp @position
    @position = @position.move direction, delta
    pp @position
  end

end#class

class Actor < Body
  def initialize(id : Int32, position : Vector, shape : Shape)
    super id, position, shape
  end

  def collide(other : AbsBody)
    puts "Actor: #{@id} Collision with #{other.id}"
    @direction = Vector.new 0.0, 0.0
  end

end#class


