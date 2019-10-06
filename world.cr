require "math"

require "./shapes"
require "./pairlist"
require "./space"
require "./colliders"
require "./engine"


abstract class World
    def add(value : Body)
        @space.add value
        @engine.add value
    end

    def check
        @collider.check @space
    end

    def start
        @engine.start @space, @collider
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
        @engine = Engine.new 1
    end
end


class BigWorld < GridWorld
    property space : SpaceHash
    property collider : GridCollider
    property engine : Engine
    
    def initialize(s : Int32)
        @space = SpaceHash.new s
        @collider = GridCollider.new
        @engine = Engine.new 1
    end
end

