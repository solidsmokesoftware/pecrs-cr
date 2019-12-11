

class Action(T)
   def fire(data : T)
   end
end#class


class Signaler(T)
   property actions : Array(Action(T))

   def initialize
      @actions = Array(Action(T)).new
   end

   def add(action : Action(T))
      @actions << action
   end

   def del(action : Action(T))
      @actions.delete action
   end

   def signal(data : T)
      @actions.each do |action|
         action.fire data
      end
   end

end#class