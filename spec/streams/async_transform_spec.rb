require_relative './stream_helper.rb'

RSpec.describe GHRepo::AsyncTransform do
  before :each do
    @source = Stack.new
    @sink = Consumer.new
    @transform = GHRepo::AsyncTransform.new { |x| sleep(rand*2); x }
  end

  it 'starts drained' do
    expect(@transform.drained?).to be(true)
  end

  it 'can pull from a source' do
    @transform.connect(@source)

    expect(@transform.drained?).to be(false)
    expect(@transform.pull).to satisfy { |n| [1,2,3].include? n }
    expect(@transform.pull_all).to satisfy { |ns| ns.all? {|n| [1,2,3].include? n } }
  end

  it 'can be pulled by a sink' do
    @transform.connect(@source)
    @sink.connect(@transform)

    expect(@sink.pull).to satisfy { |n| [1,2,3].include? n }
  end

  it 'throws an error if pulled wihout a source' do
    @sink.connect(@transform)

    expect { @sink.pull }.to raise_error(GHRepo::Source::Drained)
    expect { @sink.pull_all }.to raise_error(GHRepo::Source::Drained)
  end

  it 'transforms data from source' do
    @transform = GHRepo::AsyncTransform.new { |x| sleep(rand*2); x.succ }
    @transform.connect(@source)
    @sink.connect(@transform)

    expect(@sink.pull).to satisfy { |n| [2,3,4].include? n }
    expect(@sink.pull_all).to satisfy { |ns| ns.all? {|n| [2,3,4].include? n } }
  end

  it 'can be transformed' do
    transform2 = GHRepo::Transform.new { |x| x.to_s }
    transform2.connect(@transform.connect(@source)).into(@sink)
    expect(@sink.pull).to satisfy { |n| n.is_a?(String) }
    expect(@sink.pull_all).to satisfy { |ns| ns.all? { |s| s.is_a?(String) }}
  end
end
