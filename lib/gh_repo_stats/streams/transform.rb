module GHRepo
  class Transform
    include Source
    include Sink

    def initialize(&transform)
      @transform = transform
      drained!
    end

    def connect(source)
      super(source)
      @drained = false
    end

    def work(val)
      @transform.call(val)
    end

    def pull
      val = work(super)
      drained! if @source.drained?
      val
    end

    def next_value
      raise_drained! if drained?
      pull
    end
  end
end
