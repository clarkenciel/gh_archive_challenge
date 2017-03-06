require_relative './stream_helper.rb'

RSpec.describe GHRepo::Transform do
  before :each do
    @source = Stack.new
    @sink = Consumer.new
    @transform = GHRepo::Transform.new { |x| x }
  end

  it 'starts drained' do
    expect(@transform.drained?).to be(true)
  end

  it 'can pull from a source' do
    @transform.connect(@source)

    expect(@transform.drained?).to be(false)
    expect(@transform.pull).to eq(1)
    expect(@transform.pull_all).to eq([2,3])
  end

  it 'can be pulled by a source' do
    @transform.connect(@source)
    @sink.connect(@transform)

    expect(@sink.pull).to eq(1)
  end

  it 'throws an error if pulled wihout a source' do
    @sink.connect(@transform)

    expect { @sink.pull }.to raise_error(GHRepo::Source::Drained)
    expect { @sink.pull_all }.to raise_error(GHRepo::Source::Drained)
  end

  it 'transforms data from source' do
    @transform = GHRepo::Transform.new { |x| x.succ }
    @transform.connect(@source)
    @sink.connect(@transform)

    expect(@sink.pull).to eq(2)
    expect(@sink.pull_all).to eq([3,4])
  end
end
