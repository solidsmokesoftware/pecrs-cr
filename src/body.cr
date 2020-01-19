require "./shape"
require "./vector"

# The abstract base class for all bodies.
# Bodies are physical entities that can interact with other bodies in space.
class AbsBody
  property id : Int32
  property position : Vector
  property shape : Shape

  property direction : Vector
  property area : Tuple(Int32, Int32)
  property speed : Int32
  property name : String
  property key : Int32
  property moving : Bool

  def initialize(@id, @position, @shape)
    @direction = Vector.new 0, 0
    @area = {0, 0}
    @speed = 0
    @name = "absbody"
    @key = -1
    @moving = false
  end

  def initialize(@id, x, y, @shape)
    @position = Vector.new x, y
    @direction = Vector.new 0, 0
    @area = {0, 0}
    @speed = 0
    @name = "absbody"
    @key = -1
    @moving = false
  end

  # Advances a body by its *speed* in its *direction* over a duration of *delta*
  # Do NOT use this directly to move a body, use *Controller.move(body, delta)* instead to manage spatial partitioning.
  def move(delta : Float64) : Vector
    move @direction, delta
  end

  # Advances a body by its *speed* in the given *direction* over a duration of *delta*
  # Do NOT use this directly to move a body, use *Controller.move(body, delta)* instead to manage spatial partitioning.
  def move(direction : Vector, delta : Float64) : Vector
    step = @speed * delta
    xstep = direction.x * step
    ystep = direction.y * step
    distance = Vector.new xstep, ystep
    @position = @position + distance
    return distance
  end

  # Directly set a body at a given *position*
  # Do NOT use this directly to move a body, use *Controller.place(body, position)* instead.
  def place(position : Vector)
    @position = position
  end
end # class

# A body used for processing and collisions. Extend Body for entities that move and think
class Body < AbsBody
  def initialize(id, position, shape)
    super id, position, shape
  end
end # class

# A body used for collisions that does not move often or require additional processing.
class StaticBody < AbsBody
  def initialize(id, position, shape)
    super id, position, shape
  end
end # class
