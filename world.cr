require "math"

require "./shapes"
require "./pairlist"
require "./space"
require "./collision"
require "./engine"


abstract class AbsWorld
  def add(value : AbsBody)
    @space.add value
    @engine.add value
  end

  def check
    @collider.check @space
  end

  def start
    @engine.start
  end

  def stop
    @engine.stop
  end

  def run(n : Int32)
    @engine.run n
  end

  def test(n : Int32)
    @engine.test n
  end

end#class


class World < AbsWorld
  property space : Space
  property collider : SpaceCollider
  property engine : Engine
    
  def initialize(s : Int32)
    @space = Space.new s
    @collider = SpaceCollider.new
    @engine = Engine.new @space, @collider, 16_i64
  end

end#class

