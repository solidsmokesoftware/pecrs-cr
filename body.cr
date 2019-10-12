require "./shapes"
require "./vector"


class AbsBody
  property id : Int32
  property shape : Shape
  property pos : Vector
  property area : Tuple(Int32, Int32)

  def initialize(@id, @pos, @shape)
    @area = {0, 0}
  end

  def collision(other : AbsBody)
  end

  def move(dir : Vector, delta : Float64)
  end

  def move(delta : Float64)
  end

  def set(area : {Int32, Int32})
    @area = area
  end

end#class


class StaticBody < AbsBody
  def initialize(id : Int32, pos : Vector, shape : Shape)
    super id, pos, shape
  end
end#class
  
  
class Body < AbsBody
  property dir : Vector
  
  def initialize(id : Int32, pos : Vector, shape : Shape)
    super id, pos, shape
    @dir = Vector.new 0.0, 0.0
  end

  def collision(other : AbsBody)
    @dir = Vector.new 0.0, 0.0
  end

  #Faster than move(dir, delta)
  def move(delta : Float64)
    @pos.move @dir, delta
  end
 
  def move(dir : Vector, delta : Float64)
    @pos.move dir, delta
  end

end#class



