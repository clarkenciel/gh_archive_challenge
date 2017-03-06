module GHRepo
  class AsyncTransform < Transform
    def initialize(num_workers: 4, &transform)
      super(transform)
      @output_q = Queue.new
      @num_workers = num_workers
      @output_reader = ->() do
        while @output_q.empty?
          sleep 1
        end
        @output_q.pop
      end

      @output_stream = [@output_reader].lazy.cycle.
        map(&:call).take_while { !drained? }

      @workers = (0...@num_workers).map do |id|
        Thread.new do
          until @source.drained?
            @output_q.push(pull)
          end
          drained!
        end
      end
    end

    def next_val
      @output_stream.shift
    end
  end
end
