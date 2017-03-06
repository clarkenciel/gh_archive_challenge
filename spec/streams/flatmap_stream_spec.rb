require_relative './stream_helper'

RSpec.describe GHRepo::FlatMap do
  before :each do
    @source = Stack.new
    @collapse = GHRepo::FlatMap.new
    @sink = Consumer.new
  end

  it 'unspools a nested list of depth 1' do
    expand = GHRepo::Transform.new { |x| [x] }
    @collapse.connect(@source.into(expand)).into(@sink)

    expect(@sink.pull).to eq(1)
    expect(@sink.pull_all).to eq([2,3])
  end

  it 'unspools a nested list of any depth' do
    expand = GHRepo::Transform.new { |x| [[x]] }
    @collapse.connect(@source.into(expand)).into(@sink)
    expect(@sink.pull).to eq(1)
    expect(@sink.pull_all).to eq([2,3])
  end

  it 'leaves an un-nested stream untouched' do
    @collapse.connect(@source).into(@sink)
    expect(@sink.pull).to eq(1)
    expect(@sink.pull_all).to eq([2,3])
  end
end
