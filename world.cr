require "math"

require "./shapes"
require "./pairlist"
require "./space"
require "./collision"
require "./engine"


abstract class World
    def add(value : AbsBody)
        @space.add value
        @engine.add value
    end

    def check
        @collider.check @space
    end

    def start
        @engine.start @space, @collider
    end

    def stop
        @engine.stop
    end

    def run(n : Int32)
        @engine.run @space, @collider, n
    end
end


class OpenWorld < World
end

class GridWorld < World
end


class SimpleWorld < OpenWorld
    property space : SpaceList
    property collider : ListCollider
    property engine : Engine

    def initialize
        @space = SpaceList.new
        @collider = ListCollider.new
        @engine = Engine.new 100
    end
end


class BigWorld < GridWorld
    property space : SpaceHash
    property collider : GridCollider
    property engine : Engine
    
    def initialize(s : Int32)
        @space = SpaceHash.new s
        @collider = GridCollider.new
        @engine = Engine.new 100
    end
end

