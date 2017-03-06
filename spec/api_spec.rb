require_relative './spec_helper.rb'

RSpec.describe GHRepo::API do
  it 'returns a list of events given a time' do
    events = GHRepo::API.events_at(Time.new(2012, 11, 01, 13, 0, 0))

    expect(events.all? { |e| e.is_a? GHRepo::Event }).to be(true)
  end
end
