module Source
  def next
    if drained?
      nil
    else
      next_value
    end
  end

  def drained!
    @drained = true
  end

  def drained?
    @drained ||= false
  end
end

