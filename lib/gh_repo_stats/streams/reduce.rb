module GHRepo
  class Reduce 
    include Sink

    def initialize(accumulator, &merge)
      @acc = accumulator
      @merge = merge
    end

    def pull
      val = super
      @acc = @merge.call(@acc, val)
    end

    def pull_all
      super
      @acc
    end
  end
end
