
require "./body"
require "./shapes"
require "./pairlist"


class Space
end

class OpenSpace < Space
end

class GridSpace < Space
end


class SpaceList < OpenSpace
    property objects : PairList(Int32, Body)

    def initialize
        @objects = PairList(Int32, Body).new
    end

    def has(key : Int32)
        @objects.has key
    end

    def has!(key : Int32)
        @objects.has! key
    end

    def add(value : Body)
        @objects.add value.id, value
    end

    def get(key : Int32)
        @objects.get key
    end

    def get!(index : Int32)
        @objects.get! index
    end

    def get?(key : Int32)
        @objects.get key
    end

    def set(key : Int32, value : Body)
        @objects.set key, value
    end

    def set!(index : Int32, value : Body)
        @objects.set! index, value
    end

    def del(key : Int32)
        @objects.del key
    end

    def del!(index : Int32)
        @objects.del! index
    end
end



class SpaceHash < GridSpace
    property size : Int32
    property objects : PairList(Int32, Body)
    property grid : Hash(Tuple(Int32, Int32), Array(Body))
    
    def initialize(@size : Int32)
        @objects = PairList(Int32, Body).new
        @grid = Hash(Tuple(Int32, Int32), Array(Body)).new
    end

    def scale(x : Float32, y : Float32)
        { (x // @size).to_i32, (y // @size).to_i32 }
    end

    #Finds the localtion of value anywhere in the objects
    def has(value : Body)
        @objects.each do |body|
            result = has body[0], value
            if result
                return result
            end
        end
    end

    # Has a bucket x, y
    def has(x : Int32, y : Int32)
        has scale(x, y)
    end

    # Has a bucket k
    def has(key : {Int32, Int32})
        if @grid.has_key? key
            true
        else
            false
        end
    end

    
    def add(value : Body)
        @objects.add value.id, value
        key = scale value.pos.x, value.pos.y
        if !has key
            @grid[key] = Array(Body).new
        end
        @grid[key] << value
    end

    def add!(value : Body)
        @objects.add value.id, value
        @grid[scale(value.pos.x, value.pos.y)] << value
    end
    
    # Add a bucket directly to the objects x, y
    def add!(x : Int32, y : Int32)
        key = scale x, y
        add! key
    end

    # Add a bucket directly to the objects k
    def add!(key : {Int32, Int32})
        @grid[key] = Array(Body).new
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

    # Get all items *near* a bucket x, y
    def get(x : Float32, y : Float32, d : Int32)
        xs = (x // @size).to_i32
        ys = (y // @size).to_i32
        result = Array(Body).new
        
        get({xs-1, ys-1}).each do |i|
            result << i
        end
        get({xs-1, ys}).each do |i|
            result << i
        end
        get({xs, ys-1}).each do |i|
            result << i
        end      
        get({xs, ys}).each do |i|
            result << i
        end       
        get({xs+1, ys}).each do |i|
            result << i
        end    
        get({xs, ys+1}).each do |i|
            result << i
        end     
        get({xs+1, ys+1}).each do |i|
            result << i
        end  
        get({xs-1, ys+1}).each do |i|
            result << i
        end     
        get({xs+1, ys-1}).each do |i|
            result << i
        end
        result
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
        @objects.delete(key)
    end

    def del!(body : Body)
        key = scale(body.pos.x, body.pos.y)
        @objects.del! body.id
        @grid[key].delete body
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
        
end


