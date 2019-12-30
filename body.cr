require "./shape"
require "./vector"


class AbsBody
  property id : Int32
  property shape : Shape
  property position : Vector
  property direction : Vector
  property zone : Tuple(Int32, Int32)
  property collision : Bool

  def initialize(@id, @shape, @position)
    @direction = Vector.new 0.0, 0.0
    @zone = {0, 0}
    @collision = false
  end

  def collide(other : AbsBody)
    #puts "AbsBody: #{@id} Collision with #{other.id}"
    @collision = true
  end

  def move(direction : Vector, delta : Float64)
  end

  def move(delta : Float64)
  end

  def to_s : String
    return "#{@id}/#{@position.x}/#{@position.y}"
  end

end#class


class StaticBody < AbsBody
  def initialize(id : Int32, shape : Shape, position : Vector)
    super id, shape, position
  end

  def collide(other : AbsBody)
    #puts "StaticBody: #{@id} Collision with #{other.id}"
    @collision = true
  end

end#class
  
  
class Body < AbsBody
  def initialize(id : Int32, shape : Shape, position : Vector)
    super id, shape, position
  end

  def collide(other : AbsBody)
    #puts "Body: #{@id} Collision with #{other.id}"
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



