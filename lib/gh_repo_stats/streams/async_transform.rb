module GHRepo
  ##
  # Transform an input source asynchronously.
  # DOES NOT PRESERVE ORDER
  class AsyncTransform < Transform
    def initialize(num_workers: 4, &transform)
      super(&transform)
      @output_q = Queue.new
      @num_workers = num_workers
      @mut = Thread::Mutex.new

      @workers = (0...@num_workers).map do |id|
        Thread.new do
          until @source.drained?
            val = nil
            @mut.synchronize { val = @source.next }
            val = work(val)
            @output_q.push(val)
          end
          drained!
        end
      end
    end

    def next_value
      raise_drained! if drained?
      while @output_q.empty?
        sleep 1
      end
      @output_q.pop
    end

    def pull
      next_value
    end
  end
end
