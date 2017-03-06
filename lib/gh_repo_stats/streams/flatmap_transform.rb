require 'byebug'
module GHRepo
  class FlatMap < Pipe
    def next_value
      @current_chunk = [super].flatten if (@current_chunk.nil? or @current_chunk.empty?)
      @current_chunk.shift
    end
  end
end
