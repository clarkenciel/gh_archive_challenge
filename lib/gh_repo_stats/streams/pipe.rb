module GHRepo
  ##
  # Identity "transform"
  class Pipe < Transform
    def initialize
      super { |x| x }
    end
  end
end
