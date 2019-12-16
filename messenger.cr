
class Messenger(T)
  property lock : Mutex
  property messages : Array(T)

  def initialize()
    @lock = Mutex.new 
    @messages = Array(T).new
  end

  def send(message : T)
    @lock.lock
    @messages << message
    @lock.unlock
  end

  def get : Array(T)
    @lock.lock
    messages = @messages
    @messages = Array(T).new
    @lock.unlock
    return messages
  end
end#class
