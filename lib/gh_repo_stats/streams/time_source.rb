module GHRepo
  class TimeSource
    include Source

    def initialize(from: nil, to: nil)
      @from = from
      @to = to
      @rate = 3600
      @steps = [@rate].lazy.cycle.with_index.
        map { |rate, step| @from + rate * step }.
        take_while { |t2| t2 <= @to }.force
    end

    def next_value
      val = @steps.shift
      drained! if @steps.empty?
      val
    end
  end
end
