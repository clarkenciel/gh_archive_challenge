require_relative './stream_helper'

RSpec.describe GHRepo::TimeSource do
  before :each do
    @now = Time.now
    @source = GHRepo::TimeSource.new(
      from: @now - 3600 * 4,
      to: @now
    )
    @sink = Consumer.new
    @sink.connect(@source)
  end

  it 'returns hourly steps' do
    steps = @sink.pull_all

    expect(steps.first).to eq(@now - 3600 * 4)
    expect(steps.last).to eq(@now)
    expect(steps.size).to eq(5)
    expect(steps.all? {|s| s.is_a? Time}).to be(true)
    expect(steps[1] - steps[0]).to eq(3600)
    expect(steps[-1] - steps[0]).to eq(3600 * 4)
  end

  it 'can be transformed' do
    to_string = GHRepo::Transform.new { |x| x.to_s }
    @sink.connect(to_string)
    to_string.connect(@source)
    vals = @sink.pull_all
    expect(vals.all? {|x| x.is_a? String }).to be(true)
    expect(vals.all? {|x| Time.new(x) }).to be(true)
  end
end
