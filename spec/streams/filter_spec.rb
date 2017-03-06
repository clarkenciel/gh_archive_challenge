require_relative './stream_helper'

RSpec.describe GHRepo::Filter do
  before :each do
    @source = Stack.new
    @sink = Consumer.new
    @filter = GHRepo::Filter.new { |x| x % 2 != 0 }
    @filter.connect(@source)
    @sink.connect(@filter)
  end

  it 'yields the first match of the predicate when pulled' do
    expect(@sink.pull).to eq(1)
  end

  it 'yields all matches when "pull_all"d' do
    expect(@sink.pull_all).to eq([1,3])
  end
end
