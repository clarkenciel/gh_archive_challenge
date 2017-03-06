require_relative '../spec_helper.rb'

RSpec.describe GHRepo::Sink do
  before :each do
    @source = Stack.new
    @sink = Consumer.new
  end

  context 'operation' do
    before(:each) { @sink.connect(@source) }

    it 'can pull single values' do
      expect(@sink.pull).to be(1)
    end

    it 'can pull all values' do
      expect(@sink.pull_all).to eq([1,2,3])
    end
  end
end
