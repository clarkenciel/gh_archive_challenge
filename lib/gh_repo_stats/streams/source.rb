module GHRepo
  module Source
    def next
      if drained?
        raise(Drained, "#{self.class} is drained!")
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

    class Drained < RuntimeError
    end
  end
end
