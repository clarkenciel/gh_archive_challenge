class Transform
  include Source
  include Sink

  def initialize(&transform)
    @transform = transform
  end

  def work(val)
    @transform.call(val)
  end

  def pull
    work(super)
  end

  def next_val
    pull
  end
end

