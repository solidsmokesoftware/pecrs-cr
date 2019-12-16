

class SpatialHash(T)
  property grid : Hash(Tuple(Int32, Int32), Array(T))
  property size : Int32

  def initialize(size : Int32)
    @grid = Hash(Tuple(Int32, Int32), Array(T)).new
    @size = size
  end

  def scale(x : Int32, y : Int32) : Tuple(Int32, Int32)
    return {x // @size, y // @size}
  end

  def scale(x : Float32, y : Float32) : Tuple(Int32, Int32)
    return {x.to_i32 // @size, y.to_i32 // @size}
  end

  def get(x : Int32, y : Int32) : Array(T)
    get scale(x, y)
  end

  def get(x : Float32, y : Float32) : Array(T)
    get scale(x, y)
  end

  def get(area : Tuple(Int32, Int32)) : Array(T)
    if !grid.has_key? area
      @grid[area] = Array(T).new
    end
    return @grid[area]
  end

  def add(item : T, x : Int32, y : Int32)
    add item, scale(x, y)
  end

  def add(item : T, x : Float32, y : Float32)
    add item, scale(x, y)
  end

  def add(item : T, area : Tuple(Int32, Int32))
    if !@grid.has_key? area
      @grid[area] = Array(T).new
    end
    @grid[area] << item  
  end

  def del(item : T, x : Int32, y : Int32)
    del item, scale(x, y)
  end

  def del(item : T, x : Float32, y : Float32)
    del item, scale(x, y)
  end

  def del(item : T, area : Tuple(Int32, Int32))
    if grid.has_key? area
      @grid[area].delete item
      if @grid[area].size == 0
        @grid.delete area
      end
    end
  end

end#class