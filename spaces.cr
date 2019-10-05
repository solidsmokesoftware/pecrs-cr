require "math"

require "./shapes"
require "./spacedata"
require "./pairlist"


abstract class Space
    abstract def collision
end


class OpenSpace < Space
    def add(key : Int32, value : Shape)
        @objects.add key, value
    end

    def get(key : Int32)
        @objects.get key
    end

    def get!(index : Int32)
        @objects.get! index
    end

    def get?(key : Int32)
        @objects.get? key
    end

    def has(value : Shape)
        @objects.has value
    end

    def has!(index : Int32)
        @objects.has! index
    end

    def set(key : Int32, value : Int32)
        @objects.set key, value
    end

    def set!(index : Int32, value : Int32)
        @objects.set! index, value
    end

    def del(key : Int32)
        @objects.del key
    end

    def del!(index : Int32)
        @objects.del! index
    end

    def move(key : Int32, x : Int32, y : Int32)
    end

    def move!(index : Int32, x : Int32, y : Int32)
    end

    def collision?
    end

    def collision
        collisions = Array(Position).new
        len = @objects.grid.values.size
        len.times do |si|
            s = @objects.grid.values[si]
            (len - si).times do |oi|
                o = @objects.grid.values[oi + si]
                if s != o
                    if s.collide? o
                        collisions << s.pos
                    end
                end          
            end
        end
        collisions
    end
end

