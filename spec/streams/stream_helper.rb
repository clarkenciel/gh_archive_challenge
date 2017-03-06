require_relative '../spec_helper.rb'

class Stack
  include GHRepo::Source

  attr_reader :data
  def initialize
    @data = [1,2,3]
  end

  def next_value
    val = @data.shift
    drained! if @data.empty?
    val
  end
end
