require "./shape"
require "./vector"

# Bodies are physical entities with a unique id, a position in Space, and a shape.
# Bodies are able to collide with other bodies by using the Collider

# Important note: move(delta), move_to(x, y, delta), and place(x, y) are NOT meant to be used directly.
# Instead use the respective functions from your Manager, such as move(body, delta)
# This is because bodies don't handle what area of the search space they're in.
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
    #Callback that gives you the other body on collisions
  end

  def move(delta : Float64)
    #Advances a body by its speed in its directions over a duration of delta
    #Do NOT use this directly to move a body, use Manager.move(body, delta) instead.
    @position = @position.move @direction, delta
  end
 
  def move(direction : Vector, delta : Float64)
    #Advances a body by its speed in the direction x, y over a duration of delta
    #Do NOT use this directly to move a body, use Manager.move_to(body, x, y, delta) instead
    @position = @position.move direction, delta
  end

  def place(position : Vector)
    #Directly places a body at x, y
    #Do NOT use this directly to move a body, use Manager.place(body, x, y) instead.
    @position = position
  end
end#class


class StaticBody < AbsBody
  #StaticBodies are not regularally processed. Extend StaticBody for entities that won't be moving or thinking
  def initialize(id, position, shape)
    super id, position, shape
  end
end#class
  
  
class Body < AbsBody
  #Bodies are kept in a list for active processing. Extend Body for entities that move and think
  def initialize(id, position, shape)
    super id, position, shape
  end
end#class

