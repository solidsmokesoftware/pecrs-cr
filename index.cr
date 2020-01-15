

class Index
  # Index keeps track what number to assign to new entities.
  # Use get() to obtain a unique number from the index
  # Use delete(value) to return a number to the index for reuse
  
  property count : Int32
  property free : Array(Int32)

  def initialize
    @count = 0
    @free = Array(Int32).new
  end

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

  def del(value : Int32)
    if value >= @count
      @free << value
    end
  end

end#class

