module GHRepo
  class Runner
    def initialize(after: nil, before: nil, event: nil, count: nil, formatter: nil)
      @after = after
      @before = before
      @event_type = event
      @count = count
      @formatter = (formatter || BasicPrinter).new(STDOUT)
    end

    def run
      @formatter.start({})

      @source = TimeSource.new(from: @after, to: @before)
      @queries = AsyncTransform.new { |time| API.events_at(time) }
      @flattened = FlatMap.new
      @filter = Filter.new { |event| event.is_a? @event_type }
      @extractor = Transform.new { |event| event.repository }
      @sink = Reduce.new({}) do |hash, repo| 
        if hash.include?(repo)
          hash[repo] += 1
        else
          hash[repo] = 1
        end
        hash
      end
      @source.into(@queries).into(@flattened).into(@filter).into(@extractor).into(@sink) 
      counts = @sink.pull_all.lazy

      counts.
        sort { |c1, c2| c2[1] <=> c1[1] }.take(@count).
        map { |k, v| { owner: k.owner, name: k.name, event_count: v } }.
        each { |h| @formatter.entry({ repo: h }) }

      @formatter.stop({})
    end
  end
end
