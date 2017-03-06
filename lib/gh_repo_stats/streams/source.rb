module GHRepo
  module Source
    def next
      raise_drained! if drained?
      next_value
    end

    def drained!
      @drained = true
    end

    def drained?
      @drained ||= false
    end

    def raise_drained!
      raise(Drained, "#{self.class} is drained!")
    end

    def into(sink)
      sink.connect(self)
      self
    end

    class Drained < RuntimeError
    end
  end
end