class GridSpace < Space
    def add(key : Int32, shape : Shape)
        @objects.add key, shape
        @zone.add shape.pos.x, shape.pos.y, key
    end
    
    def add(key : Int32, shape : Shape)
        @objects.add key, shape
        @zone.add shape.pos.x, shape.pos.y, key
    end

    def get(key : Int32)
        @objects.get key
    end

    def get!(key : Int32)
        @objects.get! key
    end

    def get(x : Int32, y : Int32)
        @zone.get x, y
    end

    def get(pos : Tuple(Int32, Int32))
        @zone.get pos
    end

    def get(pos : Position)
        @zone.get pos.x, pos.y
    end

    def get(s : Shape)
        @zone.get s.pos.x, s.pos.y
    end

    def get(x : Int32, y : Int32)
        @zone.get x, y
    end

    def get!(pos : Tuple(Int32, Int32))
        @zone.get! pos
    end

    def get!(pos : Position)
        @zone.get! pos.x, pos.y
    end

    def get!(s : Shape)
        @zone.get! s.pos.x, s.pos.y
    end

    def get!(x : Int32, y : Int32)
        @zone.get! x, y
    end

    def set?(key : Int32, x : Int32, y : Int32)
        s = get key
        set? s, x, y
    end

    def set?(s : Shape, x : Int32, y : Int32)
        c = collision? s
        if !c
            set! s, x, y
        end
        c
    end

    def set!(key : Int32, x : Int32, y : Int32)
        s = get key
        set! s, x, y
    end

    def set!(s : Shape, x : Int32, y : Int32)
        s.pos.y = x
        s.pos.y = y
    end

    def del(key : Int32)
        @objects.del key
    end

    def del!(key : Int32)
        @objects.del! key
    end


    #Accepts a real positional value
    def narrow(pos : Position)
        narrow pos.x, pos.y
    end

    #Accepts a real positional value
    def narrow(x : Int32, y : Int32) 
        xs = x // @zone.grid.size
        ys = y // @zone.grid.size
        o = Array(Int32).new
        get({xs-1, ys-1}).each do |i|
            o << i
        end
        get({xs-1, ys}).each do |i|
            o << i
        end
        get({xs, ys-1}).each do |i|
            o << i
        end      
        get({xs, ys}).each do |i|
            o << i
        end       
        get({xs+1, ys}).each do |i|
            o << i
        end    
        get({xs, ys+1}).each do |i|
            o << i
        end     
        get({xs+1, ys+1}).each do |i|
            o << i
        end  
        get({xs-1, ys+1}).each do |i|
            o << i
        end     
        get({xs+1, ys-1}).each do |i|
            o << i
        end
        o
    end

    def narrow_opt(x : Int32, y : Int32)
        xs = x // @zone.grid.size
        ys = y // @zone.grid.size
        o = Array(Int32).new
        get({xs-1, ys-1}).each do |i|
            o << i
        end
        get({xs-1, ys}).each do |i|
            o << i
        end
        get({xs, ys-1}).each do |i|
            o << i
        end      
        get({xs, ys}).each do |i|
            o << i
        end       
        get({xs+1, ys}).each do |i|
            o << i
        end    
        get({xs, ys+1}).each do |i|
            o << i
        end     
        get({xs+1, ys+1}).each do |i|
            o << i
        end  
        get({xs-1, ys+1}).each do |i|
            o << i
        end     
        get({xs+1, ys-1}).each do |i|
            o << i
        end
        o
    end
    
    def move(key : Int32, x : Int32, y : Int32)
        s = get key

        hash_pos = @zone.scale s.pos.x, s.pos.y
        indexes = narrow hash_pos
        
        near_shapes = Array(Shape).new
        indexes.each do |index|
            o = get index
            if o != s
                near_shapes << o
            end
        end

        rate = 100
        xrate = x // rate
        yrate = y // rate

        rate.times do |step|
            s.pos.x += xrate
            s.pos.y += yrate

            hit = false
            near_shapes.each do |other|
                if s.collide? other
                    puts "Collision at #{s.pos.x}:#{s.pos.y}"
                    hit = true
                end
            end

            if hit
                puts "Hit at #{s.pos.x}:#{s.pos.y}"
                s.pos.x -= xrate
                s.pos.y -= yrate
                break
            end
        end

        new_hash = @zone.scale s.pos.x, s.pos.y
        if new_hash != hash_pos
            @zone.del! hash_pos, key
            @zone.add new_hash, key
        end 

    end

    def collision?(key : Int32)
        s = get key
        collision? s, s.pos.x, s.pos.y
    end

    def collision?(key : Int32, x : Int32, y : Int32)
        s = get key
        collision? s, x, y
    end
    
    def collision?(s : Shape, x : Int32, y : Int32)
        collision = false
        @objects.values.each do |o|
            if s != o
                if s.collide? o
                    collision = true
                    break
                end
            end
        end
        collision
    end

    def collision(key : Int32)
        s = get key
        collision s, s.pos.x, s.pos.y
    end

    def collision(s : Shape, x : Int32, y : Int32)
        collision = Array(Shape).new

        @objects.values.each do |o|
            if s != o
                if s.collide? o
                    collision << o
                end
            end
        end
        collision
    end

    def collision
        collisions = Array(Position).new

        @objects.values.each do |s|
            n = narrow(s.pos.x, s.pos.y)
            n.each do |i|
                o = get! i
                if s != o
                    if s.collide? o
                        collisions << s.pos
                    end
                end
            end
        end
        collisions
    end

    def collision_opt
        collisions = Array(Position).new

        @objects.values.each do |s|
            n = narrow_opt(s.pos.x, s.pos.y)
            n.each do |i|
                o = get! i
                if s != o
                    if s.collide? o
                        collisions << s.pos
                    end
                end
            end
        end
        collisions
    end
end


class SimpleSpace < OpenSpace
    property objects : SpaceList(Shape)

    def initialize
        @objects = SpaceList(Shape).new
    end
end


class FastSpace < GridSpace
    property objects : PairList(Int32, Shape)
    property zone : SpaceGrid(Int32)
    
    def initialize(s : Int32)
        @objects = PairList(Int32, Shape).new
        @zone = SpaceGrid(Int32).new s
    end
end

class BigSpace < GridSpace
    property objects : PairList(Int32, Shape)
    property zone : SpaceHash(Int32)
    
    def initialize(s : Int32)
        @objects = PairList(Int32, Shape).new
        @zone = SpaceHash(Int32).new s
    end
end

