module Sink
  def pull
    @source.next
  end

  def pull_all
    output = []
    until @source.drained?
      output.push(pull)
    end
    output
  end

  def from(source)
    @source = source
  end
end

