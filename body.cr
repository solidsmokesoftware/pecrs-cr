require "./shape"
require "./vector"


class AbsBody
  property id : Int32
  property position : Vector
  property shape : Shape
  
  property direction : Vector
  property zone : Tuple(Int32, Int32)
  property speed : Int32
  property name : String

  def initialize(@id, @position, @shape)
    @direction = Vector.new 0.0, 0.0
    @zone = {0, 0}
    @speed = 0
    @name = "absbody"
  end

  def initialize(@id, x, y, @shape)
    @position = Vector.new x, y
    @direction = Vector.new 0.0, 0.0
    @zone = {0, 0}
    @collision = false
    @speed = 0
    @name = "absbody"
  end

  def collide(other : AbsBody)
    #Callback
  end

  def move(delta : Float64)
    @position = @position.move @direction, delta
  end
 
  def move(direction : Vector, delta : Float64)
    @position = @position.move direction, delta
  end

  def add_com : String
    return "#{@id}/#{@position.x.to_i}/#{@position.y.to_i}/#{@name}"
  end

  def delete_com : String
    return "#{id}"
  end

  def pos_com : String
    return "#{@id}/#{@position.x.to_i}/#{@position.y.to_i}"
  end
end#class


class Static < AbsBody
  def initialize(id, position, shape)
    super id, position, shape
  end
end#class
  
  
class Body < AbsBody
  def initialize(id, position, shape)
    super id, position, shape
  end
end#class

