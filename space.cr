
require "./body"
require "./collider"
require "./spatialhash"

class Space
  property grid : SpatialHash(AbsBody) #spatilhash that is the world space
  property collider : Collider
  
  def initialize(size : Int32)
    @grid = SpatialHash(AbsBody).new size
    @collider = Collider.new
  end

  def pos_to_zone(x : Float32, y : Float32) : Tuple(Int32, Int32)
    return { (x.to_i32 // ZONE_SIZE), (y.to_i32 // ZONE_SIZE) }
  end

  def pos_to_zone(x : Int32, y : Int32) : Tuple(Int32, Int32)
    return { (x // ZONE_SIZE), (y // ZONE_SIZE) }
  end

  def check(body : AbsBody) : Bool
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
    if @collider.check body.shape, body.position, other.shape, other.position
      return true
    else
      return false
    end
  end

  def add(body : AbsBody, zone : Tuple(Int32, Int32))
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

  #TODO optimization handle moving so that only a 3 spaces are allocated and 3 deleted
  def move(body : AbsBody, dir : Vector)

  end


  #Move a body to a different grid area
  def place(body : AbsBody, zone : {Int32, Int32})
    delete body, body.zone
    body.zone = zone
    add body, zone
  end

  def get(zone : Tuple(Int32, Int32))
    return @grid.get zone
  end
end#class 
