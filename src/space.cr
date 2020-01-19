require "./body"
require "./collider"
require "./spatialhash"

# Space handles the interactions between the SpatialHash and the Collider.
# size is how large each collision area is. You'll have to figure out the best value for your game based on object density
# and desired preformance.
class Space
  property grid : SpatialHash(AbsBody) # spatilhash that is the world space
  property collider : Collider

  def initialize(size : Int32)
    @grid = SpatialHash(AbsBody).new size
    @collider = Collider.new
  end

  # Adds a body to the space.
  # Bodies are added to their collision area as well as the 8 nearest neighboring cells to handle overlap and fast moving obejcts.
  # areas are a Tuple of scaled x, and y, obtained from pos_to_area(x, y)
  def add(body : AbsBody, area : Tuple(Int32, Int32))
    x_area = area[0]
    y_area = area[1]

    @grid.add(body, {x_area - 1, y_area - 1})
    @grid.add(body, {x_area, y_area - 1})
    @grid.add(body, {x_area + 1, y_area - 1})
    @grid.add(body, {x_area - 1, y_area})
    @grid.add(body, {x_area, y_area})
    @grid.add(body, {x_area + 1, y_area})
    @grid.add(body, {x_area - 1, y_area + 1})
    @grid.add(body, {x_area, y_area + 1})
    @grid.add(body, {x_area + 1, y_area + 1})
  end

  # Removes a body from the space.
  # areas are a Tuple of scaled x, and y, obtained from pos_to_area(x, y)
  def delete(body : AbsBody, area : Tuple(Int32, Int32))
    x_area = area[0]
    y_area = area[1]

    @grid.delete(body, {x_area - 1, y_area - 1})
    @grid.delete(body, {x_area, y_area - 1})
    @grid.delete(body, {x_area + 1, y_area - 1})
    @grid.delete(body, {x_area - 1, y_area})
    @grid.delete(body, {x_area, y_area})
    @grid.delete(body, {x_area + 1, y_area})
    @grid.delete(body, {x_area - 1, y_area + 1})
    @grid.delete(body, {x_area, y_area + 1})
    @grid.delete(body, {x_area + 1, y_area + 1})
  end

  # Returns True if a body is in the space at the body's area. False if not
  # Note there room for bugs here if body.area is not matched up propertly with the right collision area.
  # Use Manager to move and place bodies to avoid problems
  def has(body : AbsBody)
    if body in @grid.grid[body.area]
      return true
    else
      return false
    end
  end

  def get(area : Tuple(Int32, Int32))
    return @grid.get area
  end

  # Gets a list of all bodies colliding with shape at position
  def get(position : Vector, shape : Shape) : Array(AbsBody)
    # Returns a list of bodies that colliding with shape at position in the space.
    area = pos_to_area(position)
    collisions = Array(AbsBody).new
    bucket = @grid.get area
    bucket.each do |body|
      if @collider.check shape, position, body.shape, body.position
        collisions << body
      end
    end
    return collisions
  end

  # Get a list of all bodies colliding with body
  def get(body : Body) : Array(AbsBody)
    # Returns a list of bodies colliding with body
    collisions = Array(AbsBody).new
    @grid.get(body.area).each do |other|
      if body.id != other.id
        if check body, other
          collisions << other
        end
      end
    end
    return collisions
  end

  # Check to see if something is colliding with body in the space.
  def check(body : AbsBody) : Bool
    @grid.get(body.area).each do |other|
      if body.id != other.id
        if check body, other
          return true
        end
      end
    end
    return false
  end

  # Check to see if two bodies are colliding with each other in abstract. Does not use the space.
  def check(body : AbsBody, other : AbsBody) : Bool
    # Returns True if two bodies are colliding with each other in abstract. Does not use the space.
    if @collider.check body.shape, body.position, other.shape, other.position
      return true
    else
      return false
    end
  end

  # Moves a body. This will be move efficent than place
  # Not implemented yet.
  def move(body : AbsBody, dir : Vector)
  end

  # Moves a body from one collision area to another
  def place(body : AbsBody, area : {Int32, Int32})
    delete body, body.area
    body.area = area
    add body, area
  end
end # class
