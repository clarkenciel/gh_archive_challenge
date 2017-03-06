module GHRepo
  module Sink
    def pull
      @source.next
    end

    def pull_all
      output = []
      until @source.drained?
        begin
          output.push(pull)
        rescue Source::Drained
          break
        end
      end
      output
    end

    def connect(source)
      @source = source
      self
    end
  end
end
