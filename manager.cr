require "./space"
require "./index"



class Manager
  property index : Index
  property factory : Hash(Int32, AbsBody.class)
  property list : Hash(Int32, AbsBody) #All objects in the space
  property actives : Array(Body)
  property space : Space

  property cursor : Body
  property updates : Array(String)
  
  def initialize(size)
    @index = Index.new
    @factory = Hash(Int32, AbsBody.class).new
    @list = Hash(Int32, AbsBody).new
    @actives = Array(Body).new
    @space = Space.new size

    @pointer = Rect.new 1, 1
  end

  def add(body : AbsBody) 
    @list[body.id] = body
    body.zone = @space.pos_to_zone body.position.x, body.position.y
    @space.add body, body.zone
    if body.is_a? Body
      @actives << body
    end
    @updates << body.add_info
    on_add body
  end

  def on_add(body : AbsBody)
    return #callback
  end

  def make(type, id, position)
    body = @factory[type].new id, position
    add body
    on_make body
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

  def on_make(body : AbsBody)
    return #callback
  end

  def delete(body)
    puts("Objects: Deleting body")
    @list.delete body
    @space delete body, body.zone
    if body.is_a? Body
      @actives.delete body
    end
    @updates << body.delete_info
    on_delete body
  end

  def on_delete(body : AbsBody)
    return #Callback
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
    on_move body, delta
  end

  def move(body : AbsBody, direction : Vector, delta)
    body.move direction, delta
    update_zone body
    on_move body, delta
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
    on_move body, delta
  end

  def on_move(body : AbsBody, delta)
    return #callback
  end

  def get(pos : Vector) 
    #TODO think about returning an array instead to catch multiple objects at the same position instead of the first
    #TODO Sounds like a good idea
    zone = @space.pos_to_zone pos
    bucket = @space.get zone
    for body in bucket:
      if @space.collider.check @pointer, pos, body.shape, body.position
        return body
      end
    end
    return nil
  end

  def get(x, y)
    pos = Vector.new x, y
    return get pos
  end

  def get(id : Int32)
    if @list.has_key? id
      return @list[id]
    else
      return nil
    end
  end
end