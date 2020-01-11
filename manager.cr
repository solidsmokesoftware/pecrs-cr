require "./space"
require "./index"



class Manager
  property index : Index
  property factory : Hash(Int32, AbsBody.class)
  property list : Hash(Int32, AbsBody) #All objects in the space
  property actives : Array(Body)
  property space : Space

  property updates : Array(String)
  
  def initialize(size)
    @index = Index.new
    @factory = Hash(Int32, AbsBody.class).new
    @list = Hash(Int32, AbsBody).new
    @actives = Array(Body).new
    @space = Space.new size

    @updates = Array(String).new
  end

  def update : Array(String)
    updates = @updates
    @updates = Array(String).new
    return updates
  end

  def add(body) 
    @list[body.id] = body
    body.zone = @space.pos_to_zone body.position.x, body.position.y
    @space.add body, body.zone
    if body.is_a? Body
      @actives << body
    end
    @updates << body.add_info
  end

  def make(type, id, position)
    body = @factory[type].new id, position
    add body
    return body
  end

  def make(type, position)
    id = @index.get
    return make type, id, position
  end
  
  def make(type, id, x, y)
    position = Vector.new x, y
    return make type, id, position
  end

  def make(type, x, y)
    position = Vector.new x, y
    return make type, position
  end

  def delete(body)
    puts("Objects: Deleting body")
    @list.delete body
    @space delete body, body.zone
    if body.is_a? Body
      @actives.delete body
    end
    @updates << body.delete_info
  end

  def update_zone(body : AbsBody)
    zone = @space.pos_to_zone body.position.x, body.position.y
    if zone != body.zone
      @space.delete body, body.zone
      @space.add body, zone #TODO add a move zone for optimization
      body.zone = zone
    end
  end

  def move(body : AbsBody, delta)
    body.move delta
    update_zone body
    @updates << body.pos_info
  end

  def move(body : AbsBody, direction : Vector, delta)
    body.move direction, delta
    update_zone body
    @updates << body.pos_info
  end

  def move(body : AbsBody, x, y, delta)
    direction = Vector.new x, y
    move body, direction, delta
  end

  def place(body : AbsBody, x, y)
    position = Vector.new x, y
    place body, position
  end

  def place(body : AbsBody, position : Vector)
    body.position = position
    update_zone body
    @updates << body.pos_info
  end

  def get(id : Int32)
    if @list.has_key? id
      return @list[id]
    else
      return nil
    end
  end
end