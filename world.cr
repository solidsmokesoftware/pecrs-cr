require "math"

require "./shapes"
require "./pairlist"
require "./space"
require "./colliders"


abstract class World
    def add(index : Int32, value : Body)
        @space.add index, value
    end

    def check
        @collider.check @space
    end
end


class OpenWorld < World
end

class GridWorld < World
end


class SimpleWorld < OpenWorld
    property space : SpaceList
    property collider : ListCollider

    def initialize
        @space = SpaceList.new
        @collider = ListCollider.new
    end
end


class BigWorld < GridWorld
    property space : SpaceHash
    property collider : GridCollider
    
    def initialize(s : Int32)
        @space = SpaceHash.new s
        @collider = GridCollider.new
    end
end

