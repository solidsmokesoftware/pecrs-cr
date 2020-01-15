
require "./body"
require "./collider"
require "./spatialhash"

class Space
  # Space handles the interactions between the SpatialHash and the Collider.
  # size is how large each collision area is. You'll have to figure out the best value for your game based on object density
  # and desired preformance.
  property grid : SpatialHash(AbsBody) #spatilhash that is the world space
  property collider : Collider
  
  def initialize(size : Int32)
    @grid = SpatialHash(AbsBody).new size
    @collider = Collider.new
  end

  def pos_to_zone(pos : Vector) : Tuple(Int32, Int32)
    #Returns a tuple(scaled x, scaled y) describing the collision area covered at x, y
    return { (pos.x.to_i32 // @grid.size), (pos.y.to_i32 // @grid.size) }
  end

  def pos_to_zone(x : Float32, y : Float32) : Tuple(Int32, Int32)
    #Returns a tuple(scaled x, scaled y) describing the collision area covered at x, y
    return { (x.to_i32 // @grid.size), (y.to_i32 // @grid.size) }
  end

  def pos_to_zone(x : Int32, y : Int32) : Tuple(Int32, Int32)
    #Returns a tuple(scaled x, scaled y) describing the collision area covered at x, y
    return { (x // @grid.size), (y // @grid.size) }
  end

  def has(body : AbsBody)
    #Returns True if a body is in the space at the body's zone. False if not
    #Note there room for bugs here if body.zone is not matched up propertly with the right collision area.
    #Use Manager to move and place bodies to avoid problems
    if body in @grid.grid[body.zone]
      return true
    else
      return false
    end
  end

  def get(zone : Tuple(Int32, Int32))
    return @grid.get zone
  end

  def get(position : Vector, shape : Shape)
    #Returns a list of bodies that colliding with shape at position in the space.
    zone = pos_to_zone(position)
    collisions = []
    bucket = @grid.get zone
    bucket.each do |body|
      if @collider.check shape, position, body.shape, body.position
        collisions << body
      end
    end
    return collisions
  end

  def get(body : Body)
    #Returns a list of bodies colliding with body
    collisions = []
    @grid.get(body.zone).each do |other|
      if body.id != other.id
        if check body, other
          collisions << other
        end
      end
    end
    return collisions
  end

  def check(body : AbsBody) : Bool
    #Returns True if something is colliding with body in the space.
    @grid.get(body.zone).each do |other|
      if body.id != other.id
        if check body, other
          return true
        end
      end
    end
    return false
  end

  def check(body : AbsBody, other : AbsBody) : Bool
    #Returns True if two bodies are colliding with each other in abstract. Does not use the space.
    if @collider.check body.shape, body.position, other.shape, other.position
      return true
    else
      return false
    end
  end

  def add(body : AbsBody, zone : Tuple(Int32, Int32))
    #Adds a body to the space.
    #Bodies are added to their collision area as well as the 8 nearest neighboring cells to handle overlap and fast moving obejcts.
    #zones are a Tuple of scaled x, and y, obtained from pos_to_zone(x, y)
    x_zone = zone[0]
    y_zone = zone[1]

    @grid.add(body, {x_zone-1, y_zone-1})
    @grid.add(body, {x_zone, y_zone-1})
    @grid.add(body, {x_zone+1, y_zone-1})
    @grid.add(body, {x_zone-1, y_zone})
    @grid.add(body, {x_zone, y_zone})
    @grid.add(body, {x_zone+1, y_zone})
    @grid.add(body, {x_zone-1, y_zone+1})
    @grid.add(body, {x_zone, y_zone+1})
    @grid.add(body, {x_zone+1, y_zone+1})
  end

  def delete(body : AbsBody, zone : Tuple(Int32, Int32))
    #Removes a body from the space.
    #zones are a Tuple of scaled x, and y, obtained from pos_to_zone(x, y)
    x_zone = zone[0]
    y_zone = zone[1]

    @grid.delete(body, {x_zone-1, y_zone-1})
    @grid.delete(body, {x_zone, y_zone-1})
    @grid.delete(body, {x_zone+1, y_zone-1})
    @grid.delete(body, {x_zone-1, y_zone})
    @grid.delete(body, {x_zone, y_zone})
    @grid.delete(body, {x_zone+1, y_zone})
    @grid.delete(body, {x_zone-1, y_zone+1})
    @grid.delete(body, {x_zone, y_zone+1})
    @grid.delete(body, {x_zone+1, y_zone+1})
  end

  def move(body : AbsBody, dir : Vector)
      #Moves a body. This will be move efficent than place
      #Not implemented yet.
  end

  def place(body : AbsBody, zone : {Int32, Int32})
    #Moves a body from one collision area to another
    delete body, body.zone
    body.zone = zone
    add body, zone
  end

end#class 
