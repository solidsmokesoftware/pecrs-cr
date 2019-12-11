require "./pairlist"
require "./body"
require "./signal"

class Space
  property objects : Hash(Int32, AbsBody) #All objects in the world space
  property actors : PairList(Int32, Actor) #Bodies that are being watched
  property mobiles : PairList(Int32, Body) #Moving objects
  property statics : PairList(Int32, StaticBody) #Objects that don't move often

  property grid : Hash(Tuple(Int32, Int32), Array(AbsBody)) #spatilhash that is the world space
  property size : Int32 #Size of each cell in the spatialhash

  #Dunno about this stuff, experimenting
  property vision : Hash(Tuple(Int32, Int32), String)
  property collisions : Signaler(Tuple(Int32, Int32))
  property relocations : Signaler(Tuple(Int32, Int32))
  
  def initialize(size : Int32)
    @objects = Hash(Int32, AbsBody).new
    @actors = PairList(Int32, Actor).new
    @mobiles = PairList(Int32, Body).new
    @statics = PairList(Int32, StaticBody).new

    @grid = Hash(Tuple(Int32, Int32), Array(AbsBody)).new
    @size = size

    @vision = Hash(Tuple(Int32, Int32), String).new
    @collisions = Signaler(Tuple(Int32, Int32)).new
    @relocations = Signaler(Tuple(Int32, Int32)).new
  end

  def scale(x : Float32, y : Float32) : {Int32, Int32}
    return { (x // @size).to_i32, (y // @size).to_i32 }
  end

  #TODO working on taking this out

  # def step(delta : Float64)
  #   @mobiles.values.each do |body|
  #     body.move delta
  #     area = scale body.position.x, body.position.y
  #     if body.area != area
  #       body.area
  #       set body, area
  #       #@relocations.signal area
  #     end

  #     #puts "Space: #{body.id} - #{body.position.x}:#{body.position.y}"
  #   end
  #   check
  # end


  def check
    spaces = Hash(Tuple(Int32, Int32), Array(AbsBody)).new
    @actors.values.each do |actor|
      area = scale actor.position.x, actor.position.y
      if area != actor.area
        set actor, area
      end

      if spaces.has_key? area
        others = spaces[area]
      else
        others = get area, 1
        spaces[area] = others
      end
      puts "Space: checking #{actor.id}##{actor.position.x}:#{actor.position.y} in #{area[0]}:#{area[1]} against #{others.size} others"
      
      others.each do |other|
        if actor.id != other.id
          if actor.check other
            puts "Space: Collision between #{actor.id} and #{other.id} at #{other.position.x}:#{other.position.y}"
            actor.collide other
            other.collide actor
          end
        end
      end
    end 
  end

  #TODO trying to get rid of this
  # def check
  #   #TODO test to see if going through mobile bodies only instead of the grid is faster
  #   #puts "Space: checking"

  #   @grid.each do |pair| 
  #     search_space = get!(pair[0], 1)  
  #     vision = ""
  #     pair[1].each do |body|
  #       search_space.each do |other|
  #         if body.id != other.id
  #           if body.check other
  #             body.collide other
  #             #@collisions.signal({body.id, other.id})
  #           end
  #         end
  #       end

  #       # elsif typeof(body) == StaticBody
  #       # end

  #       #TODO this needs to be done waaaaay better it's not nice at all
  #       vision += "#{body.id}:#{body.position.to_s}/"
  #     end
  #     @vision[pair[0]] = vision
  #   end

  #   #TODO figure out why this was kept after the main loop
  #   # #puts relocations
  #   # relocations.each do |body|
  #   #   set body, body.area
  #   #   body.relocate body.area
  #   # end
  # end

  #Finds the localtion of body anywhere in the objects
  #TODO: this could be much faster by searching bodies
  def has(body : AbsBody)
    #arr.index { |i| i == "Baz" }
    @objects.each do |body|
      result = has body[0], body
      if result
        return result
      end
    end
  end

  # Has a bucket k : bool
  def has(key : {Int32, Int32}) : Bool
    if @grid.has_key? key
      true
    else
      false
    end
  end

  def add(body : AbsBody)
    @objects[body.id] = body
    
    if body.is_a? Body
      @mobiles.add body.id, body # .as(Body) What is this for??  
    elsif body.is_a? StaticBody
      @statics.add body.id, body
    end

    if body.is_a? Actor
      @actors.add body.id, body
    end

    body.area = scale body.position.x, body.position.y
    
    if !has body.area
      @grid[body.area] = Array(AbsBody).new
    end
    @grid[body.area] << body

    puts "Space: Added body #{body.id} to #{body.area[0]}:#{body.area[1]} with #{@grid[body.area].size} others"
  end

  # Check and get all items from a bucket k
  def get(key : {Int32, Int32})
    if @grid.has_key? key
      return @grid[key]
    else
      bucket = Array(AbsBody).new
      @grid[key] = bucket
      return bucket
    end
  end

  # Get all items *near* a bucket key. d is a flag for overloading
  def get(key : {Int32, Int32}, d : Int32)
    results = Array(AbsBody).new

    test_key = {key[0]-1, key[1]-1}
    if @grid.has_key? test_key
      @grid[test_key].each do |body|
        results << body
      end
    end

    test_key = {key[0]+1, key[1]-1}
    if @grid.has_key? test_key
      @grid[test_key].each do |body|
        results << body
      end
    end

    test_key = {key[0]-1, key[1]+1}
    if @grid.has_key? test_key
      @grid[test_key].each do |body|
        results << body
      end
    end

    test_key = {key[0]+1, key[1]+1}
    if @grid.has_key? test_key
      @grid[test_key].each do |body|
        results << body
      end
    end

    test_key = {key[0], key[1]-1}
    if @grid.has_key? test_key
      @grid[test_key].each do |body|
        results << body
      end
    end

    test_key = {key[0], key[1]+1}
    if @grid.has_key? test_key
      @grid[test_key].each do |body|
        results << body
      end
    end

    test_key = {key[0], key[1]-1}
    if @grid.has_key? test_key
      @grid[test_key].each do |body|
        results << body
      end
    end

    test_key = {key[0], key[1]+1}
    if @grid.has_key? test_key
      @grid[test_key].each do |body|
        results << body
      end
    end

    test_key = {key[0], key[1]}
    if @grid.has_key? test_key
      @grid[test_key].each do |body|
        results << body
      end
    end

    #puts "Space: Getting bodies near #{key[0]}:#{key[1]} = #{results}"
    return results
  end

    #Move a body to a different grid area
  def set(body : AbsBody, key : {Int32, Int32})
    if @grid.has_key? body.area
      @grid[body.area].delete body
      if @grid[body.area].size == 0
        @grid.delete body.area
      end
    end

    body.area = key
    if !@grid.has_key? key
      @grid[key] = Array(AbsBody).new
    end
    @grid[key] << body
  end
   
end#class 
