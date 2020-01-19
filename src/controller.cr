require "./space"
require "./index"

# High-level manager of the physics system
class Controller
  property index : Index
  property factory : Hash(Int32, AbsBody.class)
  property list : Hash(Int32, AbsBody) # All objects in the space
  property actives : Array(Body)
  property space : Space

  property pointer : Rect

  def initialize(size)
    @index = Index.new
    @factory = Hash(Int32, AbsBody.class).new
    @list = Hash(Int32, AbsBody).new
    @actives = Array(Body).new
    @space = Space.new size

    @pointer = Rect.new 1, 1
  end

  # Produces a body of type from the factory at position x, y
  # If an id is not assigned during make, one will be generated. This is needed for syncing objects across clients and server
  # After a body is made, it is automatically added to the system.
  def make(type : AbsBody.class, id, position, direction = Vector.new(0, 0))
    body = type.new id, position
    body.direction = direction
    on_make body
    add body
    return body
  end

  def make(type : AbsBody.class, position)
    id = @index.get
    return make type, id, position
  end

  def make(key, position)
    type = @factory[key]
    id = @index.get
    return make type, id, position
  end

  def make(key, id, position)
    type = @factory[key]
    return make type, id, position
  end

  # Callback whenever bodies are made by the system
  def on_make(body : AbsBody)
  end

  # Adds a body to the system.
  # All bodies are tracked by id in list
  # All bodies are tracked by area in space
  # Bodies(Not StaticBodies) are added to a list of active bodies
  def add(body : AbsBody)
    @list[body.id] = body
    body.area = @space.pos_to_area body.position.x, body.position.y
    @space.add body, body.area
    if body.is_a? Body
      @actives << body
    end
    on_add body
  end

  # Callback whenever bodies are added to the system
  def on_add(body : AbsBody)
  end

  # Removes a body from the system.
  # Whatever the body was added to on add is cleaned up here.
  def delete(body)
    @list.delete body
    @space.delete body, body.area
    if body.is_a? Body
      @actives.delete body
    end
    on_delete body
  end

  # Callback whenever bodies are removed from the system
  def on_delete(body : AbsBody)
  end

  # Updates which collision area a body is in
  def update_area(body : AbsBody)
    area = @space.pos_to_area body.position.x, body.position.y
    if area != body.area
      @space.delete body, body.area
      @space.add body, area # TODO add a move area for optimization
      body.area = area
      on_area body
    end
  end

  # Callback whenever bodies have their area changed by the system
  def on_area(body : AbsBody)
  end

  # Move a body by it's speed and direction for delta duration.
  # Use this instead of body.move(delta) to keep track of collision area
  def move(body : AbsBody, delta)
    body.move delta
    update_area body
    on_move body
    on_motion body
  end

  # Move a body by it's speed in the direction of x, y for delta duration.
  # Use this instead of body.move(x, y, delta) to keep track of collision area
  def move(body : AbsBody, direction : Vector, delta)
    body.move direction, delta
    update_area body
    on_move body
    on_motion body
  end

  def move(body : AbsBody, x, y, delta)
    direction = Vector.new x, y
    move body, direction, delta
  end

  # Callback whenever bodies are moved by the system
  def on_move(body : AbsBody, distance : Vector)
  end

  # Directly place a body at x, y
  # Use this instead of body.place(x, y) to keep track of collision area
  def place(body : AbsBody, x, y)
    position = Vector.new x, y
    place body, position
  end

  def place(body : AbsBody, position : Vector)
    body.position = position
    update_area body
    on_place body
    on_motion body
  end

  # Callback whenever bodies are placed by the system
  def on_place(body : AbsBody)
  end

  # Callback whenever bodies have thier position changed by the system
  def on_motion(body : AbsBody)
  end

  def turn(body : AbsBody, x, y)
    turn body, Vector.new(x, y)
  end

  def turn(body : AbsBody, direction : Vector)
    body.direction = direction
    on_turn body
  end

  # Callback for when a body changes direction
  def on_turn(body : AbsBody)
  end

  # Tells a body to move when the system is processed.
  def moving(body : AbsBody)
    body.moving = true
    on_moving body
  end

  # Callback for when a body starts moving
  def on_moving(body : AbsBody)
  end

  # Tells a body to not move when the system is proccessed.
  def stop(body : AbsBody)
    body.moving = false
    on_stop body
  end

  # Callback for when a body stops moving
  def on_stop(body : AbsBody)
  end

  # Gets a body in the space at x, y
  # Uses a 1x1 pointer rect to test for collisions.
  def find(pos : Vector)
    area = @space.pos_to_area pos
    @space.get(area).each do |other|
      if @space.collider.check @pointer, pos, other.shape, other.position
        return body
      end
    end
    return nil
  end

  def find(x, y)
    pos = Vector.new x, y
    return find pos
  end

  def get(id : Int32)
    # Gets an body by its id
    if @list.has_key? id
      return @list[id]
    else
      return nil
    end
  end

  # Advances the simulation by delta steps
  def step(delta)
    on_step_start delta
    @actives.each do |body|
      on_step body, delta
      if body.moving
        move body, delta
      end
    end

    # TODO This is very unoptimized
    @actives.each do |body|
      if body.moving
        if self.space.check body
          on_collision body
        end
      end
    end
    on_step_end delta
  end

  # Callback before the simulation takes a step. Override this when extending your Controller
  def on_step_start(delta)
  end

  # Callback when the simulation takes a step over a body. Override this when extending your Controller
  def on_step(body : AbsBody, delta)
  end

  # Callback whenever bodies collide with another body
  def on_collision(body : AbsBody, collisions : Array(AbsBody))
  end

  # Callback after the simulation takes a step. Override this when extending your Controller
  def on_step_end(delta)
  end
end
