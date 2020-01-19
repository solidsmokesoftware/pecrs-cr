# Index keeps track what number to assign to new entities.
class Index
  property count : Int32
  property free : Array(Int32)

  def initialize
    @count = 0
    @free = Array(Int32).new
  end

  # Gets a unique identifer for this index. Freed ids are assigned first, in first-in-last-out order.
  def get : Int32
    if @free.size == 0
      @count += 1
      return @count
    else
      value = @free[-1]
      @free.pop
      return value
    end
  end

  # Gets a unique identifer for this index. Freed ids are assigned first, in first-in-last-out order.
  def delete(value : Int32)
    if value >= @count
      @free << value
    end
  end
end # class
