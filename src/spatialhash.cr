# A generic spatialhash
# Keeps a bucket of objects at a given scaled position
class SpatialHash(T)
  property grid : Hash(Tuple(Int32, Int32), Array(T))
  property size : Int32

  def initialize(size : Int32)
    @grid = Hash(Tuple(Int32, Int32), Array(T)).new
    @size = size
  end

  # Scales an x, y value to a grid cell position
  def scale(x : Int32, y : Int32) : Tuple(Int32, Int32)
    return {x // @size, y // @size}
  end

  # Scales an x, y value to a grid cell position
  def scale(x : Float32, y : Float32) : Tuple(Int32, Int32)
    return {x.to_i32 // @size, y.to_i32 // @size}
  end

  # Get an item
  def get(x : Int32, y : Int32) : Array(T)
    get scale(x, y)
  end

  # Get an item
  def get(x : Float32, y : Float32) : Array(T)
    get scale(x, y)
  end

  # Get an item
  def get(area : Tuple(Int32, Int32)) : Array(T)
    if !grid.has_key? area
      @grid[area] = Array(T).new
    end
    return @grid[area]
  end

  # Add an item to the grid at x, y
  def add(item : T, x : Int32, y : Int32)
    add item, scale(x, y)
  end

  # Add an item to the grid at x, y
  def add(item : T, x : Float32, y : Float32)
    add item, scale(x, y)
  end

  # Add an item to the grid at x, y
  def add(item : T, area : Tuple(Int32, Int32))
    if !@grid.has_key? area
      @grid[area] = Array(T).new
    end
    @grid[area] << item
  end

  # Delete an item to the grid at x, y
  def delete(item : T, x : Int32, y : Int32)
    del item, scale(x, y)
  end

  # Delete an item to the grid at x, y
  def delete(item : T, x : Float32, y : Float32)
    del item, scale(x, y)
  end

  # Delete an item to the grid at x, y
  def delete(item : T, area : Tuple(Int32, Int32))
    if grid.has_key? area
      @grid[area].delete item
      if @grid[area].size == 0
        @grid.delete area
      end
    end
  end
end # class
