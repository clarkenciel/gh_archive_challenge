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

      counts = TimeRangedEventStream.new(@after, @before, @event_type).each.
        map { |event|  event.repository }.
        reduce({}) do |counter, repo|
        if counter.include?(repo)
          counter[repo] += 1
        else
          counter[repo] = 1
        end
        counter
      end

      counts.lazy.
        sort { |c1, c2| c2[1] <=> c1[1] }.take(@count).
        map { |k, v| { owner: k.owner, name: k.name, event_count: v } }.
        each { |h| @formatter.entry({ repo: h }) }

      @formatter.stop({})
    end
  end
end
