require "./pairlist"
require "./collider"

class AbsSpace
end

class Space < AbsSpace
  property size : Int32
  property objects : PairList(Int32, AbsBody)
  property grid : Hash(Tuple(Int32, Int32), Array(AbsBody))
  property collider : Collider
  
  def initialize(size : Int32)
    @size = size
    @objects = PairList(Int32, AbsBody).new
    @grid = Hash(Tuple(Int32, Int32), Array(AbsBody)).new
    @collider = Collider.new
  end

  def check
    #collisions = Array(Collision).new
    relocations = Array(AbsBody).new
    
    @grid.each do |pair|
      search_space = get!(pair[0], 1)  
      
      pair[1].each do |body|
        if body.area != pair[0]
          relocations << body
        end

        search_space.each do |other|
          if body.id != other.id
            if @collider.check body, other
                #collisions << Collision.new body, other
              body.collision other
            end
          end
        end
      end
    end
    #puts relocations
    relocations.each do |body|
      set body, body.area
    end
    #puts collisions
    #collisions
  end

  def scale(x : Float32, y : Float32)
    { (x // @size).to_i32, (y // @size).to_i32 }
  end

  #Finds the localtion of value anywhere in the objects
  #TODO: this could be much faster by searching bodies
  def has(value : AbsBody)
    #arr.index { |i| i == "Baz" }
    @objects.each do |body|
      result = has body[0], value
      if result
        return result
      end
    end
  end

  # Has a bucket x, y : bool
  def has(x : Int32, y : Int32) : Bool
    has? scale(x, y)
  end

  # Has a bucket k : bool
  def has(key : {Int32, Int32}) : Bool
    if @grid.has_key? key
      true
    else
      false
    end
  end

  def add(value : AbsBody)
    @objects.add value.id, value
    value.set scale value.pos.x, value.pos.y
    if !has value.area
      @grid[value.area] = Array(AbsBody).new
    end
    @grid[value.area] << value
  end

  def add!(value : AbsBody)
    @objects.add value.id, value
    @grid[value.area] << value
  end

  # Add a bucket directly to the grid's x, y
  def add!(x : Int32, y : Int32)
    key = scale x, y
    add! key
  end

  # Add a bucket directly to the grid's k
  def add!(key : {Int32, Int32})
    @grid[key] = Array(AbsBody).new
  end

  # Check and get all items from a bucket x, y
  def get(x : Int32, y : Int32)
    key = scale x, y
    get key
  end

  # Check and get all items from a bucket k
  def get(key : {Int32, Int32})
    if !has key
      add! key
    end
    get! key
  end

  # Directly get all items from a bucket x, y
  def get!(x : Int32, y : Int32)
    key = scale x, y
    get! key
  end

  # Directly get all items from a bucket k
  def get!(key : Tuple(Int32, Int32))
    @grid[key]
  end

  def set(id : Int32, key : {Int32, Int32})
    body = @objects.get id
    @grid[body.area].delete body
    if @grid[body.area].size == 0
        del key
    end
    body.set key
    @grid[key] << value
  end

  #Move a body to a different grid area
  def set(body : AbsBody, key : {Int32, Int32})
    @grid[body.area].delete body
    if @grid[body.area].size == 0
      del key
    end
    body.set key
    if !has key
      @grid[key] = Array(AbsBody).new
    end
    @grid[key] << body
  end

  #Move a body to a different grid area
  def set!(body : AbsBody, key : {Int32, Int32})
    @grid[body.area].delete body
    body.set key
    @grid[key] << body
  end

  # Get all items *near* a bucket key. d is a flag for overloading
  def get!(key : {Int32, Int32}, d : Int32)
    results = Array(AbsBody).new

    test_key = {key[0]-1, key[1]-1}
    if @grid.has_key? test_key
      bucket = @grid[test_key]
      bucket.size.times do |i|
        results << bucket[i]
      end
    end

    test_key = {key[0]+1, key[1]-1}
    if @grid.has_key? test_key
      bucket = @grid[test_key]
      bucket.size.times do |i|
        results << bucket[i]
      end
    end

    test_key = {key[0]-1, key[1]+1}
    if @grid.has_key? test_key
      bucket = @grid[test_key]
      bucket.size.times do |i|
        results << bucket[i]
      end
    end

    test_key = {key[0]+1, key[1]+1}
    if @grid.has_key? test_key
      bucket = @grid[test_key]
      bucket.size.times do |i|
        results << bucket[i]
      end
    end

    test_key = {key[0], key[1]-1}
    if @grid.has_key? test_key
      bucket = @grid[test_key]
      bucket.size.times do |i|
        results << bucket[i]
      end
    end

    test_key = {key[0], key[1]+1}
    if @grid.has_key? test_key
      bucket = @grid[test_key]
      bucket.size.times do |i|
        results << bucket[i]
      end
    end

    test_key = {key[0], key[1]-1}
    if @grid.has_key? test_key
      bucket = @grid[test_key]
      bucket.size.times do |i|
        results << bucket[i]
      end
    end

    test_key = {key[0], key[1]+1}
    if @grid.has_key? test_key
      bucket = @grid[test_key]
      bucket.size.times do |i|
        results << bucket[i]
      end
    end

    test_key = {key[0], key[1]}
    if @grid.has_key? test_key
      bucket = @grid[test_key]
      bucket.size.times do |i|
        results << bucket[i]
      end
    end

    results
  end

  # Get all items *near* a bucket x, y. d is a flag for overloading
  def get(x : Float32, y : Float32, d : Int32)
    xs = x.to_i32 // @size
    ys = y.to_i32 // @size
    get! xs, ys, d
  end

  # Check, delete, and return a bucket x, y
  def del(x : Int32, y : Int32)
    key = scale x, y
    del key
  end

  # Check, delete, and return a bucket k
  def del(key : Tuple(Int32, Int32))
    if has key
      result = get! key
      del! key
    end
    result
  end

  # Directly delete a bucket x, y
  def del!(x : Int32, y : Int32)
    key = scale x, y
    del! key
  end

  # Directly delete a bucket k
  def del!(key : Tuple(Int32, Int32))
    @grid.delete(key)
  end

  def del!(body : AbsBody)
    @objects.del! body.id
    @grid[body.area].delete body
  end

  def del(id : Int32)
    body = @objects.get id
    if body
      key = scale(body.pos.x, body.pos.y)
      @grid[key].delete body
      @objects.del! id
    end
  end

  def del!(id : Int32)
    body = @objects.get! id
    key = scale(body.pos.x, body.pos.y)
    @grid[key].delete body
    @objects.del! id
  end
    
end#class  

