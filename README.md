# Physicr

Physicr is 2D physics system with a focus on simplicity written in Crystal.

Physicr is easy to use and intuitive, featuring a high level controller for managing the system.

Physicr is a *system* not an *engine*. It is powered by your game loop and fully under your control.

Physicr is object-oriented and highly extensible, utilizing callbacks for easy access for system functions.

Physicr is multiplayer ready. Being developed alongside a networked game, Physicr is intended to be used in online gaming.

# Example
```ruby
require "./controller"
require "./body"
require "./shape"


class Player < Body
  def initialize(id, position)
    shape = Rect.new 32, 32
    super id, position, shape
    @name = "Player"
    @speed = 100
    @moving = true
  end
end


class Objects < Controller
  def initalize(collision_area_size)
    super collision_area_size
    @factory[0] = Player.class
  end
      
  def on_make(body)
    puts "Objects made #{body.name} #{body.id} at #{body.position.x}:#{body.position.y}")
  end
      
  def on_motion(body)
    puts "#{body.name} #{body.id} is at #{body.position.x}:#{body.position.y}"
  end

  def on_collision(body, collisions)
    put "#{body.name} is colliding with #{collisions.size} others"
  end

objects = Objects 64

playerA = objects.make Player, 0, 0
playerB = objects.make 0, 10, 0

collision = objects.space.check playerA, playerB
if collision
   puts "Bodies A and B are colliding"
end

objects.place playerA, 100, 0
objects.move playerB, 1, 0, 1

objects.turn playerA, 0, 1
objects.move playerA, 1

collision = objects.space.check playerA 
if collision
   puts "Body A is colliding with another body"
end

objects.delete playerA 
objects.delete playerB

playerC = objects.make Player, 0, 0, dx=1 
playerD = objects.make Player, 0, 0, dx=-1 
playerE = objects.make Player, 0, 0, dy =1 
playerF = objects.make Player, 0, 0, dy =-1 

collisions = objects.space.get_body playerC
if collisions
   puts "Body C is colliding with #{collisions.size} others"
end

10.times do
   objects.step 0.1
end

```

# Documentation

Physicr's documentation is incomplete. See the documentation at pysics for a more indepth autodoc

https://solidsmokesoftware.github.io/pysics/

# Demonstration

Physicr's has a twin written in Python. To see the system in action, check out

https://github.com/solidsmokesoftware/solconomy

![solconomy](https://camo.githubusercontent.com/de20b3b2014d20a8746f7346e777e323586d5a35/68747470733a2f2f692e696d6775722e636f6d2f566277677664372e706e67)
