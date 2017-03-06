module GHRepo
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

    def connect(source)
      @source = source
      self
    end
  end
end
