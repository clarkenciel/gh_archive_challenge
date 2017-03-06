require_relative 'stream_helper'

RSpec.describe GHRepo::Source do
  before :each do
    @source = Stack.new
  end

  it 'starts as not drained' do
    expect(@source.drained?).to be(false)
  end

  it 'returns values when not drained' do
    expect(@source.next).to be(1)
  end

  it 'throws an exception when drained' do
    vals = []
    3.times { vals.push(@source.next) }
    expect(vals).to eq([1,2,3])
    expect { @source.next }.to raise_error(GHRepo::Source::Drained)
    expect(@source.drained?).to be(true)
  end
end
