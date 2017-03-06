module GHRepo
  class Filter < Transform
    def initialize(&pred)
      super do |x|
        pred.call(x) and x
      end
    end

    def next_val
      until val = super
      end
      val
    end
  end
end
